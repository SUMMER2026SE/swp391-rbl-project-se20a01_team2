<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
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
    <c:if test="${param.hideSidebar != 'true'}">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="active" value="questions" />
        </jsp:include>
    </c:if>

    <main class="main-content" style="${param.hideSidebar == 'true' ? 'margin-left: 0; width: 100%; max-width: 100%; padding: 20px;' : ''}">
        <header class="dashboard-header d-flex justify-content-between align-items-center mb-4 animate-fade-up">
            <div class="d-flex flex-column align-items-start">
                <c:if test="${param.hideSidebar != 'true'}">
                    <a href="${pageContext.request.contextPath}/mentor/questions" id="backBtn" class="btn btn-outline-secondary mb-3 d-inline-flex align-items-center gap-2">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </c:if>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${question == null ? 'Thêm Câu Hỏi Mới 📝' : 'Chỉnh Sửa Câu Hỏi ✍️'}</h1>
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
                        <select name="questionType" id="questionTypeSelect" class="form-select" required>
                            <option value="MultipleChoice" ${question.questionType == 'MultipleChoice' ? 'selected' : ''}>Multiple Choice</option>
                            <option value="Matching" ${question.questionType == 'Matching' ? 'selected' : ''}>Matching</option>
                            <option value="FillInBlanks" ${question.questionType == 'FillInBlanks' ? 'selected' : ''}>Fill In Blanks</option>
                            <option value="Essay" ${question.questionType == 'Essay' ? 'selected' : ''}>Tự luận (Essay)</option>
                            <option value="AudioResponse" ${question.questionType == 'AudioResponse' ? 'selected' : ''}>Ghi âm (Speaking)</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Kỹ năng <span class="text-danger">*</span></label>
                        <select name="skill" id="skillSelect" class="form-select" required>
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
                        <select name="resourceId" id="resourceId" class="selectpicker form-control" data-live-search="true" title="-- Không liên kết Resource --">
                            <option value="">-- Không liên kết Resource --</option>
                            <c:forEach var="res" items="${allResources}">
                                <option value="${res.resourceId}" data-subtext="${res.type}" ${question.resourceId == res.resourceId ? 'selected' : ''}>
                                    #${res.resourceId} - ${res.resourceName != null ? res.resourceName : 'Chưa đặt tên'}
                                </option>
                            </c:forEach>
                        </select>
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
                        
                        <div id="dynamicContentJsonBuilder" class="mb-2 p-3 bg-light rounded border">
                            <!-- This will be populated by mentor-question-builder.js based on questionType -->
                        </div>
                        
                        <textarea name="contentJson" id="contentJson" class="form-control" rows="5" style="display: none;">${question.contentJson == null ? '{}' : question.contentJson}</textarea>
                        
                        <div class="form-check form-switch mt-2">
                            <input class="form-check-input" type="checkbox" id="toggleRawContentJson">
                            <label class="form-check-label text-muted" for="toggleRawContentJson">Hiển thị mã JSON thô</label>
                        </div>
                    </div>
                </div>

                <hr class="my-5" style="border-color: var(--glass-border);">
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-green);">Đáp án (Answers)</h5>
                
                <div id="answers-container">
                    <c:forEach var="ans" items="${question.answers}" varStatus="status">
                        <div class="answer-item glass-panel mb-3 p-3 position-relative" style="background: rgba(255,255,255,0.4);">
                            <button type="button" class="btn btn-sm btn-outline-danger position-absolute top-0 end-0 m-2 btn-remove-answer"><i class="fa-solid fa-xmark"></i></button>
                            <div class="row g-3">
                                <div class="col-md-8 answer-content-col">
                                    <label class="form-label fw-bold">Nội dung đáp án</label>
                                    <input type="text" name="answerContent_${status.index}" class="form-control answer-content-input" value="${ans.content}" required>
                                </div>
                                <div class="col-md-4 d-flex align-items-end answer-correct-col">
                                    <div class="form-check form-switch mb-2">
                                        <input class="form-check-input answer-correct-checkbox" type="checkbox" name="answerIsCorrect_${status.index}" value="true" ${ans.correct ? 'checked' : ''} id="correct_${status.index}">
                                        <label class="form-check-label fw-bold text-success" for="correct_${status.index}">Là đáp án đúng?</label>
                                    </div>
                                </div>
                                <div class="col-md-12 answer-json-col">
                                    <label class="form-label fw-bold">Dữ liệu mở rộng đáp án (JSON)</label>
                                    <div class="dynamicAnsJsonBuilder mb-2 p-2 bg-light rounded border" data-index="${status.index}">
                                        <!-- Populated by JS -->
                                    </div>
                                    <textarea name="answerContentJson_${status.index}" id="ansJson_${status.index}" class="form-control ansJsonRaw" rows="5" style="display: none;">${ans.contentJson == null ? '{}' : ans.contentJson}</textarea>
                                    <div class="form-check form-switch mt-2">
                                        <input class="form-check-input toggleRawAnsJson" type="checkbox" data-index="${status.index}" id="toggleRawAnsJson_${status.index}">
                                        <label class="form-check-label text-muted" style="font-size: 0.85rem;" for="toggleRawAnsJson_${status.index}">Mã JSON thô</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <input type="hidden" name="answerCount" id="answerCount" value="${question == null ? 0 : question.answers.size()}">
                
                <button type="button" class="btn btn-outline-primary rounded-pill mb-4 shadow-sm" id="btnAddAnswer">
                    <i class="fa-solid fa-plus"></i> Thêm đáp án
                </button>

                <div class="mt-4 text-end d-flex justify-content-end gap-2 sticky-bottom" style="position: sticky; bottom: 15px; z-index: 99;">
                    <button type="button" class="btn btn-secondary rounded-pill px-4 py-2 shadow" onclick="showPreviewModal()">
                        <i class="fa-solid fa-eye me-2"></i> Xem Trước (Preview)
                    </button>
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Câu Hỏi
                    </button>
                </div>
            </form>
        </div>
        
    </main>
