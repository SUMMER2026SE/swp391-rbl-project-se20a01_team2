package controller;

import dao.SubscriptionPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SubscriptionPackage;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubscriptionController", urlPatterns = {"/subscription"})
public class SubscriptionController extends HttpServlet {

    private SubscriptionPackageDAO dao;

    @Override
    public void init() {
        dao = new SubscriptionPackageDAO();
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
        List<SubscriptionPackage> packages = dao.getActivePackagesPaginated(offset, limit);
        long totalCount = dao.getTotalActivePackagesCount();
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        request.setAttribute("packages", packages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/html/subscription.jsp").forward(request, response);
    }
}
