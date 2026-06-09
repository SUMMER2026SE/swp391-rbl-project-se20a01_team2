/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ntpho
 */


import services.DashboardService;
import services.DashboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {
    private DashboardService dashboardService = new DashboardServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Chỉ lấy thống kê Hệ thống và Doanh thu
        BigDecimal totalRevenue = dashboardService.getTotalRevenue();
        Long totalUsers = dashboardService.getTotalActiveUsers();
        Long totalTests = dashboardService.getTotalTestSubmissions();

        // 2. Ném ra View
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTests", totalTests);

        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }
}