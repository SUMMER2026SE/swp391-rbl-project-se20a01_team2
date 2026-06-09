/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ntpho
 */

import services.PackageService;
import services.PackageServiceImpl;
import model.SubscriptionPackage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/packages")
public class PackageController extends HttpServlet {
    private PackageService packageService = new PackageServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                SubscriptionPackage pkg = packageService.getPackageById(id);
                request.setAttribute("pkg", pkg);
                // Chuyển hướng sang trang Form để chỉnh sửa
                request.getRequestDispatcher("/jsp/admin/package-form.jsp").forward(request, response);
                break;
            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                packageService.deletePackage(delId);
                // Sau khi xóa xong, tải lại trang danh sách
                response.sendRedirect(request.getContextPath() + "/admin/packages");
                break;
            case "restore":
                int resId = Integer.parseInt(request.getParameter("id"));
                packageService.restorePackage(resId);
                response.sendRedirect(request.getContextPath() + "/admin/packages");
                break;
            case "add":
                // Chuyển hướng sang trang Form để tạo mới
                request.getRequestDispatcher("/jsp/admin/package-form.jsp").forward(request, response);
                break;
            default: // "list"
                List<SubscriptionPackage> list = packageService.getAllPackages();
                String showDeletedStr = request.getParameter("showDeleted");
                boolean showDeleted = "true".equals(showDeletedStr);
                
                request.setAttribute("packages", list);
                request.setAttribute("showDeleted", showDeleted);
                // Chuyển hướng sang trang hiển thị danh sách
                request.getRequestDispatcher("/jsp/admin/packages.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Nhận dữ liệu từ Form (Thêm hoặc Sửa)
        String idStr = request.getParameter("packageId");
        String name = request.getParameter("name");
        int duration = Integer.parseInt(request.getParameter("durationMonths"));
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String desc = request.getParameter("description");

        if (idStr == null || idStr.isEmpty()) {
            // Nút Thêm mới
            SubscriptionPackage newPkg = new SubscriptionPackage(name, duration, price, desc);
            packageService.createPackage(newPkg);
        } else {
            // Nút Cập nhật (Sửa)
            SubscriptionPackage pkg = packageService.getPackageById(Integer.parseInt(idStr));
            pkg.setName(name);
            pkg.setDurationMonths(duration);
            pkg.setPrice(price);
            pkg.setDescription(desc);
            packageService.updatePackage(pkg);
        }

        // Thực hiện xong quay về trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/packages");
    }
}