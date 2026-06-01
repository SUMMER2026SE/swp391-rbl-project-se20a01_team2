package controller;

import dao.SubscriptionPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SubscriptionPackage;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminSubscriptionServlet", urlPatterns = {"/admin/subscription"})
public class AdminSubscriptionServlet extends HttpServlet {

    private SubscriptionPackageDAO dao;

    @Override
    public void init() {
        dao = new SubscriptionPackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deletePackage(request, response);
                break;
            case "restore":
                restorePackage(request, response);
                break;
            case "list":
            default:
                listPackages(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/subscription");
            return;
        }
        
        switch (action) {
            case "create":
                createPackage(request, response);
                break;
            case "edit":
                updatePackage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/subscription");
                break;
        }
    }

    private void listPackages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int limit = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        String statusFilter = request.getParameter("status");
        if (statusFilter == null) statusFilter = "all";
        
        String sortOption = request.getParameter("sort");
        if (sortOption == null) sortOption = "default";
        
        int offset = (page - 1) * limit;
        List<SubscriptionPackage> packages = dao.getPackagesPaginated(offset, limit, statusFilter, sortOption);
        long totalCount = dao.getTotalPackagesCount(statusFilter);
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        request.setAttribute("packages", packages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("sortOption", sortOption);
        request.getRequestDispatcher("/html/admin/subscription/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/html/admin/subscription/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            SubscriptionPackage pkg = dao.getPackageById(id);
            request.setAttribute("pkg", pkg);
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/html/admin/subscription/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/subscription");
        }
    }

    private void deletePackage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.softDeletePackage(id);
        } catch (NumberFormatException ignored) {}
        response.sendRedirect(request.getContextPath() + "/admin/subscription");
    }

    private void restorePackage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.restorePackage(id);
        } catch (NumberFormatException ignored) {}
        response.sendRedirect(request.getContextPath() + "/admin/subscription");
    }

    private void createPackage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String name = request.getParameter("name");
            int duration = Integer.parseInt(request.getParameter("durationMonths"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String description = request.getParameter("description");

            SubscriptionPackage pkg = new SubscriptionPackage(name, duration, price, description);
            dao.addPackage(pkg);
        } catch (Exception ignored) {}
        
        response.sendRedirect(request.getContextPath() + "/admin/subscription");
    }

    private void updatePackage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("packageId"));
            String name = request.getParameter("name");
            int duration = Integer.parseInt(request.getParameter("durationMonths"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String description = request.getParameter("description");

            SubscriptionPackage pkg = dao.getPackageById(id);
            if (pkg != null) {
                pkg.setName(name);
                pkg.setDurationMonths(duration);
                pkg.setPrice(price);
                pkg.setDescription(description);
                dao.updatePackage(pkg);
            }
        } catch (Exception ignored) {}
        
        response.sendRedirect(request.getContextPath() + "/admin/subscription");
    }
}
