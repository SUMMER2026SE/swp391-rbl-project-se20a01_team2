package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý đăng xuất - xóa session và trả về JSON
 */
@WebServlet("/api/auth/logout")
public class LogoutServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doLogout(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doLogout(req, resp);
    }

    private void doLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Đăng xuất thành công");
        mapper.writeValue(resp.getOutputStream(), result);
    }
}
