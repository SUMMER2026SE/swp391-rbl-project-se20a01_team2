
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.util.*;

public class TestGrading {
    public static void main(String[] args) throws Exception {
        String candidateAnswer = "[\"A\",\"B\",\"C\",\"A\"]";
        String contentJson = "{\"1\":[\"A\"],\"2\":[\"B\"],\"3\":[\"C\"],\"4\":[\"A\"]}";
        
        int correctCount = 0;
        try {
            ObjectMapper mapper = new ObjectMapper();
            List<String> answers = mapper.readValue(candidateAnswer, new TypeReference<List<String>>(){});
            Map<String, List<String>> answerMap = mapper.readValue(contentJson, new TypeReference<Map<String, List<String>>>(){});
            
            for (int i = 0; i < answers.size(); i++) {
                String uAns = answers.get(i);
                if (uAns == null || uAns.trim().isEmpty()) continue;
                String blankKey = String.valueOf(i + 1);
                List<String> validOptions = answerMap.get(blankKey);
                if (validOptions != null) {
                    for (String validOpt : validOptions) {
                        if (uAns.trim().equalsIgnoreCase(validOpt.trim())) {
                            correctCount++;
                            break;
                        }
                    }
                }
            }
            System.out.println("Correct count: " + correctCount);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}

