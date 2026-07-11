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
            async function uploadMaterial(inputId, targetId) {
                const input = document.getElementById(inputId);
                const file = input.files[0];
                if (!file) {
                    Swal.fire({ icon: 'warning', title: 'Cảnh báo', text: 'Vui lòng chọn một file trước khi tải lên.' });
                    return;
                }

                const formData = new FormData();
                formData.append('file', file);
                formData.append('type', 'material'); // Using 'material' type

                const btn = input.nextElementSibling;
                const originalHtml = btn.innerHTML;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tải...';
                btn.disabled = true;

                try {
                    const response = await fetch(window.contextPath + '/api/upload', { // Added /api/upload
                        method: 'POST',
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (response.ok) {
                        document.getElementById(targetId).value = result.url;
                        Swal.fire({ icon: 'success', title: 'Thành công!', text: 'Tải lên thành công!', timer: 2000, showConfirmButton: false });
                    } else {
                        Swal.fire({ icon: 'error', title: 'Lỗi', text: result.error || 'Không xác định' });
                    }
                } catch (error) {
                    Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: error.message });
                } finally {
                    btn.innerHTML = originalHtml;
                    btn.disabled = false;
                }
            }
            
            function toggleResourceFields() {
                const isPassage = document.getElementById('checkPassage').checked;
                const isAudio = document.getElementById('checkAudio').checked;
                const isImage = document.getElementById('checkImage').checked;

                document.getElementById('passageFields').style.display = isPassage ? 'block' : 'none';
                document.getElementById('audioFields').style.display = isAudio ? 'block' : 'none';
                document.getElementById('imageFields').style.display = isImage ? 'block' : 'none';

                let primaryType = "";
                if (isPassage) primaryType = "Passage";
                else if (isAudio) primaryType = "Audio";
                else if (isImage) primaryType = "Image";

                document.getElementById('hiddenType').value = primaryType;
            }

            document.addEventListener('DOMContentLoaded', function() {
                toggleResourceFields();
            });
        </script>

        <div class="glass-panel animate-fade-up shadow-sm p-4" style="animation-delay: 0.1s; border-radius: 12px; background: rgba(255,255,255,0.85);">
            <form action="${pageContext.request.contextPath}/mentor/resources" method="POST" id="resourceForm">
                <input type="hidden" name="action" value="${resource != null ? 'update' : 'create'}">
                <c:if test="${resource != null}">
                    <input type="hidden" name="resourceId" value="${resource.resourceId}">
                </c:if>
                <input type="hidden" name="type" id="hiddenType" value="${resource != null ? resource.type : 'Passage'}">

                <div class="row g-4">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">Tên Tài Nguyên (Tùy chọn)</label>
                        <input type="text" name="resourceName" class="form-control" placeholder="Nhập tên gợi nhớ (VD: Cam 18 Test 1 Passage 1)" value="${resource.resourceName}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold d-block">Loại Tài Liệu <span class="text-danger">*</span></label>
                        <div class="d-flex flex-wrap gap-3 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="Passage" id="checkPassage" onchange="toggleResourceFields()" ${resource == null || not empty resource.resourceText || resource.type == 'Passage' ? 'checked' : ''}>
                                <label class="form-check-label fw-medium" for="checkPassage" style="color: #10b981;"><i class="fa-solid fa-book-open"></i> Bài đọc</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="Audio" id="checkAudio" onchange="toggleResourceFields()" ${not empty resource.resourceAudioUrl || resource.type == 'Audio' ? 'checked' : ''}>
                                <label class="form-check-label fw-medium" for="checkAudio" style="color: #f59e0b;"><i class="fa-solid fa-headphones"></i> Bài nghe</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="Image" id="checkImage" onchange="toggleResourceFields()" ${not empty resource.resourceImageUrl || resource.type == 'Image' ? 'checked' : ''}>
                                <label class="form-check-label fw-medium" for="checkImage" style="color: #3b82f6;"><i class="fa-solid fa-image"></i> Hình ảnh</label>
                            </div>
                        </div>
                    </div>
                </div>

                <hr class="my-4" style="border-color: var(--border-color);">
                <p class="text-muted mb-4"><i class="fa-solid fa-circle-info me-2"></i>Chọn các loại tài liệu ở trên để hiển thị khung nhập tương ứng.</p>

                <div id="passageFields" class="mb-4" style="display: none;">
                    <h5 class="fw-bold mb-3" style="color: #10b981;"><i class="fa-solid fa-book-open me-2"></i>Nội dung Đoạn văn</h5>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nội dung bài đọc (Rich Text)</label>
                        <textarea id="summernote" name="resourceText" class="form-control">${resource.resourceText}</textarea>
                    </div>
                </div>

                <div id="audioFields" class="mb-4" style="display: none;">
                    <h5 class="fw-bold mb-3" style="color: #f59e0b;"><i class="fa-solid fa-headphones me-2"></i>Tệp Âm Thanh</h5>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tải lên tệp nghe (MP3/WAV)</label>
                        <div class="input-group">
                            <input type="file" id="audioUpload" class="form-control" accept=".mp3,.wav,.ogg">
                            <button type="button" class="btn btn-outline-primary fw-bold" onclick="uploadMaterial('audioUpload', 'resourceAudioUrl')">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Tải lên
                            </button>
                        </div>
                        <input type="text" name="resourceAudioUrl" id="resourceAudioUrl" class="form-control mt-2 bg-light" placeholder="URL Audio sau khi tải lên sẽ hiển thị ở đây..." value="${resource.resourceAudioUrl}">
                    </div>
                </div>

                <div id="imageFields" class="mb-4" style="display: none;">
                    <h5 class="fw-bold mb-3" style="color: #3b82f6;"><i class="fa-solid fa-image me-2"></i>Tệp Hình Ảnh</h5>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tải lên hình ảnh (JPG/PNG/GIF)</label>
                        <div class="input-group">
                            <input type="file" id="imageUpload" class="form-control" accept=".jpg,.jpeg,.png,.gif,.webp,.avif">
                            <button type="button" class="btn btn-outline-primary fw-bold" onclick="uploadMaterial('imageUpload', 'resourceImageUrl')">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Tải lên
                            </button>
                        </div>
                        <input type="text" name="resourceImageUrl" id="resourceImageUrl" class="form-control mt-2 bg-light" placeholder="URL Hình ảnh sau khi tải lên sẽ hiển thị ở đây..." value="${resource.resourceImageUrl}">
                    </div>
                </div>

                <div class="mt-4 text-end d-flex justify-content-end gap-2 sticky-bottom" style="position: sticky; bottom: 15px; z-index: 99;">
                    <button type="submit" class="btn btn-primary rounded-pill px-5 py-2 shadow fw-bold" style="background-color: var(--accent-purple); border-color: var(--accent-purple);" onclick="return validateCheckboxes()">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Lưu Tài Nguyên
                    </button>
                </div>
            </form>
        </div>

        <script>
            function validateCheckboxes() {
                const isPassage = document.getElementById('checkPassage').checked;
                const isAudio = document.getElementById('checkAudio').checked;
                const isImage = document.getElementById('checkImage').checked;
                
                if (!isPassage && !isAudio && !isImage) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thiếu Loại Tài Liệu',
                        text: 'Vui lòng chọn ít nhất một loại tài liệu (Bài đọc, Bài nghe, hoặc Hình ảnh)!'
                    });
                    return false;
                }
                return true;
            }
        </script>

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
