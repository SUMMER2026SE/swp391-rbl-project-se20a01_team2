<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${exam == null ? 'Tạo đề thi' : 'Chi tiết đề thi'} - IELTSFlow Mentor</title>
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

    <!-- Include Select2 for searchable dropdown -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        .select2-container .select2-selection--single {
            height: 38px;
            border: 1px solid #ced4da;
            border-radius: 6px;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 38px;
            color: #212529;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px;
        }
    </style>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <a href="${pageContext.request.contextPath}/mentor/exams" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${exam == null ? 'Tạo đề thi mới ✨' : 'Chỉnh sửa đề thi ✏️'}</h1>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px;">
            <form action="${pageContext.request.contextPath}/mentor/exams" method="POST">
                <input type="hidden" name="action" value="${exam == null ? 'create' : 'update'}">
                <c:if test="${exam != null}">
                    <input type="hidden" name="id" value="${exam.examId}">
                </c:if>
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-purple);">Thông tin đề thi</h5>
                
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label fw-bold">Tiêu đề đề thi <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" value="${exam.title}" required placeholder="VD: IELTS Academic Practice Test 1">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Loại đề <span class="text-danger">*</span></label>
                        <select name="type" class="form-select" required>
                            <option value="Practice" ${exam.type == 'Practice' ? 'selected' : ''}>Practice (Luyện tập)</option>
                            <option value="Mock Test" ${exam.type == 'Mock Test' ? 'selected' : ''}>Mock Test (Thi thử)</option>
                            <option value="Placement Test" ${exam.type == 'Placement Test' ? 'selected' : ''}>Placement Test (Thi xếp lớp)</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Kỹ năng tập trung <span class="text-danger">*</span></label>
                        <select name="skill" class="form-select" required>
                            <option value="All" ${exam.skillFocus == 'All' ? 'selected' : ''}>Full Test (Tất cả kỹ năng)</option>
                            <option value="Listening" ${exam.skillFocus == 'Listening' ? 'selected' : ''}>Listening</option>
                            <option value="Reading" ${exam.skillFocus == 'Reading' ? 'selected' : ''}>Reading</option>
                            <option value="Writing" ${exam.skillFocus == 'Writing' ? 'selected' : ''}>Writing</option>
                            <option value="Speaking" ${exam.skillFocus == 'Speaking' ? 'selected' : ''}>Speaking</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Thời gian làm bài (Phút) <span class="text-danger">*</span></label>
                        <input type="number" name="duration" class="form-control" value="${exam.duration}" required min="0" placeholder="VD: 120">
                        <div class="form-text">Nhập 0 nếu không giới hạn thời gian.</div>
                    </div>
                </div>

                <div class="mt-5 text-end">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Đề Thi
                    </button>
                </div>
            </form>
        </div>

        <c:if test="${exam != null}">
            <div class="glass-panel animate-fade-up mt-4" style="animation-delay: 0.2s; padding: 30px;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0" style="color: var(--accent-blue);">Cấu trúc đề thi (Sections)</h5>
                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addSectionModal">
                        <i class="fa-solid fa-plus"></i> Thêm Section
                    </button>
                </div>

                <c:if test="${empty sections}">
                    <p class="text-muted">Đề thi này chưa có section nào. Hãy thêm section để bắt đầu chọn câu hỏi!</p>
                </c:if>

                <div class="accordion" id="sectionsAccordion">
                    <c:forEach var="sec" items="${sections}" varStatus="status">
                        <div class="accordion-item mb-3" style="border-radius: 10px; overflow: hidden; border: 1px solid rgba(0,0,0,0.1);" data-section-id="${sec.sectionId}">
                            <h2 class="accordion-header d-flex align-items-center" id="heading${sec.sectionId}" style="background-color: #f8f9fa;">
                                <div class="px-3" style="cursor: grab;">
                                    <i class="fa-solid fa-grip-vertical text-muted"></i>
                                </div>
                                <button class="accordion-button ${status.first ? '' : 'collapsed'} flex-grow-1 border-0 bg-transparent" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${sec.sectionId}" aria-expanded="${status.first}" aria-controls="collapse${sec.sectionId}" style="box-shadow: none;">
                                    <strong><span class="section-badge">${sec.orderIndex}</span>. ${sec.sectionName}</strong> <span class="badge bg-secondary ms-2">${sec.skill}</span>
                                </button>
                            </h2>
                            <div id="collapse${sec.sectionId}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" aria-labelledby="heading${sec.sectionId}" data-bs-parent="#sectionsAccordion">
                                <div class="accordion-body">
                                    <div class="d-flex justify-content-between mb-3">
                                        <form action="${pageContext.request.contextPath}/mentor/exams" method="POST" class="d-inline" onsubmit="return customConfirm(event, this, 'Bạn có chắc chắn muốn xóa section này?');">
                                            <input type="hidden" name="action" value="deleteSection">
                                            <input type="hidden" name="examId" value="${exam.examId}">
                                            <input type="hidden" name="sectionId" value="${sec.sectionId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i> Xóa</button>
                                        </form>
                                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#editSectionModal${sec.sectionId}">
                                            <i class="fa-solid fa-pen"></i> Sửa
                                        </button>
                                        <a href="${pageContext.request.contextPath}/mentor/exams/${exam.examId}/sections/${sec.sectionId}/add-questions" class="btn btn-sm btn-primary" style="background-color: var(--accent-blue); border-color: var(--accent-blue);">
                                            <i class="fa-solid fa-plus"></i> Thêm câu hỏi
                                        </a>
                                    </div>

                                    <c:if test="${empty sec.examQuestions}">
                                        <p class="text-muted small">Chưa có câu hỏi nào trong section này.</p>
                                    </c:if>

                                    <c:if test="${sec.resourceId != null && sec.resourceId > 0}">
                                        <div class="mb-3 p-3" style="background-color: #f1f5f9; border-radius: 8px;">
                                            <span class="me-3 fw-bold text-secondary mb-0"><i class="fa-solid fa-link me-1"></i> Resource:</span>
                                            <span class="me-3 fw-bold text-dark">
                                                #${sec.resourceId}
                                                <c:forEach var="res" items="${allResources}">
                                                    <c:if test="${res.resourceId == sec.resourceId}">
                                                        - ${res.resourceName != null ? res.resourceName : 'Chưa đặt tên'} (${res.type})
                                                    </c:if>
                                                </c:forEach>
                                            </span>
                                        </div>
                                    </c:if>
                                    
                                    <ul class="list-group sortable-questions-list" data-section-id="${sec.sectionId}">
                                        <c:forEach var="examQ" items="${sec.examQuestions}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center" data-question-id="${examQ.questionId}">
                                                <div style="cursor: grab;">
                                                    <i class="fa-solid fa-grip-vertical text-muted me-2"></i>
                                                    <span class="badge bg-light text-dark border me-2 question-badge">Q${examQ.orderIndex}</span>
                                                    <span class="text-truncate d-inline-block" style="max-width: 400px; vertical-align: middle;">
                                                        <c:choose>
                                                            <c:when test="${not empty examQ.question.content}">${examQ.question.content}</c:when>
                                                            <c:otherwise>Câu hỏi #${examQ.questionId}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/mentor/exams" method="POST" class="d-inline" onsubmit="return customConfirm(event, this, 'Xóa câu hỏi khỏi section này?');">
                                                    <input type="hidden" name="action" value="removeQuestion">
                                                    <input type="hidden" name="examId" value="${exam.examId}">
                                                    <input type="hidden" name="sectionId" value="${sec.sectionId}">
                                                    <input type="hidden" name="questionId" value="${examQ.questionId}">
                                                    <button type="submit" class="btn btn-sm text-danger" title="Xóa câu hỏi"><i class="fa-solid fa-times"></i></button>
                                                </form>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>

                    </c:forEach>
                </div>
            </div>
        </c:if>

    </main>

    <!-- Modals that must be outside accordion due to Bootstrap overflow issues -->
    <c:if test="${exam != null}">
        <!-- Edit Section Modals -->
        <c:forEach var="sec" items="${sections}">
            <div class="modal fade" id="editSectionModal${sec.sectionId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/mentor/exams" method="POST" class="modal-content">
                        <input type="hidden" name="action" value="updateSection">
                        <input type="hidden" name="examId" value="${exam.examId}">
                        <input type="hidden" name="sectionId" value="${sec.sectionId}">
                        <div class="modal-header">
                            <h5 class="modal-title fw-bold">Sửa Section</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên Section <span class="text-danger">*</span></label>
                                <input type="text" name="sectionName" class="form-control" required value="${sec.sectionName}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Kỹ năng <span class="text-danger">*</span></label>
                                <select name="skill" class="form-select" required>
                                    <option value="Listening" ${sec.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                                    <option value="Reading" ${sec.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                                    <option value="Writing" ${sec.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                                    <option value="Speaking" ${sec.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Resource (Bài đọc/nghe)</label>
                                <select name="resourceId" class="form-select select2-modal w-100">
                                    <option value="">-- Không chọn Resource --</option>
                                    <c:forEach var="res" items="${allResources}">
                                        <option value="${res.resourceId}" ${sec.resourceId == res.resourceId ? 'selected' : ''}>
                                            #${res.resourceId} - ${res.resourceName != null ? res.resourceName : 'Chưa đặt tên'} (${res.type})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary" style="background-color: var(--accent-blue); border-color: var(--accent-blue);">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>

    <!-- Modal Add Section -->
    <div class="modal fade" id="addSectionModal" tabindex="-1" aria-labelledby="addSectionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/mentor/exams" method="POST" class="modal-content">
                <input type="hidden" name="action" value="addSection">
                <input type="hidden" name="examId" value="${exam.examId}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="addSectionModalLabel">Thêm Section Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Section <span class="text-danger">*</span></label>
                        <input type="text" name="sectionName" class="form-control" required placeholder="VD: Reading Passage 1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Kỹ năng <span class="text-danger">*</span></label>
                        <select name="skill" class="form-select" required>
                            <option value="Listening">Listening</option>
                            <option value="Reading">Reading</option>
                            <option value="Writing">Writing</option>
                            <option value="Speaking">Speaking</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Resource (Bài đọc/nghe)</label>
                        <select name="resourceId" class="form-select select2-modal w-100">
                            <option value="">-- Không chọn Resource --</option>
                            <c:forEach var="res" items="${allResources}">
                                <option value="${res.resourceId}">
                                    #${res.resourceId} - ${res.resourceName != null ? res.resourceName : 'Chưa đặt tên'} (${res.type})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary" style="background-color: var(--accent-blue); border-color: var(--accent-blue);">Thêm</button>
                </div>
            </form>
        </div>
    </div>
    </c:if>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<!-- SortableJS -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script>
    function customConfirm(event, form, message) {
        event.preventDefault();
        if (confirm(message)) {
            form.submit();
        }
    }

    $(document).ready(function() {
        // Initialize Select2 in modals
        $('.select2-modal').each(function() {
            var $modal = $(this).closest('.modal');
            $(this).select2({
                dropdownParent: $modal,
                width: '100%'
            });
        });

        // Initialize SortableJS for the sections accordion
        const accordion = document.getElementById('sectionsAccordion');
        if (accordion) {
            new Sortable(accordion, {
                animation: 150,
                handle: 'div[style*="cursor: grab"]',
                ghostClass: 'bg-light',
                onEnd: function(evt) {
                    const items = accordion.querySelectorAll('.accordion-item');
                    const ids = [];
                    items.forEach((item, idx) => {
                        ids.push(item.getAttribute('data-section-id'));
                        // Update the section order badges visually
                        const badge = item.querySelector('.section-badge');
                        if (badge) {
                            badge.innerText = (idx + 1);
                        }
                    });
                    
                    if (ids.length > 0) {
                        const formData = new URLSearchParams();
                        formData.append('action', 'ajax-reorder-exam-sections');
                        formData.append('examId', '${exam.examId}');
                        formData.append('orderIds', ids.join(','));

                        fetch('${pageContext.request.contextPath}/mentor/exams', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: formData.toString()
                        })
                        .then(res => res.json())
                        .then(data => {
                            if (!data.success) {
                                console.error('Failed to save section order.');
                            }
                        })
                        .catch(err => console.error(err));
                    }
                }
            });
        }

        // Initialize SortableJS for each section's question list
        document.querySelectorAll('.sortable-questions-list').forEach(function(listContainer) {
            new Sortable(listContainer, {
                animation: 150,
                handle: 'div[style*="cursor: grab"]',
                ghostClass: 'bg-light',
                onEnd: function(evt) {
                    const items = listContainer.querySelectorAll('li');
                    const ids = [];
                    items.forEach((item, idx) => {
                        ids.push(item.getAttribute('data-question-id'));
                        // Update the badge numbers visually
                        const badge = item.querySelector('.question-badge');
                        if (badge) {
                            badge.innerText = 'Q' + (idx + 1);
                        }
                    });
                    
                    const sectionId = listContainer.getAttribute('data-section-id');
                    if (ids.length > 0) {
                        const formData = new URLSearchParams();
                        formData.append('action', 'ajax-reorder-exam-questions');
                        formData.append('sectionId', sectionId);
                        formData.append('orderIds', ids.join(','));

                        fetch('${pageContext.request.contextPath}/mentor/exams', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: formData.toString()
                        })
                        .then(res => res.json())
                        .then(data => {
                            if (!data.success) {
                                console.error('Failed to save order.');
                            }
                        })
                        .catch(err => console.error(err));
                    }
                }
            });
        });
    });
</script>
</body>
</html>
