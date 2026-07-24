<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userEmail") != null) {
        Integer roleId = (Integer) session.getAttribute("roleId");
        if (roleId != null) {
            if (roleId == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (roleId == 2) {
                response.sendRedirect(request.getContextPath() + "/mentor/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/candidate/dashboard");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập – IELTSFlow</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <script>
        window.CONTEXT_PATH = '${pageContext.request.contextPath}';
        window.GOOGLE_CLIENT_ID = '<%= System.getProperty("GOOGLE_CLIENT_ID") != null ? System.getProperty("GOOGLE_CLIENT_ID") : "" %>';
        
        var googleTokenClient;

        function handleGoogleCredential(resp) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = window.CONTEXT_PATH + '/api/auth/google';
            var inp = document.createElement('input');
            inp.type = 'hidden'; inp.name = 'credential'; inp.value = resp.credential;
            form.appendChild(inp); document.body.appendChild(form); form.submit();
        }

        window.initGoogleAuth = function() {
            if (window.google && window.google.accounts && window.GOOGLE_CLIENT_ID && window.GOOGLE_CLIENT_ID.length > 10) {
                google.accounts.id.initialize({
                    client_id: window.GOOGLE_CLIENT_ID,
                    callback: handleGoogleCredential
                });
                try { google.accounts.id.prompt(); } catch(e) {}

                googleTokenClient = google.accounts.oauth2.initTokenClient({
                    client_id: window.GOOGLE_CLIENT_ID,
                    scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
                    callback: function(response) {
                        if (response && response.access_token) {
                            var form = document.createElement('form');
                            form.method = 'POST';
                            form.action = window.CONTEXT_PATH + '/api/auth/google';
                            var inp = document.createElement('input');
                            inp.type = 'hidden'; inp.name = 'accessToken'; inp.value = response.access_token;
                            form.appendChild(inp); document.body.appendChild(form); form.submit();
                        }
                    }
                });
            }
        };
        
        window.onGoogleLibraryLoad = window.initGoogleAuth;
        // In case it's already loaded
        setTimeout(function() { if (!googleTokenClient) window.initGoogleAuth(); }, 1000);
    </script>
    <script src="https://accounts.google.com/gsi/client?onload=onGoogleLibraryLoad" async defer></script>

<style>
/* ================================================================
   IELTSFLOW AUTH PAGE – Synced với Index Light Theme
================================================================ */
:root {
  --blue-50:#EFF6FF;--blue-100:#DBEAFE;--blue-200:#BFDBFE;
  --blue-500:#3B82F6;--blue-600:#2563EB;--blue-700:#1D4ED8;
  --indigo-600:#4F46E5;--green-600:#16A34A;
  --grad-brand:linear-gradient(135deg,#2563EB 0%,#6366F1 100%);
  --grad-left:linear-gradient(160deg,#0B1A3E 0%,#0D2257 35%,#0E2D6B 60%,#0D1F52 100%);
  --text-dark:#0F172A;--text-body:#334155;--text-muted:#64748B;
  --border:#E2E8F0;--border-focus:#3B82F6;
  --shadow-sm:0 2px 8px rgba(15,23,42,.08);
  --shadow-md:0 4px 20px rgba(15,23,42,.12);
  --shadow-lg:0 12px 40px rgba(15,23,42,.14);
  --radius:12px;--font-h:'Inter',sans-serif;--font-b:'Inter',sans-serif;
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%;font-family:var(--font-b);-webkit-font-smoothing:antialiased}
body{display:flex;min-height:100vh;background:#F8FAFF}
a{text-decoration:none;color:inherit}

/* ── Layout ──────────────────────────────────────────────── */
.auth-wrap{display:flex;width:100%;min-height:100vh}

/* ── LEFT PANEL ──────────────────────────────────────────── */
.auth-left{
  width:45%;background:var(--grad-left);color:#fff;
  padding:44px 48px;display:flex;flex-direction:column;
  justify-content:space-between;position:relative;overflow:hidden;
}
/* Decorative blobs */
.auth-left::before{
  content:'';position:absolute;top:-120px;right:-120px;
  width:400px;height:400px;border-radius:50%;
  background:radial-gradient(circle,rgba(99,102,241,.25) 0%,transparent 70%);
  pointer-events:none;
}
.auth-left::after{
  content:'';position:absolute;bottom:-80px;left:-80px;
  width:300px;height:300px;border-radius:50%;
  background:radial-gradient(circle,rgba(37,99,235,.20) 0%,transparent 70%);
  pointer-events:none;
}
.left-orb{
  position:absolute;width:160px;height:160px;border-radius:50%;
  background:rgba(99,102,241,.15);border:1px solid rgba(255,255,255,.08);
  animation:orb 8s ease-in-out infinite;
}
.left-orb:nth-child(1){top:38%;left:68%;animation-delay:0s}
.left-orb:nth-child(2){top:58%;left:15%;width:90px;height:90px;animation-delay:3s;animation-duration:6s}
@keyframes orb{0%,100%{transform:translateY(0) scale(1)}50%{transform:translateY(-18px) scale(1.04)}}

.left-inner{position:relative;z-index:2;flex:1;display:flex;flex-direction:column;gap:32px}

/* Logo */
.left-logo{display:flex;align-items:center;gap:10px}
.left-logo-mark{
  width:38px;height:38px;border-radius:10px;
  background:var(--grad-brand);display:flex;align-items:center;justify-content:center;
  font-size:1rem;color:#fff;box-shadow:0 4px 14px rgba(37,99,235,.35);
}
.left-logo-text{font-family:var(--font-h);font-size:1.125rem;font-weight:700;}
.left-logo-text span{opacity:.75}

/* Hero text */
.left-headline{margin-top:8px}
.left-headline h1{
  font-family:var(--font-h);font-size:clamp(1.875rem,2.8vw,2.5rem);
  font-weight:800;line-height:1.2;margin-bottom:14px;
}
.left-headline h1 em{color:#93C5FD;font-style:normal}
.left-headline p{font-size:.9375rem;color:rgba(255,255,255,.72);line-height:1.7;max-width:340px}

/* Feature list */
.left-feats{display:flex;flex-direction:column;gap:12px;margin-top:4px}
.left-feat{
  display:flex;align-items:flex-start;gap:12px;
  background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.10);
  border-radius:14px;padding:14px 16px;backdrop-filter:blur(8px);
}
.lf-icon{
  width:36px;height:36px;border-radius:10px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;font-size:1.0625rem;
}
.lf-blue{background:rgba(59,130,246,.25)}
.lf-green{background:rgba(34,197,94,.20)}
.lf-indigo{background:rgba(99,102,241,.25)}
.lf-title{font-weight:600;font-size:.875rem;margin-bottom:2px;color:#fff}
.lf-sub{font-size:.78rem;color:rgba(255,255,255,.55)}

/* Dashboard mini-card */
.left-dash{
  background:rgba(255,255,255,.07);border:1px solid rgba(255,255,255,.12);
  border-radius:18px;padding:18px;backdrop-filter:blur(12px);
}
.ld-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.ld-label{font-size:.72rem;color:rgba(255,255,255,.55);text-transform:uppercase;letter-spacing:.07em}
.ld-band{
  font-family:var(--font-h);font-size:2.5rem;font-weight:900;
  color:#fff;line-height:1;
}
.ld-good{font-size:.75rem;color:#4ADE80;font-weight:600;margin-top:2px}
.ld-skills{display:flex;flex-direction:column;gap:7px}
.lds{display:flex;align-items:center;gap:8px}
.lds-name{font-size:.72rem;color:rgba(255,255,255,.65);width:54px;flex-shrink:0}
.lds-bar{flex:1;height:4px;background:rgba(255,255,255,.15);border-radius:2px;overflow:hidden}
.lds-fill{height:100%;border-radius:2px}
.lds-val{font-size:.72rem;font-weight:700;color:#fff;width:20px;text-align:right}
.ld-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-top:14px}
.ld-stat{background:rgba(255,255,255,.08);border-radius:10px;padding:9px 10px;text-align:center}
.ld-stat-val{font-family:var(--font-h);font-size:1.0625rem;font-weight:800;color:#fff}
.ld-stat-lbl{font-size:.65rem;color:rgba(255,255,255,.5);margin-top:2px}

/* Testimonial */
.left-quote{
  background:rgba(0,0,0,.25);border-radius:14px;
  border-left:3px solid #60A5FA;padding:16px 20px;
  font-size:.875rem;color:rgba(255,255,255,.82);line-height:1.6;
}
.left-quote strong{display:block;margin-top:8px;font-size:.8rem;color:rgba(255,255,255,.5);font-weight:400}

/* Bottom badges */
.left-badges{
  display:flex;gap:24px;padding-top:20px;
  border-top:1px solid rgba(255,255,255,.1);position:relative;z-index:2;
}
.left-badge{display:flex;align-items:center;gap:6px;font-size:.8125rem;color:rgba(255,255,255,.55)}
.left-badge i{color:rgba(255,255,255,.35);font-size:.875rem}

/* ── RIGHT PANEL ─────────────────────────────────────────── */
.auth-right{
  width:55%;display:flex;flex-direction:column;
  align-items:center;justify-content:center;
  background:#fff;padding:40px 48px;position:relative;
}



.auth-form-box{width:100%;max-width:440px}

/* Mobile logo */
.mob-logo{display:none;align-items:center;gap:8px;margin-bottom:28px}
.mob-logo-mark{width:32px;height:32px;border-radius:8px;background:var(--grad-brand);display:flex;align-items:center;justify-content:center;color:#fff;font-size:.875rem}
.mob-logo-text{font-family:var(--font-h);font-weight:800;font-size:1rem;color:var(--text-dark)}
.mob-logo-text span{color:var(--blue-600)}

/* Welcome */
.auth-welcome{margin-bottom:28px}
.auth-welcome h2{font-family:var(--font-h);font-size:1.625rem;font-weight:800;color:var(--text-dark);margin-bottom:6px}
.auth-welcome p{font-size:.9375rem;color:var(--text-muted);line-height:1.6}

/* Tab switcher */
.tab-sw{
  display:flex;position:relative;background:#F1F5F9;
  border-radius:12px;padding:4px;margin-bottom:28px;
}
.tab-sw-slide{
  position:absolute;top:4px;left:4px;
  width:calc(50% - 4px);height:calc(100% - 8px);
  background:#fff;border-radius:9px;
  box-shadow:0 2px 6px rgba(15,23,42,.08);
  transition:transform .3s cubic-bezier(.4,0,.2,1);z-index:1;
}
.tab-btn{
  flex:1;padding:11px 20px;font-family:var(--font-b);font-size:.9375rem;
  font-weight:600;color:var(--text-muted);cursor:pointer;
  border:none;background:none;z-index:2;position:relative;
  transition:color .25s;border-radius:9px;
}
.tab-btn.active{color:var(--text-dark)}

/* Google btn */
.btn-google{
  display:flex;align-items:center;justify-content:center;gap:10px;
  width:100%;padding:13px 20px;background:#fff;
  border:1.5px solid var(--border);border-radius:var(--radius);
  font-family:var(--font-b);font-size:.9375rem;font-weight:500;color:var(--text-body);
  cursor:pointer;transition:all .2s;margin-bottom:20px;
}
.btn-google:hover{border-color:#CBD5E1;box-shadow:var(--shadow-sm);background:#FAFBFF}
.g-logo{width:20px;height:20px}

/* Divider */
.or-div{
  display:flex;align-items:center;gap:12px;
  margin-bottom:20px;font-size:.8125rem;color:var(--text-muted);
}
.or-div::before,.or-div::after{content:'';flex:1;height:1px;background:var(--border)}

/* Form */
.form-area{display:none}
.form-area.active{display:block;animation:fadeUp .35s ease forwards}
@keyframes fadeUp{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}

.fgrp{margin-bottom:18px}
.fgrp label{display:block;font-size:.9375rem;font-weight:600;color:var(--text-dark);margin-bottom:7px}
.inp-wrap{position:relative}
.inp-icon{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:.9375rem;pointer-events:none}
.inp-wrap input{
  width:100%;padding:12px 40px;border:1.5px solid var(--border);
  border-radius:var(--radius);font-family:var(--font-b);font-size:.9375rem;
  color:var(--text-dark);background:#fff;outline:none;transition:border-color .2s,box-shadow .2s;
}
.inp-wrap input:focus{border-color:var(--border-focus);box-shadow:0 0 0 3px rgba(37,99,235,.10)}
.inp-wrap input::placeholder{color:var(--text-muted)}
.inp-eye{position:absolute;right:13px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;padding:4px;font-size:.875rem;transition:color .2s}
.inp-eye:hover{color:var(--text-dark)}

/* Row between */
.row-bw{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.chk-grp{display:flex;align-items:center;gap:7px;font-size:.875rem;color:var(--text-muted);cursor:pointer}
.chk-grp input[type=checkbox]{width:15px;height:15px;accent-color:var(--blue-600);cursor:pointer}
.link{color:var(--blue-600);font-weight:600;font-size:.875rem;transition:opacity .2s}
.link:hover{opacity:.75;text-decoration:underline}

/* CTA button */
.btn-cta{
  width:100%;padding:14px;border:none;border-radius:var(--radius);
  background:var(--grad-brand);color:#fff;
  font-family:var(--font-b);font-size:1rem;font-weight:700;
  cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;
  transition:all .25s;box-shadow:0 4px 16px rgba(37,99,235,.28);
  margin-bottom:16px;
}
.btn-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(37,99,235,.36)}
.btn-cta:active{transform:scale(.98)}

/* Terms */
.terms{text-align:center;font-size:.8125rem;color:var(--text-muted);line-height:1.65}
.terms a{color:var(--blue-600);font-weight:500}
.terms a:hover{text-decoration:underline}

/* Switch CTA */
.switch-cta{text-align:center;margin-top:20px;font-size:.875rem;color:var(--text-muted)}
.switch-cta a{color:var(--blue-600);font-weight:700}

/* Strength bar */
.strength-wrap{margin-top:8px;display:none}
.strength-bar{display:flex;gap:4px;height:4px;margin-bottom:5px}
.strength-seg{flex:1;background:#E2E8F0;border-radius:2px;transition:background .3s}
.strength-seg.weak{background:#EF4444}
.strength-seg.medium{background:#F59E0B}
.strength-seg.strong{background:#22C55E}
.strength-txt{font-size:.78rem;color:var(--text-muted)}

/* Alerts */
.alert-err{background:#FEF2F2;border:1px solid #FCA5A5;color:#B91C1C;padding:11px 15px;border-radius:10px;margin-bottom:18px;font-size:.875rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-ok{background:#F0FDF4;border:1px solid #86EFAC;color:#166534;padding:11px 15px;border-radius:10px;margin-bottom:18px;font-size:.875rem;font-weight:500;display:flex;align-items:center;gap:8px}

/* Lang overlay */
.lang-wrap{position:relative}
.lang-overlay{position:absolute;top:40px;right:0;background:#fff;border:1px solid var(--border);border-radius:10px;box-shadow:var(--shadow-md);overflow:hidden;display:none;min-width:130px;z-index:100}
.lang-overlay.open{display:block}
.lang-opt{display:flex;align-items:center;gap:8px;padding:9px 14px;font-size:.875rem;color:var(--text-body);cursor:pointer;transition:background .15s;white-space:nowrap}
.lang-opt:hover{background:#F8FAFF}
.lang-opt.active{color:var(--blue-600);font-weight:600}

/* Responsive */
@media(max-width:900px){
  .auth-left{display:none}
  .auth-right{width:100%;padding:32px 24px}
  .mob-logo{display:flex}
  .right-controls{top:16px;right:16px}
}
@media(max-width:480px){
  .auth-form-box{max-width:100%}
  .auth-right{padding:24px 20px;padding-top:64px}
}
/* ── Dark Mode ──────────────────────────────────────────── */
body.dark-mode {
  --text-dark:#F1F5F9;--text-body:#CBD5E1;--text-muted:#94A3B8;
  --border:#1E3A5F;--border-focus:#3B82F6;
  --shadow-sm:0 2px 8px rgba(0,0,0,.3);
  --shadow-md:0 4px 20px rgba(0,0,0,.35);
  background:#0F172A;
}
body.dark-mode .auth-right{background:#1E293B}
body.dark-mode .rc-btn{background:#0F172A;border-color:#1E3A5F;color:#94A3B8}
body.dark-mode .rc-btn:hover{border-color:#3B82F6;color:#93C5FD}
body.dark-mode .tab-sw{background:#0F172A}
body.dark-mode .tab-sw-slide{background:#1E293B;box-shadow:0 2px 6px rgba(0,0,0,.4)}
body.dark-mode .tab-btn.active{color:#F1F5F9}
body.dark-mode .tab-btn{color:#64748B}
body.dark-mode .btn-google{background:#0F172A;border-color:#1E3A5F;color:#CBD5E1}
body.dark-mode .btn-google:hover{background:#162032;border-color:#3B82F6}
body.dark-mode .or-div{color:#475569}
body.dark-mode .or-div::before,body.dark-mode .or-div::after{background:#1E3A5F}
body.dark-mode .fgrp label{color:#E2E8F0}
body.dark-mode .inp-wrap input{background:#0F172A;border-color:#1E3A5F;color:#F1F5F9}
body.dark-mode .inp-wrap input:focus{border-color:#3B82F6;box-shadow:0 0 0 3px rgba(59,130,246,.15)}
body.dark-mode .inp-wrap input::placeholder{color:#475569}
body.dark-mode .inp-icon{color:#475569}
body.dark-mode .inp-eye{color:#475569}
body.dark-mode .inp-eye:hover{color:#94A3B8}
body.dark-mode .chk-grp{color:#94A3B8}
body.dark-mode .terms{color:#64748B}
body.dark-mode .terms a{color:#93C5FD}
body.dark-mode .switch-cta{color:#64748B}
body.dark-mode .switch-cta a{color:#93C5FD}
body.dark-mode .lang-overlay{background:#1E293B;border-color:#1E3A5F}
body.dark-mode .lang-opt{color:#CBD5E1}
body.dark-mode .lang-opt:hover{background:#162032}
body.dark-mode .lang-opt.active{color:#93C5FD}
body.dark-mode .rc-sep{background:#1E3A5F}
body.dark-mode .auth-welcome h2{color:#F1F5F9}
body.dark-mode .auth-welcome p{color:#94A3B8}
body.dark-mode .strength-seg{background:#1E3A5F}
body.dark-mode .alert-err{background:rgba(239,68,68,.1);border-color:rgba(239,68,68,.3);color:#FCA5A5}
body.dark-mode .alert-ok{background:rgba(34,197,94,.1);border-color:rgba(34,197,94,.3);color:#86EFAC}
body.dark-mode .mob-logo-text{color:#F1F5F9}
</style>
</head>
<body data-tab="${not empty tab ? tab : 'login'}">
<div class="auth-wrap">

  <!-- ═══ LEFT PANEL ═══════════════════════════════════════ -->
  <div class="auth-left">
    <div class="left-orb"></div>
    <div class="left-orb"></div>

    <div class="left-inner">
      <!-- Logo -->
      <div class="left-logo">
        <div class="left-logo-mark"><i class="fas fa-graduation-cap"></i></div>
        <div class="left-logo-text">IELTS<span>Flow</span></div>
      </div>

      <!-- Headline -->
      <div class="left-headline">
        <h1>Chinh phục IELTS<br>cùng <em>AI</em></h1>
        <p>Nền tảng luyện thi IELTS thông minh, cá nhân hóa lộ trình học tập và chấm điểm bằng AI tiên tiến.</p>
      </div>

      <!-- Features -->
      <div class="left-feats">
        <div class="left-feat">
          <div class="lf-icon lf-blue"><i class="fas fa-pen-nib"></i></div>
          <div>
            <div class="lf-title">AI chấm điểm Writing &amp; Speaking</div>
            <div class="lf-sub">Nhanh chóng, chính xác, theo tiêu chuẩn IELTS</div>
          </div>
        </div>
        <div class="left-feat">
          <div class="lf-icon lf-indigo"><i class="fas fa-map"></i></div>
          <div>
            <div class="lf-title">Lộ trình học cá nhân hóa</div>
            <div class="lf-sub">Dựa trên trình độ và mục tiêu của bạn</div>
          </div>
        </div>
        <div class="left-feat">
          <div class="lf-icon lf-green"><i class="fas fa-chart-line"></i></div>
          <div>
            <div class="lf-title">Theo dõi tiến độ học tập</div>
            <div class="lf-sub">Báo cáo chi tiết &amp; gợi ý cải thiện</div>
          </div>
        </div>
      </div>

      <!-- Dashboard mini card -->
      <div class="left-dash">
        <div class="ld-top">
          <div>
            <div class="ld-label">Overall Band Score</div>
            <div class="ld-band">7.5</div>
            <div class="ld-good">▲ Good</div>
          </div>
          <div style="text-align:right;">
            <div class="ld-label">Skill Breakdown</div>
            <div class="ld-skills" style="margin-top:6px;">
              <div class="lds"><span class="lds-name">Listening</span><div class="lds-bar"><div class="lds-fill" style="width:87.5%;background:#60A5FA;"></div></div><span class="lds-val">7.0</span></div>
              <div class="lds"><span class="lds-name">Reading</span><div class="lds-bar"><div class="lds-fill" style="width:93.75%;background:#A78BFA;"></div></div><span class="lds-val">7.5</span></div>
              <div class="lds"><span class="lds-name">Writing</span><div class="lds-bar"><div class="lds-fill" style="width:87.5%;background:#F59E0B;"></div></div><span class="lds-val">7.0</span></div>
              <div class="lds"><span class="lds-name">Speaking</span><div class="lds-bar"><div class="lds-fill" style="width:93.75%;background:#34D399;"></div></div><span class="lds-val">7.5</span></div>
            </div>
          </div>
        </div>
        <div class="ld-stats">
          <div class="ld-stat"><div class="ld-stat-val">🔥 21</div><div class="ld-stat-lbl">Study Streak</div></div>
          <div class="ld-stat"><div class="ld-stat-val">1,250</div><div class="ld-stat-lbl">Vocabulary</div></div>
          <div class="ld-stat"><div class="ld-stat-val">94%</div><div class="ld-stat-lbl">Accuracy</div></div>
        </div>
      </div>

      <!-- Testimonial -->
      <div class="left-quote">
        "IELTSFlow đã giúp mình tăng từ 5.5 lên 7.5 chỉ trong 3 tháng. Công cụ chấm Writing cực kỳ chi tiết và hữu ích!"
        <strong>— Nguyễn Trần Mai Anh, IELTS 7.5</strong>
      </div>
    </div>

    <!-- Bottom badges -->
    <div class="left-badges">
      <div class="left-badge"><i class="fas fa-shield-halved"></i> Bảo mật thông tin</div>
      <div class="left-badge"><i class="fas fa-headset"></i> Hỗ trợ 24/7</div>
    </div>
  </div>

  <!-- ═══ RIGHT PANEL ══════════════════════════════════════ -->
  <div class="auth-right">


    <div class="auth-form-box">
      <!-- Mobile logo -->
      <div class="mob-logo">
        <div class="mob-logo-mark"><i class="fas fa-graduation-cap"></i></div>
        <div class="mob-logo-text">IELTS<span>Flow</span></div>
      </div>

      <!-- Welcome -->
      <div class="auth-welcome">
        <h2 id="welcomeTitle">Chào mừng trở lại! 👋</h2>
        <p id="welcomeSub">Đăng nhập để tiếp tục hành trình chinh phục IELTS</p>
      </div>

      <!-- Tab switcher -->
      <div class="tab-sw" id="tabSw">
        <div class="tab-sw-slide" id="tabSlide"></div>
        <button class="tab-btn active" id="tabLogin" onclick="switchTab('login')">Đăng nhập</button>
        <button class="tab-btn" id="tabReg" onclick="switchTab('register')">Đăng ký</button>
      </div>

      <!-- Alerts -->
      <c:if test="${not empty error}">
        <div class="alert-err"><i class="fas fa-circle-exclamation"></i> ${error}</div>
      </c:if>
      <c:if test="${not empty successMessage}">
        <div class="alert-ok"><i class="fas fa-check-circle"></i> ${successMessage}</div>
      </c:if>
      <c:if test="${not empty param.successMessage}">
        <div class="alert-ok"><i class="fas fa-check-circle"></i> ${param.successMessage}</div>
      </c:if>
      <c:if test="${not empty param.redirect_error}">
        <div class="alert-err"><i class="fas fa-circle-exclamation"></i> ${param.redirect_error}</div>
      </c:if>

      <!-- ─── LOGIN FORM ─── -->
      <div class="form-area active" id="loginArea">
        <!-- Google login -->
        <button class="btn-google" onclick="googleLogin()">
          <svg class="g-logo" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
          Đăng nhập với Google
        </button>

        <div class="or-div">hoặc đăng nhập với email</div>

        <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="POST">
          <input type="hidden" name="action" value="login">

          <div class="fgrp">
            <label for="loginEmail">Email</label>
            <div class="inp-wrap">
              <i class="fas fa-envelope inp-icon"></i>
              <input type="email" id="loginEmail" name="email" placeholder="Nhập email của bạn" required autocomplete="email">
            </div>
          </div>

          <div class="fgrp">
            <label for="loginPassword">Mật khẩu</label>
            <div class="inp-wrap">
              <i class="fas fa-lock inp-icon"></i>
              <input type="password" id="loginPassword" name="password" placeholder="Nhập mật khẩu" required autocomplete="current-password">
              <button type="button" class="inp-eye" onclick="togglePwd('loginPassword',this)">
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>

          <div class="row-bw">
            <label class="chk-grp">
              <input type="checkbox" id="rememberMe" name="rememberMe">
              Ghi nhớ đăng nhập
            </label>
            <a href="${pageContext.request.contextPath}/forgot-password" class="link">Quên mật khẩu?</a>
          </div>

          <button type="submit" class="btn-cta">
            <span>Đăng nhập</span> <i class="fas fa-arrow-right"></i>
          </button>
        </form>

        <div class="terms">
          Bằng việc đăng nhập, bạn đồng ý với
          <a href="#">Điều khoản sử dụng</a> và
          <a href="#">Chính sách bảo mật</a> của IELTSFlow.
        </div>

        <div class="switch-cta">
          Chưa có tài khoản? <a href="javascript:void(0)" onclick="switchTab('register')">Đăng ký ngay</a>
        </div>
      </div>

      <!-- ─── REGISTER FORM ─── -->
      <div class="form-area" id="registerArea">
        <button class="btn-google" onclick="googleLogin()">
          <svg class="g-logo" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
          Đăng ký với Google
        </button>

        <div class="or-div">hoặc đăng ký với email</div>

        <form id="registerForm" action="${pageContext.request.contextPath}/auth" method="POST">
          <input type="hidden" name="action" value="register">

          <div class="fgrp">
            <label for="regName">Họ và tên</label>
            <div class="inp-wrap">
              <i class="fas fa-user inp-icon"></i>
              <input type="text" id="regName" name="fullName" placeholder="Nguyễn Văn A" required autocomplete="name">
            </div>
          </div>

          <div class="fgrp">
            <label for="regEmail">Email</label>
            <div class="inp-wrap">
              <i class="fas fa-envelope inp-icon"></i>
              <input type="email" id="regEmail" name="email" placeholder="you@example.com" required autocomplete="email">
            </div>
          </div>

          <div class="fgrp">
            <label for="regPassword">Mật khẩu</label>
            <div class="inp-wrap">
              <i class="fas fa-lock inp-icon"></i>
              <input type="password" id="regPassword" name="password" placeholder="Ít nhất 8 ký tự" required autocomplete="new-password" oninput="checkStrength(this.value)">
              <button type="button" class="inp-eye" onclick="togglePwd('regPassword',this)">
                <i class="fas fa-eye"></i>
              </button>
            </div>
            <div class="strength-wrap" id="strengthWrap">
              <div class="strength-bar">
                <div class="strength-seg" id="seg1"></div>
                <div class="strength-seg" id="seg2"></div>
                <div class="strength-seg" id="seg3"></div>
                <div class="strength-seg" id="seg4"></div>
              </div>
              <div class="strength-txt" id="strengthTxt">Độ mạnh mật khẩu</div>
            </div>
          </div>

          <div class="fgrp">
            <label for="regCfm">Xác nhận mật khẩu</label>
            <div class="inp-wrap">
              <i class="fas fa-lock inp-icon"></i>
              <input type="password" id="regCfm" name="confirmPassword" placeholder="Nhập lại mật khẩu" required autocomplete="new-password">
              <button type="button" class="inp-eye" onclick="togglePwd('regCfm',this)">
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>

          <div class="fgrp" style="margin-bottom:20px;">
            <label class="chk-grp">
              <input type="checkbox" id="regTerms" required>
              <span>Tôi đồng ý với <a href="#" class="link">Điều khoản</a> và <a href="#" class="link">Bảo mật</a></span>
            </label>
          </div>

          <button type="submit" class="btn-cta">
            <span>Tạo tài khoản</span> <i class="fas fa-arrow-right"></i>
          </button>
        </form>

        <div class="switch-cta">
          Đã có tài khoản? <a href="javascript:void(0)" onclick="switchTab('login')">Đăng nhập ngay</a>
        </div>
      </div>
    </div>
  </div><!-- /auth-right -->
</div><!-- /auth-wrap -->

<script src="${pageContext.request.contextPath}/js/auth.js?v=5"></script>
<script>
/* ── Tab switching ──────────────────────────────────────── */
var currentTab = 'login';
function switchTab(tab) {
  currentTab = tab;
  var isLogin = tab === 'login';
  document.getElementById('loginArea').classList.toggle('active', isLogin);
  document.getElementById('registerArea').classList.toggle('active', !isLogin);
  document.getElementById('tabLogin').classList.toggle('active', isLogin);
  document.getElementById('tabReg').classList.toggle('active', !isLogin);
  document.getElementById('tabSlide').style.transform = isLogin ? 'translateX(0)' : 'translateX(100%)';
  if (isLogin) {
    document.getElementById('welcomeTitle').textContent = translations[currentLang].loginTitle;
    document.getElementById('welcomeSub').textContent = translations[currentLang].loginSub;
  } else {
    document.getElementById('welcomeTitle').textContent = translations[currentLang].regTitle;
    document.getElementById('welcomeSub').textContent = translations[currentLang].regSub;
  }
}

// Detect mode param OR server-side tab attribute
(function(){
  var params = new URLSearchParams(window.location.search);
  var mode = params.get('mode');
  // Server can set tab via request attribute rendered as data-tab
  var serverTab = document.body.getAttribute('data-tab');
  if (mode === 'register' || serverTab === 'register') switchTab('register');
})();

/* ── Password toggle ────────────────────────────────────── */
function togglePwd(inputId, btn) {
  var inp = document.getElementById(inputId);
  var icon = btn.querySelector('i');
  if (inp.type === 'password') {
    inp.type = 'text';
    icon.className = 'fas fa-eye-slash';
  } else {
    inp.type = 'password';
    icon.className = 'fas fa-eye';
  }
}

/* ── Password strength ──────────────────────────────────── */
function checkStrength(val) {
  var wrap = document.getElementById('strengthWrap');
  if (!val) { wrap.style.display = 'none'; return; }
  wrap.style.display = 'block';
  var score = 0;
  if (val.length >= 8) score++;
  if (/[A-Z]/.test(val)) score++;
  if (/[0-9]/.test(val)) score++;
  if (/[^A-Za-z0-9]/.test(val)) score++;
  var segs = ['seg1','seg2','seg3','seg4'];
  var cls = score <= 1 ? 'weak' : score <= 2 ? 'medium' : 'strong';
  var labels = { weak: 'Yếu', medium: 'Trung bình', strong: 'Mạnh' };
  segs.forEach(function(id, i) {
    var el = document.getElementById(id);
    el.className = 'strength-seg' + (i < score ? ' ' + cls : '');
  });
  document.getElementById('strengthTxt').textContent = labels[cls] || '';
}


/* ── Init language (Vietnamese default) ─────────────────── */
var currentLang = 'vi';

var translations = {
  vi: {
    loginTitle: 'Chào mừng trở lại! 👋',
    loginSub: 'Đăng nhập để tiếp tục hành trình chinh phục IELTS',
    regTitle: 'Tạo tài khoản miễn phí 🚀',
    regSub: 'Bắt đầu hành trình IELTS của bạn ngay hôm nay',
    tabLogin: 'Đăng nhập', tabReg: 'Đăng ký',
    google: 'Đăng nhập với Google', googleReg: 'Đăng ký với Google',
    orLogin: 'hoặc đăng nhập với email', orReg: 'hoặc đăng ký với email',
    email: 'Email', password: 'Mật khẩu', confirmPassword: 'Xác nhận mật khẩu',
    fullName: 'Họ và tên', remember: 'Ghi nhớ đăng nhập',
    forgot: 'Quên mật khẩu?', loginBtn: 'Đăng nhập', regBtn: 'Tạo tài khoản',
    terms1: 'Bằng việc đăng nhập, bạn đồng ý với',
    terms2: 'Điều khoản sử dụng', terms3: 'và', terms4: 'Chính sách bảo mật',
    noAcc: 'Chưa có tài khoản?', joinNow: 'Đăng ký ngay',
    hasAcc: 'Đã có tài khoản?', loginNow: 'Đăng nhập ngay',
    emailPh: 'Nhập email của bạn', passPh: 'Nhập mật khẩu', cfmPh: 'Nhập lại mật khẩu',
    namePh: 'Nguyễn Văn A', passPh2: 'Ít nhất 8 ký tự'
  }
};
function applyLang(lang) {
  var t = translations[lang];
  if (!t) return;
  // Welcome section
  var isLogin = currentTab === 'login';
  document.getElementById('welcomeTitle').textContent = isLogin ? t.loginTitle : t.regTitle;
  document.getElementById('welcomeSub').textContent = isLogin ? t.loginSub : t.regSub;
  // Tabs
  document.getElementById('tabLogin').textContent = t.tabLogin;
  document.getElementById('tabReg').textContent = t.tabReg;
  // Labels & placeholders
  var set = function(sel, prop, val) {
    var el = document.querySelector(sel); if (el) el[prop] = val;
  };
  set('label[for=loginEmail]', 'textContent', t.email);
  set('label[for=loginPassword]', 'textContent', t.password);
  set('#loginEmail', 'placeholder', t.emailPh);
  set('#loginPassword', 'placeholder', t.passPh);
  set('label[for=regName]', 'textContent', t.fullName);
  set('label[for=regEmail]', 'textContent', t.email);
  set('label[for=regPassword]', 'textContent', t.password);
  set('label[for=regCfm]', 'textContent', t.confirmPassword);
  set('#regName', 'placeholder', t.namePh);
  set('#regEmail', 'placeholder', t.emailPh);
  set('#regPassword', 'placeholder', t.passPh2);
  set('#regCfm', 'placeholder', t.cfmPh);
  // Forgot link
  var forgot = document.querySelector('a[href*="forgot-password"]');
  if (forgot) forgot.textContent = t.forgot;
  // Buttons
  var loginBtn = document.querySelector('#loginForm .btn-cta span');
  if (loginBtn) loginBtn.textContent = t.loginBtn;
  var regBtn = document.querySelector('#registerForm .btn-cta span');
  if (regBtn) regBtn.textContent = t.regBtn;
  // Switch CTAs
  var sc = document.querySelectorAll('.switch-cta');
  if (sc[0]) sc[0].innerHTML = t.noAcc + ' <a href="javascript:void(0)" onclick="switchTab(\'register\')">' + t.joinNow + '</a>';
  if (sc[1]) sc[1].innerHTML = t.hasAcc + ' <a href="javascript:void(0)" onclick="switchTab(\'login\')">' + t.loginNow + '</a>';
}
// Init
(function(){ applyLang(currentLang); })();


/* ── Google login ───────────────────────────────────────── */
function googleLogin() {
  if (!googleTokenClient) window.initGoogleAuth();
  
  if (googleTokenClient) {
    googleTokenClient.requestAccessToken();
  } else {
    var debug = "ClientID: " + (window.GOOGLE_CLIENT_ID ? "OK" : "MISSING") + 
                ", GoogleAPI: " + (window.google ? "OK" : "MISSING");
    alert("Hệ thống chưa cấu hình Google Login hoặc đang tải. Vui lòng thử lại sau. (" + debug + ")");
  }
}
</script>
</body>
</html>
