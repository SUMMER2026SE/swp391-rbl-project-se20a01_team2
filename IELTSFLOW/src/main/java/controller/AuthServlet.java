package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("login".equals(action)) {
            // Forward internally to LoginServlet
            req.getRequestDispatcher("/login").forward(req, resp);
        } else if ("register".equals(action)) {
            // Forward internally to RegisterServlet
            req.getRequestDispatcher("/register").forward(req, resp);
        } else {
            // Default fallback
            resp.sendRedirect(req.getContextPath() + "/auth");
        }
    }
}
