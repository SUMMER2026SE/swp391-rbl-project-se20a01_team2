<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson == null ? 'Tạo bài học' : 'Chi tiết bài học'} - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
            <div>
                <a href="${pageContext.request.contextPath}/mentor/lessons" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">${lesson == null ? 'Tạo bài học mới ✨' : 'Chỉnh sửa bài học ✏️'}</h1>
            </div>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px;">
            <form action="${pageContext.request.contextPath}/mentor/lessons" method="POST">
                <input type="hidden" name="action" value="${lesson == null ? 'create' : 'update'}">
                <c:if test="${lesson != null}">
                    <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                </c:if>
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-green);">Nội dung bài học</h5>
                
                <div class="row g-4">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">Tiêu đề bài học <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" value="${lesson.title}" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Kỹ năng <span class="text-danger">*</span></label>
                        <select name="skill" class="form-select" required>
                            <option value="Listening" ${lesson.skill == 'Listening' ? 'selected' : ''}>Listening</option>
                            <option value="Reading" ${lesson.skill == 'Reading' ? 'selected' : ''}>Reading</option>
                            <option value="Writing" ${lesson.skill == 'Writing' ? 'selected' : ''}>Writing</option>
                            <option value="Speaking" ${lesson.skill == 'Speaking' ? 'selected' : ''}>Speaking</option>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label fw-bold">Nội dung văn bản (Text/HTML)</label>
                        <textarea name="content" class="form-control" rows="8">${lesson.content}</textarea>
                        <div class="form-text">Bạn có thể sử dụng HTML cơ bản để định dạng nội dung.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">URL Video (Youtube/Vimeo)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-brands fa-youtube text-danger"></i></span>
                            <input type="url" name="videoUrl" class="form-control" placeholder="https://..." value="${lesson.videoUrl}">
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label fw-bold">URL Tài liệu (PDF/Doc)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-file-pdf text-primary"></i></span>
                            <input type="url" name="documentUrl" class="form-control" placeholder="https://..." value="${lesson.documentUrl}">
                        </div>
                    </div>
                </div>

                <div class="mt-5 text-end">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold" style="background-color: var(--accent-green); border-color: var(--accent-green);">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Bài Học
                    </button>
                </div>
            </form>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
