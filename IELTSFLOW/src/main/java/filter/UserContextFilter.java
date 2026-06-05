package filter;

import util.UserContext;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter bắt mọi request để trích xuất userId từ Session 
 * và gắn vào ThreadLocal (UserContext) cho các tầng dưới sử dụng.
 */
@WebFilter("/*")
public class UserContextFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter (nếu cần)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpSession session = httpRequest.getSession(false);
            
            if (session != null) {
                Object userIdObj = session.getAttribute("userId");
                if (userIdObj != null) {
                    try {
                        Integer userId = Integer.parseInt(userIdObj.toString());
                        UserContext.setCurrentUserId(userId);
                    } catch (NumberFormatException e) {
                        // Bỏ qua nếu userId không hợp lệ
                    }
                }
            }
        }

        try {
            // Cho phép request đi tiếp
            chain.doFilter(request, response);
        } finally {
            // LUÔN LUÔN phải xóa context ở finally để tránh Memory Leak
            // vì Thread pool có thể dùng lại thread này cho request khác
            UserContext.clear();
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp filter
    }
}
