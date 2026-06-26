<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ học viên - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        /* GitHub Issues Style List */
        .issues-container {
            border: 1px solid #d0d7de;
            border-radius: 6px;
            background: #ffffff;
            margin-top: 20px;
        }
        .issues-header {
            background-color: #f6f8fa;
            border-bottom: 1px solid #d0d7de;
            padding: 16px;
            border-top-left-radius: 6px;
            border-top-right-radius: 6px;
            display: flex;
            gap: 16px;
            font-size: 14px;
            font-weight: 600;
            color: #24292f;
        }
        .issues-header span { display: flex; align-items: center; gap: 6px; cursor: pointer; }
        .issues-header .text-muted { color: #57606a; font-weight: 400; }
        
        .issue-row {
            display: flex;
            padding: 12px 16px;
            border-bottom: 1px solid #d0d7de;
            transition: background 0.1s;
        }
        .issue-row:last-child { border-bottom: none; border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
        .issue-row:hover { background-color: #f6f8fa; }
        .issue-icon {
            margin-right: 8px;
            margin-top: 2px;
            flex-shrink: 0;
        }
        .issue-icon-open { color: #1a7f37; }
        .issue-icon-closed { color: #8250df; }
        
        .issue-content { flex-grow: 1; }
        .issue-title {
            font-size: 16px;
            font-weight: 600;
            color: #24292f;
            text-decoration: none;
            margin-bottom: 4px;
            display: inline-block;
        }
        .issue-title:hover { color: #0969da; text-decoration: none; }
        .issue-meta {
            font-size: 12px;
            color: #57606a;
        }
        .issue-comments {
            display: flex;
            align-items: flex-start;
            gap: 4px;
            color: #57606a;
            font-size: 12px;
            text-decoration: none;
            margin-left: 16px;
        }
        .issue-comments:hover { color: #0969da; }

        .label-badge {
            display: inline-block;
            padding: 0 7px;
            font-size: 12px;
            font-weight: 500;
            line-height: 18px;
            border-radius: 2em;
            border: 1px solid transparent;
            margin-left: 4px;
            vertical-align: middle;
        }
        .label-inprogress { background-color: #d4a72c; color: #fff; }
        .label-resolved { background-color: #2da44e; color: #fff; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #57606a; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-orange); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="tickets" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up">
            <h1 style="font-size: 24px; font-weight: 600; color: #24292f; margin: 0;">Tickets</h1>
        </header>
        
        <c:if test="${not empty param.success}">
            <div style="background-color: #dafbe1; border: 1px solid #4ac26b; color: #1a7f37; padding: 12px 16px; border-radius: 6px; margin-top: 20px; font-size: 14px;"><i class="fa-solid fa-check-circle me-2"></i> ${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background-color: #ffebe9; border: 1px solid #ff8182; color: #cf222e; padding: 12px 16px; border-radius: 6px; margin-top: 20px; font-size: 14px;"><i class="fa-solid fa-circle-exclamation me-2"></i> ${error}</div>
        </c:if>

        <div class="animate-fade-up" style="animation-delay: 0.1s;">
            <div class="issues-container">
                <div class="issues-header">
                    <span><i class="fa-regular fa-circle-dot"></i> Tickets</span>
                </div>
                
                <c:choose>
                    <c:when test="${empty tickets}">
                        <div class="empty-state">
                            <i class="fa-solid fa-ticket" style="font-size: 24px; margin-bottom: 16px;"></i>
                            <h4>No tickets found</h4>
                            <p>There are currently no tickets requiring your attention.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="ticket-list-body">
                            <c:forEach var="t" items="${tickets}">
                                <div class="issue-row">
                                    <div class="issue-icon ${t.status == 'Closed' ? 'issue-icon-closed' : 'issue-icon-open'}">
                                        <c:choose>
                                            <c:when test="${t.status == 'Closed'}"><i class="fa-regular fa-circle-check"></i></c:when>
                                            <c:otherwise><i class="fa-regular fa-circle-dot"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="issue-content">
                                        <a href="${pageContext.request.contextPath}/mentor/tickets/${t.ticketId}" class="issue-title">${t.subject}</a>
                                        <c:if test="${t.status == 'InProgress'}"><span class="label-badge label-inprogress">in progress</span></c:if>
                                        <c:if test="${t.status == 'Resolved'}"><span class="label-badge label-resolved">resolved</span></c:if>
                                        <div class="issue-meta">
                                            #${t.ticketId} opened <span class="time-ago" data-time="${t.createdAt}">${t.createdAt}</span> by ${t.user.fullName}
                                        </div>
                                    </div>
                                    <c:if test="${t.replies.size() > 1}">
                                        <a href="${pageContext.request.contextPath}/mentor/tickets/${t.ticketId}" class="issue-comments">
                                            <i class="fa-regular fa-message"></i> ${t.replies.size() - 1}
                                        </a>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
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
</body>
</html>