</div>

<!-- Preview Modal -->
<div class="modal fade" id="previewModal" tabindex="-1" aria-labelledby="previewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-primary" id="previewModalLabel">Xem Trước Câu Hỏi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="previewContainer" class="p-4 rounded border bg-light">
                    <!-- Preview content injected by JS -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success fw-bold" onclick="checkPreviewAnswers()">
                    <i class="fa-solid fa-check-double me-1"></i> Kiểm tra đáp án
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<div id="resource-texts" style="display:none;">
    <c:forEach var="res" items="${allResources}">
        <div id="res_text_${res.resourceId}">
            <div class="d-flex flex-column gap-3">
                <c:if test="${not empty res.resourceText}">
                    <div>${res.resourceText}</div>
                </c:if>
                <c:if test="${not empty res.resourceImageUrl}">
                    <div class="text-center">
                        <img src="${pageContext.request.contextPath}${res.resourceImageUrl}" class="img-fluid rounded shadow-sm" alt="Image Resource" style="max-height: 400px;" />
                    </div>
                </c:if>
                <c:if test="${not empty res.resourceAudioUrl}">
                    <div class="text-center p-3 bg-light rounded">
                        <c:choose>
                            <c:when test="${fn:contains(res.resourceAudioUrl, 'youtube.com') or fn:contains(res.resourceAudioUrl, 'youtu.be')}">
                                <c:set var="embedUrl" value="${fn:replace(res.resourceAudioUrl, 'watch?v=', 'embed/')}" />
                                <c:set var="embedUrl" value="${fn:replace(embedUrl, 'youtu.be/', 'youtube.com/embed/')}" />
                                <iframe width="100%" height="250" src="${embedUrl}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                            </c:when>
                            <c:when test="${fn:contains(res.resourceAudioUrl, 'drive.google.com')}">
                                <c:set var="embedUrl" value="${fn:replace(res.resourceAudioUrl, '/view', '/preview')}" />
                                <iframe src="${embedUrl}" width="100%" height="250" allow="autoplay"></iframe>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-headphones fs-1 text-warning mb-2"></i><br>
                                <audio controls class="w-100 mt-2"><source src="${pageContext.request.contextPath}${res.resourceAudioUrl}"></audio>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script src="${pageContext.request.contextPath}/js/mentor-question-builder.js?t=<%= System.currentTimeMillis() %>"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.min.js"></script>
<script>
    $(document).ready(function() {
        $('.selectpicker').selectpicker();
    });
