package test;

import services.GeminiApiService;
import io.github.cdimascio.dotenv.Dotenv;

public class TestChat {
    public static void main(String[] args) {
        try {
            // Setup keys from .env if needed
            Dotenv dotenv = Dotenv.configure()
                    .directory("c:/Code/github/SWP301_NHOM2_IELTSFLOW/IELTSFLOW/src/main/webapp/WEB-INF")
                    .filename(".env")
                    .ignoreIfMissing()
                    .load();
            String keys = dotenv.get("GEMINI_API_KEYS");
            if (keys != null) {
                System.setProperty("GEMINI_API_KEYS", keys);
            }
            
            GeminiApiService service = new GeminiApiService();
            System.out.println("Calling generateChatReply...");
            String response = service.generateChatReply("You are a helpful assistant.", "alo");
            System.out.println("Response: " + response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
