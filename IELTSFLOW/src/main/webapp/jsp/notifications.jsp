<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body { background-color: var(--color-bg); margin: 0; overflow-x: hidden; }

        /* Sidebar */
        .sidebar { width: 260px; position: fixed; top: 0; left: 0; height: 100vh; background: var(--color-surface); border-right: 1px solid var(--color-border); display: flex; flex-direction: column; z-index: var(--z-sticky); transition: transform var(--dur-300) var(--ease-out); }
        .sidebar-header { padding: var(--sp-6); border-bottom: 1px solid var(--color-border); display: flex; align-items: center; gap: var(--sp-3); }
        .sidebar-logo { width: 32px; height: 32px; background: var(--grad-primary); color: white; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-weight: var(--fw-bold); font-size: var(--text-lg); }
        .sidebar-nav { padding: var(--sp-4) var(--sp-3); flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: var(--sp-1); }
        .sidebar-nav-item { display: flex; align-items: center; gap: var(--sp-3); padding: var(--sp-3) var(--sp-4); border-radius: var(--radius-md); color: var(--color-text-secondary); font-weight: var(--fw-medium); text-decoration: none; transition: all var(--dur-200); cursor: pointer; }
        .sidebar-nav-item:hover { background: var(--color-bg-alt); color: var(--color-primary-600); }
        .sidebar-nav-item.active { background: var(--color-primary-50); color: var(--color-primary-600); font-weight: var(--fw-semibold); }
        .nav-divider { height: 1px; background: var(--color-border); margin: var(--sp-4) 0; }
        .sidebar-footer { padding: var(--sp-4); border-top: 1px solid var(--color-border); }
        .user-mini-card { display: flex; align-items: center; gap: var(--sp-3); }
        .user-avatar-small { width: 36px; height: 36px; border-radius: 50%; background: var(--grad-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: var(--fw-bold); font-size: var(--text-sm); flex-shrink: 0; }
        .user-info-small { min-width: 0; flex: 1; }

        /* Main Content */
        .main-content { margin-left: 260px; padding: var(--sp-8); max-width: 1024px; }
        .card { background: var(--color-surface); border-radius: var(--radius-xl); box-shadow: var(--shadow-sm); border: 1px solid var(--color-border); }
        .card-header { padding: var(--sp-6); border-bottom: 1px solid var(--color-border); display: flex; justify-content: space-between; align-items: center; }
        .card-title { font-size: var(--text-xl); font-weight: var(--fw-bold); margin: 0; }
        .card-subtitle { font-size: var(--text-sm); color: var(--color-text-muted); margin-top: var(--sp-1); }
        .card-body { padding: var(--sp-6); }

        .btn { padding: var(--sp-3) var(--sp-5); border-radius: var(--radius-md); font-weight: var(--fw-semibold); font-size: var(--text-sm); cursor: pointer; border: none; transition: all var(--dur-200); display: inline-block; text-decoration: none; text-align: center; }
        .btn-outline { border: 1.5px solid var(--color-border); color: var(--color-text-primary); background: transparent; }
        .btn-outline:hover { border-color: var(--color-primary-400); color: var(--color-primary-600); }

        .badge-unread { background: var(--color-danger-500); color: white; padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }

        .notification-list { display: flex; flex-direction: column; gap: var(--sp-4); }
        .notification-item { background: white; border-radius: var(--radius-md); padding: var(--sp-4); border: 1px solid var(--color-border); display: flex; gap: var(--sp-4); align-items: flex-start; border-left: 4px solid transparent; transition: box-shadow var(--dur-200), border-color var(--dur-200); }
        .notification-item.unread { border-left-color: var(--color-primary-500); background: var(--color-primary-50); }
        .notification-item:hover { box-shadow: var(--shadow-sm); }

        .notif-icon { width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .icon-reminder { background: #fff7ed; color: #ea580c; }
        .icon-system { background: #eff6ff; color: #2563eb; }
        .icon-payment { background: #f0fdf4; color: #16a34a; }
        .icon-exam { background: #fdf4ff; color: #c026d3; }

        .notif-body { flex: 1; }
        .notif-title { font-weight: var(--fw-bold); color: var(--color-text-primary); font-size: var(--text-base); margin: 0 0 4px; }
        .notif-message { font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0 0 8px; line-height: 1.5; }
        .notif-meta { display: flex; justify-content: space-between; align-items: center; font-size: var(--text-xs); color: var(--color-text-muted); }
        
        .btn-read { background: none; border: none; color: var(--color-primary-600); font-size: var(--text-xs); font-weight: var(--fw-semibold); cursor: pointer; padding: 0; transition: color var(--dur-200); }
        .btn-read:hover { color: var(--color-primary-800); text-decoration: underline; }
        
        .empty-state { text-align: center; padding: var(--sp-12) var(--sp-4); color: var(--color-text-muted); }
        .empty-state p { font-size: var(--text-base); margin-top: var(--sp-4); }

        .mobile-toggle { display: none; position: fixed; top: var(--sp-4); left: var(--sp-4); z-index: var(--z-max); background: white; border-radius: var(--radius-md); padding: var(--sp-2); box-shadow: var(--shadow-md); border: none; cursor: pointer; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: var(--sp-12) var(--sp-4) var(--sp-4); }
            .mobile-toggle { display: block; }
        }
    </style>
</head>
<body>
    <button class="mobile-toggle" id="mobileToggle">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
    </button>

    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">IF</div>
            <div>
                <div class="fw-bold text-lg">IELTS Flow</div>
                <div class="text-xs text-muted font-medium">TÀI KHOẢN</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/account#profile-section" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                Hồ sơ cá nhân
            </a>
            <a href="${pageContext.request.contextPath}/account#security-section" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                Bảo mật
            </a>
            <c:if test="${sessionScope.roleId != 1}">
            <a href="${pageContext.request.contextPath}/account#goal-section" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                Mục tiêu IELTS
            </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/my-transactions" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                Lịch sử giao dịch
            </a>
            <a href="${pageContext.request.contextPath}/notifications" class="sidebar-nav-item active">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                Thông báo
            </a>
            <a href="${pageContext.request.contextPath}/tickets" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg>
                Ticket hỗ trợ
            </a>

            <div class="nav-divider"></div>

            <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item text-danger">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                Đăng xuất
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="user-mini-card">
                <div class="user-avatar-small" id="sidebarAvatar">${not empty user ? user.fullName.substring(0, 1) : '?'}</div>
                <div class="user-info-small">
                    <div class="text-sm fw-bold truncate">${not empty user ? user.fullName : 'Guest'}</div>
                    <div class="text-xs text-muted truncate">${not empty user ? user.email : ''}</div>
                </div>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="mb-8">
            <h1 class="text-3xl fw-bold text-primary">Thông báo</h1>
            <p class="text-muted mt-2">Nhắc nhở và cập nhật từ hệ thống.</p>
        </div>

        <c:if test="${not empty error}">
            <div style="background:#fef2f2;border:1px solid #fca5a5;color:#b91c1c;padding:14px 18px;border-radius:10px;margin-bottom:20px;font-weight:500;">
                &#10060; ${error}
            </div>
        </c:if>

        <section class="card mb-8">
            <div class="card-header">
                <div style="display: flex; align-items: center; gap: var(--sp-3);">
                    <h2 class="card-title">Tất cả thông báo</h2>
                    <c:if test="${unreadCount > 0}">
                        <span class="badge-unread">${unreadCount} chưa đọc</span>
                    </c:if>
                </div>
                <c:if test="${unreadCount > 0}">
                    <form method="POST" action="${pageContext.request.contextPath}/notifications" style="margin:0;">
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
                            <h3 class="text-xl fw-bold mb-2">Bạn chưa có thông báo nào</h3>
                            <p>Khi có nhắc nhở hoặc cập nhật mới, chúng sẽ xuất hiện ở đây.</p>
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
                                                <form method="POST" action="${pageContext.request.contextPath}/notifications" style="margin:0;">
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

    <script>
        document.getElementById('mobileToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('open');
        });
    </script>
</body>
</html>
