<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm câu hỏi vào Section - IELTSFlow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-purple); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="exams" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <a href="${pageContext.request.contextPath}/mentor/exams/${exam.examId}" class="btn btn-sm btn-outline-secondary rounded-pill mb-3">
                <i class="fa-solid fa-arrow-left"></i> Quay lại chi tiết đề thi
            </a>
            <div class="d-flex align-items-center gap-3 flex-wrap">
                <div>
                    <h1 class="page-title m-0">Thêm Câu Hỏi Mới</h1>
                    <p class="text-muted mt-1 mb-0">
                        Đề thi: <strong>${exam.title}</strong> &rsaquo;
                        Section: <strong>${section.sectionName}</strong>
                        <span class="badge ms-1" style="background-color: var(--accent-blue);">${section.skill}</span>
                    </p>
                </div>
            </div>
        </header>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px;">

            <%-- Search bar (GET form, preserves section in URL) --%>
            <form method="GET" action="${pageContext.request.contextPath}/mentor/exams/${exam.examId}/sections/${section.sectionId}/add-questions" class="mb-4">
                <div class="input-group" style="max-width: 600px;">
                    <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" name="keyword" class="form-control" placeholder="Tìm câu hỏi..." value="${param.keyword}" oninput="clearTimeout(this.timer); this.timer = setTimeout(() => { ajaxSearch(this.form); }, 600);">
                    <select name="resourceId" class="form-select" onchange="this.form.submit()" style="max-width: 200px;">
                        <option value="">Tất cả Resource</option>
                        <c:forEach var="res" items="${allResources}">
                            <option value="${res.resourceId}" ${param.resourceId == res.resourceId ? 'selected' : ''}>
                                #${res.resourceId} - ${res.resourceName != null ? res.resourceName : 'Unnamed'}
                            </option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-outline-secondary d-none">Tìm</button>
                    <c:if test="${not empty param.keyword || not empty param.resourceId}">
                        <a href="${pageContext.request.contextPath}/mentor/exams/${exam.examId}/sections/${section.sectionId}/add-questions" class="btn btn-outline-danger"><i class="fa-solid fa-xmark"></i> Xóa lọc</a>
                    </c:if>
                </div>
                <small class="text-muted mt-1 d-block">Chỉ hiển thị câu hỏi thuộc kỹ năng <strong>${section.skill}</strong>.</small>
            </form>

            <form action="${pageContext.request.contextPath}/mentor/exams" method="POST">
                <input type="hidden" name="action" value="addQuestions">
                <input type="hidden" name="examId" value="${exam.examId}">
                <input type="hidden" name="sectionId" value="${section.sectionId}">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold m-0" style="color: var(--accent-blue);">
                        Ngân hàng câu hỏi
                        <span class="badge bg-secondary ms-2 fw-normal" style="font-size: 0.8rem;">${section.skill}</span>
                    </h5>
                    <button type="submit" class="btn btn-primary shadow rounded-pill px-4 fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
                        <i class="fa-solid fa-plus me-2"></i> Thêm vào Section
                    </button>
                </div>

                <div id="search-results">
                <c:if test="${empty questions}">
                    <div class="text-center py-5 text-muted">
                        <i class="fa-solid fa-inbox fa-3x mb-3 d-block" style="opacity: 0.3;"></i>
                        Không tìm thấy câu hỏi ${section.skill} nào<c:if test="${not empty param.keyword}"> khớp với "<strong>${param.keyword}</strong>"</c:if>.
                    </div>
                </c:if>

                <div class="table-responsive">
                    <table class="table align-middle table-hover">
                        <thead>
                            <tr>
                                <th style="width: 50px;">
                                    <input class="form-check-input" type="checkbox" id="selectAll">
                                </th>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 120px;">Loại</th>
                                <th>Nội dung</th>
                                <th style="width: 100px;">Độ khó</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="q" items="${questions}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${existingQuestionIds.contains(q.questionId)}">
                                                <input class="form-check-input" type="checkbox" disabled title="Đã có trong section này">
                                            </c:when>
                                            <c:otherwise>
                                                <input class="form-check-input question-cb" type="checkbox" name="questionIds" value="${q.questionId}">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-secondary fw-bold">#${q.questionId}</td>
                                    <td>
                                        <span class="badge bg-info text-dark mb-1">${q.questionType}</span>
                                        <c:if test="${existingQuestionIds.contains(q.questionId)}">
                                            <br><span class="badge bg-warning text-dark" style="font-size: 0.7rem;">Đã thêm</span>
                                        </c:if>
                                    </td>
                                    <td class="text-truncate" style="max-width: 350px;">
                                        <c:choose>
                                            <c:when test="${not empty q.content}">${q.content}</c:when>
                                            <c:otherwise><em class="text-muted">Không có nội dung text</em></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${q.difficulty eq 'Easy'}"><span class="badge bg-success">${q.difficulty}</span></c:when>
                                            <c:when test="${q.difficulty eq 'Hard'}"><span class="badge bg-danger">${q.difficulty}</span></c:when>
                                            <c:otherwise><span class="badge bg-warning text-dark">${q.difficulty}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </form>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function bindSelectAll() {
        const selectAll = document.getElementById('selectAll');
        if(selectAll) {
            selectAll.addEventListener('change', function(e) {
                var checkboxes = document.querySelectorAll('.question-cb');
                for (var cb of checkboxes) {
                    cb.checked = e.target.checked;
                }
            });
        }
    }
    bindSelectAll();

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
                bindSelectAll();
            } else {
                form.submit();
            }
        })
        .catch(err => form.submit());
}
</script>
</body>
</html>
