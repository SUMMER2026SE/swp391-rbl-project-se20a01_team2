<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Tài nguyên - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(99, 102, 241, 0.03); }
        .type-badge { font-weight: 600; font-size: 0.75rem; padding: 0.35rem 0.6rem; border-radius: 4px; }
        .type-passage { background-color: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.2); }
        .type-audio { background-color: rgba(245, 158, 11, 0.1); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.2); }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-purple); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="resources" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">Quản lý tài nguyên đề thi 📚</h1>
                <p class="text-secondary mt-1 mb-0">Quản lý các đoạn văn (Passage) và tệp nghe (Audio) dùng chung cho nhiều câu hỏi.</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/mentor/resources?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
                    Tạo Tài Nguyên <i class="fa-solid fa-plus ms-2"></i>
                </a>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up mb-4 p-3" style="animation-delay: 0.1s;">
            <form action="${pageContext.request.contextPath}/mentor/resources" method="GET" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo ID, tên, nội dung..." value="${param.keyword}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="typeFilter" class="form-select">
                        <option value="">Tất cả loại</option>
                        <option value="Passage" ${param.typeFilter == 'Passage' ? 'selected' : ''}>Passage (Đoạn văn)</option>
                        <option value="Audio" ${param.typeFilter == 'Audio' ? 'selected' : ''}>Audio (Bài nghe)</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary fw-bold" style="background-color: var(--accent-blue); border-color: var(--accent-blue);">Lọc & Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/mentor/resources" class="btn btn-outline-secondary ms-2">Bỏ lọc</a>
                </div>
            </form>
        </div>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.2s; padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Resource ID</th>
                            <th>Tên Tài Nguyên</th>
                            <th>Loại</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="res" items="${resources}">
                            <tr>
                                <td class="ps-4 fw-bold" style="color: var(--accent-purple);">#${res.resourceId}</td>
                                <td class="fw-bold text-dark">${res.resourceName != null ? res.resourceName : '<span class="text-muted fst-italic">Chưa đặt tên</span>'}</td>
                                <td>
                                    <span class="type-badge ${res.type eq 'Passage' ? 'type-passage' : (res.type eq 'Audio' ? 'type-audio' : 'bg-primary bg-opacity-10 text-primary')}">
                                        <i class="fa-solid ${res.type eq 'Passage' ? 'fa-book-open' : (res.type eq 'Audio' ? 'fa-headphones' : 'fa-image')} me-1"></i> ${res.type}
                                    </span>
                                </td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-info rounded-pill me-1" title="Xem trước" data-bs-toggle="modal" data-bs-target="#previewResourceModal${res.resourceId}">
                                        <i class="fa-solid fa-eye"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/mentor/resources/${res.resourceId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                    <form action="${pageContext.request.contextPath}/mentor/resources" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="resourceId" value="${res.resourceId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return customConfirm(event, this, 'Bạn có chắc chắn muốn xóa tài nguyên này? Các câu hỏi dùng tài nguyên này sẽ bị ảnh hưởng.');"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>

                            <!-- Preview Modal for Resource ${res.resourceId} -->
                            <div class="modal fade" id="previewResourceModal${res.resourceId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title fw-bold">Xem Trước Tài Nguyên #${res.resourceId}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body" style="background-color: #f8f9fa;">
                                            <c:choose>
                                                <c:when test="${res.type eq 'Passage'}">
                                                    <div class="bg-white p-4 border rounded shadow-sm" style="line-height: 1.8;">
                                                        ${res.resourceText}
                                                    </div>
                                                </c:when>
                                                <c:when test="${res.type eq 'Audio'}">
                                                    <div class="text-center bg-white p-5 border rounded shadow-sm">
                                                        <i class="fa-solid fa-headphones-simple mb-3 text-secondary" style="font-size: 3rem;"></i>
                                                        <br>
                                                        <audio controls src="${res.resourceAudioUrl}" style="width: 100%; max-width: 400px;"></audio>
                                                    </div>
                                                </c:when>
                                                <c:when test="${res.type eq 'Image'}">
                                                    <div class="text-center bg-white p-4 border rounded shadow-sm">
                                                        <img src="${res.resourceImageUrl}" class="img-fluid rounded" alt="Image Resource" style="max-height: 500px;" />
                                                    </div>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty resources}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">Chưa có tài nguyên nào. Nhấn "Tạo Tài Nguyên" để thêm.</td>
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
