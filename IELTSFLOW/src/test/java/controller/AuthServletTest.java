package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

class AuthServletTest {

    private AuthServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        servlet = new AuthServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);
    }

    // TC_AUTH_01: GET request forwards to auth.jsp
    @Test
    void doGet_ShouldForwardToAuthJsp() throws Exception {
        when(request.getRequestDispatcher("/jsp/auth.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(request).getRequestDispatcher("/jsp/auth.jsp");
        verify(dispatcher).forward(request, response);
    }

    // TC_AUTH_02: POST with action=login forwards to /login
    @Test
    void doPost_ShouldForwardToLogin_WhenActionIsLogin() throws Exception {
        when(request.getParameter("action")).thenReturn("login");
        when(request.getRequestDispatcher("/login")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request).getRequestDispatcher("/login");
        verify(dispatcher).forward(request, response);
    }

    // TC_AUTH_03: POST with action=register forwards to /register
    @Test
    void doPost_ShouldForwardToRegister_WhenActionIsRegister() throws Exception {
        when(request.getParameter("action")).thenReturn("register");
        when(request.getRequestDispatcher("/register")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request).getRequestDispatcher("/register");
        verify(dispatcher).forward(request, response);
    }

    // TC_AUTH_04: POST with unknown action redirects to /auth
    @Test
    void doPost_ShouldRedirectToAuth_WhenActionIsUnknown() throws Exception {
        when(request.getParameter("action")).thenReturn("unknown");
        when(request.getContextPath()).thenReturn("/ieltsflow");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/ieltsflow/auth");
    }

    // TC_AUTH_05: POST with null action redirects to /auth (Edge case)
    @Test
    void doPost_ShouldRedirectToAuth_WhenActionIsNull() throws Exception {
        when(request.getParameter("action")).thenReturn(null);
        when(request.getContextPath()).thenReturn("/ieltsflow");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/ieltsflow/auth");
    }
}
