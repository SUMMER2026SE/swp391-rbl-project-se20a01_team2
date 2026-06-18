<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>

        .card { background: var(--bg-surface); border-radius: 16px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); border: 1px solid var(--glass-border); backdrop-filter: blur(10px); }
        .card-header { padding: 24px; border-bottom: 1px solid var(--glass-border); display: flex; justify-content: space-between; align-items: center; }
        .card-title { font-size: 1.25rem; font-weight: 700; margin: 0; color: var(--text-primary); }
        .card-subtitle { font-size: 0.875rem; color: var(--text-secondary); margin-top: 4px; }
        .card-body { padding: 24px; }

        .btn { padding: 12px 20px; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; display: inline-block; text-decoration: none; text-align: center; }
        .btn-outline { border: 1.5px solid var(--glass-border); color: var(--text-primary); background: transparent; }
        .btn-outline:hover { border-color: var(--accent-blue); color: var(--accent-blue); }

        .badge-unread { background: var(--accent-red); color: white; padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }

        .notification-list { display: flex; flex-direction: column; gap: 16px; }
        .notification-item { background: var(--bg-surface); border-radius: 12px; padding: 16px; border: 1px solid var(--glass-border); display: flex; gap: 16px; align-items: flex-start; border-left: 4px solid transparent; transition: all 0.2s; backdrop-filter: blur(10px); }
        .notification-item.unread { border-left-color: var(--accent-blue); background: rgba(59, 130, 246, 0.05); }
        .notification-item:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); border-color: var(--accent-blue); }

        .notif-icon { width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .icon-reminder { background: rgba(245, 158, 11, 0.1); color: var(--accent-orange); }
        .icon-system { background: rgba(59, 130, 246, 0.1); color: var(--accent-blue); }
        .icon-payment { background: rgba(16, 185, 129, 0.1); color: var(--accent-green); }
        .icon-exam { background: rgba(139, 92, 246, 0.1); color: var(--accent-purple); }

        .notif-body { flex: 1; }
        .notif-title { font-weight: 700; color: var(--text-primary); font-size: 1rem; margin: 0 0 4px; }
        .notif-message { font-size: 0.875rem; color: var(--text-secondary); margin: 0 0 8px; line-height: 1.5; }
        .notif-meta { display: flex; justify-content: space-between; align-items: center; font-size: 0.75rem; color: var(--text-secondary); }
        
        .btn-read { background: none; border: none; color: var(--accent-blue); font-size: 0.75rem; font-weight: 600; cursor: pointer; padding: 0; transition: all 0.2s; }
        .btn-read:hover { color: var(--accent-purple); text-decoration: underline; }
        
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
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 Lịch sử & Làm lại</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link active">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Đăng xuất</a>
            </div>
        </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="animate-fade-up" style="margin-bottom: 20px;">
            <h1 style="margin-bottom: 10px;">🔔 Thông báo</h1>
            <p style="color: var(--text-secondary); margin-bottom: 30px;">Nhắc nhở và cập nhật từ hệ thống.</p>
        </div>
        <c:if test="${not empty error}">
            <div style="background:#fef2f2;border:1px solid #fca5a5;color:#b91c1c;padding:14px 18px;border-radius:10px;margin-bottom:20px;font-weight:500;">
                &#10060; ${error}
            </div>
        </c:if>

        <section class="card animate-fade-up" style="animation-delay: 0.1s; margin-bottom: 40px;">
            <div class="card-header">
                <div style="display: flex; align-items: center; gap: var(--sp-3);">
                    <h2 class="card-title">Tất cả thông báo</h2>
                    <c:if test="${unreadCount > 0}">
                        <span class="badge-unread">${unreadCount} chưa đọc</span>
                    </c:if>
                </div>
                <c:if test="${unreadCount > 0}">
                    <form method="POST" action="${pageContext.request.contextPath}/candidate/notifications" style="margin:0;">
                        <input type="hidden" name="action" value="markAllRead">
                        <button type="submit" class="btn btn-outline">Đánh dấu tất cả đã đọc</button>
                    </form>
                </c:if>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="empty-state">
                            <div style="font-size:3rem; margin-bottom: var(--sp-4);">📭</div>
                            <h3 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 8px;">Bạn chưa có thông báo nào</h3>
                            <p style="color: var(--text-secondary);">Khi có nhắc nhở hoặc cập nhật mới, chúng sẽ xuất hiện ở đây.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="notification-list">
                            <c:forEach var="n" items="${notifications}">
                                <div class="notification-item ${!n.read ? 'unread' : ''}">
                                    <div class="notif-icon icon-${n.type.toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${n.type == 'Reminder'}">⏰</c:when>
                                            <c:when test="${n.type == 'System'}">📢</c:when>
                                            <c:when test="${n.type == 'Payment'}">💳</c:when>
                                            <c:when test="${n.type == 'Exam'}">📝</c:when>
                                            <c:otherwise>🔔</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="notif-body">
                                        <div class="notif-title">${n.title}</div>
                                        <div class="notif-message">${n.content}</div>
                                        <div class="notif-meta">
                                            <span>${n.createdAt}</span>
                                            <c:if test="${!n.read}">
                                                <form method="POST" action="${pageContext.request.contextPath}/candidate/notifications" style="margin:0;">
                                                    <input type="hidden" name="action" value="markRead">
                                                    <input type="hidden" name="notificationId" value="${n.notificationId}">
                                                    <button type="submit" class="btn-read">Đánh dấu đã đọc</button>
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
        </section>
    </main>
    </div>
</body>
</html>
