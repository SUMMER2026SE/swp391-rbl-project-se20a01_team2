<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${resource == null ? 'Thêm' : 'Chỉnh sửa'} Tài nguyên - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <!-- Summernote Editor -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-purple); opacity: 0.1;"></div>
    <div class="bg-blob blob-2" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="resources" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <a href="${pageContext.request.contextPath}/mentor/resources" class="btn btn-sm btn-outline-secondary rounded-pill mb-3">
                <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách
            </a>
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">${resource == null ? 'Thêm Tài Nguyên Mới 📝' : 'Chỉnh Sửa Tài Nguyên ✍️'}</h1>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <script>
            async function uploadAudio(inputId, targetId) {
                const input = document.getElementById(inputId);
                const file = input.files[0];
                if (!file) {
                    alert('Vui lòng chọn một file trước khi tải lên.');
                    return;
                }

                const formData = new FormData();
                formData.append('file', file);
                formData.append('type', 'audio');

                const btn = input.nextElementSibling;
                const originalHtml = btn.innerHTML;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tải...';
                btn.disabled = true;

                try {
                    const response = await fetch(window.contextPath + '/upload', {
                        method: 'POST',
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (response.ok) {
                        document.getElementById(targetId).value = result.url;
                        alert('Tải lên thành công!');
                    } else {
                        alert('Lỗi: ' + (result.error || 'Không xác định'));
                    }
                } catch (error) {
                    alert('Lỗi mạng khi tải lên: ' + error.message);
                } finally {
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                }
            }
            
            function toggleResourceFields() {
                const type = document.getElementById('resourceType').value;
                if (type === 'Passage') {
                    document.getElementById('passageFields').style.display = 'block';
                    document.getElementById('audioFields').style.display = 'none';
                } else {
                    document.getElementById('passageFields').style.display = 'none';
                    document.getElementById('audioFields').style.display = 'block';
                }
            }
        </script>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 30px;">
            <form action="${pageContext.request.contextPath}/mentor/resources" method="POST">
                <input type="hidden" name="action" value="${resource == null ? 'create' : 'update'}">
                <c:if test="${resource != null}">
                    <input type="hidden" name="resourceId" value="${resource.resourceId}">
                </c:if>
                
                <h5 class="fw-bold mb-4" style="color: var(--accent-purple);">Thông tin chung</h5>
                
                <div class="row g-4">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">Tên Tài Nguyên (Tùy chọn)</label>
                        <input type="text" name="resourceName" class="form-control" placeholder="Nhập tên gợi nhớ (VD: Cam 18 Test 1 Passage 1)" value="${resource.resourceName}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Loại Tài Nguyên <span class="text-danger">*</span></label>
                        <select name="type" id="resourceType" class="form-select" required onchange="toggleResourceFields()">
                            <option value="Passage" ${resource.type == 'Passage' ? 'selected' : ''}>Đoạn văn (Reading Passage)</option>
                            <option value="Audio" ${resource.type == 'Audio' ? 'selected' : ''}>Tệp âm thanh (Listening Audio)</option>
                        </select>
                    </div>
                </div>

                <hr class="my-4" style="border-color: var(--border-color);">

                <div id="passageFields" style="display: ${resource == null || resource.type == 'Passage' ? 'block' : 'none'};">
                    <h5 class="fw-bold mb-3" style="color: #10b981;"><i class="fa-solid fa-book-open me-2"></i>Nội dung Đoạn văn</h5>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nội dung bài đọc (Rich Text)</label>
                        <textarea id="summernote" name="resourceText" class="form-control">${resource.resourceText}</textarea>
                    </div>
                </div>

                <div id="audioFields" style="display: ${resource != null && resource.type == 'Audio' ? 'block' : 'none'};">
                    <h5 class="fw-bold mb-3" style="color: #f59e0b;"><i class="fa-solid fa-headphones me-2"></i>Tệp Âm Thanh</h5>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tải lên tệp nghe (MP3/WAV)</label>
                        <div class="input-group">
                            <input type="file" id="audioUpload" class="form-control" accept=".mp3,.wav,.ogg">
                            <button type="button" class="btn btn-outline-primary fw-bold" onclick="uploadAudio('audioUpload', 'resourceAudioUrl')">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Tải lên
                            </button>
                        </div>
                        <input type="text" name="resourceAudioUrl" id="resourceAudioUrl" class="form-control mt-2 bg-light" placeholder="URL Audio sau khi tải lên sẽ hiển thị ở đây..." value="${resource.resourceAudioUrl}">
                    </div>
                </div>

                <div class="mt-4 text-end d-flex justify-content-end gap-2 sticky-bottom" style="position: sticky; bottom: 15px; z-index: 99;">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Tài Nguyên
                    </button>
                </div>
            </form>
        </div>

    </main>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script>
    $(document).ready(function() {
        $('#summernote').summernote({
            placeholder: 'Nhập hoặc dán nội dung đoạn văn Reading IELTS tại đây...',
            tabsize: 2,
            height: 400,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'italic', 'clear']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture']],
                ['view', ['fullscreen', 'codeview', 'help']]
            ],
            callbacks: {
                onImageUpload: function(files) {
                    for(let i=0; i < files.length; i++) {
                        let data = new FormData();
                        data.append("file", files[i]);
                        data.append("type", "image");
                        $.ajax({
                            data: data,
                            type: "POST",
                            url: window.contextPath + '/upload',
                            cache: false,
                            contentType: false,
                            processData: false,
                            success: function(response) {
                                $('#summernote').summernote('insertImage', response.url);
                            },
                            error: function(jqXHR, textStatus, errorThrown) {
                                alert('Lỗi tải ảnh: ' + textStatus + " " + errorThrown);
                            }
                        });
                    }
                }
            }
        });
    });
</script>
</body>
</html>
