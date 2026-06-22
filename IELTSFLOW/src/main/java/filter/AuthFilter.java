package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AuthFilter – Kiểm tra xác thực và phân quyền theo Role.
 *
 * Quy tắc:
 *  - /jsp/admin/*       → Yêu cầu đăng nhập + roleId == 1 (Admin)
 *  - /jsp/account.jsp  → Yêu cầu đăng nhập (mọi role)
 *  - /jsp/survey.jsp   → Yêu cầu đăng nhập
 *  - /jsp/change-password.jsp → Yêu cầu đăng nhập
 *  - Còn lại              → Cho phép tự do (Guest)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // Các đường dẫn yêu cầu đăng nhập (bất kỳ role nào)
    private static final String[] PROTECTED_PATHS = {
        "/jsp/account.jsp",
        "/jsp/change-password.jsp",
        "/jsp/candidate/dashboard.jsp",
        "/jsp/candidate/weekly-plan.jsp",
        "/jsp/candidate/lessons.jsp",
        "/jsp/candidate/redo-exercises.jsp",
        "/jsp/candidate/notifications.jsp",
        "/jsp/candidate/tickets.jsp",
        "/jsp/candidate/ticket-detail.jsp"
    };

    private static final String[] PROTECTED_SERVLETS = {
        "/account",
        "/change-password",
        "/checkout",
        "/dashboard",
        "/candidate/dashboard",
        "/candidate/weekly-plan",
        "/candidate/lessons",
        "/candidate/redo-exercises",
        "/candidate/notifications",
        "/candidate/tickets"
    };

    // Các đường dẫn chỉ dành cho Admin (roleId == 1)
    private static final String ADMIN_PATH_PREFIX = "/jsp/admin";
    private static final String MENTOR_PATH_PREFIX = "/jsp/mentor";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();       // VD: /IELTSFLOW
        String requestURI  = req.getRequestURI();         // VD: /IELTSFLOW/jsp/account.jsp
        // Đường dẫn sau context
        String path = requestURI.substring(contextPath.length());

        HttpSession session = req.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("userId") != null);
        int roleId = 0;
        if (isLoggedIn && session.getAttribute("roleId") != null) {
            roleId = (int) session.getAttribute("roleId");
            int userId = (int) session.getAttribute("userId");
            
            // Kiểm tra trạng thái tài khoản liên tục từ DB
            try {
                dao.UserDAO userDAO = new dao.UserDAO();
                java.util.Optional<model.User> userOpt = userDAO.findById(userId);
                if (userOpt.isPresent()) {
                    String status = userOpt.get().getStatus();
                    if ("Banned".equals(status) || "Inactive".equals(status)) {
                        session.invalidate();
                        isLoggedIn = false;
                    }
                } else {
                    session.invalidate();
                    isLoggedIn = false;
                }
            } catch (Exception e) {
                // Ignore
            }
        }

        // ── 1. Kiểm tra đường dẫn Admin ────────────────────────────────────
        if (isStaffPath(path)) {
            if (!isLoggedIn) {
                redirectToLogin(resp, contextPath, "Vui lòng đăng nhập để tiếp tục");
                return;
            }
            if (roleId != 1 && roleId != 2) {
                // Không phải Admin hoặc Mentor → Chuyển về trang chủ với thông báo
                resp.sendRedirect(contextPath + "/index.html?error=forbidden");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Kiểm tra các trang được bảo vệ ──────────────────────────────
        if (isProtectedPath(path)) {
            if (!isLoggedIn) {
                redirectToLogin(resp, contextPath, "Vui lòng đăng nhập để tiếp tục");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── 3. Trang công khai – cho phép tất cả ───────────────────────────
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // WARN: Không làm gì
    }
    //morier: whats the use of this function then?

    /** Kiểm tra đường dẫn có phải là Admin không */
    private boolean isStaffPath(String path) {
        return path.startsWith(ADMIN_PATH_PREFIX)
                || path.startsWith("/admin/")
                || path.equals("/admin")
                || path.startsWith("/api/admin/")
                || path.startsWith(MENTOR_PATH_PREFIX)
                || path.startsWith("/mentor/")
                || path.equals("/mentor");
    }

    /** Kiểm tra đường dẫn có nằm trong danh sách cần bảo vệ không */
    private boolean isProtectedPath(String path) {
        for (String protectedPath : PROTECTED_PATHS) {
            if (path.equals(protectedPath) || path.startsWith(protectedPath + "?")) {
                return true;
            }
        }
        for (String protectedServlet : PROTECTED_SERVLETS) {
            if (path.equals(protectedServlet) || path.startsWith(protectedServlet + "?") || path.startsWith(protectedServlet + "/")) {
                return true;
            }
        }
        return false;
    }

    /** Redirect về trang đăng nhập kèm thông báo lỗi */
    private void redirectToLogin(HttpServletResponse resp, String contextPath, String message)
            throws IOException {
        try {
            String encodedMsg = java.net.URLEncoder.encode("Vui lòng đăng nhập để tiếp tục", "UTF-8");
            resp.sendRedirect(contextPath + "/auth?redirect_error=" + encodedMsg);
        } catch (Exception e) {
            resp.sendRedirect(contextPath + "/auth");
        }
    }
}
