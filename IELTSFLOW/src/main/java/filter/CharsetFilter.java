package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filter thiết lập mã hóa UTF-8 cho toàn bộ request và response
 * Giúp hiển thị tiếng Việt chính xác.
 */
@WebFilter("/*")
public class CharsetFilter implements Filter {

    private String encoding;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Đọc cấu hình từ web.xml, mặc định là UTF-8
        encoding = filterConfig.getInitParameter("encoding");
        if (encoding == null) {
            encoding = "UTF-8";
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Thiết lập encoding cho request
        if (null == request.getCharacterEncoding()) {
            request.setCharacterEncoding(encoding);
        }

        // Thiết lập encoding cho response
        response.setCharacterEncoding(encoding);
        
        // Thêm các header bảo mật cơ bản
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không làm gì
    }
}
