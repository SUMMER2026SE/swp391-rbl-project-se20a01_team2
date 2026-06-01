<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - ${formAction == 'create' ? 'Tạo Gói Mới' : 'Chỉnh Sửa Gói'}</title>
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
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/admin/subscription" class="text-decoration-none"><i class="bi bi-arrow-left"></i> Quay lại</a>
            </div>

            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-white border-0 pt-4 pb-2 px-4">
                    <h5 class="mb-0 fw-bold">${formAction == 'create' ? 'Tạo Gói Mới' : 'Chỉnh Sửa Gói'}</h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <form action="${pageContext.request.contextPath}/admin/subscription" method="POST">
                        <input type="hidden" name="action" value="${formAction}">
                        <c:if test="${formAction == 'edit'}">
                            <input type="hidden" name="packageId" value="${pkg.packageId}">
                        </c:if>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold">Tên Gói</label>
                            <input type="text" class="form-control" id="name" name="name" value="${pkg.name}" placeholder="VD: Candidate Pro 3 Tháng" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="durationMonths" class="form-label fw-semibold">Thời Hạn (Tháng)</label>
                                <input type="number" class="form-control" id="durationMonths" name="durationMonths" value="${pkg.durationMonths}" min="1" placeholder="3" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label fw-semibold">Giá (VNĐ)</label>
                                <input type="number" step="0.01" class="form-control" id="price" name="price" value="${pkg.price}" placeholder="500000" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold">Mô Tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Mô tả ngắn gọn về các tính năng của gói...">${pkg.description}</textarea>
                        </div>



                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4"><i class="bi bi-save"></i> Lưu Thay Đổi</button>
                            <a href="${pageContext.request.contextPath}/admin/subscription" class="btn btn-light border px-4">Hủy</a>
                            <c:if test="${formAction == 'edit'}">

                                <c:choose>
                                    <c:when test="${pkg.deleted}">

                                        <a href="${pageContext.request.contextPath}/admin/subscription?action=restore&id=${pkg.packageId}" class="btn btn-success px-3" onclick="return confirm('Bạn có chắc chắn muốn khôi phục gói này không?');">
                                            <i class="bi bi-arrow-counterclockwise"></i> Khôi phục gói
                                        </a>

                                    </c:when>
                                    <c:otherwise>

                                        <a href="${pageContext.request.contextPath}/admin/subscription?action=delete&id=${pkg.packageId}" class="btn btn-outline-danger px-3" onclick="return confirm('Bạn có chắc chắn muốn xóa gói này không?');">
                                            <i class="bi bi-trash"></i> Xóa gói này
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
