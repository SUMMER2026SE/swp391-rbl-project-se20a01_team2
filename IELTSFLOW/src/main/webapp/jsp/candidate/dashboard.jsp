<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Candidate Dashboard</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>
    
    <div class="layout-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">HV</div>
                <div>
                    <h4 style="font-size: 1rem;">Học Viên 1</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Target: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="dashboard.jsp" class="nav-link active">🏠 Dashboard</a>
                <a href="weekly-plan.jsp" class="nav-link">📅 Weekly Plan</a>
                <a href="lessons.jsp" class="nav-link">📚 Library</a>
                <a href="redo-exercises.jsp" class="nav-link">🔄 History & Redo</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="#" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
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

    <script src="../../js/api.js?v=${System.currentTimeMillis()}"></script>
</body>
</html>
