package services;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service gọi Gemini API để chấm điểm Writing và Speaking.
 *
 * Các cải tiến:
 *  - Sử dụng model gemini-2.5-flash (đã verify hoạt động)
 *  - Key rotation dùng static AtomicInteger (single instance, shared across all calls)
 *  - Khi gặp 429/503: rotate sang key mới và thử lại thay vì dùng lại key cũ
 *  - Fallback hardcoded keys khi System.property chưa được load (Tomcat chưa restart)
 *  - Timeout hợp lý: 30s connect, 90s request (Gemini 2.5 có thể chậm với long prompts)
 */
public class GeminiApiService {

    private static final Logger LOGGER = Logger.getLogger(GeminiApiService.class.getName());

    // Đã verify ngày 25/06/2026: gemini-2.5-flash hoạt động với structured output
    private static final String MODEL_NAME = "gemma-4-31b-it";
    private static final String BASE_URL   =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            + MODEL_NAME + ":generateContent?key=";

    // Fallback keys - hardcoded để hệ thống luôn hoạt động kể cả khi .env chưa load
    private static final String[] FALLBACK_KEYS = {
        "YOUR_GEMINI_API_KEY_HERE"
    };

    // Static để tất cả instances dùng chung 1 counter tránh key bị hammer cùng lúc
    private static final AtomicInteger KEY_COUNTER = new AtomicInteger(0);

    private final HttpClient  httpClient;
    private final ObjectMapper objectMapper;

    public GeminiApiService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Lấy tất cả API keys từ System property (load từ .env) hoặc fallback hardcoded.
     */
    private String[] getAllKeys() {
        String keysStr = System.getProperty("GEMINI_API_KEYS");
        if (keysStr != null && !keysStr.isBlank()) {
            String[] parsed = keysStr.split(",");
            if (parsed.length > 0) {
                return java.util.Arrays.stream(parsed)
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .toArray(String[]::new);
            }
        }
        // Fallback: Tomcat chưa restart hoặc .env chưa được load
        LOGGER.warning("GEMINI_API_KEYS not in System properties. Using hardcoded fallback keys.");
        return FALLBACK_KEYS;
    }

    /**
     * Lấy key theo round-robin. index tăng dần, tự động quay vòng.
     */
    private String getNextKey(String[] keys) {
        int idx = (KEY_COUNTER.getAndIncrement() & Integer.MAX_VALUE) % keys.length;
        return keys[idx];
    }