</script>
<!-- INJECTED PREVIEW LOGIC -->
<script>
window.showPreviewModal = function() {
    const qType = document.querySelector('select[name=questionType]').value;
    const content = document.querySelector('textarea[name=content]').value;
    const container = document.getElementById('previewContainer');

    let resourceId = document.getElementById('resourceId').value;
    let resourceTextHtml = '';
    if (resourceId) {
        let resDiv = document.getElementById('res_text_' + resourceId);
        if (resDiv) {
            resourceTextHtml = `<div class="resource-panel mb-4 p-3 border rounded bg-white shadow-sm" style="max-height: 300px; overflow-y: auto;">` + resDiv.innerHTML + `</div>`;
        }
    }

    let html = resourceTextHtml + `<div class="q-content mb-4">\${content.replace(/\n/g, '<br>')}</div>`;

    if (qType === 'MultipleChoice') {
        html += `<div class="choices d-flex flex-column gap-2">`;
        document.querySelectorAll('.answer-item').forEach((item, i) => {
            if (item.style.display !== 'none') {
                const text = item.querySelector('.answer-content-input').value;
                html += `
                    <label class="choice border p-2 rounded d-flex align-items-center gap-2" style="cursor: pointer;">
                        <input type="radio" name="preview_mc">
                        <span class="choice-text">\${text}</span>
                    </label>
                `;
            }
        });
        html += `</div>`;
    } else if (qType === 'Matching') {
        const dataStr = document.getElementById('contentJson').value;
        let data = {};
        try { data = JSON.parse(dataStr || '{}'); } catch(e) {}
        const leftSide = data.left_side || [];
        const rightSide = data.right_side || [];

        html += `<div class="matching-preview row">`;
        html += `<div class="col-md-8">`;
        leftSide.forEach(item => {
            html += `
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-secondary">\${item.id}</span>
                    <span>\${item.text}</span>
                    <select class="form-select form-select-sm" style="width: auto;">
                        <option value="">-- Chọn --</option>
                        \${rightSide.map(r => `<option value="\${r.id}">\${r.id}</option>`).join('')}
                    </select>
                </div>
            `;
        });
        html += `</div>`;
        html += `<div class="col-md-4 border-start">`;
        html += `<h6 class="fw-bold">Lựa chọn:</h6>`;
        html += `<ul class="list-unstyled">`;
        rightSide.forEach(r => {
            html += `<li class="mb-1"><span class="badge bg-light text-dark border">\${r.id}</span> \${r.text}</li>`;
        });
        html += `</ul>`;
        html += `</div>`;
        html += `</div>`;
    } else if (qType === 'FillInBlanks') {
        const dataStr = document.getElementById('contentJson').value;
        let data = {};
        try { data = JSON.parse(dataStr || '{}'); } catch(e) {}
        const blanks = data.blanks || {};

        let previewContentHtml = content.replace(/\n/g, '<br>');
        let previewResourceHtml = resourceTextHtml;
        let warnings = [];

        for (const [id, config] of Object.entries(blanks)) {
            let blankHtml = '';
            if (config.type === 'text') {
                blankHtml = `<input type="text" data-blank-id="\${id}" class="form-control form-control-sm d-inline-block mx-1 preview-auto-fit" placeholder="\${config.placeholder || ''}" style="width: 100px; min-width: 60px;" oninput="autoFitInput(this)">`;
            } else {
                const opts = config.options || [];
                blankHtml = `<select data-blank-id="\${id}" class="form-select form-select-sm d-inline-block w-auto mx-1">`;
                blankHtml += `<option value="">-- Chọn --</option>`;
                opts.forEach(o => {
                    blankHtml += `<option value="\${o}">\${o}</option>`;
                });
                blankHtml += `</select>`;
            }

            const regex = new RegExp(`\\(\${id}\\)`, 'g');
            let foundInText = false;
            if (previewContentHtml.match(regex)) {
                previewContentHtml = previewContentHtml.replace(regex, blankHtml);
                foundInText = true;
            }
            if (previewResourceHtml && previewResourceHtml.match(regex)) {
                previewResourceHtml = previewResourceHtml.replace(regex, blankHtml);
                foundInText = true;
            }

            if (!foundInText) {
                warnings.push(`Cảnh báo: Không tìm thấy đánh dấu <strong>(\${id})</strong> trong bài đọc hoặc nội dung câu hỏi!`);
            }
        }

        let warningHtml = '';
        if (warnings.length > 0) {
            warningHtml = warnings.map(w => `<div class="alert alert-warning py-2 mb-2"><i class="fa-solid fa-triangle-exclamation"></i> \${w}</div>`).join('');
        }

        html = warningHtml + previewResourceHtml + `<div class="q-content mb-4">\${previewContentHtml}</div>`;
    } else if (qType === 'Essay') {
        html += `<textarea class="form-control mt-3" rows="8" placeholder="Học viên sẽ gõ bài làm tự luận của mình tại đây..."></textarea>`;
    } else if (qType === 'AudioResponse') {
        html += `<div class="alert alert-info mt-3 d-flex align-items-center gap-3">
            <button class="btn btn-danger rounded-circle p-3" style="width: 50px; height: 50px;"><i class="fa-solid fa-microphone"></i></button>
            <span>Khu vực học viên ghi âm câu trả lời (Bản xem trước)</span>
        </div>`;
    }

    container.innerHTML = html;

    container.querySelectorAll('.preview-auto-fit').forEach(inp => autoFitInput(inp));

    const modal = new bootstrap.Modal(document.getElementById('previewModal'));
    modal.show();
};

