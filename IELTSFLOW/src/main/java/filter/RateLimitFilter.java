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
 * RateLimitFilter – Chống tấn công Brute-force trên các endpoint đăng nhập.
 *
 * Quy tắc: Mỗi IP chỉ được thử tối đa MAX_ATTEMPTS lần trong WINDOW_MS mili giây.
 * Nếu vượt quá → Trả về HTTP 429 (Too Many Requests) và khóa IP trong BLOCK_MS.
 *
 * Áp dụng trên: POST /api/auth/login và POST /api/auth/forgot-password
 */
@WebFilter(urlPatterns = {"/api/auth/login", "/api/auth/forgot-password"})
public class RateLimitFilter implements Filter {

    /** Số lần thử tối đa trong cửa sổ thời gian */
    private static final int MAX_ATTEMPTS = 10;
    /** Cửa sổ thời gian tính lại (5 phút) */
    private static final long WINDOW_MS   = 5 * 60 * 1000L;
    /** Thời gian khóa khi vi phạm (15 phút) */
    private static final long BLOCK_MS    = 15 * 60 * 1000L;

    /** Lưu trạng thái theo IP: [IP → AttemptInfo] */
    private static final Map<String, AttemptInfo> attempts = new ConcurrentHashMap<>();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Chỉ giới hạn tốc độ với POST request
        if (!"POST".equalsIgnoreCase(req.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        String ip = getClientIP(req);
        AttemptInfo info = attempts.computeIfAbsent(ip, k -> new AttemptInfo());

        long now = System.currentTimeMillis();

        // Nếu IP đang bị khóa
        if (info.blockedUntil > now) {
            long remaining = (info.blockedUntil - now) / 1000 / 60;
            resp.setContentType("application/json;charset=UTF-8");
            resp.setStatus(429);
            resp.getWriter().write(
                "{\"success\":false,\"message\":\"Quá nhiều lần thử. Vui lòng thử lại sau " + remaining + " phút.\"}"
            );
            return;
        }

        // Reset nếu đã qua cửa sổ thời gian
        if (now - info.windowStart > WINDOW_MS) {
            info.windowStart = now;
            info.count.set(0);
        }

        int currentCount = info.count.incrementAndGet();

        if (currentCount > MAX_ATTEMPTS) {
            // Khóa IP
            info.blockedUntil = now + BLOCK_MS;
            info.count.set(0);
            resp.setContentType("application/json;charset=UTF-8");
            resp.setStatus(429);
            resp.getWriter().write(
                "{\"success\":false,\"message\":\"Tài khoản tạm thời bị khóa do đăng nhập sai quá nhiều lần. Thử lại sau 15 phút.\"}"
            );
            return;
        }

        // Thêm header thông tin còn lại
        resp.setHeader("X-RateLimit-Limit",     String.valueOf(MAX_ATTEMPTS));
        resp.setHeader("X-RateLimit-Remaining", String.valueOf(Math.max(0, MAX_ATTEMPTS - currentCount)));

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        attempts.clear();
    }

    /** Lấy IP thật của client (hỗ trợ proxy / load balancer) */
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

    /** Cấu trúc lưu trạng thái của một IP */
    private static class AttemptInfo {
        AtomicInteger count       = new AtomicInteger(0);
        long          windowStart = System.currentTimeMillis();
        long          blockedUntil = 0;
    }
}
