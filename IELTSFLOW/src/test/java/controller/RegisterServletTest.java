package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class RegisterServletTest {

    private RegisterServlet registerServlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher requestDispatcher;

    @BeforeEach
    void setUp() {
        registerServlet = new RegisterServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        requestDispatcher = mock(RequestDispatcher.class);

        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    // Edge case / EP: Register with empty full name
    @Test
    void doPost_ShouldSetError_WhenFullNameIsEmpty() throws Exception {
        when(request.getParameter("fullName")).thenReturn(""); // Empty name
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Pass1234");
        when(request.getParameter("confirmPassword")).thenReturn("Pass1234");

        registerServlet.doPost(request, response);

        verify(request).setAttribute("error", "Vui lòng nhập họ và tên");
        verify(requestDispatcher).forward(request, response);
    }

    // TC_REG_02: Register with invalid email format
    @Test
    void doPost_ShouldSetError_WhenEmailIsInvalid() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("johnexample.com"); // Invalid
        when(request.getParameter("password")).thenReturn("Pass1234");
        when(request.getParameter("confirmPassword")).thenReturn("Pass1234");

        registerServlet.doPost(request, response);

        verify(request).setAttribute("error", "Email không hợp lệ");
        verify(requestDispatcher).forward(request, response);
    }

    // TC_REG_03: Register with password length 7
    @Test
    void doPost_ShouldSetError_WhenPasswordIsTooShort() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Passwo1"); // length 7
        when(request.getParameter("confirmPassword")).thenReturn("Passwo1");

        registerServlet.doPost(request, response);

        verify(request).setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số");
        verify(requestDispatcher).forward(request, response);
    }

    // TC_REG_05: Register with mismatched passwords
    @Test
    void doPost_ShouldSetError_WhenPasswordsDoNotMatch() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Pass1234");
        when(request.getParameter("confirmPassword")).thenReturn("Pass5678");

        registerServlet.doPost(request, response);

        verify(request).setAttribute("error", "Mật khẩu xác nhận không khớp");
        verify(requestDispatcher).forward(request, response);
    }

    // TC_REG_04: Register with password length 8 (Boundary Valid)
    @Test
    void doPost_ShouldForwardToAuth_WhenPasswordIs8Chars() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Pass1234"); // length 8
        when(request.getParameter("confirmPassword")).thenReturn("Pass1234");

        // Request URL setup for baseUrl inside RegisterServlet
        when(request.getScheme()).thenReturn("http");
        when(request.getServerName()).thenReturn("localhost");
        when(request.getServerPort()).thenReturn(8080);
        when(request.getContextPath()).thenReturn("");

        // Use mockConstruction to intercept UserServiceImpl creation inside RegisterServlet
        try (org.mockito.MockedConstruction<services.UserServiceImpl> mocked = mockConstruction(services.UserServiceImpl.class)) {
            registerServlet.doPost(request, response);
        } catch (Exception e) {
            // Ignore other exceptions
        }

        // It should NOT set a validation error for password length
        verify(request, never()).setAttribute(eq("error"), eq("Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số"));
    }

    // --- MỚI: 3 Test Case bổ sung để tăng Coverage ---
    
    // 1. Tăng coverage cho hàm doGet()
    @Test
    void doGet_ShouldForwardToAuthJsp() throws Exception {
        registerServlet.doGet(request, response);
        verify(requestDispatcher).forward(request, response);
    }

    // 2. Tăng coverage cho nhánh X-Forwarded-* (Proxy Nginx)
    @Test
    void doPost_ShouldUseForwardedHeaders_WhenBehindProxy() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Pass1234");
        when(request.getParameter("confirmPassword")).thenReturn("Pass1234");

        // Giả lập request đi qua Nginx
        when(request.getHeader("X-Forwarded-Proto")).thenReturn("https");
        when(request.getHeader("X-Forwarded-Host")).thenReturn("ieltsflow.com");
        when(request.getContextPath()).thenReturn("");

        try (org.mockito.MockedConstruction<services.UserServiceImpl> mocked = mockConstruction(services.UserServiceImpl.class)) {
            registerServlet.doPost(request, response);
            
            // Lấy ra instance mock được tạo trong doPost
            services.UserServiceImpl mockService = mocked.constructed().get(0);
            
            // Xác nhận Service được gọi với baseUrl từ X-Forwarded header
            verify(mockService).registerUser("John Doe", "john@example.com", "Pass1234", "https://ieltsflow.com");
        }
        
        verify(request).setAttribute("successMessage", "Đăng ký thành công! Vui lòng kiểm tra hộp thư email (kể cả mục Spam) để kích hoạt tài khoản.");
        verify(request).setAttribute("tab", "login");
        verify(requestDispatcher).forward(request, response);
    }

    // 3. Tăng coverage cho nhánh catch (Exception e) khi gọi Service bị lỗi
    @Test
    void doPost_ShouldSetError_WhenServiceThrowsException() throws Exception {
        when(request.getParameter("fullName")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("password")).thenReturn("Pass1234");
        when(request.getParameter("confirmPassword")).thenReturn("Pass1234");
        
        when(request.getScheme()).thenReturn("http");
        when(request.getServerName()).thenReturn("localhost");
        when(request.getServerPort()).thenReturn(8080);
        when(request.getContextPath()).thenReturn("");

        // Giả lập Service ném lỗi (vd: Email đã tồn tại)
        try (org.mockito.MockedConstruction<services.UserServiceImpl> mocked = mockConstruction(services.UserServiceImpl.class, 
                (mock, context) -> {
                    when(mock.registerUser(anyString(), anyString(), anyString(), anyString()))
                        .thenThrow(new Exception("Email đã được sử dụng!"));
                })) {
            
            registerServlet.doPost(request, response);
        }

        // Xác nhận nhảy vào nhánh catch và set Attribute error
        verify(request).setAttribute("error", "Email đã được sử dụng!");
        verify(request).setAttribute("tab", "register");
        verify(requestDispatcher).forward(request, response);
    }
}
