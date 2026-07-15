<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ngân hàng câu hỏi - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(59, 130, 246, 0.03); }
        .truncate-text { max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="questions" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Ngân hàng câu hỏi ❓</h1>
            <div class="header-actions">
                <!-- Chú ý: -1 là signal cho tạo mới trong RESTful giả lập, nhưng Servlet xử lý "action=new" chưa được handle trong doGet -->
                <!-- Nhìn vào MentorQuestionServlet, pathInfo = /... hoặc id -->
                <!-- Ta sẽ dùng action=new cho doGet hoặc dùng form post. 
                     MentorQuestionServlet bắt param keyword. Nếu pathInfo là / thì hiển thị list.
                     Nếu /id thì show detail.
                     Nên ta link sang /mentor/questions/0 (hoặc URL nào đó mà ID = 0 để đại diện tạo mới).
                     Servlet parses id, nếu question == null thì nó trả về lỗi.
                     Vì vậy, cách tốt nhất là cập nhật MentorQuestionServlet để xử lý action=new hoặc id=0,
                     nhưng tạm thời tạo link /mentor/questions/0 (nếu update Servlet) hoặc form.
                     Let's check Servlet again. Nó gọi getQuestionWithTags(id).
                     Nếu không có nó báo lỗi "Không tìm thấy câu hỏi".
                     Vậy ta cần sửa Servlet 1 chút, nhưng tạm cứ để link là /mentor/questions/0
                     và ta sẽ cập nhật Servlet sau. -->
                <a href="${pageContext.request.contextPath}/mentor/questions?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold">
                    Tạo Câu Hỏi <i class="fa-solid fa-plus ms-2"></i>
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
            <form action="${pageContext.request.contextPath}/mentor/questions" method="GET" class="row g-2 align-items-center">
                <input type="hidden" name="page" id="page-input" value="${not empty questionsPage ? questionsPage.currentPage : 1}">
                
                <div class="col-md-3">
                    <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm nội dung..." value="${param.keyword}" oninput="clearTimeout(this.timer); this.timer = setTimeout(() => { document.getElementById('page-input').value = 1; ajaxSearch(this.form); }, 600);">
                </div>
                <div class="col-md-2">
                    <select name="skill" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Kỹ năng --</option>
                        <option value="Listening" ${param.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                        <option value="Reading" ${param.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                        <option value="Writing" ${param.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                        <option value="Speaking" ${param.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="difficulty" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Độ khó --</option>
                        <option value="Easy" ${param.difficulty == 'Easy' ? 'selected' : ''}>Easy</option>
                        <option value="Medium" ${param.difficulty == 'Medium' ? 'selected' : ''}>Medium</option>
                        <option value="Hard" ${param.difficulty == 'Hard' ? 'selected' : ''}>Hard</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="type" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Dạng --</option>
                        <option value="Multiple_Choice" ${param.type == 'Multiple_Choice' ? 'selected' : ''}>Multiple Choice</option>
                        <option value="FillBlank" ${param.type == 'FillBlank' ? 'selected' : ''}>Fill In Blanks</option>
                        <option value="Matching" ${param.type == 'Matching' ? 'selected' : ''}>Matching</option>
                    </select>
                </div>
                <div class="col-md-2">
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
                            <th>Nội dung</th>
                            <th>Dạng bài</th>
                            <th>Kỹ năng</th>
                            <th>Độ khó</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="q" items="${questions}">
                            <tr>
                                <td class="ps-4 text-secondary">#${q.questionId}</td>
                                <td><span class="truncate-text" title="${q.content}">${q.content}</span></td>
                                <td><span class="badge bg-light text-dark border">${q.questionType}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.skill == 'Listening'}"><span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">Listening</span></c:when>
                                        <c:when test="${q.skill == 'Reading'}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Reading</span></c:when>
                                        <c:when test="${q.skill == 'Writing'}"><span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25">Writing</span></c:when>
                                        <c:when test="${q.skill == 'Speaking'}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">Speaking</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${q.skill}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${q.difficulty}</td>
                                <td class="text-center pe-4">
                                    <a href="${pageContext.request.contextPath}/mentor/questions/${q.questionId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chi tiết & Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                    <form action="${pageContext.request.contextPath}/mentor/questions" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="questionId" value="${q.questionId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return customConfirm(event, this, 'Bạn có chắc chắn muốn xóa câu hỏi này?');"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty questions}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">Không có câu hỏi nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${questionsPage != null && questionsPage.totalPages > 1}">
                <c:set var="startPage" value="${questionsPage.currentPage - 2}" />
                <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                <c:set var="endPage" value="${questionsPage.currentPage + 2}" />
                <c:if test="${endPage > questionsPage.totalPages}"><c:set var="endPage" value="${questionsPage.totalPages}" /></c:if>

                <nav class="d-flex justify-content-center mt-4">
                    <ul class="pagination mb-0">
                        <li class="page-item ${questionsPage.currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link rounded-start-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${questionsPage.currentPage - 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-left"></i></a>
                        </li>
                        
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <li class="page-item ${questionsPage.currentPage == p ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${p}; ajaxSearch(document.querySelector('form'));">${p}</a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${questionsPage.currentPage >= questionsPage.totalPages ? 'disabled' : ''}">
                            <a class="page-link rounded-end-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${questionsPage.currentPage + 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-right"></i></a>
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
