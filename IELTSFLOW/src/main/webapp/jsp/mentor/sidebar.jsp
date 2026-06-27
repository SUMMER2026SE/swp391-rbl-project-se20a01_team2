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
        <a href="${pageContext.request.contextPath}/mentor/resources"
           class="nav-link ${param.active == 'resources' ? 'active' : ''}">📚 Quản lý Tài nguyên</a>
    </nav>

    <div style="margin-top: auto; display: flex; flex-direction: column; gap: 10px;">
        <a href="${pageContext.request.contextPath}/account" class="nav-link"
           style="color: var(--text-secondary);">👤 Cài đặt hồ sơ</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link"
           style="color: var(--accent-red);">🚪 Đăng xuất</a>
    </div>
</aside>
