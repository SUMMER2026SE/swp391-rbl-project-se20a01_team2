<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<aside class="sidebar">
    <div class="brand"
        style="background: linear-gradient(135deg, #3b82f6, #8b5cf6); -webkit-background-clip: text;">
        IELTSFLOW Admin</div>
    <div class="user-profile">
        <div class="avatar" style="background: linear-gradient(135deg, #3b82f6, #8b5cf6); color: white;">
            ${sessionScope.user != null ? sessionScope.user.fullName.substring(0,1) : 'A'}
        </div>
        <div>
            <h4 style="font-size: 1rem;">${sessionScope.user != null ? sessionScope.user.fullName : 'Administrator'}</h4>
            <span style="font-size: 0.75rem; color: var(--text-secondary);">Admin</span>
        </div>
    </div>

    <nav class="nav-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">📊 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link ${param.active == 'users' ? 'active' : ''}">👥 User Management</a>
        <a href="${pageContext.request.contextPath}/admin/users/mentors" class="nav-link ${param.active == 'mentors' ? 'active' : ''}">🛡️ Mentor Roles</a>
        <a href="${pageContext.request.contextPath}/admin/packages" class="nav-link ${param.active == 'packages' ? 'active' : ''}">📦 Membership Packages</a>
        <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-link ${param.active == 'transactions' ? 'active' : ''}">💳 Transactions</a>
        <a href="${pageContext.request.contextPath}/admin/logs" class="nav-link ${param.active == 'logs' ? 'active' : ''}">⚙️ System Logs</a>
    </nav>

    <div style="margin-top: auto; display: flex; flex-direction: column; gap: 10px;">
        <a href="${pageContext.request.contextPath}/profile" class="nav-link"
            style="color: var(--text-secondary);">👤 Account Management</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link"
            style="color: var(--accent-red);">🚪 Logout</a>
    </div>
</aside>
