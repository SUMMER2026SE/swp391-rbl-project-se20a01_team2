package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class ForgotPasswordServletTest {

    private ForgotPasswordServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        servlet = new ForgotPasswordServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

    // TC_FP_02: Forgot Password with empty email
    @Test
    void doPost_ShouldSetError_WhenEmailIsEmpty() throws Exception {
        when(request.getParameter("action")).thenReturn("sendOtp");
        when(request.getParameter("email")).thenReturn("");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Vui lòng nhập email");
        verify(dispatcher).forward(request, response);
    }

    // --- Bổ sung Test Cases để tăng Coverage ---

    @Test
    void doGet_ShouldForwardToForgotPasswordJsp() throws Exception {
        servlet.doGet(request, response);
        verify(request).getRequestDispatcher("/jsp/forgot-password.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldForwardToVerifyOtp_WhenSendOtpSuccess() throws Exception {
        when(request.getParameter("action")).thenReturn("sendOtp");
        when(request.getParameter("email")).thenReturn("test@example.com");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);

        servlet.init();
        services.UserService mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = ForgotPasswordServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        doNothing().when(mockUserService).forgotPassword("test@example.com");

        servlet.doPost(request, response);

        verify(session).setAttribute("resetEmail", "test@example.com");
        verify(request).setAttribute("step", "verifyOtp");
        verify(request).setAttribute("successMessage", "Mã xác thực đã được gửi tới email của bạn.");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldSetError_WhenEmailIsNullInSessionForVerifyOtp() throws Exception {
        when(request.getParameter("action")).thenReturn("verifyOtp");
        when(request.getParameter("otp")).thenReturn("123456");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("resetEmail")).thenReturn(null);

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Yêu cầu đã hết hạn. Vui lòng thử lại.");
        verify(request).setAttribute("step", "verifyOtp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldForwardToResetPassword_WhenVerifyOtpSuccess() throws Exception {
        when(request.getParameter("action")).thenReturn("verifyOtp");
        when(request.getParameter("otp")).thenReturn("123456");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("resetEmail")).thenReturn("test@example.com");

        servlet.init();
        services.UserService mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = ForgotPasswordServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        when(mockUserService.verifyOtp("test@example.com", "123456")).thenReturn("valid-token");

        servlet.doPost(request, response);

        verify(session).setAttribute("resetToken", "valid-token");
        verify(request).setAttribute("step", "resetPassword");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldSetError_WhenResetTokenIsNullForResetPassword() throws Exception {
        when(request.getParameter("action")).thenReturn("resetPassword");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("resetToken")).thenReturn(null);

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Phiên làm việc hết hạn. Vui lòng thử lại.");
        verify(request).setAttribute("step", "resetPassword");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldRedirectToAuth_WhenResetPasswordSuccess() throws Exception {
        when(request.getParameter("action")).thenReturn("resetPassword");
        when(request.getParameter("newPassword")).thenReturn("NewPass123");
        when(request.getParameter("confirmPassword")).thenReturn("NewPass123");
        jakarta.servlet.http.HttpSession session = mock(jakarta.servlet.http.HttpSession.class);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("resetToken")).thenReturn("valid-token");
        when(request.getRequestDispatcher("/jsp/auth.jsp")).thenReturn(dispatcher);

        servlet.init();
        services.UserService mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = ForgotPasswordServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        doNothing().when(mockUserService).resetPassword("valid-token", "NewPass123");

        servlet.doPost(request, response);

        verify(session).removeAttribute("resetEmail");
        verify(session).removeAttribute("resetToken");
        verify(request).setAttribute("successMessage", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay bây giờ.");
        verify(request).getRequestDispatcher("/jsp/auth.jsp");
        verify(dispatcher).forward(request, response);
    }
}
