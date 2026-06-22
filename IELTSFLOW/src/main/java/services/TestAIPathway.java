package services;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import model.TestSubmission;
import model.WeeklyPlan;

/**
 * Independent test class to verify AIPathwayService functionality.
 * Output is written in English to prevent console encoding issues (e.g., weird characters).
 */
public class TestAIPathway {

    public static void main(String[] args) {
        // IMPORTANT: Set your real Gemini API key here to test
         System.setProperty("GEMINI_API_KEYS", "AIzaSyAijeySlBtZ0hPexGacPVQyTl-P5TYvtNI");
        
        // If there's no key, we put a dummy one just to see it run (it will fail the API call though)
        if (System.getProperty("GEMINI_API_KEYS") == null) {
            System.out.println("---------------------------------------------------------");
            System.out.println("[WARNING] GEMINI_API_KEYS is not set.");
            System.out.println("Please uncomment line 16 and set your real API key to test.");
            System.out.println("---------------------------------------------------------");
            System.setProperty("GEMINI_API_KEYS", "DUMMY_KEY"); 
        }

        AIPathwayService aiPathwayService = new AIPathwayService();
        
        // 1. Create a mock TestSubmission (Placement Test Result)
        TestSubmission mockSubmission = new TestSubmission();
        mockSubmission.setSubmissionId(999);
        mockSubmission.setListeningBand(5.0);
        mockSubmission.setReadingBand(4.5);
        mockSubmission.setWritingBand(4.0);
        mockSubmission.setSpeakingBand(4.5);
        mockSubmission.setOverallBand(4.5);
        
        // 2. Set Target Band
        BigDecimal targetBand = new BigDecimal("6.5");
        
        // 3. Mock the wrong questions count grouped by Tags
        // These are the areas the student needs to improve the most
        Map<String, Integer> mockWrongTags = Map.of(
            "Grammar: Past Tense", 6,
            "Writing: Task 1 - Line Graph", 3,
            "Reading: Matching Headings", 4
        );
        
        System.out.println("=== STARTING AI PATHWAY GENERATION TEST ===");
        System.out.println("Current Band: " + mockSubmission.getOverallBand() + " | Target Band: " + targetBand);
        System.out.println("Weaknesses identified (Wrong Tags): " + mockWrongTags.toString());
        System.out.println("Waiting for AI response...");
        System.out.println("---------------------------------------------------------");
        
        // 4. Call the service asynchronously
        CompletableFuture<List<WeeklyPlan>> future = aiPathwayService.generatePathwayAsync(
                mockSubmission, 
                targetBand, 
                mockWrongTags
        );
        
        // 5. Block the main thread to wait for the async task to complete
        try {
            List<WeeklyPlan> weeklyPlans = future.join();
            
            if (weeklyPlans != null && !weeklyPlans.isEmpty()) {
                System.out.println("[SUCCESS] Generated " + weeklyPlans.size() + " weekly plans.");
                for (WeeklyPlan plan : weeklyPlans) {
                    System.out.println("\n--- WEEK " + plan.getWeekNumber() + " ---");
                    System.out.println("Plan JSON Content:");
                    System.out.println(plan.getPlanContent());
                }
            } else {
                System.out.println("[FAILED] Pathway generation returned null or empty.");
                System.out.println("Please check if your API Key is valid and internet connection is working.");
            }
        } catch (Exception e) {
            System.out.println("[ERROR] An exception occurred during generation:");
            e.printStackTrace();
        }
        
        System.out.println("\n=== END OF TEST ===");
    }
}