window.checkPreviewAnswers = function() {
    const qType = document.querySelector('select[name=questionType]').value;
    const container = document.getElementById('previewContainer');
    let allCorrect = true;
    let checkedAtLeastOne = false;

    if (qType === 'Essay' || qType === 'AudioResponse') {
        Swal.fire('Thông tin', 'Dạng bài này sẽ được chấm điểm bằng AI sau khi nộp bài, không có đáp án đúng sai cố định.', 'info');
        return;
    }

    if (qType === 'MultipleChoice') {
        const radios = container.querySelectorAll('input[type="radio"]');
        let selectedIndex = -1;
        radios.forEach((r, i) => { if (r.checked) selectedIndex = i; });

        if (selectedIndex === -1) {
            Swal.fire('Chưa trả lời', 'Vui lòng chọn một đáp án!', 'warning');
            return;
        }

        let correctIndex = -1;
        let count = 0;
        document.querySelectorAll('.answer-item').forEach(item => {
            if (item.style.display !== 'none') {
                if (item.querySelector('.answer-correct-checkbox').checked) correctIndex = count;
                count++;
            }
        });

        if (selectedIndex === correctIndex) {
            Swal.fire('Chính xác!', 'Bạn đã chọn đúng đáp án.', 'success');
        } else {
            Swal.fire('Sai rồi!', 'Đáp án chưa chính xác.', 'error');
        }
    } else if (qType === 'Matching') {
        const selects = container.querySelectorAll('.matching-preview select');
        if (selects.length === 0) return;

        const ansJsonTextarea = document.querySelector('.answer-item .ansJsonRaw');
        let correctMapping = {};
        try { correctMapping = JSON.parse(ansJsonTextarea.value || '{}'); } catch(e) {}

        let correctCount = 0;
        selects.forEach(sel => {
            const leftId = sel.closest('div').querySelector('.badge').innerText;
            const rightId = sel.value;
            if (rightId && correctMapping[leftId] == rightId) {
                correctCount++;
                sel.style.borderColor = 'green';
                sel.style.backgroundColor = '#e8f5e9';
            } else {
                allCorrect = false;
                if (rightId) {
                    sel.style.borderColor = 'red';
                    sel.style.backgroundColor = '#ffebee';
                }
            }
            if (rightId) checkedAtLeastOne = true;
        });

        if (!checkedAtLeastOne) {
            Swal.fire('Chưa trả lời', 'Vui lòng nối ít nhất 1 đáp án.', 'warning');
            return;
        }

        if (allCorrect) {
            Swal.fire('Chính xác!', 'Bạn đã nối đúng tất cả!', 'success');
        } else {
            Swal.fire('Chưa chính xác!', `Bạn đã đúng \${correctCount}/\${selects.length} mục.`, 'error');
        }
    } else if (qType === 'FillInBlanks') {
        const inputs = container.querySelectorAll('input.preview-auto-fit, select.form-select');
        if (inputs.length === 0) return;

        const ansJsonTextarea = document.querySelector('.answer-item .ansJsonRaw');
        let correctAnswers = {};
        try { correctAnswers = JSON.parse(ansJsonTextarea.value || '{}'); } catch(e) {}

        let correctCount = 0;
        inputs.forEach(inp => {
            const val = inp.value.trim().toLowerCase();
            const id = inp.getAttribute('data-blank-id');
            if (val) checkedAtLeastOne = true;

            let isCorrect = false;
            let validOpts = correctAnswers[id] || [];
            if (!Array.isArray(validOpts)) validOpts = [validOpts];

            validOpts = validOpts.map(v => String(v).trim().toLowerCase());

            if (val && validOpts.includes(val)) {
                isCorrect = true;
                correctCount++;
            }

            if (isCorrect) {
                inp.style.borderColor = 'green';
                inp.style.backgroundColor = '#e8f5e9';
            } else if (val) {
                inp.style.borderColor = 'red';
                inp.style.backgroundColor = '#ffebee';
                allCorrect = false;
            } else {
                allCorrect = false;
            }
        });

        if (!checkedAtLeastOne) {
            Swal.fire('Chưa trả lời', 'Vui lòng điền ít nhất 1 ô trống.', 'warning');
            return;
        }

        if (allCorrect) {
            Swal.fire('Chính xác!', 'Bạn đã điền đúng tất cả!', 'success');
        } else {
            Swal.fire('Chưa chính xác!', `Bạn đã đúng \${correctCount}/\${inputs.length} mục.`, 'error');
        }
    }
};

