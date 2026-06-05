<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Exam History</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-3"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">HV</div>
                <div><h4 style="font-size: 1rem;">Học Viên 1</h4></div>
            </div>
            <nav class="nav-menu">
                <a href="dashboard.jsp" class="nav-link">🏠 Dashboard</a>
                <a href="weekly-plan.jsp" class="nav-link">📅 Weekly Plan</a>
                <a href="lessons.jsp" class="nav-link">📚 Library</a>
                <a href="redo-exercises.jsp" class="nav-link active">🔄 History & Redo</a>
            </nav>
        </aside>

        <main class="main-content">
            <div class="animate-fade-up">
                <h1 style="margin-bottom: 10px;">Exam History</h1>
                <p style="color: var(--text-secondary); margin-bottom: 40px;">Review your past performances and retake exams to track your improvement over time.</p>
            </div>

            <div id="history-list">
                <!-- Data injected by JS -->
            </div>
        </main>
    </div>

    <script src="../../js/api.js"></script>
</body>
</html>
