package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class ChangePasswordServletTest {

    private ChangePasswordServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;
    private HttpSession session;
    private services.UserService mockUserService;

    @BeforeEach
    void setUp() throws Exception {
        servlet = new ChangePasswordServlet();
        servlet.init(); // Initialize userService internally
        
        // Inject mock UserService using reflection to avoid DB hit
        mockUserService = mock(services.UserService.class);
        java.lang.reflect.Field field = ChangePasswordServlet.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(servlet, mockUserService);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);
        session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

    // TC_CP_02: Change Password with mismatched new passwords
    @Test
    void doPost_ShouldSetError_WhenPasswordsDoNotMatch() throws Exception {
        when(request.getParameter("currentPassword")).thenReturn("OldPass1");
        when(request.getParameter("newPassword")).thenReturn("NewPass1");
        when(request.getParameter("confirmPassword")).thenReturn("DiffPass1");

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
        verify(dispatcher).forward(request, response);
    }

    // --- Bổ sung Test Cases để tăng Coverage ---

    @Test
    void doGet_ShouldRedirectToAuth_WhenSessionIsNull() throws Exception {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/ieltsflow");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/ieltsflow/auth");
    }

    @Test
    void doGet_ShouldForwardToJsp_WhenSessionIsValid() throws Exception {
        model.User user = new model.User();
        when(mockUserService.getUserById(1)).thenReturn(user);

        servlet.doGet(request, response);

        verify(request).setAttribute("user", user);
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doGet_ShouldSetError_WhenUserNotFound() throws Exception {
        when(mockUserService.getUserById(1)).thenThrow(new Exception("User not found"));

        servlet.doGet(request, response);

        verify(request).setAttribute("error", "Không thể tải thông tin tài khoản: User not found");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldRedirectToAuth_WhenSessionIsNull() throws Exception {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/ieltsflow");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/ieltsflow/auth");
    }

    @Test
    void doPost_ShouldSetError_WhenFieldsAreEmpty() throws Exception {
        when(request.getParameter("currentPassword")).thenReturn("");
        when(request.getParameter("newPassword")).thenReturn("");
        when(request.getParameter("confirmPassword")).thenReturn("");

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường");
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doPost_ShouldRedirectWithSuccess_WhenServiceSucceeds() throws Exception {
        when(request.getParameter("currentPassword")).thenReturn("OldPass1");
        when(request.getParameter("newPassword")).thenReturn("NewPass123");
        when(request.getParameter("confirmPassword")).thenReturn("NewPass123");
        when(request.getContextPath()).thenReturn("/ieltsflow");

        doNothing().when(mockUserService).changePassword(1, "OldPass1", "NewPass123");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/ieltsflow/change-password?success=C%E1%BA%ADp+nh%E1%BA%ADt+m%E1%BA%ADt+kh%E1%BA%A9u+th%C3%A0nh+c%C3%B4ng");
    }

    @Test
    void doPost_ShouldSetError_WhenServiceThrowsException() throws Exception {
        when(request.getParameter("currentPassword")).thenReturn("OldPass1");
        when(request.getParameter("newPassword")).thenReturn("NewPass123");
        when(request.getParameter("confirmPassword")).thenReturn("NewPass123");

        doThrow(new Exception("Sai mật khẩu hiện tại")).when(mockUserService).changePassword(1, "OldPass1", "NewPass123");

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Sai mật khẩu hiện tại");
        verify(dispatcher).forward(request, response);
    }
}
