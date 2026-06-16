package controller;

import jakarta.servlet.ServletException;
import services.SubscriptionService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SubscriptionPackage;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubscriptionController", urlPatterns = {"/subscription"})
public class SubscriptionController extends HttpServlet {

    private SubscriptionService service;

    @Override
    public void init() {
        service = new SubscriptionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int limit = 6; // Show 6 packages per page on frontend
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int offset = (page - 1) * limit;
        List<SubscriptionPackage> packages = service.getActivePackagesPaginated(offset, limit);
        long totalCount = service.getTotalActivePackagesCount();
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        boolean hasActiveSub = false;
        boolean hasAnySub = false;
        
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");
            hasActiveSub = (service.getActiveSubscriptionByUserId(userId) != null);
            hasAnySub = service.hasAnySubscription(userId);
        }

        request.setAttribute("packages", packages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("hasActiveSub", hasActiveSub);
        request.setAttribute("hasAnySub", hasAnySub);
        
        request.getRequestDispatcher("/jsp/subscription.jsp").forward(request, response);
    }
}
