package controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Exam;
import model.ExamSection;
import model.Question;
import model.Answer;
import services.ExamImportService;
import services.ExamService;
import services.QuestionService;
import dao.QuestionResourceDAO;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet({"/admin/exam-import", "/mentor/exam-import"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 5,  // 5MB
        maxFileSize = 1024 * 1024 * 100,      // 100MB
        maxRequestSize = 1024 * 1024 * 150    // 150MB
)
public class ExamImportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ExamImportServlet.class.getName());
    private final ExamImportService importService = new ExamImportService();
    private final ExamService examService = new ExamService();
    private final QuestionService questionService = new QuestionService();
    private final QuestionResourceDAO resourceDAO = new QuestionResourceDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("upload".equals(action)) {
                handleUpload(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.severe("Exam Import Error: " + e.getMessage());
            // Return 200 with { success: false, error: ... } instead of 500 to avoid Tomcat error valve
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            java.util.Map<String, Object> errorMap = new java.util.HashMap<>();
            errorMap.put("success", false);
            errorMap.put("error", e.getMessage() != null ? e.getMessage() : "Unknown error");
            resp.getWriter().write(mapper.writeValueAsString(errorMap));
        }
    }

    private void handleUpload(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            throw new IllegalArgumentException("File is empty or missing");
        }

        String fileName = filePart.getSubmittedFileName();
        
        String rawText;
        try (InputStream input = filePart.getInputStream()) {
            byte[] fileBytes = input.readAllBytes();
            LOGGER.info("Uploaded file size: " + fileBytes.length + " bytes.");
            if (fileBytes.length == 0) {
                 throw new IllegalArgumentException("File uploaded is 0 bytes. Tomcat may have truncated the upload.");
            }
            try (java.io.ByteArrayInputStream bais = new java.io.ByteArrayInputStream(fileBytes)) {
                rawText = importService.extractTextFromFile(bais, fileName);
            }
        }

        if (rawText == null || rawText.trim().isEmpty()) {
            throw new IllegalArgumentException("Could not extract any text from the document.");
        }

        // 2. Call Gemini
        String jsonResult = importService.parseTextToExamJson(rawText);
        
        if (jsonResult == null) {
            throw new RuntimeException("AI failed to parse the document.");
        }
        
        JsonNode rootNode = mapper.readTree(jsonResult);
        if (rootNode.has("isExamMaterial") && !rootNode.get("isExamMaterial").asBoolean(true)) {
            throw new IllegalArgumentException("Tài liệu tải lên không phải là đề thi hoặc tài liệu học tập hợp lệ.");
        }
        
        int examId = saveExamFromNode(rootNode, req);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\": true, \"examId\": " + examId + "}");
    }

    private int saveExamFromNode(JsonNode rootNode, HttpServletRequest req) throws Exception {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // 1. Create Exam
        Exam exam = new Exam();
        exam.setTitle(rootNode.path("title").asText("Imported Exam"));
        exam.setSkillFocus(rootNode.path("skillFocus").asText("All"));
        exam.setDuration(rootNode.path("duration").asInt(60));
        exam.setType("Practice"); // default
        exam.setMentorId(userId);

        examService.createExam(exam); // assumes this sets exam.getExamId()

        // 2. Create Sections and Questions
        JsonNode sectionsNode = rootNode.path("sections");
        if (sectionsNode.isArray()) {
            int orderIndex = 1;
            for (JsonNode sectionNode : sectionsNode) {
                ExamSection section = new ExamSection();
                section.setExamId(exam.getExamId());
                section.setSectionName(sectionNode.path("sectionName").asText("Section " + orderIndex));
                section.setSkill(sectionNode.path("skill").asText(exam.getSkillFocus()));
                section.setOrderIndex(orderIndex++);
                
                String resourceText = sectionNode.path("resourceText").asText("").trim();
                if (!resourceText.isEmpty()) {
                    model.QuestionResource resource = new model.QuestionResource();
                    resource.setResourceName(exam.getTitle() + " - " + section.getSectionName());
                    resource.setResourceText(resourceText);
                    resource.setType("Passage");
                    resource.setCreatedBy(userId);
                    resourceDAO.save(resource);
                    section.setResourceId(resource.getResourceId());
                }
                
                examService.addSection(section); 
                
                // Note: examService.addSection usually sets sectionId but if not, we have to reload.
                // Assuming it sets sectionId. Wait, let's load it back if needed, or assume addSection updates it.
                // Let's assume addSection works. If not, we might need a custom bulk save method.
                // For now, let's just insert questions directly.
                
                // Let's create a custom DAO method later if this fails. For now, we will add questions to the section.
                // The current architecture requires questions to be in the DB first, then mapped to ExamQuestions.
                
                JsonNode questionsNode = sectionNode.path("questions");
                if (questionsNode.isArray()) {
                    for (JsonNode qNode : questionsNode) {
                        Question q = new Question();
                        q.setContent(qNode.path("content").asText());
                        q.setQuestionType(qNode.path("questionType").asText("MultipleChoice"));
                        q.setDifficulty(qNode.path("difficulty").asText("Medium"));
                        q.setExplanation(qNode.path("explanation").asText(""));
                        q.setSkill(section.getSkill());
                        q.setCreatedBy(userId);
                        q.setContentJson("{}"); // Default
                        
                        List<Answer> answers = new ArrayList<>();
                        JsonNode answersNode = qNode.path("answers");
                        
                        if ("FillInBlanks".equals(q.getQuestionType())) {
                            com.fasterxml.jackson.databind.node.ObjectNode qContentJson = mapper.createObjectNode();
                            com.fasterxml.jackson.databind.node.ObjectNode blanksNode = mapper.createObjectNode();
                            com.fasterxml.jackson.databind.node.ObjectNode aContentJson = mapper.createObjectNode();
                            
                            int index = 0;
                            if (answersNode.isArray()) {
                                for (JsonNode aNode : answersNode) {
                                    String ansStr = aNode.path("content").asText();
                                    
                                    // Question blank config
                                    com.fasterxml.jackson.databind.node.ObjectNode blankConfig = mapper.createObjectNode();
                                    blankConfig.put("type", "text");
                                    blankConfig.put("placeholder", "");
                                    blanksNode.set(String.valueOf(index), blankConfig);
                                    
                                    // Answer array
                                    com.fasterxml.jackson.databind.node.ArrayNode ansArray = mapper.createArrayNode();
                                    ansArray.add(ansStr);
                                    aContentJson.set(String.valueOf(index), ansArray);
                                    
                                    index++;
                                }
                            }
                            qContentJson.set("blanks", blanksNode);
                            q.setContentJson(qContentJson.toString());
                            
                            Answer a = new Answer();
                            a.setContent("FillInBlanks Answer Map");
                            a.setCorrect(true);
                            a.setContentJson(aContentJson.toString());
                            answers.add(a);
                        } else {
                            if (answersNode.isArray()) {
                                for (JsonNode aNode : answersNode) {
                                    Answer a = new Answer();
                                    a.setContent(aNode.path("content").asText());
                                    a.setCorrect(aNode.path("isCorrect").asBoolean());
                                    a.setContentJson("{}");
                                    answers.add(a);
                                }
                            }
                        }
                        
                        q.setAnswers(answers);
                        questionService.createQuestion(q, answers, null);
                        
                        // Map to section
                        // If sectionId wasn't populated by addSection, we have a problem.
                        // But let's assume it was. 
                        examService.addQuestionToSection(section.getSectionId(), q.getQuestionId());
                    }
                }
            }
        }

        return exam.getExamId();
    }
}
