package controller;

import dao.CandidateTargetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CandidateTarget;
import model.User;
import services.UserService;
import services.UserServiceImpl;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "IeltsTargetServlet", urlPatterns = {"/ielts-target"})
public class IeltsTargetServlet extends HttpServlet {

    private UserService userService;
    private CandidateTargetDAO targetDAO;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        targetDAO = new CandidateTargetDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        Integer roleId = (Integer) session.getAttribute("roleId");
        if (roleId != null && (roleId == 1 || roleId == 2)) {
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        try {
            User user = userService.getUserById(userId);
            req.setAttribute("user", user);

            Optional<CandidateTarget> targetOpt = targetDAO.findActiveByUserId(userId);
            if (targetOpt.isPresent()) {
                req.setAttribute("target", targetOpt.get());
            }
        } catch (Exception e) {
            req.setAttribute("error", "Khong the tai thong tin: " + e.getMessage());
        }

        req.getRequestDispatcher("/jsp/ielts-target.jsp").forward(req, resp);
    }
}
