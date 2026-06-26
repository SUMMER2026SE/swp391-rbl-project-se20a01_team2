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
                    ${not empty sessionScope.fullName ? sessionScope.fullName.substring(0,1) : 'A'}
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Quản trị viên'}</h4>
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

<script>
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.querySelector('.sidebar');
    const layoutWrapper = document.querySelector('.layout-wrapper');
    if (!sidebar || !layoutWrapper || document.querySelector('.mobile-topbar')) return;

    // 1. Create Mobile Topbar
    const topbar = document.createElement('div');
    topbar.className = 'mobile-topbar hidden-desktop';
    
    // Hamburger Button
    const hamburgerBtn = document.createElement('button');
    hamburgerBtn.className = 'mobile-menu-btn';
    hamburgerBtn.innerHTML = '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12h18M3 6h18M3 18h18"/></svg>';
    
    // Brand Text
    const brandContainer = document.createElement('div');
    brandContainer.className = 'mobile-brand';
    brandContainer.innerHTML = '<strong>ADMIN</strong>';
    
    topbar.appendChild(hamburgerBtn);
    topbar.appendChild(brandContainer);
    
    // 2. Create Overlay
    const overlay = document.createElement('div');
    overlay.className = 'sidebar-overlay';
    
    // 3. Inject into DOM
    layoutWrapper.insertBefore(topbar, layoutWrapper.firstChild);
    document.body.appendChild(overlay);
    
    // 4. Interaction Logic
    function toggleMenu() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        document.body.style.overflow = sidebar.classList.contains('active') ? 'hidden' : '';
    }
    
    hamburgerBtn.addEventListener('click', toggleMenu);
    overlay.addEventListener('click', toggleMenu);

    // 5. Auto-wrap tables for responsiveness
    document.querySelectorAll('table').forEach(table => {
        if (!table.parentElement.classList.contains('table-responsive')) {
            const wrapper = document.createElement('div');
            wrapper.className = 'table-responsive';
            table.parentNode.insertBefore(wrapper, table);
            wrapper.appendChild(table);
        }
    });
});
</script>
