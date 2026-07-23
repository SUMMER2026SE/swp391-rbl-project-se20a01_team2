package controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.AsyncContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.GeminiApiService;

import java.io.IOException;

@WebServlet(value = "/api/chat", asyncSupported = true)
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
        // Content type will be set based on success or error

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
                response.setContentType("application/json; charset=UTF-8");
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

            response.setContentType("text/event-stream");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            response.setHeader("Connection", "keep-alive");
            response.setHeader("X-Accel-Buffering", "no");

            final String instruction = systemInstruction;
            final String msg = userMessage;

            AsyncContext asyncCtx = request.startAsync();
            asyncCtx.setTimeout(130_000);
            asyncCtx.start(() -> {
                try {
                    geminiApiService.streamChatReply(instruction, msg, asyncCtx.getResponse().getWriter());
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    asyncCtx.complete();
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An internal error occurred\"}");
        }
    }

}
