<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài học - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(16, 185, 129, 0.03); }
        .truncate-text { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-green); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="lessons" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Quản lý Bài học 📚</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/mentor/lessons?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold" style="background-color: var(--accent-green); border-color: var(--accent-green);">
                    Tạo Bài Học <i class="fa-solid fa-plus ms-2"></i>
                </a>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 20px; margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/mentor/lessons" method="GET" class="row g-3 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm tiêu đề bài học..." value="${param.keyword}">
                </div>
                <div class="col-md-4">
                    <select name="skill" class="form-select rounded-pill">
                        <option value="">-- Tất cả Kỹ Năng --</option>
                        <option value="Listening" ${param.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                        <option value="Reading" ${param.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                        <option value="Writing" ${param.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                        <option value="Speaking" ${param.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary rounded-pill shadow-sm fw-bold w-100" style="background-color: var(--accent-green); border-color: var(--accent-green);">Lọc <i class="fa-solid fa-filter"></i></button>
                </div>
            </form>
        </div>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.2s; padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Tiêu đề</th>
                            <th>Kỹ năng</th>
                            <th>Tài liệu đính kèm</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="lesson" items="${lessons}">
                            <c:if test="${!lesson.deleted}">
                                <tr>
                                    <td class="ps-4 text-secondary">#${lesson.lessonId}</td>
                                    <td class="fw-bold" style="color: var(--text-primary);">
                                        <span class="truncate-text" title="${lesson.title}">${lesson.title}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lesson.skill == 'Listening'}"><span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">Listening</span></c:when>
                                            <c:when test="${lesson.skill == 'Reading'}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Reading</span></c:when>
                                            <c:when test="${lesson.skill == 'Writing'}"><span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25">Writing</span></c:when>
                                            <c:when test="${lesson.skill == 'Speaking'}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">Speaking</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${lesson.skill}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <c:if test="${not empty lesson.videoUrl}">
                                                <span class="badge bg-light text-dark border" title="Có Video"><i class="fa-solid fa-video text-danger"></i> Video</span>
                                            </c:if>
                                            <c:if test="${not empty lesson.documentUrl}">
                                                <span class="badge bg-light text-dark border" title="Có Document"><i class="fa-solid fa-file-pdf text-primary"></i> Tài liệu</span>
                                            </c:if>
                                            <c:if test="${empty lesson.videoUrl && empty lesson.documentUrl}">
                                                <span class="text-muted fst-italic fs-7">Chỉ có text</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="text-center pe-4">
                                        <a href="${pageContext.request.contextPath}/mentor/lessons/${lesson.lessonId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                        <form action="${pageContext.request.contextPath}/mentor/lessons" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này?');"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty lessons}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">Không có bài học nào.</td>
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
