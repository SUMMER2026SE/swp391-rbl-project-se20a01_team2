<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson Library</title>
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
    <div class="bg-blob blob-3"></div>
    <div class="bg-blob blob-1"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">HV</div>
                <div>
                    <h4 style="font-size: 1rem;">Học Viên 1</h4>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="dashboard.jsp" class="nav-link">🏠 Dashboard</a>
                <a href="weekly-plan.jsp" class="nav-link">📅 Weekly Plan</a>
                <a href="lessons.jsp" class="nav-link active">📚 Library</a>
                <a href="redo-exercises.jsp" class="nav-link">🔄 History & Redo</a>
            </nav>
        </aside>

        <main class="main-content">
            <h1 class="animate-fade-up" style="margin-bottom: 10px;">Study Library</h1>
            <p class="animate-fade-up" style="color: var(--text-secondary); margin-bottom: 30px;">Discover video lectures and comprehensive PDF guides provided by Mentors.</p>

            <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                <input type="text" id="search-input" placeholder="Search for Map, Task 1, Vocabulary...">
                <select id="skill-filter">
                    <option value="All Skills" style="color: black;">All Skills</option>
                    <option value="Listening" style="color: black;">Listening</option>
                    <option value="Reading" style="color: black;">Reading</option>
                    <option value="Writing" style="color: black;">Writing</option>
                    <option value="Speaking" style="color: black;">Speaking</option>
                    <option value="Vocabulary" style="color: black;">Vocabulary</option>
                </select>
                <button class="btn btn-primary" style="border-radius: 25px;" onclick="searchLessons()">Search</button>
            </div>

            <div class="lesson-grid" id="library-grid">
                <!-- Data injected by JS -->
            </div>
        </main>
    </div>

    <script src="../../js/api.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
