package controller;

import dao.CandidateTargetDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.util.Optional;
import model.CandidateTarget;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class GoalApiServletTest {

    @Mock
    private CandidateTargetDAO candidateTargetDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    private GoalApiServlet servlet;
    private StringWriter stringWriter;
    private PrintWriter printWriter;

    @BeforeEach
    public void setUp() throws Exception {
        servlet = new GoalApiServlet(candidateTargetDAO);
        stringWriter = new StringWriter();
        printWriter = new PrintWriter(stringWriter);

        lenient().when(response.getWriter()).thenReturn(printWriter);
        
        // Mock session behavior
        lenient().when(request.getSession(false)).thenReturn(session);
        lenient().when(session.getAttribute("userId")).thenReturn(1);
        
        // Default parameter stubbing to prevent Mockito strictness exceptions
        lenient().when(request.getParameter(anyString())).thenReturn(null);
    }

    @Test
    public void doPost_ShouldSaveGoal_WhenValidTargetBand() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("6.5");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(candidateTargetDAO, times(1)).saveOrUpdate(eq(1), any(), eq(new BigDecimal("6.5")));
        assertTrue(stringWriter.toString().contains("\"success\":true"));
    }

    @Test
    public void doPost_ShouldSaveGoal_WhenMinBoundaryTargetBand() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("4.0");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(candidateTargetDAO, times(1)).saveOrUpdate(eq(1), any(), eq(new BigDecimal("4.0")));
        assertTrue(stringWriter.toString().contains("\"success\":true"));
    }

    @Test
    public void doPost_ShouldSaveGoal_WhenMaxBoundaryTargetBand() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("9.0");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(candidateTargetDAO, times(1)).saveOrUpdate(eq(1), any(), eq(new BigDecimal("9.0")));
        assertTrue(stringWriter.toString().contains("\"success\":true"));
    }

    @Test
    public void doPost_ShouldReturnError_WhenBelowMinBoundary() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("3.9");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(response).setStatus(400);
        assertTrue(stringWriter.toString().contains("Target band must be between 4.0 and 9.0"));
        verify(candidateTargetDAO, never()).saveOrUpdate(anyInt(), any(), any());
    }

    @Test
    public void doPost_ShouldReturnError_WhenAboveMaxBoundary() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("9.1");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(response).setStatus(400);
        assertTrue(stringWriter.toString().contains("Target band must be between 4.0 and 9.0"));
        verify(candidateTargetDAO, never()).saveOrUpdate(anyInt(), any(), any());
    }

    @Test
    public void doPost_ShouldReturnError_WhenEmptyTargetBand() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(response).setStatus(400);
        assertTrue(stringWriter.toString().contains("targetBand is required"));
        verify(candidateTargetDAO, never()).saveOrUpdate(anyInt(), any(), any());
    }

    @Test
    public void doPost_ShouldReturnError_WhenNonNumericTargetBand() throws Exception {
        // Arrange
        when(request.getParameter("targetBand")).thenReturn("abc");

        // Act
        servlet.doPost(request, response);
        printWriter.flush();

        // Assert
        verify(response).setStatus(400);
        assertTrue(stringWriter.toString().contains("targetBand must be a number"));
        verify(candidateTargetDAO, never()).saveOrUpdate(anyInt(), any(), any());
    }

    @Test
    public void constructor_ShouldInitializeDao() {
        GoalApiServlet defaultServlet = new GoalApiServlet();
        assertNotNull(defaultServlet);
    }

    @Test
    public void doGet_ShouldReturn401_WhenSessionIsNull() throws Exception {
        lenient().when(request.getSession(false)).thenReturn(null);
        
        servlet.doGet(request, response);
        printWriter.flush();
        
        verify(response).setStatus(401);
        assertTrue(stringWriter.toString().contains("Unauthenticated"));
    }

    @Test
    public void doGet_ShouldReturn401_WhenUserIdIsNull() throws Exception {
        lenient().when(session.getAttribute("userId")).thenReturn(null);
        
        servlet.doGet(request, response);
        printWriter.flush();
        
        verify(response).setStatus(401);
        assertTrue(stringWriter.toString().contains("Unauthenticated"));
    }

    @Test
    public void doGet_ShouldReturnTarget_WhenTargetExists() throws Exception {
        CandidateTarget target = new CandidateTarget(1, new BigDecimal("6.5"), new BigDecimal("5.0"));
        when(candidateTargetDAO.findActiveByUserId(1)).thenReturn(Optional.of(target));
        
        servlet.doGet(request, response);
        printWriter.flush();
        
        assertTrue(stringWriter.toString().contains("\"currentBand\":5.0"));
        assertTrue(stringWriter.toString().contains("\"targetBand\":6.5"));
    }

    @Test
    public void doGet_ShouldReturnNulls_WhenTargetDoesNotExist() throws Exception {
        when(candidateTargetDAO.findActiveByUserId(1)).thenReturn(Optional.empty());
        
        servlet.doGet(request, response);
        printWriter.flush();
        
        assertTrue(stringWriter.toString().contains("\"currentBand\":null"));
        assertTrue(stringWriter.toString().contains("\"targetBand\":null"));
    }

    @Test
    public void doPost_ShouldReturn401_WhenSessionIsNull() throws Exception {
        lenient().when(request.getSession(false)).thenReturn(null);
        
        servlet.doPost(request, response);
        printWriter.flush();
        
        verify(response).setStatus(401);
        assertTrue(stringWriter.toString().contains("Unauthenticated"));
    }

    @Test
    public void doPost_ShouldReturn401_WhenUserIdIsNull() throws Exception {
        lenient().when(session.getAttribute("userId")).thenReturn(null);
        
        servlet.doPost(request, response);
        printWriter.flush();
        
        verify(response).setStatus(401);
        assertTrue(stringWriter.toString().contains("Unauthenticated"));
    }

    @Test
    public void doPost_ShouldSaveGoal_WhenValidTargetBandAndCurrentBandIsProvided() throws Exception {
        when(request.getParameter("targetBand")).thenReturn("6.5");
        when(request.getParameter("currentBand")).thenReturn("5.0");

        servlet.doPost(request, response);
        printWriter.flush();

        verify(candidateTargetDAO, times(1)).saveOrUpdate(eq(1), eq(new BigDecimal("5.0")), eq(new BigDecimal("6.5")));
        assertTrue(stringWriter.toString().contains("\"success\":true"));
    }

    @Test
    public void doPost_ShouldReturn500_WhenExceptionOccurs() throws Exception {
        when(request.getParameter("targetBand")).thenReturn("6.5");
        doThrow(new RuntimeException("Database error")).when(candidateTargetDAO).saveOrUpdate(anyInt(), any(), any());

        servlet.doPost(request, response);
        printWriter.flush();

        verify(response).setStatus(500);
        assertTrue(stringWriter.toString().contains("Database error"));
    }
}
