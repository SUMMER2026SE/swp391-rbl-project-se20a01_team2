/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ntpho
 */

import services.SystemLogService;
import services.SystemLogServiceImpl;
import model.SystemLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/logs")
public class SystemLogController extends HttpServlet {
    private SystemLogService systemLogService = new SystemLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String action = request.getParameter("action");
        String entity = request.getParameter("entity");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        Integer userId = (userIdStr != null && !userIdStr.isEmpty()) ? Integer.parseInt(userIdStr) : null;
        if (action != null && action.isEmpty()) action = null;
        if (entity != null && entity.isEmpty()) entity = null;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) fromDate = sdf.parse(fromDateStr);
            if (toDateStr != null && !toDateStr.isEmpty()) toDate = sdf.parse(toDateStr);
        } catch (ParseException e) {
            // Thay vì printStackTrace, ta bắt lỗi và gán null để bỏ qua filter theo ngày bị sai format
            // Trong hệ thống thực tế nên dùng Logger (SLF4J/Logback) để ghi file log
            System.err.println("[Error] SystemLogController: Invalid date format passed - " + e.getMessage());
        }

        // Lấy danh sách log theo điều kiện lọc
        List<SystemLog> logs = systemLogService.filterSystemLogs(userId, action, entity, fromDate, toDate, 50);
        
        request.setAttribute("logs", logs);
        request.setAttribute("paramUserId", userIdStr);
        request.setAttribute("paramAction", action);
        request.setAttribute("paramEntity", entity);
        request.setAttribute("paramFromDate", fromDateStr);
        request.setAttribute("paramToDate", toDateStr);

        request.getRequestDispatcher("/jsp/admin/system-logs.jsp").forward(request, response);
    }
}
