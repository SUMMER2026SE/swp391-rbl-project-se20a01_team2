<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lesson Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-blob blob-3"></div>
    <div class="bg-blob blob-1"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar" id="appSidebar">
            <button class="toggle-sidebar-btn" onclick="toggleSidebar()">◀</button>
            <div class="brand">IELTSFLOW</div>
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
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link" title="Bảng điều khiển">🏠 <span class="nav-text">Bảng điều khiển</span></a>
                <!-- <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link" title="Kế hoạch tuần">📅 <span class="nav-text">Kế hoạch tuần</span></a> -->
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link active" title="Thư viện">📚 <span class="nav-text">Thư viện</span></a>
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

        <main class="main-content" id="appMainContent">
            <h1 class="animate-fade-up" style="margin-bottom: 10px;">Thư viện học tập</h1>
            <p class="animate-fade-up" style="color: var(--text-secondary); margin-bottom: 30px;">Khám phá các bài giảng video và tài liệu PDF chi tiết từ các Mentor.</p>

            <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                <input type="text" id="search-input" placeholder="Tìm kiếm Map, Task 1, Từ vựng..." oninput="searchLessons()">
                <select id="skill-filter" onchange="searchLessons()">
                    <option value="All Skills" style="color: black;">All Skills</option>
                    <option value="Listening" style="color: black;">Listening</option>
                    <option value="Reading" style="color: black;">Reading</option>
                    <option value="Writing" style="color: black;">Writing</option>
                    <option value="Speaking" style="color: black;">Speaking</option>
                    <option value="Vocabulary" style="color: black;">Vocabulary</option>
                </select>
                <select id="type-filter" onchange="searchLessons()">
                    <option value="All Types" style="color: black;">All Types</option>
                    <option value="Bookmark" style="color: black;">Bookmark</option>
                    <option value="Learned" style="color: black;">Learned</option>
                    <option value="Unlearned" style="color: black;">Unlearned</option>
                </select>
                <button class="btn btn-primary" style="border-radius: 25px;" onclick="searchLessons()">Tìm kiếm</button>
            </div>

            <div class="lesson-grid" id="library-grid">
                <!-- Data injected by JS -->
            </div>
        </main>
    </div>

    <script>
        window.MOCK_LESSONS = ${not empty lessonsJson ? lessonsJson : '[]'};
    </script>
    <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
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

