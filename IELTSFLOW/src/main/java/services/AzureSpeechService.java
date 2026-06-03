package services;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.cognitiveservices.speech.*;
import com.microsoft.cognitiveservices.speech.audio.AudioConfig;
import model.PronunciationResult;

import java.io.File;
import java.util.concurrent.ExecutionException;

public class AzureSpeechService {

    private final String speechKey;
    private final String speechRegion;
    private final ObjectMapper objectMapper;

    public AzureSpeechService(String speechKey, String speechRegion) {
        this.speechKey = speechKey;
        this.speechRegion = speechRegion;
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Chấm điểm phát âm của thí sinh so với văn bản chuẩn (Task 55)
     */
    public PronunciationResult assessPronunciation(File audioFile, String referenceText) {
        try (SpeechConfig speechConfig = SpeechConfig.fromSubscription(speechKey, speechRegion);
             AudioConfig audioConfig = AudioConfig.fromWavFileInput(audioFile.getAbsolutePath())) {
             
            speechConfig.setSpeechRecognitionLanguage("en-US");

            try (SpeechRecognizer recognizer = new SpeechRecognizer(speechConfig, audioConfig);
                 PronunciationAssessmentConfig pronConfig = new PronunciationAssessmentConfig(
                         referenceText,
                         PronunciationAssessmentGradingSystem.HundredMark,
                         PronunciationAssessmentGranularity.Phoneme,
                         true // Bật tính toán miscue (thừa/thiếu từ)
                 )) {

                // Bật chấm điểm ngữ điệu (cộng điểm cho Fluency)
                pronConfig.enableProsodyAssessment();
                pronConfig.applyTo(recognizer);

                // Gọi API đồng bộ (chờ kết quả)
                SpeechRecognitionResult result = recognizer.recognizeOnceAsync().get();

                if (result.getReason() == ResultReason.RecognizedSpeech) {
                    PronunciationAssessmentResult pronResult = PronunciationAssessmentResult.fromResult(result);
                    
                    // Lấy chuỗi JSON chi tiết từ Azure
                    String detailedJsonString = result.getProperties().getProperty(PropertyId.SpeechServiceResponse_JsonResult);
                    JsonNode detailedJson = objectMapper.readTree(detailedJsonString);

                    return new PronunciationResult(
                            pronResult.getAccuracyScore(),
                            pronResult.getFluencyScore(),
                            pronResult.getCompletenessScore(),
                            pronResult.getProsodyScore(),
                            pronResult.getPronunciationScore(),
                            result.getText(),
                            detailedJson
                    );
                } else if (result.getReason() == ResultReason.NoMatch) {
                    return PronunciationResult.error("Không nhận diện được giọng nói trong file audio.");
                } else if (result.getReason() == ResultReason.Canceled) {
                    CancellationDetails cancellation = CancellationDetails.fromResult(result);
                    return PronunciationResult.error("Hủy do lỗi: " + cancellation.getErrorDetails());
                }
            }

        } catch (InterruptedException | ExecutionException e) {
            Thread.currentThread().interrupt();
            return PronunciationResult.error("Lỗi khi kết nối tới Azure API: " + e.getMessage());
        } catch (Exception e) {
            return PronunciationResult.error("Lỗi hệ thống: " + e.getMessage());
        }
        
        return PronunciationResult.error("Lỗi không xác định");
    }

    /**
     * Chuyển đổi giọng nói thành văn bản thuần túy (Task 60 - STT)
     */
    public String speechToText(File audioFile) {
        try (SpeechConfig speechConfig = SpeechConfig.fromSubscription(speechKey, speechRegion);
             AudioConfig audioConfig = AudioConfig.fromWavFileInput(audioFile.getAbsolutePath())) {

            speechConfig.setSpeechRecognitionLanguage("en-US");

            try (SpeechRecognizer recognizer = new SpeechRecognizer(speechConfig, audioConfig)) {
                SpeechRecognitionResult result = recognizer.recognizeOnceAsync().get();

                if (result.getReason() == ResultReason.RecognizedSpeech) {
                    return result.getText();
                } else if (result.getReason() == ResultReason.Canceled) {
                    CancellationDetails cancellation = CancellationDetails.fromResult(result);
                    throw new RuntimeException("Canceled STT: " + cancellation.getErrorDetails());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi xử lý Speech-To-Text: " + e.getMessage(), e);
        }
        return "";
    }
}
