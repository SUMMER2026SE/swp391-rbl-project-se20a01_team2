<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đề thi - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                <button type="button" id="btnBulkDelete" class="btn btn-danger rounded-pill shadow-sm fw-bold me-2" style="display: none;" onclick="confirmBulkDelete()">
                    Xóa đã chọn (<span id="selectedCount">0</span>) <i class="fa-solid fa-trash ms-1"></i>
                </button>
                <button type="button" class="btn btn-outline-primary rounded-pill shadow-sm fw-bold me-2" data-bs-toggle="modal" data-bs-target="#importAiModal">
                    Import AI <i class="fa-solid fa-wand-magic-sparkles ms-2"></i>
                </button>
                <a href="${pageContext.request.contextPath}/mentor/exams?action=new" class="btn btn-primary rounded-pill shadow-sm fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
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
            <form action="${pageContext.request.contextPath}/mentor/exams" method="GET" class="row g-2 align-items-center">
                <input type="hidden" name="page" id="page-input" value="${not empty examsPage ? examsPage.currentPage : 1}">
                
                <div class="col-md-3">
                    <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm tiêu đề đề thi..." value="${param.keyword}" oninput="clearTimeout(this.timer); this.timer = setTimeout(() => { document.getElementById('page-input').value = 1; ajaxSearch(this.form); }, 600);">
                </div>
                <div class="col-md-3">
                    <select name="type" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Loại Đề --</option>
                        <option value="Mock Test" ${param.type == 'Mock Test' ? 'selected' : ''}>Mock Test</option>
                        <option value="Placement Test" ${param.type == 'Placement Test' ? 'selected' : ''}>Placement Test</option>
                        <option value="Practice" ${param.type == 'Practice' ? 'selected' : ''}>Practice</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="skill" class="form-select rounded-pill" onchange="document.getElementById('page-input').value = 1; ajaxSearch(this.form);">
                        <option value="">-- Kỹ Năng --</option>
                        <option value="All" ${param.skill == 'All' ? 'selected' : ''}>Full Test (All)</option>
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
                            <th style="width: 40px;" class="text-center ps-4"><input type="checkbox" id="selectAll" class="form-check-input"></th>
                            <th>ID</th>
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
                                    <td class="text-center ps-4"><input type="checkbox" class="form-check-input item-checkbox" value="${exam.examId}"></td>
                                    <td class="text-secondary">#${exam.examId}</td>
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
                                        <a href="${pageContext.request.contextPath}/mentor/exams/${exam.examId}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                                        <form action="${pageContext.request.contextPath}/mentor/exams" method="POST" style="display:inline;">
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
                                <td colspan="7" class="text-center py-5 text-muted">Không có đề thi nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${examsPage != null && examsPage.totalPages > 1}">
                <c:set var="startPage" value="${examsPage.currentPage - 2}" />
                <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                <c:set var="endPage" value="${examsPage.currentPage + 2}" />
                <c:if test="${endPage > examsPage.totalPages}"><c:set var="endPage" value="${examsPage.totalPages}" /></c:if>

                <nav class="d-flex justify-content-center mt-4">
                    <ul class="pagination mb-0">
                        <li class="page-item ${examsPage.currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link rounded-start-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${examsPage.currentPage - 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-left"></i></a>
                        </li>
                        
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <li class="page-item ${examsPage.currentPage == p ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${p}; ajaxSearch(document.querySelector('form'));">${p}</a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${examsPage.currentPage >= examsPage.totalPages ? 'disabled' : ''}">
                            <a class="page-link rounded-end-pill" href="javascript:void(0)" onclick="document.getElementById('page-input').value = ${examsPage.currentPage + 1}; ajaxSearch(document.querySelector('form'));"><i class="fa-solid fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </main>
</div>

<form id="bulkDeleteForm" action="${pageContext.request.contextPath}/mentor/exams" method="POST" style="display: none;">
    <input type="hidden" name="action" value="bulk_delete">
