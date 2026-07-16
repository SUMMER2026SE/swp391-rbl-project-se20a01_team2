<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Detail - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .back-link {
            display: inline-flex; align-items: center; gap: 6px; color: #0969da;
            text-decoration: none; font-size: 14px; margin-bottom: 24px;
        }
        .back-link:hover { text-decoration: underline; }

        .issue-header-container { border-bottom: 1px solid #d0d7de; padding-bottom: 16px; margin-bottom: 24px; }
        .issue-title-row { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
        .issue-title { font-size: 32px; font-weight: 400; color: #24292f; margin: 0; line-height: 1.125; }
        .issue-number { font-size: 32px; font-weight: 300; color: #57606a; margin: 0; }
        
        .issue-meta-row { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #57606a; }
        .state-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 5px 12px; border-radius: 2em; font-size: 14px; font-weight: 500;
            color: #fff;
        }
        .state-open { background-color: #2da44e; }
        .state-closed { background-color: #8250df; }

        .layout-grid { display: grid; grid-template-columns: 1fr 280px; gap: 24px; }
        @media(max-width:768px) { .layout-grid { grid-template-columns: 1fr; } }

        .timeline-item { display: flex; gap: 16px; margin-bottom: 24px; }
        .timeline-avatar {
            width: 40px; height: 40px; border-radius: 50%; background-color: #f6f8fa;
            border: 1px solid #d0d7de; display: flex; align-items: center; justify-content: center;
            font-weight: 600; color: #57606a; flex-shrink: 0; overflow: hidden;
        }
        .timeline-content {
            flex-grow: 1; border: 1px solid #d0d7de; border-radius: 6px;
            background-color: #fff; min-width: 0;
            position: relative;
        }
        .timeline-content::before {
            content: ""; position: absolute; top: 11px; left: -16px;
            border-style: solid; border-width: 8px; border-color: transparent #d0d7de transparent transparent;
        }
        .timeline-content::after {
            content: ""; position: absolute; top: 12px; left: -14px;
            border-style: solid; border-width: 7px; border-color: transparent #f6f8fa transparent transparent;
        }
        
        .timeline-header {
            background-color: #f6f8fa; border-bottom: 1px solid #d0d7de;
            padding: 8px 16px; border-top-left-radius: 6px; border-top-right-radius: 6px;
            font-size: 14px; color: #57606a;
        }
        .timeline-header strong { color: #24292f; }
        .mentor-badge {
            border: 1px solid #d0d7de; border-radius: 2em; padding: 2px 8px;
            font-size: 12px; font-weight: 500; margin-left: 8px; color: #57606a;
        }
        
        .timeline-body { padding: 16px; font-size: 14px; color: #24292f; line-height: 1.5; }

        /* Comment Form */
        .comment-form-container { display: flex; gap: 16px; margin-top: 24px; border-top: 2px solid #e1e4e8; padding-top: 24px; }
        .comment-form {
            flex-grow: 1; border: 1px solid #d0d7de; border-radius: 6px;
            background-color: #fff;
        }
        .comment-form-header {
            background-color: #f6f8fa; border-bottom: 1px solid #d0d7de;
            padding: 8px 16px; border-top-left-radius: 6px; border-top-right-radius: 6px;
            font-weight: 600; font-size: 14px;
        }
        .comment-textarea {
            width: 100%; border: none; padding: 16px; min-height: 120px;
            font-size: 14px; font-family: monospace; resize: vertical; box-sizing: border-box;
            background-color: #f6f8fa;
        }
        .comment-textarea:focus { outline: none; background-color: #fff; }
        .comment-form-footer {
            padding: 8px 16px; display: flex; justify-content: flex-end; gap: 8px;
            background-color: #f6f8fa; border-top: 1px dashed #d0d7de; border-bottom-left-radius: 6px; border-bottom-right-radius: 6px;
        }

        .btn { padding: 5px 16px; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; border: 1px solid transparent; }
        .btn-primary { background-color: #2da44e; color: #fff; border-color: rgba(27,31,36,0.15); }
        .btn-primary:hover { background-color: #2c974b; }
        .btn-default { background-color: #f6f8fa; color: #24292f; border-color: rgba(27,31,36,0.15); }
        .btn-default:hover { background-color: #f3f4f6; border-color: rgba(27,31,36,0.15); }
        .btn-danger-outline { background-color: #f6f8fa; color: #cf222e; border-color: rgba(27,31,36,0.15); }
        .btn-danger-outline:hover { background-color: #ffebe9; }

        /* Sidebar */
        .sidebar-section { border-bottom: 1px solid #d0d7de; padding-bottom: 16px; margin-bottom: 16px; }
        .sidebar-title { font-size: 12px; font-weight: 600; color: #57606a; margin-bottom: 8px; display: block; }
        .sidebar-value { font-size: 14px; color: #24292f; }

        /* Markdown Styles */
        .markdown-body { font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif; }
        .markdown-body pre { background-color: #f6f8fa; padding: 16px; border-radius: 6px; overflow: auto; }
        .markdown-body code { background-color: rgba(175,184,193,0.2); padding: 0.2em 0.4em; border-radius: 6px; font-family: monospace; font-size: 85%; }
        .markdown-body p { margin-top: 0; margin-bottom: 16px; }
        .markdown-body p:last-child { margin-bottom: 0; }
    </style>
</head>
<body>
    <div class="bg-blob blob-1"></div>
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
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Mục tiêu: ${not empty sessionScope.targetBand ? sessionScope.targetBand : 'Chưa thiết lập'}</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Bảng điều khiển</a>
                <!-- <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Kế hoạch tuần</a> -->
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Thư viện</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="nav-link">🎯 Bài thi</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 Lịch sử & Làm lại</a>
                <!-- <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a> -->
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link active">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Đăng xuất</a>
            </div>
        </aside>

        <main class="main-content">
    <div class="animate-fade-up">
    <a href="${pageContext.request.contextPath}/candidate/tickets" class="back-link">
        <i class="fa-solid fa-arrow-left"></i> Back to issues
    </a>

    <c:if test="${not empty param.success}">
        <div style="background-color: #dafbe1; border: 1px solid #4ac26b; color: #1a7f37; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 14px;"><i class="fa-solid fa-check-circle me-2"></i> ${param.success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div style="background-color: #ffebe9; border: 1px solid #ff8182; color: #cf222e; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 14px;"><i class="fa-solid fa-circle-exclamation me-2"></i> ${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty ticket}">
            <div style="text-align:center;padding:60px;color:#57606a;">
                <p>Issue not found.</p>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Header -->
            <div class="issue-header-container">
                <div class="issue-title-row">
                    <h1 class="issue-title">${ticket.subject}</h1>
                    <span class="issue-number">#${ticket.ticketId}</span>
                </div>
                <div class="issue-meta-row">
                    <c:choose>
                        <c:when test="${ticket.status == 'Closed'}">
                            <span class="state-badge state-closed"><i class="fa-regular fa-circle-check"></i> Closed</span>
                        </c:when>
                        <c:otherwise>
                            <span class="state-badge state-open"><i class="fa-regular fa-circle-dot"></i> Open</span>
                        </c:otherwise>
                    </c:choose>
                    <span>
                        <strong>${ticket.user.fullName}</strong> opened this issue <span class="time-ago" data-time="${ticket.createdAt}">${ticket.createdAt}</span> &middot; ${ticket.replies.size()} comments
                    </span>
                </div>
            </div>

            <div class="layout-grid">
                <!-- Timeline -->
                <div class="timeline-container">
                    <c:forEach var="reply" items="${ticket.replies}">
                        <div class="timeline-item">
                            <div class="timeline-avatar">
                                <c:choose>
                                    <c:when test="${not empty reply.sender.profilePic}">
                                        <img src="${pageContext.request.contextPath}${reply.sender.profilePic}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>${reply.sender.fullName.substring(0, 1)}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-header">
                                    <strong>${reply.sender.fullName}</strong> commented <span class="time-ago" data-time="${reply.createdAt}">${reply.createdAt}</span>
                                    <c:if test="${reply.sender.roleId == 1}">
                                        <span class="mentor-badge">Admin</span>
                                    </c:if>
                                    <c:if test="${reply.sender.roleId == 2}">
                                        <span class="mentor-badge">Mentor</span>
                                    </c:if>
                                </div>
                                <div class="timeline-body markdown-body raw-markdown" style="display:none;">${reply.message}</div>
                                <div class="timeline-body markdown-body rendered-markdown"></div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Form reply n&#7871;u ch&#432;a close -->
                    <c:if test="${ticket.status != 'Closed'}">
                        <div class="comment-form-container">
                            <div class="timeline-avatar">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.profilePic}">
                                        <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>${sessionScope.fullName.substring(0, 1)}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="comment-form">
                                <div class="comment-form-header">Write a comment</div>
                                <form method="POST" action="${pageContext.request.contextPath}/candidate/tickets">
                                    <input type="hidden" name="action" value="reply">
                                    <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                    <textarea name="replyContent" class="comment-textarea" placeholder="Leave a comment (Markdown is supported)"></textarea>
                                    <div class="comment-form-footer">
                                        <button type="submit" class="btn btn-primary">Comment</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <div style="display: flex; justify-content: flex-end; margin-top: 16px;">
                            <form method="POST" action="${pageContext.request.contextPath}/candidate/tickets">
                                <input type="hidden" name="action" value="close">
                                <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                <button type="submit" class="btn btn-danger-outline"><i class="fa-regular fa-circle-check"></i> Close issue</button>
                            </form>
                        </div>
                    </c:if>
                </div>

                <!-- Sidebar -->
                <div class="issue-sidebar">

                    
                    <div class="sidebar-section">
                        <span class="sidebar-title">Labels</span>
                        <c:choose>
                            <c:when test="${ticket.status == 'InProgress'}">
                                <span class="label-badge label-inprogress">in progress</span>
                            </c:when>
                            <c:when test="${ticket.status == 'Resolved'}">
                                <span class="label-badge label-resolved">resolved</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color:#57606a; font-size:14px;">None yet</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dompurify/dist/purify.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const rawEls = document.querySelectorAll('.raw-markdown');
            const renderedEls = document.querySelectorAll('.rendered-markdown');
            for(let i=0; i<rawEls.length; i++) {
                const rawText = rawEls[i].textContent;
                const html = DOMPurify.sanitize(marked.parse(rawText));
                renderedEls[i].innerHTML = html;
            }

            function timeAgo(dateString) {
                const date = new Date(dateString);
                const seconds = Math.floor((new Date() - date) / 1000);
                let interval = seconds / 31536000;
                if (interval >= 1) return Math.floor(interval) + " years ago";
                interval = seconds / 2592000;
                if (interval >= 1) return Math.floor(interval) + " months ago";
                interval = seconds / 86400;
                if (interval >= 1) return Math.floor(interval) + " days ago";
                interval = seconds / 3600;
                if (interval >= 1) return Math.floor(interval) + " hours ago";
                interval = seconds / 60;
                if (interval >= 1) return Math.floor(interval) + " minutes ago";
                if (seconds < 0) return "just now";
                return Math.floor(seconds) + " seconds ago";
            }
            document.querySelectorAll('.time-ago').forEach(el => {
                const dateVal = el.getAttribute('data-time');
                if (dateVal) el.textContent = timeAgo(dateVal);
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/api.js?v=${System.currentTimeMillis()}"></script>
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
</body>
</html>
