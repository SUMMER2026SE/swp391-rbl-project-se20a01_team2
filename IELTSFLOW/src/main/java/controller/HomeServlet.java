package controller;

import dao.CandidateTargetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CandidateTarget;
import model.Lesson;
import model.SubscriptionPackage;
import services.LessonService;
import services.SubscriptionService;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Servlet xử lý trang chủ (root URL).
 * Load dữ liệu động từ DB: gói đăng ký, bài học, mục tiêu band của học viên.
 * Forward sang /jsp/home.jsp để render.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private final SubscriptionService subscriptionService;
    private final LessonService lessonService;
    private final CandidateTargetDAO candidateTargetDAO;

    public HomeServlet() {
        this.subscriptionService = new SubscriptionService();
        this.lessonService = new LessonService();
        this.candidateTargetDAO = new CandidateTargetDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Load danh sách gói đăng ký đang hoạt động (tối đa 6 gói)
        try {
            List<SubscriptionPackage> packages = subscriptionService.getActivePackagesPaginated(0, 6);
            req.setAttribute("packages", packages);
        } catch (Exception e) {
            // Nếu lỗi DB, fallback là list rỗng → JSP sẽ hiển thị "Liên hệ để biết bảng giá"
            req.setAttribute("packages", java.util.Collections.emptyList());
        }

        // 2. Load 6 bài học mới nhất từ tất cả skill (cho section Thư viện ôn tập)
        try {
            // Dùng searchLessons với page=1, pageSize=6 để lấy bài mới nhất
            util.PaginatedList<Lesson> lessonPage = lessonService.searchLessons(null, null, 1, 6);
            req.setAttribute("recentLessons", lessonPage.getItems());
        } catch (Exception e) {
            req.setAttribute("recentLessons", java.util.Collections.emptyList());
        }

        // 3. Nếu học viên đã đăng nhập → load CandidateTarget hiện tại
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                int userId = (int) session.getAttribute("userId");
                Optional<CandidateTarget> targetOpt = candidateTargetDAO.findActiveByUserId(userId);
                targetOpt.ifPresent(target -> req.setAttribute("candidateTarget", target));
            } catch (Exception e) {
                // Bỏ qua nếu lỗi – JSP sẽ hiển thị form mặc định
            }
        }

        // 4. Forward sang /jsp/home.jsp để render
        req.getRequestDispatcher("/jsp/home.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
