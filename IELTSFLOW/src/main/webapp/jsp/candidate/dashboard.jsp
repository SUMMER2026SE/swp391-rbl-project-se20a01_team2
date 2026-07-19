<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>
    
    <div class="layout-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar" id="appSidebar">
            <button class="toggle-sidebar-btn" onclick="toggleSidebar()">◀</button>
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: inherit;">
                <div class="brand">IELTSFLOW</div>
            </a>
            <div class="user-profile">
                <div class="avatar" style="overflow: hidden;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.profilePic}">
                            <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            ${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Mục tiêu: ${not empty sessionScope.targetBand ? sessionScope.targetBand : 'Chưa thiết lập'}</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link active" title="Bảng điều khiển">🏠 <span class="nav-text">Bảng điều khiển</span></a>
                <!-- <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link" title="Kế hoạch tuần">📅 <span class="nav-text">Kế hoạch tuần</span></a> -->
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link" title="Thư viện">📚 <span class="nav-text">Thư viện</span></a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="nav-link" title="Bài thi">🎯 <span class="nav-text">Bài thi</span></a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link" title="Lịch sử & Làm lại">🔄 <span class="nav-text">Lịch sử & Làm lại</span></a>
                <!-- <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link" title="Thông báo">🔔 <span class="nav-text">Thông báo</span></a> -->
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link" title="Ticket hỗ trợ">🎫 <span class="nav-text">Ticket hỗ trợ</span></a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link" title="Cài đặt tài khoản">⚙️ <span class="nav-text">Cài đặt tài khoản</span></a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);" title="Đăng xuất">🚪 <span class="nav-text">Đăng xuất</span></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content" id="appMainContent">
            <div class="welcome-banner animate-fade-up" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h1 style="font-size: 2.5rem; margin-bottom: 10px;">Chào mừng trở lại! 🚀</h1>
                    <c:choose>
                        <c:when test="${not empty target}">
                            <p style="font-size: 1.1rem; color: black; margin-bottom: 5px;">Mục tiêu IELTS của bạn: <strong style="color: var(--accent-blue);">${target.targetBand}</strong></p>
                            <c:if test="${not empty daysRemaining}">
                                <c:choose>
                                    <c:when test="${daysRemaining > 0}">
                                        <p style="font-size: 1.1rem; color: var(--accent-red); font-weight: 600;">⏰ Chỉ còn ${daysRemaining} ngày nữa là đến kỳ thi!</p>
                                    </c:when>
                                    <c:when test="${daysRemaining == 0}">
                                        <p style="font-size: 1.1rem; color: var(--accent-red); font-weight: 600;">🔥 Hôm nay là ngày thi! Chúc bạn thi tốt!</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="font-size: 1.1rem; color: var(--text-secondary); font-weight: 600;">Kỳ thi đã qua.</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <p style="font-size: 1.1rem; color: black;">Hãy vào Cài đặt tài khoản để thiết lập Mục tiêu và Ngày thi của bạn nhé!</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <c:if test="${not empty target}">
                <div style="display: flex; gap: 20px;">
                    <div style="text-align: center;">
                        <div style="width: 100px; height: 100px; border-radius: 50%; border: 8px solid rgba(59, 130, 246, 0.3); border-top-color: var(--accent-blue); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 800; margin-bottom: 8px;">
                            ${target.currentBand}
                        </div>
                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-secondary);">Hiện tại</span>
                    </div>
                    <div style="text-align: center;">
                        <div style="width: 100px; height: 100px; border-radius: 50%; border: 8px solid rgba(16, 185, 129, 0.3); border-top-color: var(--accent-green); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 800; margin-bottom: 8px;">
                            ${target.targetBand}
                        </div>
                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-secondary);">Mục tiêu</span>
                    </div>
                </div>
                </c:if>
            </div>

            <div class="stats-grid animate-fade-up" style="animation-delay: 0.1s;">
                <%-- 
                <div class="stat-card" style="display: none;">
                    <p>Giờ học (Tuần này)</p>
                    <h3 style="color: var(--accent-blue);">${stats.studyHours}h</h3>
                </div>
                --%>
                <div class="stat-card">
                    <p>Bài học đã hoàn thành</p>
                    <h3 style="color: var(--accent-green);">${stats.lessonsCompleted}</h3>
                </div>
                <div class="stat-card">
                    <p>Điểm Mock Test gần nhất</p>
                    <h3 style="color: var(--accent-purple);">${not empty stats.latestMockTest and stats.latestMockTest > 0 ? stats.latestMockTest : 'N/A'}</h3>
                </div>
            </div>

            <h2 style="margin-bottom: 20px; margin-top: 40px;" class="animate-fade-up">🔥 Trọng tâm hôm nay</h2>
            <div class="lesson-grid" id="today-lessons-grid">
                <!-- Data injected by JS -->
            </div>
        </main>
    </div>

    <!-- AI Chatbox Widget -->
    <jsp:include page="/jsp/components/chat-widget.jsp" />

    <script>
        window.MOCK_LESSONS = ${not empty lessonsJson ? lessonsJson : '[]'};
        window.MOCK_TODAY_LESSONS = window.MOCK_LESSONS.slice(0, 4); // Show top 4 lessons as today's
    </script>
    <script src="${pageContext.request.contextPath}/js/api.js?v=${System.currentTimeMillis()}"></script>
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        if (localStorage.getItem('sidebarCollapsed') === 'true') {
            var sidebar = document.getElementById('appSidebar');
            var main = document.getElementById('appMainContent');
            if (sidebar) sidebar.classList.add('collapsed');
            if (main) main.classList.add('expanded');
        }
    });

    function toggleSidebar() {
        var sidebar = document.getElementById('appSidebar');
        var main = document.getElementById('appMainContent');
        if (sidebar && main) {
            sidebar.classList.toggle('collapsed');
            main.classList.toggle('expanded');
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        }
    }
    </script>
</body>
</html>

