<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Candidate Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>
    
    <div class="layout-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}</div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Target: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link active">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Weekly Plan</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Library</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 History & Redo</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="welcome-banner animate-fade-up">
                <div>
                    <h1 style="font-size: 2.5rem; margin-bottom: 10px;">Welcome back! 🚀</h1>
                    <p style="font-size: 1.1rem; color: black;">Keep up the great work. You're 20% closer to your Target Band 7.0.</p>
                </div>
                <div style="width: 120px; height: 120px; border-radius: 50%; border: 8px solid rgba(59, 130, 246, 0.3); border-top-color: var(--accent-blue); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 800;">
                    6.0
                </div>
            </div>

            <div class="stats-grid animate-fade-up" style="animation-delay: 0.1s;">
                <div class="stat-card">
                    <p>Study Hours (This Week)</p>
                    <h3 style="color: var(--accent-blue);">12.5h</h3>
                </div>
                <div class="stat-card">
                    <p>Lessons Completed</p>
                    <h3 style="color: var(--accent-green);">24</h3>
                </div>
                <div class="stat-card">
                    <p>Latest Mock Test</p>
                    <h3 style="color: var(--accent-purple);">6.5</h3>
                </div>
            </div>

            <h2 style="margin-bottom: 20px; margin-top: 40px;" class="animate-fade-up">🔥 Today's Focus</h2>
            <div class="lesson-grid" id="today-lessons-grid">
                <!-- Data injected by JS -->
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/api.js?v=${System.currentTimeMillis()}"></script>
</body>
</html>
