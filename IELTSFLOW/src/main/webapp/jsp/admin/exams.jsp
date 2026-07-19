<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đề thi - IELTSFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(139, 92, 246, 0.03); }
        .truncate-text { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-purple); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="exams" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Quản lý Đề thi 📝</h1>
            <div class="header-actions">
                <button type="button" class="btn btn-outline-primary rounded-pill shadow-sm fw-bold me-2" data-bs-toggle="modal" data-bs-target="#importAiModal">
                    Import AI <i class="fa-solid fa-wand-magic-sparkles ms-2"></i>
                </button>
                <a href="${pageContext.request.contextPath}/admin/exams?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
                    Tạo Đề Thi <i class="fa-solid fa-plus ms-2"></i>
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
            <form action="${pageContext.request.contextPath}/admin/exams" method="GET" class="row g-3 align-items-center">
                <div class="col-md-4">
                    <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm tiêu đề đề thi..." value="${param.keyword}">
                </div>
                <div class="col-md-3">
                    <select name="type" class="form-select rounded-pill">
                        <option value="">-- Loại Đề --</option>
                        <option value="Mock Test" ${param.type == 'Mock Test' ? 'selected' : ''}>Mock Test</option>
                        <option value="Placement Test" ${param.type == 'Placement Test' ? 'selected' : ''}>Placement Test</option>
                        <option value="Practice" ${param.type == 'Practice' ? 'selected' : ''}>Practice</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="skill" class="form-select rounded-pill">
                        <option value="">-- Kỹ Năng --</option>
                        <option value="All" ${param.skill == 'All' ? 'selected' : ''}>Full Test (All)</option>
                        <option value="Listening" ${param.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                        <option value="Reading" ${param.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                        <option value="Writing" ${param.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                        <option value="Speaking" ${param.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary rounded-pill shadow-sm fw-bold w-100" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">Lọc <i class="fa-solid fa-filter"></i></button>
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
                            <th>Loại Đề</th>
                            <th>Kỹ năng</th>
                            <th>Thời gian làm bài</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="exam" items="${exams}">
                            <c:if test="${!exam.deleted}">
                                <tr>
                                    <td class="ps-4 text-secondary">#${exam.examId}</td>
                                    <td class="fw-bold" style="color: var(--text-primary);">
                                        <span class="truncate-text" title="${exam.title}">${exam.title}</span>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${exam.type}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${exam.skillFocus == 'All'}"><span class="badge bg-dark bg-opacity-10 text-dark border border-dark border-opacity-25">Full Test</span></c:when>
                                            <c:when test="${exam.skillFocus == 'Listening'}"><span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">Listening</span></c:when>
                                            <c:when test="${exam.skillFocus == 'Reading'}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Reading</span></c:when>
                                            <c:when test="${exam.skillFocus == 'Writing'}"><span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25">Writing</span></c:when>
                                            <c:when test="${exam.skillFocus == 'Speaking'}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">Speaking</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${exam.skillFocus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        ${exam.duration > 0 ? exam.duration += ' phút' : 'Không giới hạn'}
                                    </td>
                                    <td class="text-center pe-4">
                                        <a href="${pageContext.request.contextPath}/admin/exams/${exam.examId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                        <form action="${pageContext.request.contextPath}/admin/exams" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${exam.examId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return customConfirm(event, this, 'Bạn có chắc chắn muốn xóa đề thi này?');"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty exams}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">Không có đề thi nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- AI Import Modal -->
<div class="modal fade" id="importAiModal" tabindex="-1" aria-labelledby="importAiModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fw-bold" id="importAiModalLabel"><i class="fa-solid fa-wand-magic-sparkles text-primary"></i> Import Đề Thi bằng AI</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        
        <!-- Step 1: Upload Form -->
        <div id="aiUploadStep">
            <div id="aiUploadError" class="alert alert-danger d-none shadow-sm"><i class="fa-solid fa-triangle-exclamation"></i> <span id="aiUploadErrorMsg"></span></div>
            <p class="text-muted">Tải lên file tài liệu chứa nội dung đề thi (.pdf, .docx, .xlsx, .md, .txt). AI sẽ tự động trích xuất các phần thi, đoạn văn bản, và câu hỏi (bao gồm đáp án) cho bạn.</p>
            <form id="aiUploadForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="upload">
                <div class="mb-3">
                    <label class="form-label fw-bold">Chọn File (PDF/Docx/Excel/MD/TXT)</label>
                    <input class="form-control" type="file" id="examFile" name="file" accept=".pdf,.docx,.xlsx,.xls,.md,.txt" required>
                </div>
                <button type="submit" class="btn btn-primary shadow-sm rounded-pill w-100" id="btnUploadAi">
                    Phân tích bằng AI <i class="fa-solid fa-microchip ms-2"></i>
                </button>
            </form>
            <div class="text-center mt-3 d-none" id="aiLoadingIndicator">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="text-muted mt-2">AI đang phân tích dữ liệu, vui lòng chờ... (có thể mất 15-30 giây)</p>
            </div>
        </div>



      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('aiUploadForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const fileInput = document.getElementById('examFile');
        if (!fileInput.files.length) return;

        const formData = new FormData(this);
        const btnSubmit = document.getElementById('btnUploadAi');
        const loading = document.getElementById('aiLoadingIndicator');
        const uploadStep = document.getElementById('aiUploadStep');
        const previewStep = document.getElementById('aiPreviewStep');
        const editor = document.getElementById('aiJsonEditor');
        const errorAlert = document.getElementById('aiUploadError');
        const errorMsg = document.getElementById('aiUploadErrorMsg');

        errorAlert.classList.add('d-none');
        btnSubmit.disabled = true;
        loading.classList.remove('d-none');

        fetch(window.contextPath + '/admin/exam-import', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                return response.json().then(err => { throw new Error(err.error || 'Network error'); });
            }
            return response.json();
        })
        .then(data => {
            if (data.success && data.examId) {
                window.location.href = window.contextPath + '/admin/exams/' + data.examId;
            } else {
                throw new Error("Lỗi không xác định khi lưu đề thi.");
            }
        })
        .catch(err => {
            errorMsg.textContent = 'Lỗi khi phân tích bằng AI: ' + err.message;
            errorAlert.classList.remove('d-none');
        })
        .finally(() => {
            btnSubmit.disabled = false;
            loading.classList.add('d-none');
        });
    });


</script>

</body>
</html>
