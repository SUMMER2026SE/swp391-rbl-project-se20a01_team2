package controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class VerifyEmailServletTest {

    private VerifyEmailServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;

    @BeforeEach
    void setUp() {
        servlet = new VerifyEmailServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
    }

    // TC_VE_02: Verify Email with missing token
    @Test
    void doGet_ShouldRedirectWithError_WhenTokenIsMissing() throws Exception {
        when(request.getParameter("token")).thenReturn(null);
        when(request.getContextPath()).thenReturn("/ieltsflow");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/ieltsflow/auth?redirect_error=Link+x%C3%A1c+th%E1%BB%B1c+kh%C3%B4ng+h%E1%BB%A3p+l%E1%BB%87.");
    }

    // TC_VE_01: Verify Email successfully (Tăng coverage nhánh try)
    @Test
    void doGet_ShouldRedirectWithSuccess_WhenTokenIsValid() throws Exception {
        when(request.getParameter("token")).thenReturn("valid-token");
        when(request.getContextPath()).thenReturn("/ieltsflow");

        // Inject mock UserService
        services.UserService mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = VerifyEmailServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        doNothing().when(mockUserService).verifyEmail("valid-token");

        servlet.doGet(request, response);

        verify(mockUserService).verifyEmail("valid-token");
        verify(response).sendRedirect("/ieltsflow/auth?successMessage=X%C3%A1c+th%E1%BB%B1c+email+th%C3%A0nh+c%C3%B4ng%21+B%C3%A2y+gi%E1%BB%9D+b%E1%BA%A1n+%C4%91%C3%A3+c%C3%B3+th%E1%BB%83+%C4%91%C4%83ng+nh%E1%BA%ADp.");
    }

    // TC_VE_03: Verify Email throws Exception (Tăng coverage nhánh catch)
    @Test
    void doGet_ShouldRedirectWithError_WhenServiceThrowsException() throws Exception {
        when(request.getParameter("token")).thenReturn("invalid-token");
        when(request.getContextPath()).thenReturn("/ieltsflow");

        // Inject mock UserService
        services.UserService mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = VerifyEmailServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        doThrow(new Exception("Token không hợp lệ")).when(mockUserService).verifyEmail("invalid-token");

        servlet.doGet(request, response);

        verify(mockUserService).verifyEmail("invalid-token");
        verify(response).sendRedirect("/ieltsflow/auth?redirect_error=Token+kh%C3%B4ng+h%E1%BB%A3p+l%E1%BB%87&tab=login");
    }
}
