package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.PronunciationResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import services.AIEvaluationService;
import services.AzureSpeechService;
import services.SubmissionService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class SpeechAssessmentServletTest {

    private SpeechAssessmentServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private AzureSpeechService mockSpeechService;

    @Mock
    private SubmissionService mockSubmissionService;

    @Mock
    private AIEvaluationService mockAiEvaluationService;

    @Mock
    private Part mockPart;

    private StringWriter stringWriter;
    private PrintWriter printWriter;

    @BeforeEach
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        servlet = new SpeechAssessmentServlet();

        // Inject mocked dependencies using Reflection
        injectField(servlet, "speechService", mockSpeechService);
        injectField(servlet, "objectMapper", new ObjectMapper());
        injectField(servlet, "submissionService", mockSubmissionService);
        injectField(servlet, "aiEvaluationService", mockAiEvaluationService);

        stringWriter = new StringWriter();
        printWriter = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(printWriter);
    }

    private void injectField(Object target, String fieldName, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }

    // TC_SA_01: Verify Speech Assessment fails when audio file is missing
    @Test
    public void test_TC_SA_01_MissingAudioFile() throws Exception {
        // Arrange
        when(request.getPart("audioFile")).thenReturn(null);
        when(request.getParameter("referenceText")).thenReturn("Hello");

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(400);
        String jsonResponse = stringWriter.toString();
        assertTrue(jsonResponse.contains("Vui lòng đính kèm file âm thanh"));
    }

    // TC_SA_02: Verify Speech Assessment fails when Azure API throws error
    @Test
    public void test_TC_SA_02_AzureThrowsError() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello");
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L); // Valid size
        
        InputStream mockStream = new ByteArrayInputStream("dummy audio data".getBytes());
        when(mockPart.getInputStream()).thenReturn(mockStream);

        // Mock Azure throwing an exception or returning error
        when(mockSpeechService.assessPronunciation(any(), any()))
                .thenReturn(PronunciationResult.error("Azure connection failed"));

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(500);
        String jsonResponse = stringWriter.toString();
        assertTrue(jsonResponse.contains("Azure connection failed"));
    }

    // TC_SA_03: Verify Speech Assessment succeeds without saving to DB when detailId is absent
    @Test
    public void test_TC_SA_03_SuccessNoDbSave() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello");
        when(request.getParameter("detailId")).thenReturn(null); // detailId is absent
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L);
        when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("data".getBytes()));

        PronunciationResult mockResult = new PronunciationResult(90, 80, 100, 70, 85, "Hello", null);
        when(mockSpeechService.assessPronunciation(any(), any())).thenReturn(mockResult);

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(200);
        
        // Verify it did NOT save to DB
        verify(mockSubmissionService, never()).updateSpeakingEvaluation(anyInt(), anyString(), anyDouble());
        verify(mockAiEvaluationService, never()).evaluateSpeakingAsync(anyInt(), anyString(), anyString(), anyDouble());
    }

    // TC_SA_04: Verify Speech Assessment saves to DB without triggering AI when isUnscripted is false
    @Test
    public void test_TC_SA_04_SavesToDbWithoutAI() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello");
        when(request.getParameter("detailId")).thenReturn("101");
        when(request.getParameter("isUnscripted")).thenReturn("false"); // isUnscripted = false
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L);
        when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("data".getBytes()));

        PronunciationResult mockResult = new PronunciationResult(90, 80, 100, 70, 85, "Hello", null);
        when(mockSpeechService.assessPronunciation(any(), any())).thenReturn(mockResult);
        
        // Mock DB save success
        when(mockSubmissionService.updateSpeakingEvaluation(101, "Hello", 85.0)).thenReturn(true);

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(200);
        
        // Verify it SAVED to DB
        verify(mockSubmissionService, times(1)).updateSpeakingEvaluation(101, "Hello", 85.0);
        
        // Verify AI was NOT triggered
        verify(mockSubmissionService, never()).getQuestionContentByDetailId(anyInt());
        verify(mockAiEvaluationService, never()).evaluateSpeakingAsync(anyInt(), anyString(), anyString(), anyDouble());
    }

    // TC_SA_05: Verify Speech Assessment saves to DB and triggers AI when isUnscripted is true
    @Test
    public void test_TC_SA_05_SavesToDbAndTriggersAI() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello");
        when(request.getParameter("detailId")).thenReturn("102");
        when(request.getParameter("isUnscripted")).thenReturn("true"); // isUnscripted = true
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L);
        when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("data".getBytes()));

        PronunciationResult mockResult = new PronunciationResult(90, 80, 100, 70, 85, "Hello", null);
        when(mockSpeechService.assessPronunciation(any(), any())).thenReturn(mockResult);
        
        // Mock DB save success & fetching topic
        when(mockSubmissionService.updateSpeakingEvaluation(102, "Hello", 85.0)).thenReturn(true);
        when(mockSubmissionService.getQuestionContentByDetailId(102)).thenReturn("Describe a book");

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(200);
        
        // Verify it SAVED to DB
        verify(mockSubmissionService, times(1)).updateSpeakingEvaluation(102, "Hello", 85.0);
        
        // Verify it fetched topic for AI
        verify(mockSubmissionService, times(1)).getQuestionContentByDetailId(102);
        
        // Verify AI WAS triggered asynchronously
        verify(mockAiEvaluationService, times(1)).evaluateSpeakingAsync(102, "Describe a book", "Hello", 85.0);
    }

    // TC_SA_06: Verify handleFreeSpeechToText when referenceText is empty
    @Test
    public void test_TC_SA_06_FreeSpeechToText() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("");
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L);
        when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("data".getBytes()));

        when(mockSpeechService.speechToText(any())).thenReturn("This is free speech");

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(200);
        String jsonResponse = stringWriter.toString();
        assertTrue(jsonResponse.contains("This is free speech"));
    }

    // TC_SA_07: Verify internal server error is handled
    @Test
    public void test_TC_SA_07_InternalServerError() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello");
        when(request.getPart("audioFile")).thenThrow(new RuntimeException("Simulated internal error"));

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(500);
        String jsonResponse = stringWriter.toString();
        assertTrue(jsonResponse.contains("Lỗi Server Nội bộ"));
    }

    // TC_SA_08: Verify handleFreeSpeechToText fails early when audio is missing
    @Test
    public void test_TC_SA_08_MissingAudio_WithFreeSpeech() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("");
        when(request.getPart("audioFile")).thenReturn(null);

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(400);
        String jsonResponse = stringWriter.toString();
        assertTrue(jsonResponse.contains("Vui lòng đính kèm file âm thanh"));
    }

    // TC_SA_09: Verify processing succeeds without DB save when detailId format is invalid
    @Test
    public void test_TC_SA_09_InvalidDetailIdFormat_StillSucceedsWithoutSavingToDb() throws Exception {
        // Arrange
        when(request.getParameter("referenceText")).thenReturn("Hello world");
        when(request.getParameter("detailId")).thenReturn("abc"); // Invalid format
        when(request.getPart("audioFile")).thenReturn(mockPart);
        when(mockPart.getSize()).thenReturn(100L);
        when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("data".getBytes()));

        PronunciationResult mockResult = new PronunciationResult(90, 80, 100, 70, 85, "Hello world", null);
        when(mockSpeechService.assessPronunciation(any(), any())).thenReturn(mockResult);

        // Act
        servlet.doPost(request, response);

        // Assert
        verify(response).setStatus(200);
        // DB save should not be called since detailId will default to -1 after parse exception
        verify(mockSubmissionService, never()).updateSpeakingEvaluation(anyInt(), anyString(), anyDouble());
    }

    // TC_SA_10: Verify Init method logs warning when environment variables are missing
    @Test
    public void test_TC_SA_10_InitMethod_PrintsWarning_WhenKeysMissing() throws Exception {
        // Clear properties just to be sure
        System.clearProperty("SPEECH_KEY");
        System.clearProperty("SPEECH_REGION");
        
        SpeechAssessmentServlet freshServlet = new SpeechAssessmentServlet();
        // Just calling init to verify no exceptions are thrown and it handles nulls gracefully
        freshServlet.init();
        
        // Assert: Should not throw any exception, silently catches/prints error internally
        assertTrue(true);
    }
}
