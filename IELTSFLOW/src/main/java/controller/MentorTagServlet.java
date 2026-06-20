package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Tag;
import services.TagService;

import java.io.IOException;

@WebServlet("/mentor/tags/*")
public class MentorTagServlet extends HttpServlet {

    private final TagService tagService = new TagService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                req.setAttribute("tags", tagService.getAllTags());
                req.getRequestDispatcher("/jsp/mentor/tags.jsp").forward(req, resp);
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Tag tag = tagService.getTagById(id);
                if (tag == null) {
                    req.setAttribute("error", "Không tìm thấy tag");
                    req.setAttribute("tags", tagService.getAllTags());
                    req.getRequestDispatcher("/jsp/mentor/tags.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("tag", tag);
                req.getRequestDispatcher("/jsp/mentor/tag-detail.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ");
            req.setAttribute("tags", tagService.getAllTags());
            req.getRequestDispatcher("/jsp/mentor/tags.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("tags", tagService.getAllTags());
            req.getRequestDispatcher("/jsp/mentor/tags.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!isMentor(session, resp, req)) return;

        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                Tag tag = buildFromRequest(req);
                tagService.createTag(tag);
                resp.sendRedirect(req.getContextPath() + "/mentor/tags?success=Tạo+tag+thành+công");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("tagId"));
                Tag tag = buildFromRequest(req);
                tag.setTagId(id);
                tagService.updateTag(tag);
                resp.sendRedirect(req.getContextPath() + "/mentor/tags?success=Cập+nhật+thành+công");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("tagId"));
                tagService.deleteTag(id);
                resp.sendRedirect(req.getContextPath() + "/mentor/tags?success=Xóa+tag+thành+công");

            } else {
                resp.sendRedirect(req.getContextPath() + "/mentor/tags");
            }

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }

    private Tag buildFromRequest(HttpServletRequest req) {
        Tag tag = new Tag();
        tag.setName(req.getParameter("name"));
        tag.setType(req.getParameter("type"));
        return tag;
    }

    private boolean isMentor(HttpSession session, HttpServletResponse resp, HttpServletRequest req)
            throws IOException {
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth.jsp");
            return false;
        }
        return true;
    }
}
