<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<aside class="sidebar">
    <a href="${pageContext.request.contextPath}/" style="text-decoration: none;">
        <div class="brand"
            style="background: linear-gradient(135deg, #3b82f6, #8b5cf6); -webkit-background-clip: text;">
            IELTSFLOW Admin</div>
    </a>
    <div class="user-profile">
        <div class="avatar" style="overflow: hidden; background: linear-gradient(135deg, #3b82f6, #8b5cf6); color: white;">
            <c:choose>
                <c:when test="${not empty sessionScope.profilePic}">
                    <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    ${sessionScope.user != null ? sessionScope.user.fullName.substring(0,1) : 'A'}
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <h4 style="font-size: 1rem;">${sessionScope.user != null ? sessionScope.user.fullName : 'Quản trị viên'}</h4>
            <span style="font-size: 0.75rem; color: var(--text-secondary);">Quản trị viên</span>
        </div>
    </div>

    <nav class="nav-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">📊 Tổng quan</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link ${param.active == 'users' ? 'active' : ''}">👥 Quản lý người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/packages" class="nav-link ${param.active == 'packages' ? 'active' : ''}">📦 Gói thành viên</a>
        <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-link ${param.active == 'transactions' ? 'active' : ''}">💳 Giao dịch</a>
        <a href="${pageContext.request.contextPath}/admin/logs" class="nav-link ${param.active == 'logs' ? 'active' : ''}">⚙️ Nhật ký hệ thống</a>
    </nav>

    <div style="margin-top: auto; display: flex; flex-direction: column; gap: 10px;">
        <a href="${pageContext.request.contextPath}/account" class="nav-link"
            style="color: var(--text-secondary);">👤 Cài đặt hồ sơ</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link"
            style="color: var(--accent-red);">🚪 Đăng xuất</a>
    </div>
</aside>
