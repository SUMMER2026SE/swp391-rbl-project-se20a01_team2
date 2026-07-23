<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
<jsp:include page="/jsp/candidate/sidebar.jsp">
            <jsp:param name="activePage" value="lessons" />
        </jsp:include>

        <main class="main-content" id="appMainContent">
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

                <%
                    model.Lesson l = (model.Lesson)request.getAttribute("lesson");
                    
                    boolean hasVideo = false;
                    if (l.getVideoUrl() != null) {
                        String v = l.getVideoUrl().trim();
                        if (v.length() > 5 && (v.startsWith("http") || v.startsWith("/"))) {
                            hasVideo = true;
                        }
                    }
                    request.setAttribute("hasVideo", hasVideo);

                    boolean hasDoc = false;
                    String fileName = "Tài liệu đính kèm";
                    boolean isPdf = false;
                    boolean isOffice = false;
                    String finalDocUrl = "";
                    if (l.getDocumentUrl() != null) {
                        String d = l.getDocumentUrl().trim();
                        finalDocUrl = d;
                        String lowerD = d.toLowerCase();
                        if (lowerD.endsWith(".pdf")) isPdf = true;
                        else if (lowerD.endsWith(".docx") || lowerD.endsWith(".doc") || lowerD.endsWith(".pptx") || lowerD.endsWith(".xlsx")) isOffice = true;
                        if (d.length() > 5 && (d.startsWith("http") || d.startsWith("/"))) {
                            hasDoc = true;
                            if (d.contains("/")) {
                                fileName = d.substring(d.lastIndexOf('/') + 1);
                                // remove UUID prefix if exists (UUID is 36 chars long)
                                if (fileName.length() > 37 && fileName.charAt(36) == '.') {
                                    // Sometimes UUIDs are at the start
                                    // Just show the raw file name
                                }
                            } else {
                                fileName = d;
                            }
                        }
                    }
                    request.setAttribute("hasDoc", hasDoc);
                    request.setAttribute("fileName", fileName);
                    request.setAttribute("isPdf", isPdf);
                    request.setAttribute("isOffice", isOffice);
                    request.setAttribute("finalDocUrl", finalDocUrl);
                %>

                <c:if test="${hasVideo}">
                    <div class="video-container">
                        <c:choose>
                            <c:when test="${lesson.videoUrl.contains('youtube.com') || lesson.videoUrl.contains('youtu.be')}">
                                <iframe src="${lesson.videoUrl.replace('watch?v=', 'embed/').replace('youtu.be/', 'youtube.com/embed/')}" 
                                        style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" 
                                        frameborder="0" allowfullscreen>
                                </iframe>
                            </c:when>
                            <c:otherwise>
                                <video controls style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: contain; background: #000;">
                                    <source src="${pageContext.request.contextPath}${lesson.videoUrl}" type="video/mp4">
                                    Your browser does not support HTML video.
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
                <c:if test="${not hasVideo}">
                    <div style="padding: 40px 20px; text-align: center; background: rgba(0,0,0,0.03); border-radius: 12px; margin-bottom: 20px; border: 1px dashed rgba(0,0,0,0.15); box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);">
                        <div style="font-size: 2.2rem; opacity: 0.6; margin-bottom: 10px; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">🎦</div>
                        <div style="color: #64748b; font-style: italic; font-size: 0.95rem; font-weight: 500;">Không có video bài giảng cho bài học này</div>
                    </div>
                </c:if>

                <div style="font-size: 1.1rem; line-height: 1.8; color: var(--text-primary); min-height: 100px; margin-bottom: 20px;">
                    ${lesson.content}
                </div>

                <% if (hasDoc) { %>
                    <div style="margin-bottom: 30px; padding: 15px; background: rgba(0,0,0,0.03); border-radius: 8px; border-left: 4px solid var(--accent-green);">
                        <div style="margin-bottom: 15px;">
                            <span style="color: var(--text-secondary); margin-right: 10px;">Tài liệu đính kèm:</span>
                            <a href="<%= finalDocUrl.startsWith("http") ? finalDocUrl : request.getContextPath() + finalDocUrl %>" download target="_blank" style="color: var(--accent-green); text-decoration: underline; font-weight: 500;">
                                Click vào đây để tải về tài liệu đính kèm (docs/pdf)
                            </a>
                        </div>
                        
                        <% if (isPdf) { %>
                            <div style="width: 100%; height: 800px; border: 1px solid var(--glass-border); border-radius: 12px; overflow: hidden; background: #fff;">
                                <iframe src="<%= finalDocUrl.startsWith("http") ? finalDocUrl : request.getContextPath() + finalDocUrl %>" width="100%" height="100%" style="border: none;"></iframe>
                            </div>
                        <% } else if (isOffice) { %>
                            <div style="width: 100%; height: 800px; border: 1px solid var(--glass-border); border-radius: 12px; overflow: hidden; background: #fff;">
                                <iframe src="https://docs.google.com/viewer?embedded=true&url=<%= finalDocUrl.startsWith("http") ? finalDocUrl : "https://ieltsflow.tanmanh350.ovh" + finalDocUrl %>" width="100%" height="100%" style="border: none;"></iframe>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div style="margin-bottom: 30px; padding: 15px; background: rgba(0,0,0,0.03); border-radius: 8px; border-left: 4px solid rgba(0,0,0,0.15); box-shadow: 0 2px 5px rgba(0,0,0,0.02);">
                        <span style="color: #64748b; font-style: italic; font-size: 0.95rem; font-weight: 500; text-shadow: 0 1px 2px rgba(255,255,255,0.5);">📄 Không có tài liệu đính kèm</span>
                    </div>
                <% } %>

                <div class="actions-bar">
                    <button id="learn-btn" class="btn btn-primary" onclick="toggleLearned()">✓ Đánh dấu đã học</button>
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
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
    <!-- AI Chatbox Widget -->
    <jsp:include page="/jsp/components/chat-widget.jsp" />
    
</body>
</html>

