<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H&#7895; tr&#7907; - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-title { font-size: 1.8rem; font-weight: 700; color: #1e293b; margin: 0 0 8px; }
        .page-subtitle { color: #64748b; font-size: 0.9rem; margin: 0 0 32px; }

        .layout { display: grid; grid-template-columns: 1fr 360px; gap: 24px; }
        @media(max-width:768px) { .layout { grid-template-columns: 1fr; } }

        /* Ticket List */
        .ticket-list { display: flex; flex-direction: column; gap: 12px; }
        .ticket-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-left: 4px solid;
            text-decoration: none; color: inherit;
            transition: box-shadow 0.2s, transform 0.1s;
            display: block;
        }
        .ticket-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.1); transform: translateY(-2px); }
        .ticket-card[data-status="Open"] { border-left-color: #3b82f6; }
        .ticket-card[data-status="InProgress"] { border-left-color: #f59e0b; }
        .ticket-card[data-status="Resolved"] { border-left-color: #22c55e; }
        .ticket-card[data-status="Closed"] { border-left-color: #94a3b8; }

        .ticket-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
        .ticket-subject { font-weight: 600; color: #1e293b; font-size: 0.95rem; margin: 0; }
        .status-badge {
            padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600;
            white-space: nowrap; flex-shrink: 0; margin-left: 10px;
        }
        .badge-Open { background: #dbeafe; color: #1d4ed8; }
        .badge-InProgress { background: #fef3c7; color: #b45309; }
        .badge-Resolved { background: #dcfce7; color: #15803d; }
        .badge-Closed { background: #f1f5f9; color: #64748b; }

        .ticket-preview { color: #64748b; font-size: 0.85rem; margin: 0 0 10px; line-height: 1.5; }
        .ticket-date { font-size: 12px; color: #94a3b8; }

        /* Create Form */
        .create-card {
            background: white; border-radius: 12px; padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); height: fit-content;
            position: sticky; top: 20px;
        }
        .create-title { font-weight: 700; font-size: 1rem; color: #1e293b; margin: 0 0 20px; }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
        .form-input, .form-textarea {
            width: 100%; padding: 10px 14px; border: 1px solid #e2e8f0;
            border-radius: 8px; font-size: 14px; font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s; box-sizing: border-box;
        }
        .form-input:focus, .form-textarea:focus {
            outline: none; border-color: #f97316; box-shadow: 0 0 0 3px rgba(249,115,22,0.1);
        }
        .form-textarea { resize: vertical; min-height: 120px; }
        .btn-submit {
            width: 100%; padding: 12px; background: #f97316; color: white;
            border: none; border-radius: 8px; font-size: 15px; font-weight: 600;
            cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: #ea580c; }

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
        .alert-success { background: #dcfce7; border: 1px solid #86efac; color: #15803d; }
        .alert-error { background: #fef2f2; border: 1px solid #fca5a5; color: #b91c1c; }
        .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
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
        <div class="animate-fade-up" style="margin-bottom: 20px;">
            <h1 style="margin-bottom: 10px;">🎫 Ticket Hỗ Trợ</h1>
            <p style="color: var(--text-secondary); margin-bottom: 30px;">Gửi câu hỏi và theo dõi phản hồi từ Mentor</p>
        </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">&#9989; ${param.success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">&#10060; ${error}</div>
    </c:if>

    <div class="layout animate-fade-up" style="animation-delay: 0.1s;">
        <!-- Danh sach ticket -->
        <div>
            <h2 style="font-size:1rem;font-weight:600;color:#374151;margin:0 0 16px;">Ticket c&#7911;a b&#7841;n</h2>
            <c:choose>
                <c:when test="${empty tickets}">
                    <div class="empty-state">
                        <div style="font-size:3rem;">&#127915;</div>
                        <p>B&#7841;n ch&#432;a g&#7917;i ticket n&#224;o</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ticket-list">
                        <c:forEach var="t" items="${tickets}">
                            <a href="${pageContext.request.contextPath}/candidate/tickets?id=${t.ticketId}"
                               class="ticket-card" data-status="${t.status}">
                                <div class="ticket-header">
                                    <div class="ticket-subject">#${t.ticketId} - ${t.subject}</div>
                                    <span class="status-badge badge-${t.status}">
                                        <c:choose>
                                            <c:when test="${t.status == 'Open'}">M&#7903;</c:when>
                                            <c:when test="${t.status == 'InProgress'}">&#272;ang x&#7917; l&#253;</c:when>
                                            <c:when test="${t.status == 'Resolved'}">&#272;&#227; gi&#7843;i quy&#7871;t</c:when>
                                            <c:otherwise>&#272;&#227; &#273;&#243;ng</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="ticket-preview">${t.lastMessage}</div>
                                <div class="ticket-date">&#128197; ${t.createdAt}</div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Form tao ticket moi -->
        <div>
            <div class="create-card">
                <div class="create-title">&#9997;&#65039; G&#7917;i c&#226;u h&#7887;i m&#7899;i</div>
                <form method="POST" action="${pageContext.request.contextPath}/candidate/tickets">
                    <input type="hidden" name="action" value="create">
                    <div class="form-group">
                        <label class="form-label" for="subject">Ti&#234;u &#273;&#7873; *</label>
                        <input type="text" id="subject" name="subject" class="form-input"
                               placeholder="T&#243;m t&#7855;t v&#7845;n &#273;&#7873; c&#7911;a b&#7841;n" required maxlength="200">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="content">N&#7897;i dung *</label>
                        <textarea id="content" name="content" class="form-textarea"
                                  placeholder="M&#244; t&#7843; chi ti&#7871;t c&#226;u h&#7887;i ho&#7863;c v&#7845;n &#273;&#7873; b&#7841;n g&#7863;p ph&#7843;i..." required></textarea>
                    </div>
                    <button type="submit" class="btn-submit">G&#7917;i ticket &rarr;</button>
                </form>
            </div>
        </div>
    </div>
        </main>
    </div>
</body>
</html>
