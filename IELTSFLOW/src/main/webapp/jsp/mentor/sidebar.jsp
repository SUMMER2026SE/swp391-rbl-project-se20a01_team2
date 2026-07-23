<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<aside class="sidebar">
    <a href="${pageContext.request.contextPath}/" style="text-decoration: none;">
        <div class="brand"
            style="background: linear-gradient(135deg, #10b981, #3b82f6); -webkit-background-clip: text;">
            IELTSFLOW Mentor
        </div>
    </a>

    <div class="user-profile">
        <div class="avatar" style="overflow: hidden; background: linear-gradient(135deg, #10b981, #3b82f6); color: white;">
            <c:choose>
                <c:when test="${not empty sessionScope.profilePic}">
                    <img src="${pageContext.request.contextPath}${sessionScope.profilePic}"
                         alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    ${not empty sessionScope.fullName ? sessionScope.fullName.substring(0,1) : 'M'}
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Mentor'}</h4>
            <span style="font-size: 0.75rem; color: var(--text-secondary);">Giảng viên / Mentor</span>
        </div>
    </div>

    <nav class="nav-menu">
        <a href="${pageContext.request.contextPath}/mentor/dashboard"
           class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">📊 Tổng quan</a>
        <a href="${pageContext.request.contextPath}/mentor/questions"
           class="nav-link ${param.active == 'questions' ? 'active' : ''}">❓ Ngân hàng câu hỏi</a>
        <a href="${pageContext.request.contextPath}/mentor/resources"
           class="nav-link ${param.active == 'resources' ? 'active' : ''}">📚 Quản lý Tài nguyên đề thi</a>
        <a href="${pageContext.request.contextPath}/mentor/lessons"
           class="nav-link ${param.active == 'lessons' ? 'active' : ''}">📚 Bài học</a>
        <a href="${pageContext.request.contextPath}/mentor/exams"
           class="nav-link ${param.active == 'exams' ? 'active' : ''}">📝 Đề thi</a>
        <a href="${pageContext.request.contextPath}/mentor/tickets"
           class="nav-link ${param.active == 'tickets' ? 'active' : ''}">🎫 Hỗ trợ học viên</a>
        <a href="${pageContext.request.contextPath}/mentor/students"
           class="nav-link ${param.active == 'students' ? 'active' : ''}">🎓 Tiến độ học viên</a>
        <a href="${pageContext.request.contextPath}/mentor/tags"
           class="nav-link ${param.active == 'tags' ? 'active' : ''}">🏷️ Quản lý Tag</a>
    </nav>

    <div style="margin-top: auto; display: flex; flex-direction: column; gap: 10px;">
        <a href="${pageContext.request.contextPath}/account" class="nav-link"
           style="color: var(--text-secondary);">👤 Cài đặt hồ sơ</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link"
           style="color: var(--accent-red);">🚪 Đăng xuất</a>
    </div>
</aside>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function customConfirm(event, element, message) {
        event.preventDefault(); // Prevent default action (form submission or link navigation)
        Swal.fire({
            title: 'Xác nhận',
            text: message,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đồng ý',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                // If the element is a form, submit it
                if (element.tagName && element.tagName.toLowerCase() === 'form') {
                    // Temporarily remove onsubmit to prevent infinite loop
                    const oldOnSubmit = element.onsubmit;
                    element.onsubmit = null;
                    element.submit();
                    element.onsubmit = oldOnSubmit;
                } 
                // If it's a button inside a form with onclick="return customConfirm(...)"
                else if (element.form) {
                    const form = element.form;
                    // Append hidden input if it's a specific submit button with name/value
                    if (element.name) {
                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = element.name;
                        input.value = element.value;
                        form.appendChild(input);
                    }
                    const oldOnSubmit = form.onsubmit;
                    form.onsubmit = null;
                    form.submit();
                    form.onsubmit = oldOnSubmit;
                }
                // If it's an anchor tag
                else if (element.tagName && element.tagName.toLowerCase() === 'a') {
                    window.location.href = element.href;
                }
            }
        });
        return false;
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Floating back button logic
        let floatingBtn = null;
        window.addEventListener('scroll', function() {
            const btn = document.getElementById('backBtn');
            if (!btn) return;
            if (window.scrollY > 150) {
                if (!floatingBtn) {
                    floatingBtn = document.createElement('a');
                    floatingBtn.href = btn.href;
                    floatingBtn.className = 'floating-back-btn';
                    floatingBtn.innerHTML = '<i class="fa-solid fa-arrow-left"></i>';
                    document.body.appendChild(floatingBtn);
                }
            } else {
                if (floatingBtn) {
                    floatingBtn.remove();
                    floatingBtn = null;
                }
            }
        });

        // Globally prevent Enter key from submitting the form if the target is a text input
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                const target = e.target;
                if (target.tagName === 'INPUT' && (target.type === 'text' || target.type === 'number' || target.type === 'checkbox')) {
                    e.preventDefault();
                }
            }
        });
    });
</script>

