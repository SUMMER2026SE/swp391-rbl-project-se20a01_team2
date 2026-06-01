<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản Lý Gói Thành Viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/subscription">Quản Trị Viên IELTSFlow</a>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4 text-primary"><i class="bi bi-box-seam"></i> Quản Lý Gói Thành Viên</h2>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <p class="text-muted mb-0">Quản lý tất cả các gói thành viên cung cấp cho học viên.</p>
        <a href="${pageContext.request.contextPath}/admin/subscription?action=create" class="btn btn-primary shadow-sm rounded-pill px-3">
            <i class="bi bi-plus-lg"></i> Thêm Gói Mới
        </a>
    </div>
    
    <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>Tên Gói</th>
                        <th>Thời Hạn</th>
                        <th>Giá (VNĐ)</th>
                        <th>Trạng Thái</th>
                        <th class="text-end pe-4">Thao Tác</th>
                    </tr>
                </thead>
                <tbody class="border-top-0">
                    <c:forEach var="pkg" items="${packages}">
                        <tr>
                            <td class="ps-4 text-muted">#${pkg.packageId}</td>
                            <td class="fw-bold">${pkg.name}</td>
                            <td>${pkg.durationMonths} Tháng</td>
                            <td class="text-primary fw-semibold">${pkg.price}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${pkg.deleted}">
                                        <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Đã Xóa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Hoạt Động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end pe-4">
                                <a href="${pageContext.request.contextPath}/admin/subscription?action=edit&id=${pkg.packageId}" class="btn btn-sm btn-light border me-1" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <c:if test="${!pkg.deleted}">
                                    <a href="${pageContext.request.contextPath}/admin/subscription?action=delete&id=${pkg.packageId}" class="btn btn-sm btn-light border text-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa gói này không?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty packages}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                Không tìm thấy gói nào. Nhấp vào 'Thêm Gói Mới' để bắt đầu.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
