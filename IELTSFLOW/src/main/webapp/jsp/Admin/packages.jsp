<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Gói Thành Viên - IELTSFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin-style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(79, 70, 229, 0.02); }
    </style>
</head>
<body>

<div class="admin-layout">
    <div class="mobile-overlay" id="mobileOverlay"></div>

    <aside class="admin-sidebar" id="adminSidebar">
        <div class="sidebar-header">IELTSFlow</div>
        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Tổng quan</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                    <i class="fa-solid fa-house"></i> Dashboard
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Quản lý Người dùng</div>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                    <i class="fa-solid fa-users-gear"></i> Thêm/Sửa/Khóa TK
                </a>
                <a href="${pageContext.request.contextPath}/admin/users/mentors" class="nav-item">
                    <i class="fa-solid fa-user-shield"></i> Phân quyền Mentor
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Tài chính & Doanh thu</div>
                <a href="${pageContext.request.contextPath}/admin/packages" class="nav-item active">
                    <i class="fa-solid fa-box-open"></i> Gói Thành Viên
                </a>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-item">
                    <i class="fa-solid fa-money-check-dollar"></i> Giao Dịch
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Hệ thống</div>
                <a href="${pageContext.request.contextPath}/admin/logs" class="nav-item">
                    <i class="fa-solid fa-server"></i> Log Hệ Thống
                </a>
            </div>
        </div>
    </aside>

    <main class="admin-main">
        <header class="main-header animate-on-scroll">
            <button class="hamburger" id="hamburgerBtn"><i class="fa-solid fa-bars"></i></button>
            <h1 class="page-title">Quản lý Gói Subscription</h1>
            <div class="header-actions">
                <c:if test="${!showDeleted}">
                    <a href="${pageContext.request.contextPath}/admin/packages?showDeleted=true" class="btn btn-light rounded-pill shadow-sm fw-bold me-2" style="color: var(--text-secondary);">Hiển thị gói đã xóa</a>
                </c:if>
                <c:if test="${showDeleted}">
                    <a href="${pageContext.request.contextPath}/admin/packages?showDeleted=false" class="btn btn-secondary rounded-pill shadow-sm fw-bold me-2">Ẩn gói đã xóa</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/packages?action=add" class="btn-nested">
                    Tạo Gói Mới <span class="btn-icon"><i class="fa-solid fa-plus"></i></span>
                </a>
            </div>
        </header>

        <div class="db-card-shell animate-on-scroll" style="animation-delay: 0.1s;">
            <div class="db-card-core" style="padding: 0; overflow: hidden;">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Tên Gói</th>
                                <th>Thời Hạn (Tháng)</th>
                                <th>Giá Tiền</th>
                                <th>Mô Tả Ngắn</th>
                                <th>Trạng Thái</th>
                                <th class="text-center pe-4">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pkg" items="${packages}">
                                <c:if test="${!pkg.deleted || showDeleted}">
                                    <tr class="${pkg.deleted ? 'opacity-50' : ''}">
                                        <td class="ps-4 text-secondary">${pkg.packageId}</td>
                                        <td class="fw-bold" style="color: var(--text-primary);">${pkg.name}</td>
                                        <td>${pkg.durationMonths} tháng</td>
                                        <td class="fw-bold" style="color: #10B981;">$ ${pkg.price}</td>
                                        <td class="text-secondary">${pkg.description}</td>
                                        <td>
                                            <c:if test="${pkg.deleted}">
                                                <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger border border-danger">Đã xóa mềm</span>
                                            </c:if>
                                            <c:if test="${!pkg.deleted}">
                                                <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success">Hoạt động</span>
                                            </c:if>
                                        </td>
                                        <td class="text-center pe-4">
                                            <c:if test="${!pkg.deleted}">
                                                <a href="${pageContext.request.contextPath}/admin/packages?action=edit&id=${pkg.packageId}" class="btn btn-sm btn-outline-primary rounded-pill me-1"><i class="fa-solid fa-pen"></i></a>
                                                <a href="${pageContext.request.contextPath}/admin/packages?action=delete&id=${pkg.packageId}" 
                                                   class="btn btn-sm btn-outline-danger rounded-pill" 
                                                   onclick="return confirm('Cảnh báo: Bạn có chắc chắn muốn xóa mềm gói này?');"><i class="fa-solid fa-trash"></i></a>
                                            </c:if>
                                            <c:if test="${pkg.deleted}">
                                                <a href="${pageContext.request.contextPath}/admin/packages?action=restore&id=${pkg.packageId}" 
                                                   class="btn btn-sm btn-outline-success rounded-pill"><i class="fa-solid fa-rotate-left"></i> Khôi phục</a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty packages}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">Không có dữ liệu gói thành viên.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/admin-script.js"></script>
</body>
</html>
