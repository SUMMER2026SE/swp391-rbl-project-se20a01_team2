<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>B&#7843;o m&#7853;t - IELTSFlow</title>
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
        .card-header { padding: var(--sp-6); border-bottom: 1px solid var(--color-border); }
        .card-title { font-size: var(--text-xl); font-weight: var(--fw-bold); margin: 0; }
        .card-subtitle { font-size: var(--text-sm); color: var(--color-text-muted); margin-top: var(--sp-1); }
        .card-body { padding: var(--sp-6); }

        .form-group { margin-bottom: var(--sp-4); }
        .form-label { display: block; font-size: var(--text-sm); font-weight: var(--fw-semibold); color: var(--color-text-secondary); margin-bottom: var(--sp-2); }
        .form-label-required::after { content: ' *'; color: var(--color-danger-500); }
        .form-input { width: 100%; padding: var(--sp-3); border: 1.5px solid var(--color-border); border-radius: var(--radius-md); font-size: var(--text-base); font-family: inherit; box-sizing: border-box; transition: border-color var(--dur-200), box-shadow var(--dur-200); }
        .form-input:focus { outline: none; border-color: var(--color-primary-500); box-shadow: 0 0 0 3px var(--color-primary-100); }
        .form-input-wrap { position: relative; }

        .btn { padding: var(--sp-3) var(--sp-5); border-radius: var(--radius-md); font-weight: var(--fw-semibold); font-size: var(--text-sm); cursor: pointer; border: none; transition: all var(--dur-200); display: inline-block; text-decoration: none; text-align: center; }
        .btn-primary { background: var(--color-primary-600); color: white; }
        .btn-primary:hover { background: var(--color-primary-700); color: white; }

        .toast-container { position: fixed; bottom: var(--sp-6); right: var(--sp-6); z-index: var(--z-toast); display: flex; flex-direction: column; gap: var(--sp-2); }
        .toast { padding: var(--sp-3) var(--sp-4); border-radius: var(--radius-md); background: white; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: var(--sp-3); transform: translateX(100%); opacity: 0; transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
        .toast.show { transform: translateX(0); opacity: 1; }
        .toast-success { border-left: 4px solid var(--color-success-500); }
        .toast-error { border-left: 4px solid var(--color-danger-500); }

        .mobile-toggle { display: none; position: fixed; top: var(--sp-4); left: var(--sp-4); z-index: var(--z-max); background: white; border-radius: var(--radius-md); padding: var(--sp-2); box-shadow: var(--shadow-md); border: none; cursor: pointer; }
        
        .strength-bar { display: flex; gap: 4px; height: 4px; margin-top: var(--sp-2); }
        .strength-seg { flex: 1; background: var(--color-gray-200); border-radius: 2px; transition: background var(--dur-300); }
        .strength-seg.weak { background: var(--color-danger-500); }
        .strength-seg.medium { background: var(--color-warning-500); }
        .strength-seg.strong { background: var(--color-success-500); }
        
        .flex-col { display: flex; flex-direction: column; }
        .gap-4 { gap: 1rem; }
        .flex { display: flex; }
        .justify-start { justify-content: flex-start; }
        .mt-4 { margin-top: 1rem; }
        .mb-8 { margin-bottom: 2rem; }
        .text-3xl { font-size: 1.875rem; line-height: 2.25rem; }
        .fw-bold { font-weight: 700; }
        .text-primary { color: var(--color-primary-900); }
        .text-muted { color: var(--color-text-muted); }
        .mt-2 { margin-top: 0.5rem; }
        .hidden { display: none; }

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
        <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: inherit;">
            <div class="sidebar-header">
                <div class="sidebar-logo">IF</div>
                <div>
                    <div class="fw-bold text-lg">IELTS Flow</div>
                    <div class="text-xs text-muted font-medium">T&#192;I KHO&#7842;N</div>
                </div>
            </div>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/account" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                Hồ sơ cá nhân
            </a>
            <a href="${pageContext.request.contextPath}/change-password" class="sidebar-nav-item active">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                Bảo mật
            </a>
            <c:if test="${sessionScope.roleId == 3}">
            <a href="${pageContext.request.contextPath}/ielts-target" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                Mục tiêu IELTS
            </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/my-transactions" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                Lịch sử giao dịch
            </a>

            <div class="nav-divider"></div>

            <c:if test="${sessionScope.roleId == 3}">
            <a href="${pageContext.request.contextPath}/candidate/dashboard" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                Bảng điều khiển học tập
            </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                Trang chủ
            </a>
            <c:if test="${sessionScope.roleId == 1 || sessionScope.roleId == 2}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                Hệ thống
            </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item text-danger">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                Đăng xuất
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="user-mini-card">
                <div class="user-avatar-small" id="sidebarAvatar">
                    <c:choose>
                        <c:when test="${not empty user.profilePic}">
                            <img src="${pageContext.request.contextPath}${user.profilePic}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            ${not empty user ? user.fullName.substring(0, 1) : '?'}
                        </c:otherwise>
                    </c:choose>
                </div>
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
            <h1 class="text-3xl fw-bold text-primary">B&#7843;o m&#7853;t t&#224;i kho&#7843;n</h1>
            <p class="text-muted mt-2">&#272;&#7893;i m&#7853;t kh&#7849;u &#273;&#7875; b&#7843;o v&#7879; t&#224;i kho&#7843;n c&#7911;a b&#7841;n.</p>
        </div>

        <c:if test="${not empty param.success}">
            <div style="background:#dcfce7;border:1px solid #86efac;color:#15803d;padding:14px 18px;border-radius:10px;margin-bottom:20px;font-weight:500;">
                &#10004; ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background:#fef2f2;border:1px solid #fca5a5;color:#b91c1c;padding:14px 18px;border-radius:10px;margin-bottom:20px;font-weight:500;">
                &#10060; ${error}
            </div>
        </c:if>

        <section class="card mb-8">
            <div class="card-header">
                <h2 class="card-title">&#272;&#7893;i m&#7853;t kh&#7849;u</h2>
            </div>
            <div class="card-body">
                <form id="passwordForm" action="${pageContext.request.contextPath}/change-password" method="POST" style="max-width: 400px;" class="flex-col gap-4">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="form-group">
                        <label class="form-label form-label-required">Mật khẩu hiện tại</label>
                        <div class="form-input-wrap">
                            <input type="password" class="form-input" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label form-label-required">Mật khẩu mới</label>
                        <div class="form-input-wrap">
                            <input type="password" class="form-input" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                        </div>
                        <div class="strength-bar">
                            <div class="strength-seg" id="str-1"></div>
                            <div class="strength-seg" id="str-2"></div>
                            <div class="strength-seg" id="str-3"></div>
                            <div class="strength-seg" id="str-4"></div>
                        </div>
                        <div style="font-size: 12px; color: var(--color-text-muted); margin-top: 4px;" id="str-label">Độ mạnh mật khẩu</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label form-label-required">Xác nhận mật khẩu mới</label>
                        <div class="form-input-wrap">
                            <input type="password" class="form-input" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                        <div id="passwordMatchError" class="hidden" style="color: var(--color-danger-500); font-size: 12px; margin-top: 4px;">Mật khẩu không khớp</div>
                    </div>
                    <div class="flex justify-start mt-4">
                        <button type="submit" class="btn btn-primary">Lưu mật khẩu mới</button>
                    </div>
                </form>
            </div>
        </section>
    </main>

    <div class="toast-container" id="toastContainer"></div>

    <script src="${pageContext.request.contextPath}/js/account.js?v=9"></script>
</body>
</html>
