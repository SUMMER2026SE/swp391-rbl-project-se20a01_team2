<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${question == null ? 'Tạo câu hỏi' : 'Chi tiết câu hỏi'} - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Select CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/css/bootstrap-select.min.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
            <div>
                <a href="${pageContext.request.contextPath}/mentor/questions" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${question == null ? 'Tạo câu hỏi mới ✨' : 'Chỉnh sửa câu hỏi ✏️'}</h1>
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

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px;">
            <form action="${pageContext.request.contextPath}/mentor/questions" method="POST">
                <input type="hidden" name="action" value="${question == null ? 'create' : 'update'}">
                <c:if test="${question != null}">
                    <input type="hidden" name="questionId" value="${question.questionId}">
                </c:if>
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-blue);">Thông tin chung</h5>
                
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label fw-bold">Nội dung câu hỏi <span class="text-danger">*</span></label>
                        <textarea name="content" class="form-control" rows="3" required>${question.content}</textarea>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Dạng bài <span class="text-danger">*</span></label>
                        <select name="questionType" class="form-select" required>
                            <option value="MultipleChoice" ${question.questionType == 'MultipleChoice' ? 'selected' : ''}>Multiple Choice</option>
                            <option value="Matching" ${question.questionType == 'Matching' ? 'selected' : ''}>Matching</option>
                            <option value="FillInBlanks" ${question.questionType == 'FillInBlanks' ? 'selected' : ''}>Fill In Blanks</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Kỹ năng <span class="text-danger">*</span></label>
                        <select name="skill" class="form-select" required>
                            <option value="Listening" ${question.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                            <option value="Reading" ${question.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                            <option value="Writing" ${question.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                            <option value="Speaking" ${question.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Độ khó <span class="text-danger">*</span></label>
                        <select name="difficulty" class="form-select" required>
                            <option value="Easy" ${question.difficulty == 'Easy' ? 'selected' : ''}>Dễ (Easy)</option>
                            <option value="Medium" ${question.difficulty == 'Medium' ? 'selected' : ''}>Trung bình (Medium)</option>
                            <option value="Hard" ${question.difficulty == 'Hard' ? 'selected' : ''}>Khó (Hard)</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Resource (Bài đọc/nghe)</label>
                        <select name="resourceId" id="resourceId" class="selectpicker form-control" data-live-search="true" title="-- Không liên kết Resource --" onchange="toggleOrderInResource(true)">
                            <option value="">-- Không liên kết Resource --</option>
                            <c:forEach var="res" items="${allResources}">
                                <option value="${res.resourceId}" data-subtext="${res.type}" ${question.resourceId == res.resourceId ? 'selected' : ''}>
                                    #${res.resourceId} - ${res.resourceName != null ? res.resourceName : 'Chưa đặt tên'}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="col-md-4" id="orderInResourceContainer">
                        <label class="form-label fw-bold d-flex justify-content-between align-items-center mb-1">
                            <span>Thứ tự trong Resource</span>
                            <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2" onclick="openReorderModal()" style="font-size: 0.8rem;" title="Sắp xếp câu hỏi">
                                <i class="fa-solid fa-arrow-down-short-wide"></i> Sắp xếp
                            </button>
                        </label>
                        <div class="p-2 bg-light border rounded text-center fw-bold fs-6 text-primary" id="orderDisplay">
                            ${question != null && not empty question.orderInResource ? question.orderInResource : '-'}
                        </div>
                        <input type="hidden" name="orderInResource" id="orderInResourceInput" value="${question != null && not empty question.orderInResource ? question.orderInResource : 0}">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Tags</label>
                        <select name="tagIds" class="selectpicker form-control" multiple data-live-search="true" data-actions-box="true" title="-- Chọn Tags --" data-selected-text-format="count > 3">
                            <c:forEach var="tag" items="${allTags}">
                                <c:set var="isSelected" value="false" />
                                <c:if test="${question != null}">
                                    <c:forEach var="qTag" items="${question.tags}">
                                        <c:if test="${qTag.tagId == tag.tagId}"><c:set var="isSelected" value="true" /></c:if>
                                    </c:forEach>
                                </c:if>
                                <option value="${tag.tagId}" data-subtext="${tag.type}" ${isSelected ? 'selected' : ''}>
                                    ${tag.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label fw-bold">Giải thích (Explanation)</label>
                        <textarea name="explanation" class="form-control" rows="2">${question.explanation}</textarea>
                    </div>
                    
                    <div class="col-md-12">
                        <label class="form-label fw-bold">Dữ liệu nâng cao (JSON) <span class="text-danger">*</span></label>
                        
                        <!-- JSON Builder UI -->
                        <div id="contentJsonBuilder" class="mb-2 p-3 bg-light rounded border">
                            <div class="json-fields-container" id="contentJsonFields"></div>
                            <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addJsonField('contentJsonFields')">
                                <i class="fa-solid fa-plus"></i> Thêm trường dữ liệu
                            </button>
                        </div>
                        
                        <textarea name="contentJson" id="contentJson" class="form-control" rows="2" style="display: none;">${question.contentJson == null ? '{}' : question.contentJson}</textarea>
                        
                        <div class="form-check form-switch mt-2">
                            <input class="form-check-input" type="checkbox" id="toggleRawContentJson" onchange="toggleRawJson('contentJson', 'contentJsonBuilder')">
                            <label class="form-check-label text-muted" for="toggleRawContentJson">Hiển thị mã JSON thô</label>
                        </div>
                    </div>
                </div>

                <hr class="my-5" style="border-color: var(--glass-border);">
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-green);">Đáp án (Answers)</h5>
                
                <div id="answers-container">
                    <c:forEach var="ans" items="${question.answers}" varStatus="status">
                        <div class="answer-item glass-panel mb-3 p-3 position-relative" style="background: rgba(255,255,255,0.4);">
                            <button type="button" class="btn btn-sm btn-outline-danger position-absolute top-0 end-0 m-2" onclick="this.parentElement.remove(); updateAnswerCount();"><i class="fa-solid fa-xmark"></i></button>
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-bold">Nội dung đáp án</label>
                                    <input type="text" name="answerContent_${status.index}" class="form-control" value="${ans.content}" required>
                                </div>
                                <div class="col-md-4 d-flex align-items-end">
                                    <div class="form-check form-switch mb-2">
                                        <input class="form-check-input" type="checkbox" name="answerIsCorrect_${status.index}" value="true" ${ans.correct ? 'checked' : ''} id="correct_${status.index}">
                                        <label class="form-check-label fw-bold text-success" for="correct_${status.index}">Là đáp án đúng?</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-bold">Dữ liệu mở rộng đáp án (JSON)</label>
                                    
                                    <div id="ansJsonBuilder_${status.index}" class="mb-2 p-2 bg-light rounded border">
                                        <div class="json-fields-container" id="ansJsonFields_${status.index}"></div>
                                        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addJsonField('ansJsonFields_${status.index}')">
                                            <i class="fa-solid fa-plus"></i> Thêm trường dữ liệu
                                        </button>
                                    </div>
                                    
                                    <textarea name="answerContentJson_${status.index}" id="ansJson_${status.index}" class="form-control" rows="2" style="display: none;">${ans.contentJson == null ? '{}' : ans.contentJson}</textarea>
                                    
                                    <div class="form-check form-switch mt-2">
                                        <input class="form-check-input" type="checkbox" id="toggleRawAnsJson_${status.index}" onchange="toggleRawJson('ansJson_${status.index}', 'ansJsonBuilder_${status.index}')">
                                        <label class="form-check-label text-muted" style="font-size: 0.85rem;" for="toggleRawAnsJson_${status.index}">Mã JSON thô</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <input type="hidden" name="answerCount" id="answerCount" value="${question == null ? 0 : question.answers.size()}">
                
                <button type="button" class="btn btn-outline-primary rounded-pill mb-4 shadow-sm" onclick="addAnswer()">
                    <i class="fa-solid fa-plus"></i> Thêm đáp án
                </button>

                <div class="mt-5 text-end">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Câu Hỏi
                    </button>
                </div>
            </form>
        </div>
        
    </main>
</div>

<!-- Modal Sắp xếp câu hỏi -->
<div class="modal fade" id="reorderQuestionsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-primary">Sắp xếp câu hỏi trong Resource</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted small mb-3">Kéo thả để thay đổi thứ tự các câu hỏi hiện có trong Resource này. Chỉ các câu hỏi đã lưu mới hiển thị ở đây.</p>
                <ul class="list-group" id="sortableQuestionsList">
                    <!-- Fetched via AJAX -->
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnSaveOrder" onclick="saveQuestionsOrder()">Lưu thứ tự</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script>
    let answerIndex = parseInt(document.getElementById('answerCount').value);
    
    function addAnswer() {
        const container = document.getElementById('answers-container');
        const html = `
            <div class="answer-item glass-panel mb-3 p-3 position-relative" style="background: rgba(255,255,255,0.4);">
                <button type="button" class="btn btn-sm btn-outline-danger position-absolute top-0 end-0 m-2" onclick="this.parentElement.remove(); updateAnswerCount();"><i class="fa-solid fa-xmark"></i></button>
                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">Nội dung đáp án</label>
                        <input type="text" name="answerContent_` + answerIndex + `" class="form-control" required>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input class="form-check-input" type="checkbox" name="answerIsCorrect_` + answerIndex + `" value="true" id="correct_` + answerIndex + `">
                            <label class="form-check-label fw-bold text-success" for="correct_` + answerIndex + `">Là đáp án đúng?</label>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label fw-bold">Dữ liệu mở rộng đáp án (JSON)</label>
                        <div id="ansJsonBuilder_` + answerIndex + `" class="mb-2 p-2 bg-light rounded border">
                            <div class="json-fields-container" id="ansJsonFields_` + answerIndex + `"></div>
                            <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addJsonField('ansJsonFields_` + answerIndex + `')">
                                <i class="fa-solid fa-plus"></i> Thêm trường dữ liệu
                            </button>
                        </div>
                        <textarea name="answerContentJson_` + answerIndex + `" id="ansJson_` + answerIndex + `" class="form-control" rows="2" style="display: none;">{}</textarea>
                        <div class="form-check form-switch mt-2">
                            <input class="form-check-input" type="checkbox" id="toggleRawAnsJson_` + answerIndex + `" onchange="toggleRawJson('ansJson_` + answerIndex + `', 'ansJsonBuilder_` + answerIndex + `')">
                            <label class="form-check-label text-muted" style="font-size: 0.85rem;" for="toggleRawAnsJson_` + answerIndex + `">Mã JSON thô</label>
                        </div>
                    </div>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', html);
        answerIndex++;
        updateAnswerCount();
    }
    
    function updateAnswerCount() {
        // MentorQuestionServlet relies on answerCount to loop up to that index.
        // Actually, it loops from 0 to count-1. So we shouldn't just decrement count, 
        // because the indices might have gaps if we remove one in the middle.
        // The servlet reads `req.getParameter("answerContent_" + i)`. If it's missing, it continues.
        // So we just need answerCount to be at least the maximum index + 1.
        document.getElementById('answerCount').value = answerIndex;
    }
    
    // --- JSON BUILDER LOGIC ---
    function toggleRawJson(textareaId, builderId) {
        const textarea = document.getElementById(textareaId);
        const builder = document.getElementById(builderId);
        if (textarea.style.display === 'none') {
            // Show raw, hide builder
            textarea.style.display = 'block';
            builder.style.display = 'none';
        } else {
            // Hide raw, show builder
            textarea.style.display = 'none';
            builder.style.display = 'block';
            // Sync from textarea to builder
            syncTextareaToBuilder(textareaId, builderId.replace('Builder', 'Fields'));
        }
    }

    function addJsonField(containerId, key = '', value = '') {
        const container = document.getElementById(containerId);
        const row = document.createElement('div');
        row.className = 'row g-2 mb-2 align-items-center json-field-row';
        row.innerHTML = `
            <div class="col-4">
                <input type="text" class="form-control form-control-sm json-key" placeholder="Key (VD: blanks)" value="` + key.replace(/"/g, '&quot;') + `" onchange="syncBuilderToTextarea('` + containerId + `')">
            </div>
            <div class="col-7">
                <input type="text" class="form-control form-control-sm json-value" placeholder="Value (Text, Number, hoặc JSON Array)" value="` + value.replace(/"/g, '&quot;') + `" onchange="syncBuilderToTextarea('` + containerId + `')">
            </div>
            <div class="col-1 text-end">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="this.parentElement.parentElement.remove(); syncBuilderToTextarea('` + containerId + `')"><i class="fa-solid fa-trash"></i></button>
            </div>
        `;
        container.appendChild(row);
    }

    function syncBuilderToTextarea(containerId) {
        const container = document.getElementById(containerId);
        const rows = container.querySelectorAll('.json-field-row');
        const obj = {};
        
        rows.forEach(row => {
            const key = row.querySelector('.json-key').value.trim();
            const val = row.querySelector('.json-value').value.trim();
            if (key) {
                // Try to parse val as JSON (for numbers, booleans, arrays, objects)
                try {
                    obj[key] = JSON.parse(val);
                } catch (e) {
                    obj[key] = val; // fallback to string
                }
            }
        });
        
        // Find corresponding textarea
        const textareaId = containerId.replace('Fields', ''); // 'contentJsonFields' -> 'contentJson', 'ansJsonFields_0' -> 'ansJson_0'
        const textarea = document.getElementById(textareaId);
        if (textarea) {
            textarea.value = JSON.stringify(obj, null, 2);
        }
    }

    function syncTextareaToBuilder(textareaId, containerId) {
        const textarea = document.getElementById(textareaId);
        const container = document.getElementById(containerId);
        if (!textarea || !container) return;
        
        container.innerHTML = ''; // clear current
        
        try {
            const obj = JSON.parse(textarea.value || '{}');
            for (const [k, v] of Object.entries(obj)) {
                let valStr = typeof v === 'object' ? JSON.stringify(v) : String(v);
                addJsonField(containerId, k, valStr);
            }
        } catch (e) {
            console.error("Invalid JSON in textarea", textareaId);
            addJsonField(containerId);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        toggleOrderInResource();
        const contentJsonRaw = document.getElementById('contentJson').value;
        const contentContainer = document.getElementById('contentJsonFields');
        if (contentContainer) syncTextareaToBuilder('contentJson', 'contentJsonFields');

        const answerCount = parseInt(document.getElementById('answerCount').value);
        for (let i = 0; i < answerCount; i++) {
            if (document.getElementById('ansJson_' + i)) {
                syncTextareaToBuilder('ansJson_' + i, 'ansJsonFields_' + i);
            }
        }
    });

    function toggleOrderInResource(isUserAction = false) {
        const resourceIdInput = document.getElementById('resourceId');
        const orderContainer = document.getElementById('orderInResourceContainer');
        const orderInput = document.getElementById('orderInResourceInput');
        const orderDisplay = document.getElementById('orderDisplay');
        
        if (resourceIdInput && orderContainer) {
            const resId = resourceIdInput.value.trim();
            if (resId === '') {
                orderContainer.style.display = 'none';
                if (isUserAction && orderInput) {
                    orderInput.value = '0';
                    if (orderDisplay) orderDisplay.innerText = '-';
                }
            } else {
                orderContainer.style.display = 'block';
                if (isUserAction && orderInput) {
                    if (orderDisplay) orderDisplay.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
                    fetch(window.contextPath + '/mentor/questions?action=ajax-next-order&resourceId=' + resId)
                        .then(response => response.json())
                        .then(data => {
                            if (data && data.nextOrder) {
                                orderInput.value = data.nextOrder;
                                if (orderDisplay) orderDisplay.innerText = data.nextOrder;
                            }
                        })
                        .catch(error => {
                            console.error("Error fetching next order:", error);
                            if (orderDisplay) orderDisplay.innerText = '-';
                        });
                }
            }
        }
    }

    // Drag and drop reordering
    let sortableInstance = null;
    
    function openReorderModal() {
        const resourceId = document.getElementById('resourceId').value.trim();
        if (!resourceId) {
            alert('Vui lòng chọn Resource trước khi sắp xếp.');
            return;
        }

        const listContainer = document.getElementById('sortableQuestionsList');
        listContainer.innerHTML = '<li class="list-group-item text-center"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải...</li>';
        
        const modal = new bootstrap.Modal(document.getElementById('reorderQuestionsModal'));
        modal.show();

        fetch(window.contextPath + '/mentor/questions?action=ajax-get-questions-by-resource&resourceId=' + resourceId)
            .then(res => res.json())
            .then(data => {
                listContainer.innerHTML = '';
                if (data.length === 0) {
                    listContainer.innerHTML = '<li class="list-group-item text-center text-muted">Chưa có câu hỏi nào trong Resource này.</li>';
                    return;
                }
                
                data.forEach((q, index) => {
                    const li = document.createElement('li');
                    li.className = 'list-group-item d-flex align-items-center';
                    li.dataset.id = q.questionId;
                    li.innerHTML = `
                        <i class="fa-solid fa-grip-vertical text-muted me-3" style="cursor: grab;"></i>
                        <span class="badge bg-secondary me-2">` + (index + 1) + `</span>
                        <span class="text-truncate">` + q.content + `</span>
                    `;
                    listContainer.appendChild(li);
                });

                if (sortableInstance) sortableInstance.destroy();
                sortableInstance = new Sortable(listContainer, {
                    animation: 150,
                    ghostClass: 'bg-light',
                    onEnd: function () {
                        // Update badges after drag
                        const items = listContainer.querySelectorAll('li');
                        items.forEach((item, idx) => {
                            const badge = item.querySelector('.badge');
                            if (badge) badge.innerText = (idx + 1);
                        });
                    }
                });
            })
            .catch(err => {
                console.error(err);
                listContainer.innerHTML = '<li class="list-group-item text-center text-danger">Có lỗi xảy ra khi tải dữ liệu.</li>';
            });
    }

    function saveQuestionsOrder() {
        const listContainer = document.getElementById('sortableQuestionsList');
        const items = listContainer.querySelectorAll('li');
        if (items.length === 0) return;

        const ids = Array.from(items).map(li => li.dataset.id).filter(id => id);
        if (ids.length === 0) return;

        const btn = document.getElementById('btnSaveOrder');
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';

        const formData = new URLSearchParams();
        formData.append('action', 'ajax-update-questions-order');
        formData.append('orderIds', ids.join(','));

        fetch(window.contextPath + '/mentor/questions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                bootstrap.Modal.getInstance(document.getElementById('reorderQuestionsModal')).hide();
                // If editing a question, update its order display
                const currentQuestionId = '${question != null ? question.questionId : ""}';
                if (currentQuestionId) {
                    const currentIndex = ids.indexOf(currentQuestionId);
                    if (currentIndex !== -1) {
                        const newOrder = currentIndex + 1;
                        document.getElementById('orderInResourceInput').value = newOrder;
                        const display = document.getElementById('orderDisplay');
                        if (display) {
                            display.innerText = newOrder;
                        }
                    }
                } else {
                    // If creating a new question, refresh the auto-assigned next order
                    toggleOrderInResource(true);
                }
            }
        })
        .catch(err => console.error(err))
        .finally(() => {
            btn.disabled = false;
            btn.innerText = 'Lưu thứ tự';
        });
    }
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.min.js"></script>
<script>
    $(document).ready(function() {
        $('.selectpicker').selectpicker();
        
        $('#resourceId').on('change', function () {
            toggleOrderInResource(true);
        });
    });
</script>
</body>
</html>