window.autoFitInput = function(inp) {
    const canvas = window.autoFitInput._canvas || (window.autoFitInput._canvas = document.createElement('canvas'));
    const ctx = canvas.getContext('2d');
    const style = window.getComputedStyle(inp);
    ctx.font = style.fontSize + ' ' + style.fontFamily;
    const text = inp.value || inp.placeholder || '';
    const measured = ctx.measureText(text).width;
    const newWidth = Math.max(measured + 24, 70);
    inp.style.width = Math.min(newWidth, 400) + 'px';
};
</script>

<!-- INJECTED QUESTION TYPE LOGIC -->
<script>
window.filterQuestionTypes = function() {
    const skill = document.getElementById('skillSelect').value;
    const qTypeSelect = document.getElementById('questionTypeSelect');
    
    let validTypes = [];
    if (skill === 'Writing') {
        validTypes = ['Essay'];
    } else if (skill === 'Speaking') {
        validTypes = ['AudioResponse'];
    } else {
        validTypes = ['MultipleChoice', 'Matching', 'FillInBlanks'];
    }
    
    let currentVal = qTypeSelect.value;
    qTypeSelect.innerHTML = '';
    
    const allOptions = [
        {value: 'MultipleChoice', text: 'Multiple Choice'},
        {value: 'Matching', text: 'Matching'},
        {value: 'FillInBlanks', text: 'Fill In Blanks'},
        {value: 'Essay', text: 'Tự luận (Essay)'},
        {value: 'AudioResponse', text: 'Ghi âm (Speaking)'}
    ];
    
    let hasSelected = false;
    allOptions.forEach(opt => {
        if (validTypes.includes(opt.value)) {
            const option = document.createElement('option');
            option.value = opt.value;
            option.text = opt.text;
            if (opt.value === currentVal) {
                option.selected = true;
                hasSelected = true;
            }
            qTypeSelect.appendChild(option);
        }
    });
    
    if (!hasSelected && validTypes.length > 0) {
        qTypeSelect.value = validTypes[0];
    }
    
    if (typeof window.applyQuestionTypeLogicOverride === 'function') {
        setTimeout(window.applyQuestionTypeLogicOverride, 10);
    }
};

window.applyQuestionTypeLogicOverride = function() {
    const qTypeSelect = document.getElementById('questionTypeSelect');
    if (!qTypeSelect) return;
    const qType = qTypeSelect.value;
    const contentJsonContainer = document.getElementById('dynamicContentJsonBuilder');
    const btnAddAnswer = document.getElementById('btnAddAnswer');
    const answersContainerBody = document.getElementById('answersContainer');
    
    if (qType === 'Essay' || qType === 'AudioResponse') {
        if (contentJsonContainer) contentJsonContainer.parentElement.style.display = 'none';
        if (btnAddAnswer) btnAddAnswer.style.display = 'none';
        
        if (answersContainerBody) {
            answersContainerBody.style.display = 'none';
            const header = answersContainerBody.parentElement.querySelector('.card-header');
            if (header) header.style.display = 'none';
        }
    } else {
        if (answersContainerBody) {
            answersContainerBody.style.display = '';
            const header = answersContainerBody.parentElement.querySelector('.card-header');
            if (header) header.style.display = '';
        }
    }
};

document.addEventListener('DOMContentLoaded', function() {
    const skillSelect = document.getElementById('skillSelect');
    if (skillSelect) {
        skillSelect.addEventListener('change', window.filterQuestionTypes);
        // Run once on load
        window.filterQuestionTypes();
    }
    const qTypeSelect = document.getElementById('questionTypeSelect');
    if (qTypeSelect) {
        qTypeSelect.addEventListener('change', () => setTimeout(window.applyQuestionTypeLogicOverride, 10));
    }
});
</script>

</body>
</html>
