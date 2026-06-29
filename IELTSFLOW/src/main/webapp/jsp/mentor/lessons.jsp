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

        <script>
            if (window.history.replaceState) {
                const url = new URL(window.location.href);
                if (url.searchParams.has('success') || url.searchParams.has('error')) {
                    url.searchParams.delete('success');
                    url.searchParams.delete('error');
                    window.history.replaceState(null, '', url.toString() || window.location.pathname);
                }
            }
        </script>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 20px; margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/mentor/lessons" method="GET" class="row g-2 align-items-center">
                <input type="hidden" name="page" id="page-input" value="${not empty lessonsPage ? lessonsPage.currentPage : 1}">
                
                <div class="col-md-5">
                    <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm tiêu đề bài học..." value="${param.keyword}" oninput="clearTimeout(this.timer); this.timer = setTimeout(() => { document.getElementById('page-input').value = 1; ajaxSearch(this.form); }, 600);">
                </div>
                <div class="col-md-4">
                    <select name="skill" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Tất cả Kỹ Năng --</option>
                        <option value="Listening" ${param.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                        <option value="Reading" ${param.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                        <option value="Writing" ${param.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                        <option value="Speaking" ${param.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="limit" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="10" ${param.limit == '10' ? 'selected' : ''}>10 / trang</option>
                        <option value="20" ${param.limit == '20' || empty param.limit ? 'selected' : ''}>20 / trang</option>
                        <option value="50" ${param.limit == '50' ? 'selected' : ''}>50 / trang</option>
                    </select>
                </div>
            </form>
        </div>

        <div id="search-results" class="glass-panel animate-fade-up" style="animation-delay: 0.2s; padding: 0; overflow: hidden;">
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
                                        <button type="button" class="btn btn-sm btn-outline-info rounded-pill me-1" title="Xem trước" data-bs-toggle="modal" data-bs-target="#previewLessonModal${lesson.lessonId}">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/mentor/lessons/${lesson.lessonId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                        <form action="${pageContext.request.contextPath}/mentor/lessons" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này?');"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Preview Modal for Lesson ${lesson.lessonId} -->
                                <div class="modal fade" id="previewLessonModal${lesson.lessonId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title fw-bold">Xem Trước Bài Học: ${lesson.title}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body" style="background-color: #f8f9fa;">
                                                <div class="container-fluid">
                                                    <c:if test="${not empty lesson.videoUrl}">
                                                        <div class="mb-4 bg-dark rounded shadow-sm overflow-hidden" style="position: relative; padding-top: 56.25%;">
                                                            <iframe src="${lesson.videoUrl.replace('watch?v=', 'embed/').replace('youtu.be/', 'youtube.com/embed/')}" 
                                                                    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" 
                                                                    frameborder="0" allowfullscreen>
                                                            </iframe>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${not empty lesson.documentUrl}">
                                                        <div class="mb-4">
                                                            <a href="${lesson.documentUrl}" target="_blank" class="btn btn-outline-primary w-100">
                                                                <i class="fa-solid fa-file-pdf me-2"></i> Xem tài liệu đính kèm
                                                            </a>
                                                        </div>
                                                    </c:if>

                                                    <div class="bg-white p-4 border rounded shadow-sm" style="line-height: 1.8;">
                                                        ${lesson.content}
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

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
            
            <c:if test="${lessonsPage != null && lessonsPage.totalPages > 1}">
                <c:set var="startPage" value="${lessonsPage.currentPage - 2}" />
                <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                <c:set var="endPage" value="${lessonsPage.currentPage + 2}" />
                <c:if test="${endPage > lessonsPage.totalPages}"><c:set var="endPage" value="${lessonsPage.totalPages}" /></c:if>

                <nav class="d-flex justify-content-center mt-4">
                    <ul class="pagination mb-0">
                        <li class="page-item ${lessonsPage.currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link rounded-start-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${lessonsPage.currentPage - 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-left"></i></a>
                        </li>
                        
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <li class="page-item ${lessonsPage.currentPage == p ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${p}; ajaxSearch(document.querySelector('form'));">${p}</a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${lessonsPage.currentPage >= lessonsPage.totalPages ? 'disabled' : ''}">
                            <a class="page-link rounded-end-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${lessonsPage.currentPage + 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </main>
</div>

</body>
<script>
function ajaxSearch(form) {
    const url = new URL(form.action || window.location.href);
    const formData = new FormData(form);
    const params = new URLSearchParams();
    for (const [key, value] of formData) {
        if(value) params.append(key, value);
    }
    url.search = params.toString();

    const results = document.getElementById('search-results');
    if (results) {
        results.style.opacity = '0.5';
        results.style.transition = 'opacity 0.2s';
    }

    fetch(url)
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newResults = doc.getElementById('search-results');
            if (newResults && results) {
                results.innerHTML = newResults.innerHTML;
                results.style.opacity = '1';
                window.history.replaceState({}, '', url);
            } else {
                form.submit();
            }
        })
        .catch(err => form.submit());
}
</script>
</html>
