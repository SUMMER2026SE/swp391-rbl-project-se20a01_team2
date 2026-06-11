<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>T&#224;i kho&#7843;n - IELTSFlow</title>
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
        .main-content { margin-left: 260px; padding: var(--sp-8); max-width: 780px; }
        .card { background: var(--color-surface); border-radius: var(--radius-xl); box-shadow: var(--shadow-sm); border: 1px solid var(--color-border); }
        .card-header { padding: var(--sp-6); border-bottom: 1px solid var(--color-border); }
        .card-title { font-size: var(--text-xl); font-weight: var(--fw-bold); margin: 0; }
        .card-subtitle { font-size: var(--text-sm); color: var(--color-text-muted); margin-top: var(--sp-1); }
        .card-body { padding: var(--sp-6); }

        .avatar-upload-container { display: flex; align-items: center; gap: var(--sp-6); margin-bottom: var(--sp-6); }
        .avatar-large { width: 80px; height: 80px; border-radius: 50%; background: var(--grad-primary); color: white; display: flex; align-items: center; justify-content: center; font-size: var(--text-3xl); font-weight: var(--fw-bold); position: relative; cursor: pointer; flex-shrink: 0; overflow: hidden; }
        .avatar-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity var(--dur-200); border-radius: 50%; }
        .avatar-large:hover .avatar-overlay { opacity: 1; }

        .form-group { margin-bottom: var(--sp-4); }
        .form-label { display: block; font-size: var(--text-sm); font-weight: var(--fw-semibold); color: var(--color-text-secondary); margin-bottom: var(--sp-2); }
        .form-label-required::after { content: ' *'; color: var(--color-danger-500); }
        .form-input { width: 100%; padding: var(--sp-3); border: 1.5px solid var(--color-border); border-radius: var(--radius-md); font-size: var(--text-base); font-family: inherit; box-sizing: border-box; transition: border-color var(--dur-200), box-shadow var(--dur-200); }
        .form-input:focus { outline: none; border-color: var(--color-primary-500); box-shadow: 0 0 0 3px var(--color-primary-100); }
        .form-input-wrap { position: relative; }
        .form-hint { font-size: var(--text-xs); color: var(--color-text-muted); margin-top: var(--sp-1); }

        .btn { padding: var(--sp-3) var(--sp-5); border-radius: var(--radius-md); font-weight: var(--fw-semibold); font-size: var(--text-sm); cursor: pointer; border: none; transition: all var(--dur-200); }
        .btn-cta { background: var(--grad-primary); color: white; }
        .btn-cta:hover { opacity: 0.9; }
        .btn-primary { background: var(--color-primary-600); color: white; }
        .btn-primary:hover { background: var(--color-primary-700); }

        .strength-bar { display: flex; gap: 4px; height: 4px; margin-top: var(--sp-2); }
        .strength-seg { flex: 1; background: var(--color-gray-200); border-radius: 2px; transition: background var(--dur-300); }
        .strength-label { font-size: var(--text-xs); color: var(--color-text-muted); margin-top: var(--sp-1); }
        .form-error { color: var(--color-danger-500); font-size: var(--text-xs); margin-top: var(--sp-1); }

        .gap-indicator { margin-top: var(--sp-4); }
        .gap-message { font-weight: var(--fw-semibold); text-align: center; color: var(--color-primary-700); }
        .gap-bar-track { height: 12px; background: var(--color-gray-200); border-radius: 6px; position: relative; overflow: hidden; margin-top: var(--sp-2); }
        .gap-bar-current, .gap-bar-target { position: absolute; top: 0; height: 100%; border-radius: 6px; transition: width var(--dur-300); }
        .gap-bar-current { background: var(--color-primary-500); }
        .gap-bar-target { background: var(--color-primary-200); }

        .band-selector { display: flex; flex-wrap: wrap; gap: var(--sp-2); }
        .band-option { padding: var(--sp-2) var(--sp-3); border: 1.5px solid var(--color-border); border-radius: var(--radius-md); cursor: pointer; font-weight: var(--fw-semibold); font-size: var(--text-sm); transition: all var(--dur-200); }
        .band-option:hover { border-color: var(--color-primary-400); }
        .band-option.selected { background: var(--color-primary-500); color: white; border-color: var(--color-primary-500); }

        .toast-container { position: fixed; bottom: var(--sp-6); right: var(--sp-6); z-index: var(--z-toast); display: flex; flex-direction: column; gap: var(--sp-2); }
        .toast { padding: var(--sp-3) var(--sp-4); border-radius: var(--radius-md); background: white; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: var(--sp-3); transform: translateX(100%); opacity: 0; transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
        .toast.show { transform: translateX(0); opacity: 1; }
        .toast-success { border-left: 4px solid var(--color-success-500); }
        .toast-error { border-left: 4px solid var(--color-danger-500); }

        .mobile-toggle { display: none; position: fixed; top: var(--sp-4); left: var(--sp-4); z-index: var(--z-max); background: white; border-radius: var(--radius-md); padding: var(--sp-2); box-shadow: var(--shadow-md); border: none; cursor: pointer; }
        .hidden { display: none !important; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: var(--sp-12) var(--sp-4) var(--sp-4); }
            .mobile-toggle { display: block; }
            .avatar-upload-container { flex-direction: column; text-align: center; }
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
                <div class="text-xs text-muted font-medium">T&#192;I KHO&#7842;N</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="#profile-section" class="sidebar-nav-item active" data-target="profile-section">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                H&#7891; s&#417; c&#225; nh&#226;n
            </a>
            <a href="#security-section" class="sidebar-nav-item" data-target="security-section">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                B&#7843;o m&#7853;t
            </a>
            <c:if test="${sessionScope.roleId != 1}">
            <a href="#goal-section" class="sidebar-nav-item" data-target="goal-section">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                M&#7909;c ti&#234;u IELTS
            </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/notifications" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                Th&#244;ng b&#225;o
            </a>
            <a href="${pageContext.request.contextPath}/tickets" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg>
                Ticket h&#7895; tr&#7907;
            </a>

            <div class="nav-divider"></div>

            <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                Trang ch&#7911;
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item text-danger">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                &#272;&#259;ng xu&#7845;t
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
            <h1 class="text-3xl fw-bold text-primary">C&#224;i &#273;&#7863;t t&#224;i kho&#7843;n</h1>
            <p class="text-muted mt-2">Qu&#7843;n l&#253; th&#244;ng tin c&#225; nh&#226;n v&#224; m&#7909;c ti&#234;u h&#7885;c t&#7853;p.</p>
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

        <!-- Profile Section -->
        <section id="profile-section" class="card mb-8">
            <div class="card-header">
                <h2 class="card-title">H&#7891; s&#417; c&#225; nh&#226;n</h2>
            </div>
            <div class="card-body">
                <div class="avatar-upload-container">
                    <input type="file" id="avatarInput" accept="image/png, image/jpeg" style="display: none;">
                    <div class="avatar-large" id="profileAvatar">
                        <img id="avatarPreview" src="" alt="Avatar" style="display: none; width: 100%; height: 100%; border-radius: 50%; object-fit: cover; position: absolute; z-index: 1;">
                        <span id="profileInitials" style="position: relative; z-index: 2;">${not empty user ? user.fullName.substring(0, 1) : '?'}</span>
                        <div class="avatar-overlay" style="z-index: 3;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path><circle cx="12" cy="13" r="4"></circle></svg>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg fw-bold">${not empty user ? user.fullName : ''}</h3>
                        <p class="text-sm text-muted">Click v&#224;o &#7843;nh &#273;&#7875; thay &#273;&#7893;i avatar. H&#7895; tr&#7907; JPG, PNG.</p>
                    </div>
                </div>

                <form id="profileForm" action="${pageContext.request.contextPath}/account" method="POST" class="flex-col gap-4">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="form-group">
                        <label class="form-label form-label-required">H&#7885; v&#224; t&#234;n</label>
                        <div class="form-input-wrap">
                            <input type="text" class="form-input" id="fullName" name="fullName" placeholder="Nh&#7853;p h&#7885; v&#224; t&#234;n" value="${not empty user ? user.fullName : ''}" required>
                        </div>
                    </div>

                    <div class="form-group mt-2">
                        <label class="form-label">Email</label>
                        <div class="form-input-wrap">
                            <input type="email" class="form-input" id="email" value="${not empty user ? user.email : ''}" disabled style="background: var(--color-gray-100); color: var(--color-text-muted);">
                        </div>
                        <p class="form-hint">Email kh&#244;ng th&#7875; thay &#273;&#7893;i.</p>
                    </div>

                    <div class="flex justify-end mt-4">
                        <button type="submit" class="btn btn-cta">L&#432;u thay &#273;&#7893;i</button>
                    </div>
                </form>
            </div>
        </section>

        <!-- Security Section -->
        <section id="security-section" class="card mb-8">
            <div class="card-header">
                <h2 class="card-title">B&#7843;o m&#7853;t</h2>
            </div>
            <div class="card-body">
                <p class="text-muted mb-4">&#272;&#7893;i m&#7853;t kh&#7849;u &#273;&#7875; b&#7843;o v&#7879; t&#224;i kho&#7843;n c&#7911;a b&#7841;n.</p>
                <a href="${pageContext.request.contextPath}/change-password" class="btn btn-primary">&#272;&#7893;i m&#7853;t kh&#7849;u &rarr;</a>
            </div>
        </section>

        <c:if test="${sessionScope.roleId != 1}">
        <!-- Goal Section -->
        <section id="goal-section" class="card mb-12">
            <div class="card-header">
                <h2 class="card-title">M&#7909;c ti&#234;u IELTS</h2>
                <div class="card-subtitle">Theo d&#245;i h&#224;nh tr&#236;nh &#273;&#7841;t band &#273;i&#7875;m m&#417; &#432;&#7899;c</div>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label">Band &#273;i&#7875;m hi&#7879;n t&#7841;i</label>
                    <div class="band-selector" id="currentBandSelector"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Band &#273;i&#7875;m m&#7909;c ti&#234;u</label>
                    <div class="band-selector" id="targetBandSelector"></div>
                </div>
                <div class="form-group" style="max-width: 300px;">
                    <label class="form-label">Ng&#224;y d&#7921; &#273;&#7883;nh thi</label>
                    <div class="form-input-wrap">
                        <input type="date" class="form-input" id="examDate">
                    </div>
                </div>
                <div class="gap-indicator">
                    <div class="gap-message" id="gapMessage">H&#227;y thi&#7871;t l&#7853;p &#273;i&#7875;m &#273;&#7875; xem ti&#7871;n &#273;&#7897;!</div>
                    <div class="gap-bar-track">
                        <div class="gap-bar-current" id="gapBarCurrent"></div>
                        <div class="gap-bar-target" id="gapBarTarget"></div>
                    </div>
                    <div class="flex justify-between text-xs text-muted font-medium mt-2">
                        <span>0.0</span>
                        <span>9.0</span>
                    </div>
                </div>
                <div class="flex justify-end mt-2">
                    <button type="button" id="saveGoalBtn" class="btn btn-cta">L&#432;u m&#7909;c ti&#234;u</button>
                </div>
            </div>
        </section>
        </c:if>
    </main>

    <div class="toast-container" id="toastContainer"></div>

    <script src="${pageContext.request.contextPath}/js/account.js?v=4"></script>
</body>
</html>
