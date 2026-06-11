<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Th&#244;ng b&#225;o - IELTSFlow</title>
    <link rel="stylesheet" href="../css/design-system.css">
    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #f8fafc; }
        .page-wrapper { max-width: 760px; margin: 0 auto; padding: 40px 20px; }
        .page-title { font-size: 1.8rem; font-weight: 700; color: #1e293b; margin: 0 0 8px; }
        .page-subtitle { color: #64748b; font-size: 0.9rem; margin: 0 0 32px; }

        .toolbar {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px;
        }
        .badge-unread {
            background: #f97316; color: white;
            padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600;
        }
        .btn-mark-all {
            background: none; border: 1px solid #cbd5e1; color: #475569;
            padding: 8px 16px; border-radius: 8px; font-size: 13px; cursor: pointer;
            transition: all 0.2s;
        }
        .btn-mark-all:hover { background: #f1f5f9; border-color: #94a3b8; }

        .notification-list { display: flex; flex-direction: column; gap: 12px; }
        .notification-item {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex; gap: 16px; align-items: flex-start;
            border-left: 4px solid transparent;
            transition: box-shadow 0.2s;
        }
        .notification-item.unread { border-left-color: #f97316; }
        .notification-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.1); }

        .notif-icon {
            width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center; font-size: 20px;
        }
        .icon-reminder { background: #fff7ed; }
        .icon-system { background: #eff6ff; }
        .icon-promotion { background: #f0fdf4; }

        .notif-body { flex: 1; }
        .notif-title {
            font-weight: 600; color: #1e293b; font-size: 0.95rem; margin: 0 0 6px;
        }
        .notif-title.unread { color: #0f172a; }
        .notif-message { font-size: 0.875rem; color: #64748b; margin: 0 0 10px; line-height: 1.5; }
        .notif-meta {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 12px; color: #94a3b8;
        }
        .btn-read {
            background: none; border: none; color: #3b82f6; font-size: 12px;
            cursor: pointer; padding: 0; text-decoration: underline;
        }
        .empty-state {
            text-align: center; padding: 80px 20px; color: #94a3b8;
        }
        .empty-state p { font-size: 1rem; margin-top: 16px; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="page-title">&#128276; Th&#244;ng b&#225;o</div>
    <div class="page-subtitle">Nh&#7855;c nh&#7903; v&#224; c&#7853;p nh&#7853;t t&#7915; h&#7879; th&#7889;ng</div>

    <c:if test="${not empty error}">
        <div style="background:#fef2f2;border:1px solid #fca5a5;color:#b91c1c;padding:14px 18px;border-radius:10px;margin-bottom:20px;">
            ${error}
        </div>
    </c:if>

    <div class="toolbar">
        <span>
            <c:choose>
                <c:when test="${unreadCount > 0}">
                    <span class="badge-unread">${unreadCount} ch&#432;a &#273;&#7885;c</span>
                </c:when>
                <c:otherwise>
                    <span style="color:#64748b;font-size:14px;">T&#7845;t c&#7843; &#273;&#227; &#273;&#7885;c</span>
                </c:otherwise>
            </c:choose>
        </span>
        <c:if test="${unreadCount > 0}">
            <form method="POST" action="${pageContext.request.contextPath}/notifications" style="margin:0;">
                <input type="hidden" name="action" value="markAllRead">
                <button type="submit" class="btn-mark-all">&#10003; &#272;&#225;nh d&#7845;u t&#7845;t c&#7843; &#273;&#227; &#273;&#7885;c</button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="empty-state">
                <div style="font-size:4rem;">&#128276;</div>
                <p>B&#7841;n ch&#432;a c&#243; th&#244;ng b&#225;o n&#224;o</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="notification-list">
                <c:forEach var="n" items="${notifications}">
                    <div class="notification-item ${!n.read ? 'unread' : ''}">
                        <div class="notif-icon icon-${n.type == 'REMINDER' ? 'reminder' : n.type == 'SYSTEM' ? 'system' : 'promotion'}">
                            <c:choose>
                                <c:when test="${n.type == 'REMINDER'}">&#9200;</c:when>
                                <c:when test="${n.type == 'SYSTEM'}">&#128227;</c:when>
                                <c:otherwise>&#127873;</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="notif-body">
                            <div class="notif-title ${!n.read ? 'unread' : ''}">${n.title}</div>
                            <div class="notif-message">${n.message}</div>
                            <div class="notif-meta">
                                <span>${n.createdAt}</span>
                                <c:if test="${!n.read}">
                                    <form method="POST" action="${pageContext.request.contextPath}/notifications" style="margin:0;">
                                        <input type="hidden" name="action" value="markRead">
                                        <input type="hidden" name="notificationId" value="${n.notificationId}">
                                        <button type="submit" class="btn-read">&#272;&#225;nh d&#7845;u &#273;&#227; &#273;&#7885;c</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
