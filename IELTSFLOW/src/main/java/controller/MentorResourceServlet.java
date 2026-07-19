package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.QuestionResource;
import services.QuestionResourceService;

import java.io.IOException;

@WebServlet("/mentor/resources/*")
public class MentorResourceServlet extends HttpServlet {

    private final QuestionResourceService resourceService = new QuestionResourceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String action = req.getParameter("action");
                if ("new".equals(action)) {
                    req.getRequestDispatcher("/jsp/mentor/resource-detail.jsp").forward(req, resp);
                    return;
                }

                String keyword = req.getParameter("keyword");
                String typeFilter = req.getParameter("typeFilter");
                String sortOrder = req.getParameter("sortOrder");
                
                int page = 1;
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException ignored) {}
                
                util.PaginatedList<model.QuestionResource> resourcesPage = resourceService.searchResources(keyword, typeFilter, sortOrder, page, 10);
                
                req.setAttribute("resources", resourcesPage.getItems());
                req.setAttribute("resourcesPage", resourcesPage);
                
                req.setAttribute("keyword", keyword);
                req.setAttribute("typeFilter", typeFilter);
                req.setAttribute("sortOrder", sortOrder);
                req.getRequestDispatcher("/jsp/mentor/resources.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                QuestionResource resource = resourceService.getResourceById(id);
                if (resource == null) {
                    req.setAttribute("error", "Không tìm thấy tài nguyên");
                    req.setAttribute("resources", resourceService.getAllResources());
                    req.getRequestDispatcher("/jsp/mentor/resources.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("resource", resource);
                req.getRequestDispatcher("/jsp/mentor/resource-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ");
            req.setAttribute("resources", resourceService.getAllResources());
            req.getRequestDispatcher("/jsp/mentor/resources.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("resources", resourceService.getAllResources());
            req.getRequestDispatcher("/jsp/mentor/resources.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String action = req.getParameter("action");
        int mentorId = (int) session.getAttribute("userId");

        try {
            if ("create".equals(action)) {
                QuestionResource resource = buildFromRequest(req);
                resource.setCreatedBy(mentorId);
                resourceService.createResource(resource);
                resp.sendRedirect(req.getContextPath() + "/mentor/resources?success=" + java.net.URLEncoder.encode("Tạo tài nguyên thành công", "UTF-8"));

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("resourceId"));
                QuestionResource resource = buildFromRequest(req);
                resource.setResourceId(id);
                resourceService.updateResource(resource);
                resp.sendRedirect(req.getContextPath() + "/mentor/resources?success=" + java.net.URLEncoder.encode("Cập nhật thành công", "UTF-8"));

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("resourceId"));
                resourceService.deleteResource(id);
                resp.sendRedirect(req.getContextPath() + "/mentor/resources?success=" + java.net.URLEncoder.encode("Xóa tài nguyên thành công", "UTF-8"));

            } else if ("bulk_delete".equals(action)) {
                String[] rIds = req.getParameterValues("resourceIds");
                if (rIds != null) {
                    for (String idStr : rIds) {
                        try {
                            resourceService.deleteResource(Integer.parseInt(idStr));
                        } catch (Exception ignored) {}
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/mentor/resources?success=" + java.net.URLEncoder.encode("Xóa hàng loạt tài nguyên thành công", "UTF-8"));

            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/resources");
            }

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private QuestionResource buildFromRequest(HttpServletRequest req) {
        QuestionResource r = new QuestionResource();
        r.setType(req.getParameter("type")); // "Passage" or "Audio"
        r.setResourceName(req.getParameter("resourceName"));
        
        String resourceText = req.getParameter("resourceText");
        r.setResourceText(resourceText != null && !resourceText.trim().isEmpty() ? resourceText : null);
        
        String resourceAudioUrl = req.getParameter("resourceAudioUrl");
        r.setResourceAudioUrl(resourceAudioUrl != null && !resourceAudioUrl.trim().isEmpty() ? resourceAudioUrl : null);
        
        String resourceImageUrl = req.getParameter("resourceImageUrl");
        r.setResourceImageUrl(resourceImageUrl != null && !resourceImageUrl.trim().isEmpty() ? resourceImageUrl : null);
        
        return r;
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req)
            throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return false;
        }
        return true;
    }
}
