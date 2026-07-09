package controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.GeminiApiService;

import java.io.IOException;

@WebServlet("/api/chat")
public class ChatController extends HttpServlet {

    private GeminiApiService geminiApiService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        this.geminiApiService = new GeminiApiService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        int roleId = (Integer) session.getAttribute("roleId");
        
        try {
            JsonNode rootNode = objectMapper.readTree(request.getInputStream());
            String userMessage = rootNode.path("message").asText();

            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Message is empty\"}");
                return;
            }

            String systemInstruction;
            if (roleId == 2) { // 2 = Mentor
                systemInstruction = "Bạn là một trợ lý ảo chuyên về IELTS (IELTSFLOW AI). Bạn đang trò chuyện với một Giảng viên/Mentor. Hãy trả lời các câu hỏi về chuyên môn tiếng Anh, phương pháp giảng dạy IELTS, hoặc cung cấp tài liệu một cách ngắn gọn, súc tích và chuyên nghiệp.";
            } else { // 3 = Candidate or others
                systemInstruction = "Bạn là một trợ lý ảo chuyên về IELTS (IELTSFLOW AI). Bạn đang trò chuyện với một Học viên (Candidate). Hãy giải đáp các thắc mắc về kiến thức tiếng Anh, ngữ pháp, từ vựng, mẹo làm bài thi IELTS một cách dễ hiểu, nhiệt tình và truyền cảm hứng. Lưu ý dùng định dạng Markdown ngắn gọn nếu cần nhấn mạnh.";
            }

            String reply = geminiApiService.generateChatReply(systemInstruction, userMessage);

            if (reply != null) {
                String jsonResponse = objectMapper.writeValueAsString(new ChatResponse(reply));
                response.getWriter().write(jsonResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to get response from AI\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An internal error occurred\"}");
        }
    }

    private static class ChatResponse {
        public String reply;
        public ChatResponse(String reply) {
            this.reply = reply;
        }
    }
}
