<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar" id="appSidebar">
            <button class="toggle-sidebar-btn" onclick="toggleSidebar()">◀</button>
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: inherit;">
                <div class="brand">IELTSFLOW</div>
            </a>
            <div class="user-profile">
                <div class="avatar" style="overflow: hidden;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.profilePic}">
                            <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" alt="Profile"
                                style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            ${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}
                    </h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Mục tiêu: ${not empty
                        sessionScope.targetBand ? sessionScope.targetBand : 'Chưa thiết lập'}</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard"
                    class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}" title="Bảng điều khiển">🏠 <span
                        class="nav-text">Bảng điều khiển</span></a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan"
                    class="nav-link ${param.activePage == 'weekly-plan' ? 'active' : ''}" title="Kế hoạch tuần">📅 <span
                        class="nav-text">Kế hoạch tuần</span></a>
                <a href="${pageContext.request.contextPath}/candidate/lessons"
                    class="nav-link ${param.activePage == 'lessons' ? 'active' : ''}" title="Thư viện">📚 <span
                        class="nav-text">Thư viện</span></a>
                <a href="${pageContext.request.contextPath}/candidate/tests"
                    class="nav-link ${param.activePage == 'tests' ? 'active' : ''}" title="Bài thi">🎯 <span
                        class="nav-text">Bài thi</span></a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises"
                    class="nav-link ${param.activePage == 'redo-exercises' ? 'active' : ''}"
                    title="Lịch sử & Làm lại">🔄 <span class="nav-text">Lịch sử & Làm lại</span></a>
                <a href="${pageContext.request.contextPath}/candidate/notifications"
                    class="nav-link ${param.activePage == 'notifications' ? 'active' : ''}" title="Thông báo" style="position: relative;">
                    🔔 <span class="nav-text">Thông báo</span>
                    <span id="notif-badge" style="display: none; position: absolute; top: 10px; right: 10px; background: var(--accent-red); color: white; border-radius: 50%; font-size: 10px; padding: 2px 6px; font-weight: bold;">0</span>
                </a>
                <a href="${pageContext.request.contextPath}/candidate/tickets"
                    class="nav-link ${param.activePage == 'tickets' ? 'active' : ''}" title="Ticket hỗ trợ">🎫 <span
                        class="nav-text">Ticket hỗ trợ</span></a>
                <a href="${pageContext.request.contextPath}/account"
                    class="nav-link ${param.activePage == 'account' ? 'active' : ''}" title="Cài đặt tài khoản">⚙️ <span
                        class="nav-text">Cài đặt tài khoản</span></a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);"
                    title="Đăng xuất">🚪 <span class="nav-text">Đăng xuất</span></a>
            </div>
        </aside>

        <script>
            function toggleSidebar() {
                var sidebar = document.getElementById('appSidebar');
                var mainContent = document.querySelector('.main-content');
                if (sidebar) sidebar.classList.toggle('collapsed');
                if (mainContent) mainContent.classList.toggle('expanded');
            }

            // Fetch unread notification count
            function fetchUnreadNotifications() {
                fetch('${pageContext.request.contextPath}/api/notifications/unread')
                    .then(response => {
                        if (response.ok) return response.json();
                        throw new Error('Network response was not ok.');
                    })
                    .then(data => {
                        if (data.success) {
                            const badge = document.getElementById('notif-badge');
                            if (data.unreadCount > 0) {
                                badge.textContent = data.unreadCount > 99 ? '99+' : data.unreadCount;
                                badge.style.display = 'inline-block';
                            } else {
                                badge.style.display = 'none';
                            }
                        }
                    })
                    .catch(error => console.error('Error fetching unread notifications:', error));
            }

            // Call immediately and set interval for every 2 minutes
            document.addEventListener('DOMContentLoaded', function() {
                fetchUnreadNotifications();
                setInterval(fetchUnreadNotifications, 120000);
            });
        </script>