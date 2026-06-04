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

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * RateLimitFilter - Chong tan cong Brute-force tren cac endpoint dang nhap.
 * Moi IP chi duoc thu toi da MAX_ATTEMPTS lan trong WINDOW_MS mili giay.
 */
@WebFilter(urlPatterns = {"/login", "/register"})
public class RateLimitFilter implements Filter {

    private static final int MAX_ATTEMPTS  = 10;
    private static final long WINDOW_MS    = 5 * 60 * 1000L;
    private static final long BLOCK_MS     = 15 * 60 * 1000L;

    private static final Map<String, AttemptInfo> attempts = new ConcurrentHashMap<>();

    @Override public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        if (!"POST".equalsIgnoreCase(req.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        String ip = getClientIP(req);
        AttemptInfo info = attempts.computeIfAbsent(ip, k -> new AttemptInfo());
        long now = System.currentTimeMillis();

        if (info.blockedUntil > now) {
            long remaining = (info.blockedUntil - now) / 1000 / 60;
            req.setAttribute("error", "Quá nhiều lần thử. Vui lòng thử lại sau " + remaining + " phút.");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }

        if (now - info.windowStart > WINDOW_MS) {
            info.windowStart = now;
            info.count.set(0);
        }

        if (info.count.incrementAndGet() > MAX_ATTEMPTS) {
            info.blockedUntil = now + BLOCK_MS;
            info.count.set(0);
            req.setAttribute("error", "Tài khoản tạm thời bị khóa do đăng nhập sai quá nhiều lần. Thử lại sau 15 phút.");
            req.getRequestDispatcher("/jsp/auth.jsp").forward(req, resp);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { attempts.clear(); }

    private String getClientIP(HttpServletRequest req) {
        String forwarded = req.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isEmpty() && !"unknown".equalsIgnoreCase(forwarded)) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = req.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isEmpty() && !"unknown".equalsIgnoreCase(realIp)) {
            return realIp;
        }
        return req.getRemoteAddr();
    }

    private static class AttemptInfo {
        AtomicInteger count        = new AtomicInteger(0);
        long          windowStart  = System.currentTimeMillis();
        long          blockedUntil = 0;
    }
}
