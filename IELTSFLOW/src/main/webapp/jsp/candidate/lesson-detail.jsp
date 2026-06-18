<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson Detail</title>
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 */
            height: 0;
            overflow: hidden;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.5);
            border: 1px solid var(--glass-border);
        }
        .video-container iframe {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
        }
        .actions-bar {
            display: flex; gap: 15px; margin-top: 30px; padding-top: 20px;
            border-top: 1px solid var(--glass-border);
        }
    </style>
</head>
<body>
    <div class="bg-blob blob-2"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar">
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
                </div>
            </div>
            <nav class="nav-menu">
                <a href="dashboard.jsp" class="nav-link">🏠 Bảng điều khiển</a>
                <a href="weekly-plan.jsp" class="nav-link">📅 Kế hoạch tuần</a>
                <a href="lessons.jsp" class="nav-link active">📚 Thư viện</a>
                <a href="redo-exercises.jsp" class="nav-link">🔄 Lịch sử & Làm lại</a>
            </nav>
        </aside>

        <main class="main-content">
            <button class="btn btn-glass animate-fade-up" style="margin-bottom: 20px;" onclick="window.location.href='lessons.jsp'">← Back to Library</button>
            
            <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px;">
                    <div>
                        <span id="lesson-badge" class="badge badge-blue">Listening</span>
                        <h1 id="lesson-title" style="margin-top: 15px; font-size: 2rem;">IELTS Listening - Section 1 Tips</h1>
                        <p style="color: var(--text-secondary); margin-top: 5px;">Mentor: John Doe • 15 mins</p>
                    </div>
                    <button id="bookmark-btn" class="btn btn-glass" style="color: var(--accent-red); border-color: rgba(239, 68, 68, 0.3);" onclick="toggleBookmark()">❤️ Lưu bài</button>
                </div>

                <!-- Fake Video Embed -->
                <div class="video-container">
                    <div style="width:100%; height:100%; background: #000; position:absolute; display:flex; flex-direction: column; align-items:center; justify-content:center; color: #fff;">
                        <span style="font-size: 4rem; margin-bottom: 20px; color: var(--accent-blue);">▶️</span>
                        <h2 style="font-weight: 400; opacity: 0.7;">Video Player Area</h2>
                    </div>
                </div>

                <div style="font-size: 1.1rem; line-height: 1.8; color: rgba(255,255,255,0.85);">
                    <h3>About this lesson</h3>
                    <p style="margin-top: 10px;">In this lesson, we will cover the top tips and tricks to ace Section 1 of the IELTS Listening test. Pay special attention to spelling traps and distractors.</p>
                </div>

                <div class="actions-bar">
                    <button id="learn-btn" class="btn btn-primary" onclick="toggleLearned()">✓ Đánh dấu đã học</button>
                    <button class="btn btn-glass" style="color: var(--accent-green); border-color: rgba(16, 185, 129, 0.3);">📄 Download Script (PDF)</button>
                </div>
            </div>
        </main>
    </div>
    <script src="../../js/api.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
