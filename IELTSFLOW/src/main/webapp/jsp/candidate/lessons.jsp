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
                <jsp:include page="/jsp/candidate/sidebar.jsp">
                        <jsp:param name="activePage" value="lessons" />
                    </jsp:include>

                    <main class="main-content" id="appMainContent">
                        <h1 class="animate-fade-up" style="margin-bottom: 10px;">Thư viện học tập</h1>
                        <p class="animate-fade-up" style="color: var(--text-secondary); margin-bottom: 30px;">Khám phá
                            các bài giảng video và tài liệu PDF chi tiết từ các Mentor.</p>

                        <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                            <input type="text" id="search-input" placeholder="Tìm kiếm Map, Task 1, Từ vựng..."
                                oninput="searchLessons()">
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
                            <button class="btn btn-primary" style="border-radius: 25px;" onclick="searchLessons()">Tìm
                                kiếm</button>
                        </div>

                        <div class="lesson-grid" id="library-grid">
                            <!-- Data injected by JS -->
                        </div>
                    </main>
            </div>

            <script>
                window.MOCK_LESSONS = ${not empty lessonsJson ? lessonsJson : '[]' };
            </script>
            <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
            <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
            
        </body>

        </html>