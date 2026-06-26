<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <title>Lesson Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Kế hoạch tuần</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link active">📚 Thư viện</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 Lịch sử & Làm lại</a>
            </nav>
        </aside>

        <main class="main-content">
            <button class="btn btn-glass animate-fade-up" style="margin-bottom: 20px;" onclick="window.location.href='${pageContext.request.contextPath}/candidate/lessons'">← Quay lại Thư viện</button>
            
            <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px;">
                    <div>
                        <c:set var="skillColor" value="blue"/>
                        <c:if test="${lesson.skill == 'Reading'}"><c:set var="skillColor" value="green"/></c:if>
                        <c:if test="${lesson.skill == 'Writing'}"><c:set var="skillColor" value="orange"/></c:if>
                        <c:if test="${lesson.skill == 'Speaking'}"><c:set var="skillColor" value="purple"/></c:if>
                        
                        <span id="lesson-badge" class="badge badge-${skillColor}">${lesson.skill}</span>
                        <h1 id="lesson-title" style="margin-top: 15px; font-size: 2rem;">${lesson.title}</h1>
                    </div>
                    <button id="bookmark-btn" class="btn btn-glass" style="color: var(--accent-red); border-color: rgba(239, 68, 68, 0.3);" onclick="toggleBookmark()">❤️ Lưu bài</button>
                </div>

                <c:if test="${not empty lesson.videoUrl}">
                    <div class="video-container">
                        <video controls style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: contain; background: #000;">
                            <source src="${pageContext.request.contextPath}${lesson.videoUrl}" type="video/mp4">
                            Your browser does not support HTML video.
                        </video>
                    </div>
                </c:if>

                <div style="font-size: 1.1rem; line-height: 1.8; color: rgba(255,255,255,0.85); min-height: 100px;">
                    ${lesson.content}
                </div>

                <div class="actions-bar">
                    <button id="learn-btn" class="btn btn-primary" onclick="toggleLearned()">✓ Đánh dấu đã học</button>
                    <c:if test="${not empty lesson.documentUrl}">
                        <a href="${pageContext.request.contextPath}${lesson.documentUrl}" download target="_blank" class="btn btn-glass" style="color: var(--accent-green); border-color: rgba(16, 185, 129, 0.3); text-decoration: none;">📄 Tải tài liệu đính kèm</a>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    <script>
        window.MOCK_LESSONS = [{
            id: parseInt('${lesson.lessonId}'),
            title: '${lesson.title}',
            skill: '${lesson.skill}',
            color: '${skillColor}'
        }];
    </script>
    <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