    /**
     * Gọi Gemini API với structured JSON output.
     *
     * @param systemInstruction Vai trò và hướng dẫn cho AI
     * @param userPrompt        Nội dung cần AI đánh giá
     * @param responseSchemaJson JSON Schema string định dạng output
     * @return Chuỗi JSON kết quả từ AI, hoặc null nếu thất bại hoàn toàn
     */
    public String generateStructuredContent(String systemInstruction,
                                            String userPrompt,
                                            String responseSchemaJson) {
        String[] keys = getAllKeys();
        int maxAttempts = keys.length * 2; // Thử tối đa 2 vòng key rotation

        Exception lastException = null;
        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
            String apiKey = getNextKey(keys);
            LOGGER.info(String.format("[Gemini] Attempt %d/%d - Key: ...%s",
                    attempt, maxAttempts, apiKey.substring(Math.max(0, apiKey.length() - 8))));
            try {
                // Build full JSON payload cho Gemini API request
                String fullPayload = buildPayload(systemInstruction, userPrompt, responseSchemaJson);
                if (fullPayload == null) {
                    throw new RuntimeException("Failed to build JSON payload for Gemini");
                }

                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(BASE_URL + apiKey))
                        .header("Content-Type", "application/json; charset=UTF-8")
                        .timeout(Duration.ofSeconds(90))
                        .POST(HttpRequest.BodyPublishers.ofString(fullPayload, java.nio.charset.StandardCharsets.UTF_8))
                        .build();

                HttpResponse<String> response = httpClient.send(request,
                        HttpResponse.BodyHandlers.ofString(java.nio.charset.StandardCharsets.UTF_8));

                int status = response.statusCode();
                LOGGER.info(String.format("[Gemini] Response status: %d for attempt %d", status, attempt));

                if (status == 200) {
                    return extractTextFromResponse(response.body());
                } else if (status == 429 || status == 503 || status >= 500) {
                    // Rate limit hoặc server overload: rotate key và thử lại sau delay
                    LOGGER.warning(String.format("[Gemini] Status %d on attempt %d. Rotating key and retrying after delay.", status, attempt));
                    lastException = new RuntimeException("Gemini HTTP " + status);
                    int sleepMs = Math.min(3000 * attempt, 15000); // max 15s wait
                    Thread.sleep(sleepMs);
                    // Tiếp tục vòng lặp với key mới
                } else {
                    // Lỗi client (400, 401, 403) - không retry vì retry sẽ không giúp ích
                    LOGGER.severe(String.format("[Gemini] Fatal error %d: %s", status, response.body()));
                    throw new RuntimeException(String.format("Gemini API error %d: %s", status, response.body()));
                }

            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
                LOGGER.warning("[Gemini] Thread interrupted during retry sleep.");
                throw new RuntimeException("Thread interrupted while calling Gemini");
            } catch (Exception e) {
                lastException = e;
                LOGGER.log(Level.WARNING,
                        String.format("[Gemini] Exception on attempt %d: %s", attempt, e.getMessage()), e);
                if (attempt < maxAttempts) {
                    try { Thread.sleep(2000); } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new RuntimeException("Interrupted");
                    }
                }
            }
        }

        LOGGER.severe("[Gemini] All " + maxAttempts + " attempts exhausted. Returning null.");
        throw new RuntimeException("Gemini API requests exhausted. Last error: " + (lastException != null ? lastException.getMessage() : "Unknown"));
    }

    /**
     * Build JSON payload cho Gemini API request.
     */
    private String buildPayload(String systemInstruction, String userPrompt, String responseSchemaJson) {
        try {
            String sysText = objectMapper.writeValueAsString(systemInstruction);
            String userText = objectMapper.writeValueAsString(userPrompt);
            return "{"
                + "\"systemInstruction\":{\"parts\":[{\"text\":" + sysText + "}]},"
                + "\"contents\":[{\"parts\":[{\"text\":" + userText + "}]}],"
                + "\"generationConfig\":{"
                + "\"temperature\":0.2,"
                + "\"responseMimeType\":\"application/json\","
                + "\"responseSchema\":" + responseSchemaJson
                + "}"
                + "}";
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to build Gemini payload", e);
            return null;
        }
    }

    /**
     * Gọi Gemini API cho tính năng Chat (Plain text).
     *
     * @param systemInstruction Vai trò và hướng dẫn cho AI
     * @param userMessage        Tin nhắn của người dùng
     * @return Chuỗi text phản hồi từ AI, hoặc null nếu thất bại
     */
    public String generateChatReply(String systemInstruction, String userMessage) {
        String[] keys = getAllKeys();
        int maxAttempts = keys.length * 2; 

        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
            String apiKey = getNextKey(keys);
            try {
                String fullPayload = buildChatPayload(systemInstruction, userMessage);

                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(BASE_URL + apiKey))
                        .header("Content-Type", "application/json; charset=UTF-8")
                        .timeout(Duration.ofSeconds(60))
                        .POST(HttpRequest.BodyPublishers.ofString(fullPayload, java.nio.charset.StandardCharsets.UTF_8))
                        .build();

                HttpResponse<String> response = httpClient.send(request,
                        HttpResponse.BodyHandlers.ofString(java.nio.charset.StandardCharsets.UTF_8));

                int status = response.statusCode();

                if (status == 200) {
                    String jsonText = extractTextFromResponse(response.body());
                    if (jsonText != null) {
                        try {
                            com.fasterxml.jackson.databind.JsonNode root = objectMapper.readTree(jsonText);
                            if (root.has("reply")) {
                                return root.get("reply").asText();
                            }
                        } catch (Exception e) {
                            LOGGER.warning("Failed to parse chat json response: " + jsonText);
                        }
                    }
                    return jsonText;
                } else if (status == 429 || status == 503 || status >= 500) {
                    int sleepMs = Math.min(2000 * attempt, 10000); 
                    Thread.sleep(sleepMs);
                } else {
                    LOGGER.severe(String.format("[Gemini Chat] Fatal error %d: %s", status, response.body()));
                    return null;
                }
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
                return null;
            } catch (Exception e) {
                if (attempt < maxAttempts) {
                    try { Thread.sleep(1000); } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return null;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Build JSON payload đơn giản cho Chat.
     */
    private String buildChatPayload(String systemInstruction, String userMessage) {
        try {
            String sysText = objectMapper.writeValueAsString(systemInstruction);
            String userText = objectMapper.writeValueAsString(userMessage);
            String schema = "{\"type\":\"object\",\"properties\":{\"thinking\":{\"type\":\"string\",\"description\":\"Internal thoughts and reasoning\"},\"reply\":{\"type\":\"string\",\"description\":\"The final response to the user\"}},\"required\":[\"thinking\",\"reply\"]}";
            return "{"
                + "\"systemInstruction\":{\"parts\":[{\"text\":" + sysText + "}]},"
                + "\"contents\":[{\"parts\":[{\"text\":" + userText + "}]}],"
                + "\"generationConfig\":{"
                + "\"temperature\":0.7,"
                + "\"responseMimeType\":\"application/json\","
                + "\"responseSchema\":" + schema
                + "}"
                + "}";
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to build Chat payload", e);
            return null;
        }
    }

    /**
     * Parse kết quả từ Gemini API response body.
     * Gemini trả về text nằm trong candidates[0].content.parts[0].text
     */
    private String extractTextFromResponse(String responseBody) {
        try {
            var rootNode = objectMapper.readTree(responseBody);

            // Check candidates array
            var candidates = rootNode.path("candidates");
            if (!candidates.isArray() || candidates.isEmpty()) {
                LOGGER.warning("[Gemini] Response has no candidates: " + responseBody.substring(0, Math.min(200, responseBody.length())));
                return null;
            }

            var firstCandidate = candidates.get(0);

            // Check finishReason - nếu là SAFETY thì bị block
            String finishReason = firstCandidate.path("finishReason").asText("");
            if ("SAFETY".equals(finishReason) || "RECITATION".equals(finishReason)) {
                LOGGER.warning("[Gemini] Response blocked by safety filter. finishReason: " + finishReason);
                throw new RuntimeException("Gemini blocked response due to safety filter (" + finishReason + ")");
            }

            var parts = firstCandidate.path("content").path("parts");
            if (!parts.isArray() || parts.isEmpty()) {
                LOGGER.warning("[Gemini] No parts in response: " + responseBody.substring(0, Math.min(200, responseBody.length())));
                return null;
            }

            String text = parts.get(0).path("text").asText();
            if (text == null || text.isBlank()) {
                LOGGER.warning("[Gemini] Empty text in response.");
                return null;
            }

            // Gemini đôi khi bọc JSON trong ```json ... ``` dù đã set responseMimeType
            text = text.trim();
            if (text.startsWith("```json")) {
                text = text.substring(7);
            } else if (text.startsWith("```")) {
                text = text.substring(3);
            }
            if (text.endsWith("```")) {
                text = text.substring(0, text.length() - 3);
            }

            return text.trim();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[Gemini] Failed to parse response body", e);
            return null;
        }
    }
}
