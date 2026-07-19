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
        } else if (lowerName.endsWith(".md") || lowerName.endsWith(".txt")) {
            return new String(is.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
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
        String systemInstruction = loadResourceFile("prompts/exam_import_prompt.txt");
        String responseSchemaJson = loadResourceFile("prompts/exam_import_schema.json");

        return geminiApiService.generateStructuredContent(systemInstruction, rawText, responseSchemaJson);
    }
    
    private String loadResourceFile(String path) {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream(path)) {
            if (is == null) {
                throw new IOException("Resource not found: " + path);
            }
            return new String(is.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to load resource file: " + path, e);
            return "";
        }
    }
}
