<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${tag == null ? 'Tạo Tag' : 'Chi tiết Tag'} - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-orange); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="tags" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <a href="${pageContext.request.contextPath}/mentor/tags" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${tag == null ? 'Tạo Tag mới ✨' : 'Chỉnh sửa Tag ✏️'}</h1>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px; max-width: 600px;">
            <form action="${pageContext.request.contextPath}/mentor/tags" method="POST">
                <input type="hidden" name="action" value="${tag == null ? 'create' : 'update'}">
                <c:if test="${tag != null}">
                    <input type="hidden" name="tagId" value="${tag.tagId}">
                </c:if>
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-orange);">Thông tin Tag</h5>
                
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label fw-bold">Tên Tag <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" value="${tag.tagName}" required placeholder="VD: Grammar, Vocabulary, Note Completion...">
                    </div>

                    <div class="col-md-12">
                        <label class="form-label fw-bold">Loại Tag <span class="text-danger">*</span></label>
                        <select name="type" class="form-select" required>
                            <option value="Topic" ${tag.type == 'Topic' ? 'selected' : ''}>Topic (Chủ đề)</option>
                            <option value="Grammar" ${tag.type == 'Grammar' ? 'selected' : ''}>Grammar (Ngữ pháp)</option>
                            <option value="Vocabulary" ${tag.type == 'Vocabulary' ? 'selected' : ''}>Vocabulary (Từ vựng)</option>
                            <option value="QuestionType" ${tag.type == 'QuestionType' ? 'selected' : ''}>Question Type (Dạng câu hỏi)</option>
                            <option value="Other" ${tag.type == 'Other' ? 'selected' : ''}>Other (Khác)</option>
                        </select>
                    </div>
                </div>

                <div class="mt-5 text-end">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold" style="background-color: var(--accent-orange); border-color: var(--accent-orange);">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Tag
                    </button>
                </div>
            </form>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
