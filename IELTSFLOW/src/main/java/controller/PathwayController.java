package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Pathway;
import model.WeeklyPlan;
import services.PathwayService;

import java.io.IOException;
import java.util.List;

/**
 * PathwayController - SSR refactored:
 *   GET /admin/pathways          : Xem danh sách lộ trình học
 *   POST /admin/pathways         : Thêm/Sửa/Xóa lộ trình học qua action
 */
@WebServlet("/admin/pathways/*")
public class PathwayController extends HttpServlet {

    private final PathwayService pathwayService = new PathwayService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); 

        try {
            // Hiển thị danh sách tất cả lộ trình
            if (pathInfo == null || pathInfo.equals("/")) {
                List<Pathway> pathways = pathwayService.getAllPathways();
                req.setAttribute("pathways", pathways);
                req.getRequestDispatcher("/jsp/admin/pathways.jsp").forward(req, resp);
                return;
            }

            // Xử lý các đường dẫn chi tiết khác nếu cần (ví dụ: /admin/pathways/123)
            String[] parts = pathInfo.substring(1).split("/");
            int id = Integer.parseInt(parts[0]);

            if (parts.length > 1 && "weekly-plans".equals(parts[1])) {
                List<WeeklyPlan> plans = pathwayService.getWeeklyPlans(id);
                req.setAttribute("plans", plans);
                req.getRequestDispatcher("/jsp/admin/weekly-plans.jsp").forward(req, resp);
            } else {
                Pathway pathway = pathwayService.getPathwayById(id);
                if (pathway == null) {
                    req.setAttribute("error", "Pathway not found");
                    req.getRequestDispatcher("/jsp/admin/pathways.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("pathway", pathway);
                req.getRequestDispatcher("/jsp/admin/pathway-detail.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid ID format");
            req.getRequestDispatcher("/jsp/admin/pathways.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/admin/pathways.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String pathInfo = req.getPathInfo();
        
        try {
            if ("create".equals(action)) {
                // Simplification for SSR forms
                Pathway pathway = new Pathway();
                // set attributes...
                // pathwayService.createPathway(pathway, List.of());
            } else if ("update".equals(action)) {
                // update logic
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                pathwayService.deletePathway(id);
            }
            
            resp.sendRedirect(req.getContextPath() + "/admin/pathways");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}
