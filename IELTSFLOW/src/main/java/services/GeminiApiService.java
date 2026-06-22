package services;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GeminiApiService {
    private static final Logger LOGGER = Logger.getLogger(GeminiApiService.class.getName());
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=";
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GeminiApiService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    private static final java.util.concurrent.atomic.AtomicInteger keyIndex = new java.util.concurrent.atomic.AtomicInteger(0);

    private String getApiKey() {
        String keysStr = System.getProperty("GEMINI_API_KEYS");
        if (keysStr == null || keysStr.isBlank()) {
            LOGGER.severe("GEMINI_API_KEYS is not set in environment or .env file.");
            return null;
        }
        String[] keys = keysStr.split(",");
        if (keys.length == 0) return null;
        
        int index = (keyIndex.getAndIncrement() & Integer.MAX_VALUE) % keys.length;
        return keys[index].trim();
    }

    /**
     * Call Gemini API with structured output
     * @param systemInstruction The system instruction (role, context)
     * @param userPrompt The user prompt (text to evaluate)
     * @param responseSchemaJson The JSON Schema string for structured output
     * @return The JSON string of the extracted data
     */
    public String generateStructuredContent(String systemInstruction, String userPrompt, String responseSchemaJson) {
        String apiKey = getApiKey();
        if (apiKey == null) return null;

        try {
            // Build the JSON payload for Gemini API
            String payload = "{\n" +
                "  \"systemInstruction\": {\n" +
                "    \"parts\": [{\"text\": " + objectMapper.writeValueAsString(systemInstruction) + "}]\n" +
                "  },\n" +
                "  \"contents\": [{\n" +
                "    \"parts\": [{\"text\": " + objectMapper.writeValueAsString(userPrompt) + "}]\n" +
                "  }],\n" +
                "  \"generationConfig\": {\n" +
                "    \"temperature\": 0.2,\n" +
                "    \"responseMimeType\": \"application/json\",\n" +
                "    \"responseSchema\": " + responseSchemaJson + "\n" +
                "  }\n" +
                "}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL + apiKey))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(60)) // Allow up to 60 seconds for AI processing
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                // Parse response to extract the actual JSON text
                var rootNode = objectMapper.readTree(response.body());
                var candidates = rootNode.path("candidates");
                if (candidates.isArray() && candidates.size() > 0) {
                    var textNode = candidates.get(0).path("content").path("parts").get(0).path("text");
                    return textNode.asText();
                }
            } else {
                LOGGER.severe("Gemini API Error: " + response.statusCode() + " - " + response.body());
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Exception calling Gemini API", e);
        }
        return null;
    }
}
