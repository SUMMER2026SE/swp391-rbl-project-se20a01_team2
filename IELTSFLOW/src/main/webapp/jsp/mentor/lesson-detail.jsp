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

        <script src="${pageContext.request.contextPath}/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/js/chunked-upload.js"></script>
        <script>
            if (window.history.replaceState) {
                const url = new URL(window.location.href);
                if (url.searchParams.has('success') || url.searchParams.has('error')) {
                    url.searchParams.delete('success');
                    url.searchParams.delete('error');
                    window.history.replaceState(null, '', url.toString() || window.location.pathname);
                }
            }

            async function uploadMaterial(inputId, targetId) {
                const fileInput = document.getElementById(inputId);
                if (!fileInput.files || fileInput.files.length === 0) {
                    showToast('Vui lòng chọn file trước khi tải lên.', 'error');
                    return;
                }
                
                const btn = fileInput.nextElementSibling;
                const originalHtml = btn.innerHTML;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tải...';
                btn.disabled = true;

                const file = fileInput.files[0];

                try {
                    let data;
                    if (file.size > 10 * 1024 * 1024) {
                        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> 0%';
                        data = await uploadFileChunked(file, 'material', (progress, statusText) => {
                            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> ' + (statusText || progress + '%');
                        });
                    } else {
                        const formData = new FormData();
                        formData.append('type', 'material');
                        formData.append('file', file);
                        const response = await fetch(window.contextPath + '/api/upload', {
                            method: 'POST',
                            body: formData
                        });
                        data = await response.json();
                        if (!response.ok) {
                            throw new Error(data.error || 'Lỗi không xác định');
                        }
                    }
                    
                    document.getElementById(targetId).value = data.url;
                    showToast('Tải lên thành công!', 'success');
                } catch (error) {
                    showToast('Lỗi: ' + error.message, 'error');
                } finally {
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                }
            }
        </script>

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
                        <label class="form-label fw-bold">Video Bài Giảng (MP4/WebM)</label>
                        <div class="input-group">
                            <input type="file" id="videoUpload" class="form-control" accept=".mp4,.mov,.webm">
                            <button type="button" class="btn btn-outline-primary fw-bold" onclick="uploadMaterial('videoUpload', 'videoUrl')">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Tải lên
                            </button>
                        </div>
                        <input type="text" name="videoUrl" id="videoUrl" class="form-control mt-2 bg-light" readonly placeholder="URL Video sau khi tải lên sẽ hiển thị ở đây..." value="${lesson.videoUrl}">
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Tài Liệu Đính Kèm (PDF/Docx/Zip)</label>
                        <div class="input-group">
                            <input type="file" id="documentUpload" class="form-control" accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip,.rar">
                            <button type="button" class="btn btn-outline-primary fw-bold" onclick="uploadMaterial('documentUpload', 'documentUrl')">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Tải lên
                            </button>
                        </div>
                        <input type="text" name="documentUrl" id="documentUrl" class="form-control mt-2 bg-light" readonly placeholder="URL Tài liệu sau khi tải lên sẽ hiển thị ở đây..." value="${lesson.documentUrl}">
                    </div>
                </div>

                <div class="mt-4 text-end d-flex justify-content-end gap-2 sticky-bottom" style="position: sticky; bottom: 15px; z-index: 99;">
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
