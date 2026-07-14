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
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="questions" />
    </jsp:include>

    <main class="main-content">
        <header class="dashboard-header d-flex justify-content-between align-items-center mb-4 animate-fade-up">
            <div class="d-flex flex-column align-items-start">
                <a href="${pageContext.request.contextPath}/mentor/questions" id="backBtn" class="btn btn-outline-secondary mb-3 d-inline-flex align-items-center gap-2">
                    <i class="fa-solid fa-arrow-left"></i> <span>Quay lại</span>
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
<script src="${pageContext.request.contextPath}/js/mentor-question-builder.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.min.js"></script>
<script>
    $(document).ready(function() {
        $('.selectpicker').selectpicker();
    });
</script>
</body>
</html>
