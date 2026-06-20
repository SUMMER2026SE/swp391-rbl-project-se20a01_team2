<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
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
            border-radius: 14px; padding: 24px;
            margin-bottom: 20px;
        }
        .user-reply {
            background: white; border: 1px solid #e2e8f0;
        }
        .user-reply .reply-title { color: #334155; }
        
        .mentor-reply {
            background: linear-gradient(135deg, #eff6ff, #f0fdf4);
            border: 1px solid #bfdbfe;
        }
        .mentor-reply .reply-title { font-weight: 700; color: #1e40af; }
        
        .reply-title { font-weight: 700; margin: 0 0 12px; font-size: 0.9rem; }
        .reply-content { color: #1e293b; line-height: 1.7; white-space: pre-wrap; }
        .reply-date { font-size: 12px; color: #64748b; margin-top: 10px; }
        
        .reply-form-box {
            background: white; border-radius: 14px; padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); margin-bottom: 20px;
        }
        .form-textarea {
            width: 100%; padding: 12px; border: 1px solid #e2e8f0;
            border-radius: 8px; font-family: inherit; font-size: 14px;
            resize: vertical; min-height: 100px; box-sizing: border-box;
        }
        .form-textarea:focus { outline: none; border-color: #f97316; }
        .btn-submit {
            background: #f97316; color: white; border: none; padding: 10px 20px;
            border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; transition: background 0.2s;
        }
        .btn-submit:hover { background: #ea580c; }

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
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Mục tiêu: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Kế hoạch tuần</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Thư viện</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="nav-link">🎯 Bài thi</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 Lịch sử & Làm lại</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
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
        &larr; Quay l&#7841;i danh s&#225;ch
    </a>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success" style="background: #dcfce7; border: 1px solid #86efac; color: #15803d; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">&#9989; ${param.success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error" style="background: #fef2f2; border: 1px solid #fca5a5; color: #b91c1c; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">&#10060; ${error}</div>
    </c:if>

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
            </div>

            <!-- Tin nh&#7855;n chat -->
            <div class="chat-history">
                <c:forEach var="reply" items="${ticket.replies}">
                    <c:choose>
                        <c:when test="${reply.sender.userId == sessionScope.userId}">
                            <!-- Tin nh&#7855;n c&#7911;a candidate -->
                            <div class="reply-box user-reply">
                                <div class="reply-title">&#128100; B&#7841;n</div>
                                <div class="reply-content">${reply.message}</div>
                                <div class="reply-date">${reply.createdAt}</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Tin nh&#7855;n c&#7911;a Mentor -->
                            <div class="reply-box mentor-reply">
                                <div class="reply-title">&#128172; Mentor (${reply.sender.fullName})</div>
                                <div class="reply-content">${reply.message}</div>
                                <div class="reply-date">${reply.createdAt}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

            <!-- Form reply n&#7871;u ch&#432;a close -->
            <c:if test="${ticket.status != 'Closed'}">
                <div class="reply-form-box">
                    <form method="POST" action="${pageContext.request.contextPath}/candidate/tickets">
                        <input type="hidden" name="action" value="reply">
                        <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                        <textarea name="replyContent" class="form-textarea" placeholder="Nh&#7853;p n&#7897;i dung ph&#7843;n h&#7891;i..." required></textarea>
                        <button type="submit" class="btn-submit" style="margin-top: 10px;">G&#7917;i ph&#7843;n h&#7891;i</button>
                    </form>
                </div>
            </c:if>

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
