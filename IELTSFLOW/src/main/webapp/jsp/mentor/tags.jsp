<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Tag - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(245, 158, 11, 0.03); }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-orange); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="tags" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Quản lý Tag 🏷️</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/mentor/tags?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold" style="background-color: var(--accent-orange); border-color: var(--accent-orange);">
                    Tạo Tag Mới <i class="fa-solid fa-plus ms-2"></i>
                </a>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Tên Tag</th>
                            <th>Loại Tag</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tag" items="${tags}">
                            <tr>
                                <td class="ps-4 text-secondary">#${tag.tagId}</td>
                                <td class="fw-bold" style="color: var(--text-primary);">${tag.tagName}</td>
                                <td><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">${tag.type}</span></td>
                                <td class="text-center pe-4">
                                    <a href="${pageContext.request.contextPath}/mentor/tags/${tag.tagId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                    <form action="${pageContext.request.contextPath}/mentor/tags" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="tagId" value="${tag.tagId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return confirm('Bạn có chắc chắn muốn xóa tag này?');"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty tags}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">Không có tag nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>
