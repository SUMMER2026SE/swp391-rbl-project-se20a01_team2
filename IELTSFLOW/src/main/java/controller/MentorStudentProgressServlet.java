package controller;

import dao.MentorStudentDAO;
import dao.MockSubmissionDAO;
import model.User;
import model.TestSubmission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/mentor/students")
public class MentorStudentProgressServlet extends HttpServlet {

    private final MentorStudentDAO studentDAO = new MentorStudentDAO();
    private final MockSubmissionDAO submissionDAO = new MockSubmissionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        int mentorId = (int) session.getAttribute("userId");
        String keyword = req.getParameter("keyword");
        String sort = req.getParameter("sort");
        
        List<User> students = studentDAO.searchStudents(keyword, sort);
        
        // Optionally attach recent submissions count or latest submission to each student for display
        // Currently we can just pass the list of students, and if a mentor clicks on a student, it shows their submissions.
        req.setAttribute("students", students);
        
        String studentIdStr = req.getParameter("studentId");
        if (studentIdStr != null && !studentIdStr.isEmpty()) {
            int studentId = Integer.parseInt(studentIdStr);
            List<TestSubmission> submissions = submissionDAO.getSubmissionsByUser(studentId);
            req.setAttribute("selectedStudentId", studentId);
            req.setAttribute("studentSubmissions", submissions);
        }

        req.getRequestDispatcher("/jsp/mentor/student-progress.jsp").forward(req, resp);
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req) throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return false;
        }
        Integer roleId = (Integer) session.getAttribute("roleId");
        if (roleId == null || (roleId != 1 && roleId != 2)) {
            resp.sendRedirect(req.getContextPath() + "/?error=forbidden");
            return false;
        }
        return true;
    }
}
