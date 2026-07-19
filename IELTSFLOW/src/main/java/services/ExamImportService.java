package services;

import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;

public class ExamImportService {

    private static final Logger LOGGER = Logger.getLogger(ExamImportService.class.getName());
    private final GeminiApiService geminiApiService;

    public ExamImportService() {
        this.geminiApiService = new GeminiApiService();
    }

    /**
     * Tries to extract raw text from an uploaded file based on its extension.
     */
    public String extractTextFromFile(InputStream is, String fileName) throws IOException {
        String lowerName = fileName.toLowerCase();
        if (lowerName.endsWith(".pdf")) {
            return extractTextFromPdf(is);
        } else if (lowerName.endsWith(".docx")) {
            return extractTextFromDocx(is);
        } else if (lowerName.endsWith(".xlsx") || lowerName.endsWith(".xls")) {
            return extractTextFromExcel(is);
        } else {
            throw new IllegalArgumentException("Unsupported file type: " + fileName);
        }
    }

    private String extractTextFromPdf(InputStream is) throws IOException {
        try (PDDocument document = PDDocument.load(is)) {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    private String extractTextFromDocx(InputStream is) throws IOException {
        try (XWPFDocument doc = new XWPFDocument(is);
             XWPFWordExtractor extractor = new XWPFWordExtractor(doc)) {
            return extractor.getText();
        }
    }

    private String extractTextFromExcel(InputStream is) throws IOException {
        StringBuilder sb = new StringBuilder();
        DataFormatter dataFormatter = new DataFormatter();
        try (Workbook workbook = WorkbookFactory.create(is)) {
            for (Sheet sheet : workbook) {
                sb.append("Sheet: ").append(sheet.getSheetName()).append("\n");
                for (Row row : sheet) {
                    for (Cell cell : row) {
                        String cellValue = dataFormatter.formatCellValue(cell);
                        sb.append(cellValue).append("\t");
                    }
                    sb.append("\n");
                }
                sb.append("\n");
            }
        }
        return sb.toString();
    }

    /**
     * Parses the extracted text into a structured JSON Exam using Gemini.
     */
    public String parseTextToExamJson(String rawText) {
        String systemInstruction = "You are an AI assistant specialized in parsing IELTS and English test exams. "
                + "You will be provided with raw unstructured text extracted from a test document (PDF, Word, or Excel). "
                + "If the provided text is clearly NOT an exam, test, or educational learning material, you must set isExamMaterial to false and return empty/default values for the rest. "
                + "Otherwise, set isExamMaterial to true and identify the Exam title, sections (e.g. Listening, Reading), passages (resource text), and questions with their options and correct answers. "
                + "Return a strictly formatted JSON object matching the provided schema. Do your best to extract all questions accurately.";

        // We define a strict schema matching our frontend preview and backend models
        String responseSchemaJson = "{\n" +
                "  \"type\": \"object\",\n" +
                "  \"properties\": {\n" +
                "    \"isExamMaterial\": { \"type\": \"boolean\", \"description\": \"Set to false if the document is NOT an exam, test, or educational material.\" },\n" +
                "    \"title\": { \"type\": \"string\" },\n" +
                "    \"skillFocus\": { \"type\": \"string\", \"enum\": [\"Reading\", \"Listening\", \"Writing\", \"Speaking\", \"All\"] },\n" +
                "    \"duration\": { \"type\": \"integer\", \"description\": \"Duration in minutes\" },\n" +
                "    \"sections\": {\n" +
                "      \"type\": \"array\",\n" +
                "      \"items\": {\n" +
                "        \"type\": \"object\",\n" +
                "        \"properties\": {\n" +
                "          \"sectionName\": { \"type\": \"string\" },\n" +
                "          \"skill\": { \"type\": \"string\" },\n" +
                "          \"resourceText\": { \"type\": \"string\", \"description\": \"Reading passage or listening transcript. Return empty string if none.\" },\n" +
                "          \"questions\": {\n" +
                "            \"type\": \"array\",\n" +
                "            \"items\": {\n" +
                "              \"type\": \"object\",\n" +
                "              \"properties\": {\n" +
                "                \"content\": { \"type\": \"string\", \"description\": \"The question text\" },\n" +
                "                \"questionType\": { \"type\": \"string\", \"enum\": [\"MultipleChoice\", \"FillInBlanks\", \"Matching\", \"TrueFalse\"] },\n" +
                "                \"difficulty\": { \"type\": \"string\", \"enum\": [\"Easy\", \"Medium\", \"Hard\"] },\n" +
                "                \"explanation\": { \"type\": \"string\" },\n" +
                "                \"answers\": {\n" +
                "                  \"type\": \"array\",\n" +
                "                  \"items\": {\n" +
                "                    \"type\": \"object\",\n" +
                "                    \"properties\": {\n" +
                "                      \"content\": { \"type\": \"string\", \"description\": \"Answer text (e.g., option A, B, C or fill in blank answer)\" },\n" +
                "                      \"isCorrect\": { \"type\": \"boolean\" }\n" +
                "                    },\n" +
                "                    \"required\": [\"content\", \"isCorrect\"]\n" +
                "                  }\n" +
                "                }\n" +
                "              },\n" +
                "              \"required\": [\"content\", \"questionType\", \"answers\"]\n" +
                "            }\n" +
                "          }\n" +
                "        },\n" +
                "        \"required\": [\"sectionName\", \"skill\", \"questions\"]\n" +
                "      }\n" +
                "    }\n" +
                "  },\n" +
                "  \"required\": [\"isExamMaterial\", \"title\", \"skillFocus\", \"duration\", \"sections\"]\n" +
                "}";

        return geminiApiService.generateStructuredContent(systemInstruction, rawText, responseSchemaJson);
    }
}
