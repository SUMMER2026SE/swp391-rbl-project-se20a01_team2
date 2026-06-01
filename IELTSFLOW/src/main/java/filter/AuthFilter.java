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
 *  - /pages/admin/*       → Yêu cầu đăng nhập + roleId == 1 (Admin)
 *  - /pages/profile.html  → Yêu cầu đăng nhập (mọi role)
 *  - /pages/survey.html   → Yêu cầu đăng nhập
 *  - /pages/change-password.html → Yêu cầu đăng nhập
 *  - Còn lại              → Cho phép tự do (Guest)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // Các đường dẫn yêu cầu đăng nhập (bất kỳ role nào)
    private static final String[] PROTECTED_PATHS = {
        "/pages/profile.html",
        "/pages/survey.html",
        "/pages/change-password.html"
    };

    // Các đường dẫn chỉ dành cho Admin (roleId == 1)
    private static final String ADMIN_PATH_PREFIX = "/pages/admin";

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
        String requestURI  = req.getRequestURI();         // VD: /IELTSFLOW/pages/profile.html
        // Đường dẫn sau context
        String path = requestURI.substring(contextPath.length());

        HttpSession session = req.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("userId") != null);
        int roleId = 0;
        if (isLoggedIn && session.getAttribute("roleId") != null) {
            roleId = (int) session.getAttribute("roleId");
        }

        // ── 1. Kiểm tra đường dẫn Admin ────────────────────────────────────
        if (path.startsWith(ADMIN_PATH_PREFIX)) {
            if (!isLoggedIn) {
                redirectToLogin(resp, contextPath, "Vui lòng đăng nhập để tiếp tục");
                return;
            }
            if (roleId != 1) {
                // Không phải Admin → Chuyển về trang chủ với thông báo
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
        // Không làm gì
    }

    /** Kiểm tra đường dẫn có nằm trong danh sách cần bảo vệ không */
    private boolean isProtectedPath(String path) {
        for (String protectedPath : PROTECTED_PATHS) {
            if (path.equals(protectedPath) || path.startsWith(protectedPath + "?")) {
                return true;
            }
        }
        return false;
    }

    /** Redirect về trang đăng nhập kèm thông báo lỗi */
    private void redirectToLogin(HttpServletResponse resp, String contextPath, String message)
            throws IOException {
        try {
            String encodedMsg = java.net.URLEncoder.encode(message, "UTF-8");
            resp.sendRedirect(contextPath + "/pages/login.html?redirect_error=" + encodedMsg);
        } catch (Exception e) {
            resp.sendRedirect(contextPath + "/pages/login.html");
        }
    }
}
