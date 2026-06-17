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
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(79, 70, 229, 0.02); }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="packages" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Quản lý Gói Subscription 📦</h1>
            <div class="header-actions">
                <c:if test="${!showDeleted}">
                    <a href="${pageContext.request.contextPath}/admin/packages?showDeleted=true" class="btn btn-glass rounded-pill shadow-sm fw-bold me-2">Hiển thị gói đã xóa</a>
                </c:if>
                <c:if test="${showDeleted}">
                    <a href="${pageContext.request.contextPath}/admin/packages?showDeleted=false" class="btn btn-secondary rounded-pill shadow-sm fw-bold me-2">Ẩn gói đã xóa</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/packages?action=add" class="btn btn-primary rounded-pill shadow-sm fw-bold">
                    Tạo Gói Mới <i class="fa-solid fa-plus ms-2"></i>
                </a>
            </div>
        </header>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 0; overflow: hidden;">
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
                                        <td class="fw-bold" style="color: #10B981;">${pkg.price} ₫</td>
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
    </main>
</div>

<!-- <script src="${pageContext.request.contextPath}/js/admin-script.js"></script> -->
</body>
</html>
