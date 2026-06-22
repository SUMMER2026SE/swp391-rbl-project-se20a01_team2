<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pkg != null ? 'Sửa' : 'Thêm'} Gói Thành Viên - IELTSFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .form-control { border-radius: 1rem; padding: 0.75rem 1rem; border: 1px solid var(--border-color); background-color: #f9fafb; transition: all 0.2s; }
        .form-control:focus { background-color: #fff; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); border-color: var(--accent-color); }
        .form-label { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.875rem; }
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
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <div style="display: flex; align-items: center;">
                <a href="${pageContext.request.contextPath}/admin/packages" style="color: var(--text-secondary); text-decoration: none; margin-right: 1rem; font-size: 1.5rem;"><i class="fa-solid fa-arrow-left"></i></a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${pkg != null ? 'Cập Nhật Gói 📦' : 'Tạo Gói Mới 📦'}</h1>
            </div>
        </header>

        <div style="max-width: 600px; margin: 0 auto;">
            <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 2.5rem;">
                    
                    <form action="${pageContext.request.contextPath}/admin/packages" method="post">
                        <!-- Chứa ID ngầm nếu đang trong chế độ Sửa -->
                        <input type="hidden" name="packageId" value="${pkg != null ? pkg.packageId : ''}" />
                        
                        <div class="mb-4">
                            <label class="form-label">Tên Gói</label>
                            <input type="text" class="form-control" name="name" value="${pkg != null ? pkg.name : ''}" placeholder="Vd: Gói Pro 3 Tháng" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Thời Hạn (Số tháng)</label>
                                <input type="number" class="form-control" name="durationMonths" value="${pkg != null ? pkg.durationMonths : ''}" min="1" required>
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Giá Tiền (₫)</label>
                                <div class="input-group">
                                    <span class="input-group-text" style="border-radius: 1rem 0 0 1rem; border: 1px solid var(--border-color); background: #f9fafb; font-weight: bold;">₫</span>
                                    <input type="number" step="0.01" class="form-control" name="price" value="${pkg != null ? pkg.price : ''}" style="border-radius: 0 1rem 1rem 0;" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-5">
                            <label class="form-label">Mô Tả Quyền Lợi</label>
                            <textarea class="form-control" name="description" rows="4" placeholder="Nhập các quyền lợi đặc biệt của gói này...">${pkg != null ? pkg.description : ''}</textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end align-items-center gap-3">
                            <a href="${pageContext.request.contextPath}/admin/packages" class="text-secondary fw-bold" style="text-decoration: none;">Hủy bỏ</a>
                            <button type="submit" class="btn" style="background-color: #10B981; color: white;">
                                Lưu Thông Tin
                            </button>
                        </div>
                    </form>

            </div>
        </div>

    </main>
</div>

<!-- <script src="${pageContext.request.contextPath}/js/admin-script.js"></script> -->
</body>
</html>