</form>

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

        <!-- Step 2: Preview & Edit JSON -->
        <div id="aiPreviewStep" class="d-none">
            <div id="aiSaveError" class="alert alert-danger d-none shadow-sm"><i class="fa-solid fa-triangle-exclamation"></i> <span id="aiSaveErrorMsg"></span></div>
            <div class="alert alert-info shadow-sm mb-3">
                <i class="fa-solid fa-circle-check"></i> Phân tích hoàn tất! Vui lòng kiểm tra và có thể chỉnh sửa cấu trúc bên dưới trước khi lưu.
            </div>
            <div id="visualAiEditor" style="max-height: 60vh; overflow-y: auto; padding-right: 10px;"></div>
            <textarea id="aiJsonEditor" class="form-control d-none"></textarea>
            
            <div class="mt-3 text-end border-top pt-3">
                <button type="button" class="btn btn-outline-secondary rounded-pill me-2" onclick="document.getElementById('aiPreviewStep').classList.add('d-none'); document.getElementById('aiUploadStep').classList.remove('d-none');">Thử Lại</button>
                <button type="button" class="btn btn-success rounded-pill shadow-sm" id="btnSaveAiExam">
                    Lưu Đề Thi <i class="fa-solid fa-save ms-2"></i>
                </button>
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

        fetch(window.contextPath + '/mentor/exam-import', {
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
            // Store raw for fallback, but render visual editor
            editor.value = JSON.stringify(data, null, 2);
            renderVisualEditor(data);
            uploadStep.classList.add('d-none');
            previewStep.classList.remove('d-none');
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

    function escapeHtml(text) {
        if (text == null) return '';
        return text.toString()
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function renderVisualEditor(data) {
        const container = document.getElementById('visualAiEditor');
        let html = '';
        
        html += `
            <div class="card mb-4 border-0 shadow-sm">
                <div class="card-header bg-primary bg-opacity-10 text-primary fw-bold border-0">Thông Tin Chung</div>
                <div class="card-body bg-light">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-secondary small">Tiêu đề Exam</label>
                            <input type="text" class="form-control ve-exam-title border-0 shadow-sm" value="\${escapeHtml(data.title)}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold text-secondary small">Kỹ Năng</label>
                            <select class="form-select ve-exam-skill border-0 shadow-sm">
                                <option value="All" \${data.skillFocus == 'All' ? 'selected' : ''}>All</option>
                                <option value="Listening" \${data.skillFocus == 'Listening' ? 'selected' : ''}>Listening</option>
                                <option value="Reading" \${data.skillFocus == 'Reading' ? 'selected' : ''}>Reading</option>
                                <option value="Writing" \${data.skillFocus == 'Writing' ? 'selected' : ''}>Writing</option>
                                <option value="Speaking" \${data.skillFocus == 'Speaking' ? 'selected' : ''}>Speaking</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold text-secondary small">Thời gian (phút)</label>
                            <input type="number" class="form-control ve-exam-duration border-0 shadow-sm" value="\${escapeHtml(data.duration)}">
                        </div>
                    </div>
                </div>
            </div>
            <h5 class="fw-bold text-secondary mb-3"><i class="fa-solid fa-layer-group me-2"></i> Cấu trúc đề thi</h5>
            <div id="ve-sections-container">
        `;
        
        if (data.sections) {
            data.sections.forEach((sec, sIdx) => {
                html += `
                <div class="card mb-3 ve-section border-secondary border-opacity-25 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                    <div class="card-header d-flex justify-content-between align-items-center bg-white border-bottom-0 py-3">
                        <div class="w-75">
                            <input type="text" class="form-control fw-bold ve-sec-name border-0 bg-light rounded-pill px-3" value="\${escapeHtml(sec.sectionName)}" placeholder="Tên Section">
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill" onclick="this.closest('.ve-section').remove()"><i class="fa-solid fa-trash"></i> Xóa Section</button>
                    </div>
                    <div class="card-body pt-0 pb-4 bg-white">
                        <div class="mb-3 px-3">
                            <label class="form-label fw-bold text-secondary small">Đoạn văn / Bài đọc (Resource Text)</label>
                            <textarea class="form-control ve-sec-resource border-0 bg-light shadow-sm" rows="4" placeholder="Nội dung bài đọc hoặc transcript (để trống nếu không có)...">\${escapeHtml(sec.resourceText)}</textarea>
                        </div>
                        <div class="ve-questions-container ps-4 border-start border-2 border-primary border-opacity-25 ms-3">
                `;
                
                if (sec.questions) {
                    sec.questions.forEach((q, qIdx) => {
                        html += `
                            <div class="card mt-3 ve-question shadow-sm border-0 bg-light" style="border-radius: 10px;">
                                <div class="card-body p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div class="flex-grow-1 me-3">
                                            <textarea class="form-control ve-q-content border-0 mb-2 shadow-sm" rows="2" placeholder="Nội dung câu hỏi...">\${escapeHtml(q.content)}</textarea>
                                            <select class="form-select form-select-sm w-auto ve-q-type border-0 shadow-sm text-secondary fw-bold bg-white">
                                                <option value="MultipleChoice" \${q.questionType == 'MultipleChoice' ? 'selected' : ''}>Multiple Choice</option>
                                                <option value="FillInBlanks" \${q.questionType == 'FillInBlanks' ? 'selected' : ''}>Fill In Blanks</option>
                                                <option value="Matching" \${q.questionType == 'Matching' ? 'selected' : ''}>Matching</option>
                                                <option value="TrueFalse" \${q.questionType == 'TrueFalse' ? 'selected' : ''}>True/False/NotGiven</option>
                                            </select>
                                        </div>
                                        <button type="button" class="btn btn-sm text-danger border-0" onclick="this.closest('.ve-question').remove()"><i class="fa-solid fa-xmark fs-5"></i></button>
                                    </div>
                                    <div class="ve-answers-container mt-3 ps-3 border-start border-2 border-secondary border-opacity-25">
                        `;
                        
                        if (q.answers) {
                            q.answers.forEach((ans, aIdx) => {
                                html += `
                                        <div class="d-flex align-items-center mb-2 ve-answer">
                                            <input type="text" class="form-control form-control-sm ve-a-content border-0 shadow-sm me-2" value="\${escapeHtml(ans.content)}">
                                            <div class="form-check form-switch mb-0 me-2" title="Là đáp án đúng?">
                                                <input class="form-check-input ve-a-correct" type="checkbox" role="switch" \${ans.isCorrect ? 'checked' : ''}>
                                            </div>
                                            <button type="button" class="btn btn-sm text-muted border-0 p-0" onclick="this.closest('.ve-answer').remove()"><i class="fa-solid fa-trash-can"></i></button>
                                        </div>
                                `;
                            });
                        }
                        
                        html += `
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                }
                
                html += `
                        </div>
                    </div>
                </div>
                `;
            });
        }
        
        html += `</div>`;
        container.innerHTML = html;
    }

    function extractDataFromVisualEditor() {
        const container = document.getElementById('visualAiEditor');
        const data = {
            title: container.querySelector('.ve-exam-title').value,
            skillFocus: container.querySelector('.ve-exam-skill').value,
            duration: parseInt(container.querySelector('.ve-exam-duration').value) || 0,
            sections: []
        };
        
        container.querySelectorAll('.ve-section').forEach(secEl => {
            const sec = {
                sectionName: secEl.querySelector('.ve-sec-name').value,
                skill: data.skillFocus, // default to exam skill focus
                resourceText: secEl.querySelector('.ve-sec-resource').value,
                questions: []
            };
            
            secEl.querySelectorAll('.ve-question').forEach(qEl => {
                const q = {
                    content: qEl.querySelector('.ve-q-content').value,
                    questionType: qEl.querySelector('.ve-q-type').value,
                    answers: []
                };
                
                qEl.querySelectorAll('.ve-answer').forEach(aEl => {
                    q.answers.push({
                        content: aEl.querySelector('.ve-a-content').value,
                        isCorrect: aEl.querySelector('.ve-a-correct').checked
                    });
                });
                
                sec.questions.push(q);
            });
            
            data.sections.push(sec);
        });
        
        return data;
    }

    document.getElementById('btnSaveAiExam').addEventListener('click', function() {
        const btnSave = this;
        const errorAlert = document.getElementById('aiSaveError');
        const errorMsg = document.getElementById('aiSaveErrorMsg');
        let jsonData;
        
        errorAlert.className = 'alert alert-danger d-none shadow-sm';

        try {
            jsonData = extractDataFromVisualEditor();
        } catch (e) {
            errorMsg.textContent = 'Lỗi trích xuất dữ liệu: ' + e.message;
            errorAlert.classList.remove('d-none');
            return;
        }

        btnSave.disabled = true;
        btnSave.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang lưu...';

        fetch(window.contextPath + '/mentor/exam-import?action=save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(jsonData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                errorAlert.className = 'alert alert-success shadow-sm';
                errorAlert.innerHTML = '<i class="fa-solid fa-check"></i> Tạo đề thi thành công! Đang tải lại...';
                setTimeout(() => window.location.reload(), 1000);
            } else {
                errorMsg.textContent = 'Có lỗi xảy ra: ' + data.error;
                errorAlert.classList.remove('d-none');
                btnSave.disabled = false;
                btnSave.innerHTML = 'Lưu Đề Thi <i class="fa-solid fa-save ms-2"></i>';
            }
        })
        .catch(err => {
            errorMsg.textContent = 'Lỗi hệ thống: ' + err.message;
            errorAlert.classList.remove('d-none');
            btnSave.disabled = false;
            btnSave.innerHTML = 'Lưu Đề Thi <i class="fa-solid fa-save ms-2"></i>';
        });
    });
</script>

</body>
<script>
function updateBulkDeleteBtn() {
    const btnBulkDelete = document.getElementById('btnBulkDelete');
    const selectedCount = document.getElementById('selectedCount');
    if (!btnBulkDelete || !selectedCount) return;
    const checked = document.querySelectorAll('.item-checkbox:checked');
    if (checked.length > 0) {
        btnBulkDelete.style.display = 'inline-block';
        selectedCount.textContent = checked.length;
    } else {
        btnBulkDelete.style.display = 'none';
    }
}

document.addEventListener('change', function(e) {
    if (e.target && e.target.id === 'selectAll') {
        const checkboxes = document.querySelectorAll('.item-checkbox');
        checkboxes.forEach(cb => cb.checked = e.target.checked);
        updateBulkDeleteBtn();
    } else if (e.target && e.target.classList.contains('item-checkbox')) {
        const selectAll = document.getElementById('selectAll');
        const checkboxes = document.querySelectorAll('.item-checkbox');
        if (!e.target.checked && selectAll) selectAll.checked = false;
        if (document.querySelectorAll('.item-checkbox:checked').length === checkboxes.length && selectAll) selectAll.checked = true;
        updateBulkDeleteBtn();
    }
});

function confirmBulkDelete() {
    const checked = document.querySelectorAll('.item-checkbox:checked');
    if (checked.length === 0) return;
    
    Swal.fire({
        title: 'Bạn có chắc chắn?',
        text: 'Bạn đang chuẩn bị xóa ' + checked.length + ' đề thi. Hành động này không thể hoàn tác!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Có, xóa tất cả!',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.getElementById('bulkDeleteForm');
            checked.forEach(cb => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'examIds';
                input.value = cb.value;
                form.appendChild(input);
            });
            form.submit();
        }
    });
}
</script>
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
                updateBulkDeleteBtn();
            } else {
                form.submit();
            }
        })
        .catch(err => form.submit());
}
</script>
</html>
