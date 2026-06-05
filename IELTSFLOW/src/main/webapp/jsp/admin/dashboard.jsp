<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard – IELTS Flow</title>
  <meta name="description" content="Trang qu&#7843;n tr&#7883; h&#7879; th&#7889;ng IELTS Flow">
  
  <c:if test="${empty users}">
    <script>
      window.location.replace('/IELTSFLOW/admin/dashboard');
    </script>
  </c:if>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    :root {
      --bg:       #0a0e1a;
      --bg2:      #111827;
      --bg3:      #1a2235;
      --border:   rgba(255,255,255,0.08);
      --primary:  #3b82f6;
      --success:  #10b981;
      --warning:  #f59e0b;
      --danger:   #ef4444;
      --purple:   #8b5cf6;
      --text1:    #f1f5f9;
      --text2:    #94a3b8;
      --text3:    #64748b;
      --glass:    rgba(255,255,255,0.04);
      --ease:     cubic-bezier(0.16,1,0.3,1);
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', sans-serif;
      background: var(--bg);
      color: var(--text1);
      min-height: 100vh;
      display: flex;
    }

    /* ── Sidebar ────────────────── */
    .sidebar {
      width: 260px;
      background: var(--bg2);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0; left: 0; bottom: 0;
      z-index: 100;
      transition: transform 0.3s var(--ease);
    }
    .sidebar-logo {
      padding: 1.5rem 1.5rem 1rem;
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }
    .logo-icon {
      width: 38px; height: 38px;
      background: linear-gradient(135deg,#3b82f6,#8b5cf6);
      border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; font-weight: 900; color: #fff;
    }
    .logo-text { font-size: 1.125rem; font-weight: 800; }
    .logo-badge {
      font-size: 0.625rem; font-weight: 700; letter-spacing: .05em;
      background: rgba(139,92,246,0.2); color: #a78bfa;
      border: 1px solid rgba(139,92,246,0.3);
      padding: 2px 8px; border-radius: 20px; margin-top: 2px;
    }
    .sidebar-nav {
      padding: 1rem 0.75rem;
      flex: 1;
      overflow-y: auto;
    }
    .nav-section-label {
      font-size: 0.625rem; font-weight: 700; letter-spacing: .12em;
      color: var(--text3); text-transform: uppercase;
      padding: 0.75rem 0.75rem 0.25rem;
    }
    .nav-item {
      display: flex; align-items: center; gap: 0.75rem;
      padding: 0.75rem 0.875rem;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.2s;
      color: var(--text2);
      font-size: 0.875rem; font-weight: 500;
      text-decoration: none;
      margin-bottom: 2px;
    }
    .nav-item:hover { background: rgba(255,255,255,0.05); color: var(--text1); }
    .nav-item.active {
      background: rgba(59,130,246,0.12);
      color: #60a5fa;
    }
    .nav-item.active .nav-icon { color: var(--primary); }
    .nav-icon { font-size: 1.1rem; width: 20px; text-align: center; flex-shrink: 0; }
    .nav-badge {
      margin-left: auto;
      background: var(--primary);
      color: #fff;
      font-size: 0.625rem; font-weight: 700;
      padding: 2px 7px; border-radius: 20px;
    }
    .sidebar-footer {
      padding: 1rem 0.75rem;
      border-top: 1px solid var(--border);
    }
    .admin-profile {
      display: flex; align-items: center; gap: 0.75rem;
      padding: 0.625rem 0.75rem; border-radius: 10px;
      cursor: pointer; transition: background 0.2s;
    }
    .admin-profile:hover { background: rgba(255,255,255,0.05); }
    .admin-avatar {
      width: 36px; height: 36px; border-radius: 10px;
      background: linear-gradient(135deg,#3b82f6,#8b5cf6);
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 0.875rem;
    }
    .admin-name { font-size: 0.875rem; font-weight: 600; }
    .admin-role { font-size: 0.75rem; color: var(--text3); }

    /* ── Main Content ────────────── */
    .main {
      margin-left: 260px;
      flex: 1;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    .topbar {
      position: sticky; top: 0; z-index: 50;
      background: rgba(10,14,26,0.85);
      backdrop-filter: blur(20px);
      border-bottom: 1px solid var(--border);
      padding: 1rem 2rem;
      display: flex; align-items: center; justify-content: space-between;
    }
    .page-title { font-size: 1.125rem; font-weight: 700; }
    .page-sub   { font-size: 0.8125rem; color: var(--text3); }
    .topbar-actions { display: flex; align-items: center; gap: 0.75rem; }
    .btn {
      display: inline-flex; align-items: center; gap: 0.5rem;
      padding: 0.5rem 1rem; border-radius: 8px;
      font-size: 0.8125rem; font-weight: 600; cursor: pointer;
      border: none; transition: all 0.2s; text-decoration: none;
    }
    .btn-primary { background: var(--primary); color: #fff; }
    .btn-primary:hover { background: #2563eb; transform: translateY(-1px); }
    .btn-ghost {
      background: rgba(255,255,255,0.06);
      color: var(--text2);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover { background: rgba(255,255,255,0.1); color: var(--text1); }

    /* ── Content Area ─────────────── */
    .content { padding: 2rem; flex: 1; }

    /* ── Stats Grid ─────────────── */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      margin-bottom: 2rem;
    }
    .stat-card {
      background: var(--bg2);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 1.25rem;
      position: relative;
      overflow: hidden;
      transition: transform 0.2s var(--ease), border-color 0.2s;
    }
    .stat-card:hover { transform: translateY(-2px); border-color: rgba(255,255,255,0.15); }
    .stat-card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 2px;
    }
    .stat-card.blue::before   { background: linear-gradient(90deg,#3b82f6,#60a5fa); }
    .stat-card.green::before  { background: linear-gradient(90deg,#10b981,#34d399); }
    .stat-card.amber::before  { background: linear-gradient(90deg,#f59e0b,#fbbf24); }
    .stat-card.purple::before { background: linear-gradient(90deg,#8b5cf6,#a78bfa); }
    .stat-card.red::before    { background: linear-gradient(90deg,#ef4444,#f87171); }
    .stat-icon {
      width: 42px; height: 42px; border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.25rem; margin-bottom: 1rem;
    }
    .stat-icon.blue   { background: rgba(59,130,246,0.15); }
    .stat-icon.green  { background: rgba(16,185,129,0.15); }
    .stat-icon.amber  { background: rgba(245,158,11,0.15); }
    .stat-icon.purple { background: rgba(139,92,246,0.15); }
    .stat-icon.red    { background: rgba(239,68,68,0.15); }
    .stat-value {
      font-size: 2rem; font-weight: 900;
      line-height: 1; margin-bottom: 0.25rem;
      letter-spacing: -0.02em;
    }
    .stat-value.blue   { color: #60a5fa; }
    .stat-value.green  { color: #34d399; }
    .stat-value.amber  { color: #fbbf24; }
    .stat-value.purple { color: #a78bfa; }
    .stat-value.red    { color: #f87171; }
    .stat-label { font-size: 0.8125rem; color: var(--text3); }
    .stat-change {
      margin-top: 0.5rem;
      font-size: 0.75rem; font-weight: 600;
      color: var(--success);
    }

    /* ── Main Grid ──────────────── */
    .dashboard-grid {
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 1.25rem;
      margin-bottom: 1.25rem;
    }
    @media (max-width: 1100px) { .dashboard-grid { grid-template-columns: 1fr; } }

    /* ── Cards ──────────────────── */
    .card {
      background: var(--bg2);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
    }
    .card-header {
      display: flex; align-items: center; justify-content: space-between;
      padding: 1.25rem 1.5rem;
      border-bottom: 1px solid var(--border);
    }
    .card-title { font-size: 0.9375rem; font-weight: 700; }
    .card-sub   { font-size: 0.75rem; color: var(--text3); margin-top: 2px; }
    .card-body  { padding: 1.25rem 1.5rem; }

    /* ── Chart ──────────────────── */
    .chart-wrap {
      position: relative; height: 220px;
      padding: 0.5rem 0;
    }

    /* ── Provider breakdown ─────── */
    .provider-list { display: flex; flex-direction: column; gap: 0.75rem; }
    .provider-item {
      display: flex; align-items: center; justify-content: space-between;
      gap: 0.75rem;
    }
    .provider-info { display: flex; align-items: center; gap: 0.625rem; flex: 1; }
    .provider-icon {
      width: 32px; height: 32px; border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.875rem; flex-shrink: 0;
    }
    .provider-bar-wrap {
      flex: 1; height: 6px;
      background: rgba(255,255,255,0.07);
      border-radius: 3px; overflow: hidden;
    }
    .provider-bar {
      height: 100%; border-radius: 3px;
      transition: width 1s var(--ease);
    }
    .provider-pct { font-size: 0.8125rem; font-weight: 700; min-width: 36px; text-align: right; }

    /* ── Table ──────────────────── */
    .table-wrap { overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; }
    thead th {
      text-align: left;
      padding: 0.75rem 1rem;
      font-size: 0.75rem; font-weight: 600; letter-spacing: .05em;
      color: var(--text3); text-transform: uppercase;
      border-bottom: 1px solid var(--border);
    }
    tbody tr {
      border-bottom: 1px solid var(--border);
      transition: background 0.15s;
    }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: rgba(255,255,255,0.03); }
    tbody td {
      padding: 0.875rem 1rem;
      font-size: 0.875rem; vertical-align: middle;
    }
    .user-cell { display: flex; align-items: center; gap: 0.75rem; }
    .user-av {
      width: 34px; height: 34px; border-radius: 10px;
      background: linear-gradient(135deg,#3b82f6,#8b5cf6);
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 0.75rem; flex-shrink: 0;
    }
    .user-name-text { font-weight: 600; font-size: 0.875rem; }
    .user-email     { font-size: 0.75rem; color: var(--text3); }
    .badge {
      display: inline-flex; align-items: center; gap: 0.3rem;
      padding: 0.25rem 0.625rem; border-radius: 20px;
      font-size: 0.75rem; font-weight: 600;
    }
    .badge-dot { width: 6px; height: 6px; border-radius: 50%; }
    .badge.active  { background: rgba(16,185,129,0.12); color: #34d399; }
    .badge.active .badge-dot { background: #34d399; }
    .badge.inactive { background: rgba(245,158,11,0.12); color: #fbbf24; }
    .badge.inactive .badge-dot { background: #fbbf24; }
    .badge.banned  { background: rgba(239,68,68,0.12); color: #f87171; }
    .badge.banned .badge-dot  { background: #f87171; }
    .badge.admin   { background: rgba(139,92,246,0.12); color: #a78bfa; }
    .badge.candidate { background: rgba(59,130,246,0.1); color: #60a5fa; }
    .badge.google  { background: rgba(234,67,53,0.1); color: #f97316; }
    .badge.local   { background: rgba(255,255,255,0.07); color: var(--text2); }

    /* ── Search / Filter ─────────── */
    .table-toolbar {
      padding: 1rem 1.5rem;
      border-bottom: 1px solid var(--border);
      display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap;
    }
    .search-wrap {
      position: relative; flex: 1; min-width: 200px;
    }
    .search-wrap input {
      width: 100%; padding: 0.5rem 0.875rem 0.5rem 2.25rem;
      background: rgba(255,255,255,0.05);
      border: 1px solid var(--border);
      border-radius: 8px; color: var(--text1);
      font-size: 0.875rem; outline: none;
      transition: border-color 0.2s;
    }
    .search-wrap input::placeholder { color: var(--text3); }
    .search-wrap input:focus { border-color: var(--primary); }
    .search-icon {
      position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%);
      color: var(--text3); pointer-events: none;
    }
    select.filter-select {
      padding: 0.5rem 0.875rem;
      background: rgba(255,255,255,0.05);
      border: 1px solid var(--border);
      border-radius: 8px; color: var(--text1);
      font-size: 0.8125rem; font-weight: 500; cursor: pointer;
      outline: none;
    }

    /* ── Action Buttons ────────── */
    .action-btn {
      display: inline-flex; align-items: center; gap: 0.375rem;
      padding: 0.3125rem 0.75rem; border-radius: 6px;
      font-size: 0.75rem; font-weight: 600; cursor: pointer;
      border: none; transition: all 0.2s;
    }
    .action-ban    { background: rgba(239,68,68,0.12); color: #f87171; }
    .action-ban:hover { background: rgba(239,68,68,0.22); }
    .action-unban  { background: rgba(16,185,129,0.12); color: #34d399; }
    .action-unban:hover { background: rgba(16,185,129,0.22); }

    /* ── Loading skeleton ──────── */
    .skeleton {
      background: linear-gradient(90deg, rgba(255,255,255,0.05) 25%, rgba(255,255,255,0.1) 50%, rgba(255,255,255,0.05) 75%);
      background-size: 200% 100%;
      animation: shimmer 1.5s infinite;
      border-radius: 6px;
    }
    @keyframes shimmer { 0%{background-position:200% 0} 100%{background-position:-200% 0} }

    /* ── Toast ─────────────────── */
    #toast-container {
      position: fixed; bottom: 1.5rem; right: 1.5rem;
      z-index: 9999; display: flex; flex-direction: column; gap: 0.75rem;
    }
    .toast {
      display: flex; align-items: flex-start; gap: 0.75rem;
      padding: 0.875rem 1rem; border-radius: 12px; min-width: 280px;
      background: var(--bg2); border: 1px solid var(--border);
      box-shadow: 0 20px 40px rgba(0,0,0,0.4);
      animation: toast-in 0.4s var(--ease);
    }
    @keyframes toast-in { from{opacity:0;transform:translateX(100%)} to{opacity:1;transform:none} }
    @keyframes toast-out { from{opacity:1;transform:none} to{opacity:0;transform:translateX(100%)} }

    /* ── Responsive ─────────────── */
    @media (max-width: 768px) {
      .sidebar { transform: translateX(-100%); }
      .main { margin-left: 0; }
    }
  </style>
</head>
<body>

  <!-- ═══════════ SIDEBAR ═══════════ -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">IF</div>
      <div>
        <div class="logo-text">IELTS Flow</div>
        <div class="logo-badge">ADMIN PANEL</div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-section-label">Tổng quan</div>
      <a href="#dashboard" class="nav-item active" onclick="showSection('dashboard',this)">
        <span class="nav-icon">📊</span> Dashboard
      </a>
      <a href="#users" class="nav-item" onclick="showSection('users',this)">
        <span class="nav-icon">👥</span> Quản lý User
        <span class="nav-badge" id="nav-total-badge">...</span>
      </a>

      <div class="nav-section-label" style="margin-top:.5rem">Hệ thống</div>
      <a href="/IELTSFLOW/index.jsp" class="nav-item">
        <span class="nav-icon">🏠</span> Xem trang chủ
      </a>
      <a href="#" class="nav-item" onclick="confirmLogout()">
        <span class="nav-icon">🚪</span> Đăng xuất
      </a>
    </nav>

    <div class="sidebar-footer">
        <div class="admin-profile">
          <div class="admin-avatar" id="admin-initials">${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1).toUpperCase() : 'A'}</div>
          <div>
            <div class="admin-name" id="admin-name">${not empty sessionScope.fullName ? sessionScope.fullName : 'Admin'}</div>
            <div class="admin-role">Qu&#7843;n tr&#7883; vi&#234;n</div>
          </div>
        </div>
    </div>
  </aside>

  <!-- ═══════════ MAIN ═══════════ -->
  <div class="main">
    <!-- Topbar -->
    <header class="topbar">
      <div>
        <div class="page-title" id="page-title">Dashboard</div>
        <div class="page-sub" id="page-sub">Tổng quan hệ thống IELTS Flow</div>
      </div>
      <div class="topbar-actions">
        <button class="btn btn-ghost" onclick="loadData()">🔄 Làm mới</button>
        <a href="/IELTSFLOW/jsp/account.jsp" class="btn btn-ghost">👋 Hồ sơ</a>
      </div>
    </header>

    <!-- Content -->
    <div class="content">

      <!-- ─ SECTION: DASHBOARD ─ -->
      <div id="section-dashboard">
        <!-- Stats -->
        <div class="stats-grid">
          <div class="stat-card blue">
            <div class="stat-icon blue">&#128105;&#8205;&#128105;&#8205;&#128103;&#8205;&#128102;</div>
            <div class="stat-value blue" id="stat-total">${stats.totalUsers}</div>
            <div class="stat-label">T&#7893;ng ng&#432;&#7901;i d&#249;ng</div>
            <div class="stat-change">&#8593; H&#7879; th&#7889;ng &#273;ang ph&#225;t tri&#7875;n</div>
          </div>
          <div class="stat-card green">
            <div class="stat-icon green">&#9989;</div>
            <div class="stat-value green" id="stat-active">${stats.activeUsers}</div>
            <div class="stat-label">T&#224;i kho&#7843;n Active</div>
          </div>
          <div class="stat-card amber">
            <div class="stat-icon amber">&#127381;</div>
            <div class="stat-value amber" id="stat-today">${stats.newToday}</div>
            <div class="stat-label">&#272;&#259;ng k&#253; h&#244;m nay</div>
          </div>
          <div class="stat-card purple">
            <div class="stat-icon purple">&#128273;</div>
            <div class="stat-value purple" id="stat-google">${stats.googleUsers}</div>
            <div class="stat-label">&#272;&#259;ng nh&#7853;p Google</div>
          </div>
          <div class="stat-card red">
            <div class="stat-icon red">&#10060;</div>
            <div class="stat-value red" id="stat-banned">${stats.bannedUsers}</div>
            <div class="stat-label">T&#224;i kho&#7843;n b&#7883; kh&#243;a</div>
          </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
          <!-- Auth Provider Breakdown -->
          <div class="card">
            <div class="card-header">
              <div>
                <div class="card-title">Phân tích người dùng</div>
                <div class="card-sub">Phương thức đăng nhập & trạng thái</div>
              </div>
            </div>
            <div class="card-body">
              <div class="chart-wrap">
                <canvas id="authChart"></canvas>
              </div>
            </div>
          </div>

          <!-- Quick Metrics -->
          <div class="card">
            <div class="card-header">
              <div>
                <div class="card-title">Phương thức đăng nhập</div>
                <div class="card-sub">Tỷ lệ Google vs. Email</div>
              </div>
            </div>
            <div class="card-body">
              <div class="provider-list" id="provider-list">
                <div class="provider-item">
                  <div class="provider-info">
                    <div class="provider-icon" style="background:rgba(234,67,53,0.15)">🔗</div>
                    <div>
                      <div style="font-size:.875rem;font-weight:600">Google</div>
                      <div style="font-size:.75rem;color:var(--text3)" id="google-count">— users</div>
                    </div>
                  </div>
                  <div class="provider-bar-wrap">
                    <div class="provider-bar" id="google-bar" style="width:0%;background:linear-gradient(90deg,#ea4335,#fb923c)"></div>
                  </div>
                  <div class="provider-pct" id="google-pct" style="color:#fb923c">—%</div>
                </div>
                <div class="provider-item" style="margin-top:.75rem">
                  <div class="provider-info">
                    <div class="provider-icon" style="background:rgba(59,130,246,0.15)">📧</div>
                    <div>
                      <div style="font-size:.875rem;font-weight:600">Email / Password</div>
                      <div style="font-size:.75rem;color:var(--text3)" id="local-count">— users</div>
                    </div>
                  </div>
                  <div class="provider-bar-wrap">
                    <div class="provider-bar" id="local-bar" style="width:0%;background:linear-gradient(90deg,#3b82f6,#60a5fa)"></div>
                  </div>
                  <div class="provider-pct" id="local-pct" style="color:#60a5fa">—%</div>
                </div>
              </div>

              <div style="margin-top:1.5rem;padding-top:1rem;border-top:1px solid var(--border)">
                <div style="font-size:.75rem;font-weight:600;letter-spacing:.05em;text-transform:uppercase;color:var(--text3);margin-bottom:.75rem">Trạng thái tài khoản</div>
                <div style="display:flex;flex-direction:column;gap:.5rem" id="status-breakdown">
                  <!-- filled by JS -->
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ─ SECTION: USER MANAGEMENT ─ -->
      <div id="section-users" style="display:none">
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title">Qu&#7843;n l&#253; ng&#432;&#7901;i d&#249;ng</div>
              <div class="card-sub" id="user-count-label">
                <c:choose>
                  <c:when test="${not empty stats.totalUsers}">${stats.totalUsers} ng&#432;&#7901;i d&#249;ng trong h&#7879; th&#7889;ng</c:when>
                  <c:otherwise>0 ng&#432;&#7901;i d&#249;ng trong h&#7879; th&#7889;ng</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
          <div class="table-toolbar">
            <div class="search-wrap">
              <span class="search-icon">🔍</span>
              <input type="text" id="search-input" placeholder="Tìm theo tên hoặc email..." oninput="filterTable()">
            </div>
            <select class="filter-select" id="status-filter" onchange="filterTable()">
              <option value="">Tất cả trạng thái</option>
              <option value="Active">✅ Active</option>
              <option value="Inactive">⏳ Inactive</option>
              <option value="Banned">🔒 Banned</option>
            </select>
            <select class="filter-select" id="provider-filter" onchange="filterTable()">
              <option value="">Tất cả nguồn</option>
              <option value="Google">🔗 Google</option>
              <option value="Local">📧 Email</option>
            </select>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Người dùng</th>
                  <th>Vai trò</th>
                  <th>Phương thức</th>
                  <th>Trạng thái</th>
                  <th>Ngày đăng ký</th>
                  <th>Hành động</th>
                </tr>
              </thead>
              <tbody id="user-table-body">
                <c:if test="${empty users}">
                  <tr><td colspan="6" style="text-align:center;padding:2rem;color:var(--text3)">Kh&#244;ng c&#243; d&#7919; li&#7879;u</td></tr>
                </c:if>
                <c:forEach items="${users}" var="u">
                  <c:set var="statusClass" value="${u.status == 'Active' ? 'active' : (u.status == 'Banned' ? 'banned' : 'inactive')}" />
                  <tr data-name="${u.fullName.toLowerCase()}" data-email="${u.email.toLowerCase()}" data-status="${u.status}" data-provider="${u.authProvider}">
                    <td>
                      <div class="user-cell">
                        <div class="user-av">${not empty u.fullName ? u.fullName.substring(0, 1).toUpperCase() : '?'}</div>
                        <div>
                          <div class="user-name-text">${u.fullName}</div>
                          <div class="user-email">${u.email}</div>
                        </div>
                      </div>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${u.roleId == 1}"><span class="badge admin">Admin</span></c:when>
                        <c:otherwise><span class="badge candidate">Candidate</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${u.authProvider == 'Google'}"><span class="badge google">&#128273; Google</span></c:when>
                        <c:otherwise><span class="badge local">&#128231; Email</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td><span class="status-dot ${statusClass}"></span> ${u.status}</td>
                    <td>${u.createdAt}</td>
                    <td>
                      <c:choose>
                        <c:when test="${u.status == 'Banned'}">
                          <button class="action-btn action-unban" onclick="banUser(${u.userId}, 'unban', '${u.fullName}')">&#128275; M&#7903; kh&#243;a</button>
                        </c:when>
                        <c:when test="${u.roleId != 1}">
                          <button class="action-btn action-ban" onclick="banUser(${u.userId}, 'ban', '${u.fullName}')">&#128274; Kh&#243;a</button>
                        </c:when>
                        <c:otherwise>
                          <span style="font-size:.75rem;color:var(--text3)">-</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

    </div><!-- /content -->
  </div><!-- /main -->

  <div id="toast-container"></div>
  <script>
    const statsData = ${statsJson != null ? statsJson : '{}'};
  </script>
  <script src="${pageContext.request.contextPath}/js/admin-dashboard.js?v=4"></script>
</body>
</html>
