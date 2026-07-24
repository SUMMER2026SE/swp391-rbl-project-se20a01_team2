<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${exam == null ? 'Tạo đề thi' : 'Chi tiết đề thi'} - IELTSFlow Admin</title>
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

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <a href="${pageContext.request.contextPath}/admin/exams" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
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
            <form action="${pageContext.request.contextPath}/admin/exams" method="POST">
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
                        <select name="type" id="examTypeSelect" class="form-select" required>
                            <option value="Practice" ${exam.type == 'Practice' ? 'selected' : ''}>Practice (Luyện tập)</option>
                            <option value="Mock Test" ${exam.type == 'Mock Test' ? 'selected' : ''}>Mock Test (Thi thử)</option>
                            <option value="Placement Test" ${exam.type == 'Placement Test' ? 'selected' : ''}>Placement Test (Thi xếp lớp)</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">Kỹ năng tập trung <span class="text-danger">*</span></label>
                        <select name="skill" id="examSkillSelect" class="form-select" required>
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

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const typeSelect = document.getElementById('examTypeSelect');
        const skillSelect = document.getElementById('examSkillSelect');
        
        if (typeSelect && skillSelect) {
            function updateSkillOptions() {
                const type = typeSelect.value;
                const options = skillSelect.querySelectorAll('option');
                
                options.forEach(option => {
                    if (type === 'Practice') {
                        if (option.value === 'All') {
                            option.hidden = true;
                            option.disabled = true;
                        } else {
                            option.hidden = false;
                            option.disabled = false;
                        }
                    } else {
                        if (option.value === 'All') {
                            option.hidden = false;
                            option.disabled = false;
                        } else {
                            option.hidden = true;
                            option.disabled = true;
                        }
                    }
                });

                if (skillSelect.options[skillSelect.selectedIndex] && skillSelect.options[skillSelect.selectedIndex].disabled) {
                    if (type === 'Practice') {
                        skillSelect.value = 'Listening';
                    } else {
                        skillSelect.value = 'All';
                    }
                }
            }

            typeSelect.addEventListener('change', updateSkillOptions);
            updateSkillOptions();
        }
    });
</script>
</body>
</html>
