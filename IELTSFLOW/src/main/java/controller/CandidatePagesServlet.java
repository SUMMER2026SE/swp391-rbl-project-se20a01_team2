package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;

/**
 * Servlet for Candidate feature pages.
 * Maps multiple URLs to their corresponding JSPs.
 */
@WebServlet(name = "CandidatePagesServlet", urlPatterns = {
    "/candidate/weekly-plan", 
    "/candidate/lessons", 
    "/candidate/redo-exercises"
})
public class CandidatePagesServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải thông tin người dùng: " + e.getMessage());
        }

        String path = req.getServletPath();
        String jspPath = "/jsp/candidate/dashboard.jsp"; // Default fallback

        if ("/candidate/weekly-plan".equals(path)) {
            jspPath = "/jsp/candidate/weekly-plan.jsp";
        } else if ("/candidate/lessons".equals(path)) {
            jspPath = "/jsp/candidate/lessons.jsp";
        } else if ("/candidate/redo-exercises".equals(path)) {
            jspPath = "/jsp/candidate/redo-exercises.jsp";
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}
