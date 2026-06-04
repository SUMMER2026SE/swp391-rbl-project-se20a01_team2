package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Pathway;
import model.WeeklyPlan;
import services.PathwayService;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * PathwayController - xử lý các chức năng:
 *   #26 Xem lộ trình học         : GET /api/pathway?userId=...
 *                                   GET /api/pathway/{id}/weekly-plans
 *   #27 Nhận gợi ý học hôm nay   : GET /api/pathway/today?userId=...
 */
@WebServlet("/api/pathway/*")
public class PathwayController extends HttpServlet {

    private final PathwayService pathwayService = new PathwayService();
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo(); // null, /, /today, /123, /123/weekly-plans

        try {
            // #27 Gợi ý học hôm nay
            if ("/today".equals(pathInfo)) {
                String userIdStr = req.getParameter("userId");
                if (userIdStr == null) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"userId is required\"}");
                    return;
                }
                WeeklyPlan today = pathwayService.getTodaySuggestion(Integer.parseInt(userIdStr));
                if (today == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"message\":\"Không có gợi ý học hôm nay\"}");
                    return;
                }
                mapper.writeValue(resp.getWriter(), today);
                return;
            }

            if (pathInfo == null || pathInfo.equals("/")) {
                // #26 Lấy lộ trình của user
                String userIdStr = req.getParameter("userId");
                if (userIdStr != null) {
                    mapper.writeValue(resp.getWriter(),
                            pathwayService.getPathwaysByUser(Integer.parseInt(userIdStr)));
                } else {
                    mapper.writeValue(resp.getWriter(), pathwayService.getAllPathways());
                }
                return;
            }

            String[] parts = pathInfo.substring(1).split("/");
            int id = Integer.parseInt(parts[0]);

            if (parts.length > 1 && "weekly-plans".equals(parts[1])) {
                // #26 Lấy weekly plans của 1 lộ trình
                List<WeeklyPlan> plans = pathwayService.getWeeklyPlans(id);
                mapper.writeValue(resp.getWriter(), plans);
            } else {
                // Lấy chi tiết pathway
                Pathway pathway = pathwayService.getPathwayById(id);
                if (pathway == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\":\"Pathway not found\"}");
                    return;
                }
                mapper.writeValue(resp.getWriter(), pathway);
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid ID format\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            // Body: { "pathway": {...}, "weeklyPlans": [...] }
            PathwayRequest body = mapper.readValue(req.getReader(), PathwayRequest.class);
            List<WeeklyPlan> plans = body.weeklyPlans != null
                    ? Arrays.asList(body.weeklyPlans) : List.of();
            pathwayService.createPathway(body.pathway, plans);
            resp.setStatus(HttpServletResponse.SC_CREATED);
            mapper.writeValue(resp.getWriter(), body.pathway);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            WeeklyPlan plan = mapper.readValue(req.getReader(), WeeklyPlan.class);
            pathwayService.updateWeeklyPlan(plan);
            mapper.writeValue(resp.getWriter(), plan);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            pathwayService.deletePathway(Integer.parseInt(pathInfo.substring(1)));
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private static class PathwayRequest {
        public Pathway pathway;
        public WeeklyPlan[] weeklyPlans;
    }
}
