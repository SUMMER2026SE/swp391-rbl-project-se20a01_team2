<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi ti&#7871;t Ticket - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .back-link {
            display: inline-flex; align-items: center; gap: 6px; color: #64748b;
            text-decoration: none; font-size: 14px; margin-bottom: 24px;
            transition: color 0.2s;
        }
        .back-link:hover { color: #f97316; }

        .ticket-box {
            background: white; border-radius: 14px; padding: 30px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); margin-bottom: 20px;
        }
        .ticket-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .ticket-id { font-size: 12px; color: #94a3b8; font-weight: 600; margin-bottom: 6px; }
        .ticket-subject { font-size: 1.3rem; font-weight: 700; color: #1e293b; margin: 0; }
        .status-badge {
            padding: 6px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; white-space: nowrap;
        }
        .badge-Open { background: #dbeafe; color: #1d4ed8; }
        .badge-InProgress { background: #fef3c7; color: #b45309; }
        .badge-Resolved { background: #dcfce7; color: #15803d; }
        .badge-Closed { background: #f1f5f9; color: #64748b; }

        .ticket-content { color: #475569; line-height: 1.7; white-space: pre-wrap; }
        .ticket-date { font-size: 12px; color: #94a3b8; margin-top: 16px; }

        .reply-box {
            background: linear-gradient(135deg, #eff6ff, #f0fdf4);
            border: 1px solid #bfdbfe; border-radius: 14px; padding: 24px;
            margin-bottom: 20px;
        }
        .reply-title { font-weight: 700; color: #1e40af; margin: 0 0 12px; font-size: 0.9rem; }
        .reply-content { color: #1e293b; line-height: 1.7; white-space: pre-wrap; }
        .reply-date { font-size: 12px; color: #64748b; margin-top: 10px; }

        .pending-box {
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 12px; padding: 20px;
            text-align: center; color: #92400e; margin-bottom: 20px;
        }

        .btn-close {
            display: inline-flex; align-items: center; gap: 6px;
            background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0;
            padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 500;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-close:hover { background: #e2e8f0; }
    </style>
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>
    <div class="layout-wrapper">
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
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Weekly Plan</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Library</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 History & Redo</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link active">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <main class="main-content">
    <div class="animate-fade-up">
    <a href="${pageContext.request.contextPath}/candidate/tickets" class="back-link">
        &larr; Quay l&#7841;i danh s&#225;ch
    </a>

    <c:choose>
        <c:when test="${empty ticket}">
            <div style="text-align:center;padding:60px;color:#94a3b8;">
                <p>Kh&#244;ng t&#236;m th&#7845;y ticket n&#224;y.</p>
            </div>
        </c:when>
        <c:otherwise>
            <!-- N&#7897;i dung ticket -->
            <div class="ticket-box">
                <div class="ticket-header">
                    <div>
                        <div class="ticket-id">TICKET #${ticket.ticketId}</div>
                        <div class="ticket-subject">${ticket.subject}</div>
                    </div>
                    <span class="status-badge badge-${ticket.status}">
                        <c:choose>
                            <c:when test="${ticket.status == 'Open'}">M&#7903;</c:when>
                            <c:when test="${ticket.status == 'InProgress'}">&#272;ang x&#7917; l&#253;</c:when>
                            <c:when test="${ticket.status == 'Resolved'}">&#272;&#227; gi&#7843;i quy&#7871;t</c:when>
                            <c:otherwise>&#272;&#227; &#273;&#243;ng</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="ticket-content">${ticket.content}</div>
                <div class="ticket-date">&#128197; G&#7917;i l&#250;c: ${ticket.createdAt}</div>
            </div>

            <!-- Ph&#7843;n h&#7891;i t&#7915; Mentor -->
            <c:choose>
                <c:when test="${not empty ticket.adminReply}">
                    <div class="reply-box">
                        <div class="reply-title">&#128172; Ph&#7843;n h&#7891;i t&#7915; Mentor</div>
                        <div class="reply-content">${ticket.adminReply}</div>
                        <div class="reply-date">Ph&#7843;n h&#7891;i l&#250;c: ${ticket.repliedAt}</div>
                    </div>
                </c:when>
                <c:when test="${ticket.status != 'Closed'}">
                    <div class="pending-box">
                        &#8987; &#272;ang ch&#7901; Mentor ph&#7843;n h&#7891;i. Ch&#250;ng t&#244;i s&#7869; tr&#7843; l&#7901;i trong v&#242;ng 24 gi&#7897;.
                    </div>
                </c:when>
            </c:choose>

            <!-- N&#250;t &#273;&#243;ng ticket -->
            <c:if test="${ticket.status == 'Open' || ticket.status == 'Resolved'}">
                <form method="POST" action="${pageContext.request.contextPath}/candidate/tickets">
                    <input type="hidden" name="action" value="close">
                    <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                    <button type="submit" class="btn-close">&#10005; &#272;&#243;ng ticket</button>
                </form>
            </c:if>
        </c:otherwise>
    </c:choose>
    </div>
        </main>
    </div>
</body>
</html>
