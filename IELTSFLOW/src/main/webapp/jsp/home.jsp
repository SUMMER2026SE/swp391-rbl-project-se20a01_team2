<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="IELTSFlow - Nền tảng luyện thi IELTS tích hợp AI hàng đầu. Chấm điểm thông minh, phản hồi chi tiết, lộ trình cá nhân hóa.">
    <title>IELTSFlow - Chinh phục IELTS nhanh hơn với AI</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">

<style>
/* ================================================================
   IELTSFLOW LANDING PAGE v5 – Light Theme
================================================================ */
:root {
  --blue-50:  #EFF6FF; --blue-100: #DBEAFE; --blue-200: #BFDBFE;
  --blue-500: #3B82F6; --blue-600: #2563EB; --blue-700: #1D4ED8;
  --indigo-50:#EEF2FF; --indigo-500:#6366F1; --indigo-600:#4F46E5;
  --purple-500:#8B5CF6;
  --teal-500: #14B8A6; --green-500: #22C55E; --green-600: #16A34A;
  --amber-400:#FBBF24; --amber-500:#F59E0B; --red-500:#EF4444;
  --grad-brand: linear-gradient(135deg,#2563EB 0%,#6366F1 100%);
  --grad-cta:   linear-gradient(135deg,#2563EB 0%,#0EA5E9 100%);
  --bg-page:  #F8FAFF; --bg-white: #FFFFFF; --bg-subtle:#F1F5F9; --bg-section:#F0F4FF;
  --text-dark:#0F172A; --text-body:#334155; --text-muted:#64748B; --text-light:#94A3B8;
  --border-light:#E2E8F0; --border-mid:#CBD5E1;
  --shadow-xs:0 1px 3px rgba(15,23,42,.06); --shadow-sm:0 2px 8px rgba(15,23,42,.08);
  --shadow-md:0 4px 20px rgba(15,23,42,.10); --shadow-lg:0 12px 40px rgba(15,23,42,.12);
  --shadow-xl:0 24px 60px rgba(15,23,42,.14); --shadow-blue:0 8px 30px rgba(37,99,235,.22);
  --radius-sm:6px; --radius-md:10px; --radius-lg:14px; --radius-xl:20px;
  --radius-2xl:28px; --radius-full:9999px;
  --ease:cubic-bezier(.16,1,.3,1); --dur:240ms;
  --font-h:'Inter',sans-serif; --font-b:'Inter',sans-serif;
}



*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth;font-size:16px}
body{font-family:var(--font-b);background:var(--bg-page);color:var(--text-body);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased;transition:background .3s,color .3s}
a{text-decoration:none;color:inherit}
img{display:block;max-width:100%}
ul{list-style:none}
button{cursor:pointer;border:none;background:none;font-family:inherit}

.container{width:100%;max-width:1200px;margin:0 auto;padding:0 24px}
.section{padding:88px 0}
.tg{background:var(--grad-brand);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
[data-sr]{transition:opacity .65s var(--ease),transform .65s var(--ease)}
.sr-up{opacity:0;transform:translateY(28px)}
.sr-left{opacity:0;transform:translateX(32px)}
.sr-right{opacity:0;transform:translateX(-32px)}
.sr-zoom{opacity:0;transform:scale(.93)}

/* Buttons */
.btn{display:inline-flex;align-items:center;justify-content:center;gap:7px;padding:11px 24px;border-radius:var(--radius-lg);font-family:var(--font-b);font-size:.9375rem;font-weight:600;cursor:pointer;border:none;transition:all var(--dur) var(--ease);white-space:nowrap}
.btn:active{transform:scale(.97)}
.btn-primary{background:var(--grad-brand);color:#fff;box-shadow:var(--shadow-blue)}
.btn-primary:hover{transform:translateY(-2px);box-shadow:0 12px 36px rgba(37,99,235,.30)}
.btn-outline{background:var(--bg-white);color:var(--text-body);border:1.5px solid var(--border-mid);box-shadow:var(--shadow-xs)}
.btn-outline:hover{border-color:var(--blue-500);color:var(--blue-600);background:var(--blue-50)}
.btn-ghost{background:transparent;color:var(--text-muted)}
.btn-ghost:hover{color:var(--text-dark);background:var(--bg-subtle);border-radius:8px}
.btn-lg{padding:14px 30px;font-size:1rem;border-radius:var(--radius-xl)}
.btn-sm{padding:7px 16px;font-size:.8125rem}
.btn-green{background:linear-gradient(135deg,#16A34A,#22C55E);color:#fff;box-shadow:0 4px 16px rgba(22,163,74,.22)}
.btn-green:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(22,163,74,.28)}
.btn-full{width:100%;justify-content:center}

/* Labels */
.label{display:inline-flex;align-items:center;gap:6px;padding:5px 13px;border-radius:var(--radius-full);font-size:.8rem;font-weight:600;letter-spacing:.04em;text-transform:uppercase;margin-bottom:14px}
.lb-blue{background:var(--blue-50);color:var(--blue-600);border:1px solid var(--blue-100)}
.lb-indigo{background:var(--indigo-50);color:var(--indigo-600);border:1px solid #C7D2FE}
.lb-green{background:#F0FDF4;color:var(--green-600);border:1px solid #BBF7D0}
.lb-amber{background:#FFFBEB;color:#92400E;border:1px solid #FDE68A}

/* Section Headers */
.sec-hdr{margin-bottom:48px}
.sec-hdr.center{text-align:center}
.sec-hdr.center .sec-sub{margin:0 auto}
.sec-title{font-family:var(--font-h);font-weight:800;font-size:clamp(1.75rem,3.5vw,2.5rem);line-height:1.15;color:var(--text-dark);margin-bottom:12px}
.sec-sub{font-size:1rem;color:var(--text-muted);max-width:560px;line-height:1.75}

/* Cards */
.card{background:var(--bg-white);border:1px solid var(--border-light);border-radius:var(--radius-xl);box-shadow:var(--shadow-sm);transition:all var(--dur) var(--ease)}
.card:hover{box-shadow:var(--shadow-lg);transform:translateY(-4px);border-color:var(--border-mid)}

/* ── NAVBAR ── */
.navbar{position:sticky;top:0;z-index:1000;background:rgba(248,250,255,.92);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border-bottom:1px solid var(--border-light);transition:box-shadow var(--dur)}
.navbar.scrolled{box-shadow:var(--shadow-md)}
.nav-inner{max-width:1400px;margin:0 auto;padding:0 24px;height:64px;display:flex;align-items:center;gap:20px}
.nav-logo{display:flex;align-items:center;gap:10px;flex-shrink:0}
.nav-logo-mark{width:36px;height:36px;border-radius:10px;background:var(--grad-brand);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1rem;box-shadow:0 4px 12px rgba(37,99,235,.25)}
.nav-logo-text{font-family:var(--font-h);font-size:1.125rem;font-weight:800;color:var(--text-dark);}
.nav-logo-text span{color:var(--blue-600)}
.nav-links{display:flex;align-items:center;gap:2px;flex:1;justify-content:center}
.nav-link{padding:7px 14px;border-radius:8px;font-size:.9375rem;font-weight:500;color:var(--text-muted);transition:all var(--dur)}
.nav-link:hover{color:var(--text-dark);background:var(--bg-subtle)}
.nav-link.active{color:var(--blue-600);background:var(--blue-50)}
.nav-actions{display:flex;align-items:center;gap:10px;flex-shrink:0}
.hamburger{display:none;flex-direction:column;gap:5px;padding:8px}
.hamburger span{width:20px;height:2px;background:var(--text-muted);border-radius:2px;transition:all .3s;display:block}
.mob-menu{display:none;position:fixed;inset:64px 0 0 0;background:rgba(255,255,255,.98);backdrop-filter:blur(16px);z-index:999;flex-direction:column;padding:20px;gap:4px;border-top:1px solid var(--border-light)}
.mob-menu.open{display:flex}
.mob-link{padding:13px 16px;border-radius:12px;font-size:.9375rem;font-weight:500;color:var(--text-body);transition:all var(--dur)}
.mob-link:hover{background:var(--bg-subtle);color:var(--blue-600)}
.mob-sep{height:1px;background:var(--border-light);margin:8px 0}
.mob-btns{display:flex;flex-direction:column;gap:10px;margin-top:8px}
.mob-btns .btn{width:100%;justify-content:center;padding:13px}

/* ── HERO ── */
.hero{padding:72px 0 60px;background:var(--bg-page);position:relative;overflow:hidden}
.hero::before{content:'';position:absolute;top:-120px;right:-80px;width:700px;height:700px;background:radial-gradient(circle,rgba(37,99,235,.07) 0%,transparent 70%);border-radius:50%;pointer-events:none}
.hero::after{content:'';position:absolute;bottom:-80px;left:-80px;width:500px;height:500px;background:radial-gradient(circle,rgba(99,102,241,.06) 0%,transparent 70%);border-radius:50%;pointer-events:none}
.hero-grid{display:grid;grid-template-columns:1fr 1fr;gap:64px;align-items:center;position:relative;z-index:1}
.hero-badge{display:inline-flex;align-items:center;gap:7px;margin-bottom:22px;padding:5px 13px;background:var(--blue-50);border:1px solid var(--blue-100);border-radius:var(--radius-full);font-size:.8125rem;font-weight:600;color:var(--blue-600)}
.hero-dot{width:7px;height:7px;background:var(--blue-500);border-radius:50%;animation:blink 1.5s infinite}
@keyframes blink{0%,100%{opacity:1}50%{opacity:.3}}
.hero-title{font-family:var(--font-h);font-weight:800;font-size:clamp(2.25rem,4.5vw,3.5rem);line-height:1.08;color:var(--text-dark);margin-bottom:18px}
.hero-sub{font-size:1.0625rem;color:var(--text-muted);line-height:1.75;max-width:480px;margin-bottom:34px}
.hero-cta{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:36px}
.hero-proof{display:flex;align-items:center;gap:12px}
.ha-group{display:flex}
.ha{width:32px;height:32px;border-radius:50%;border:2px solid #fff;display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;color:#fff;margin-left:-8px}
.ha:first-child{margin-left:0}
.proof-txt{font-size:.875rem;color:var(--text-muted)}
.proof-txt strong{color:var(--text-dark)}

/* Hero Visual */
.hero-visual{position:relative}
.hero-dash-card{background:#fff;border-radius:20px;border:1px solid var(--border-light);box-shadow:var(--shadow-xl);padding:24px;position:relative;animation:float 6s ease-in-out infinite}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-10px)}}
.dash-hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.dash-title-main{font-family:var(--font-h);font-size:.875rem;font-weight:600;color:var(--text-muted)}
.dash-overall{display:flex;align-items:baseline;gap:6px;font-family:var(--font-h);font-size:3.25rem;font-weight:900;color:var(--text-dark);margin:4px 0 8px}
.dash-overall span{font-size:.875rem;font-weight:500;color:var(--green-600)}
.dash-ring-row{display:flex;align-items:center;gap:20px;margin-bottom:20px}
.dash-ring{width:100px;height:100px;background:conic-gradient(var(--blue-600) 0% 63%,#F59E0B 63% 81%,#8B5CF6 81% 100%);border-radius:50%;display:flex;align-items:center;justify-content:center}
.dash-ring-in{width:68px;height:68px;background:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-family:var(--font-h);font-size:1.375rem;font-weight:800;color:var(--text-dark)}
.dash-skills{display:flex;flex-direction:column;gap:8px;flex:1}
.ds{display:flex;align-items:center;justify-content:space-between;gap:8px}
.ds-name{font-size:.75rem;color:var(--text-muted);width:60px}
.ds-bar{flex:1;height:5px;background:#F1F5F9;border-radius:3px;overflow:hidden}
.ds-fill{height:100%;border-radius:3px}
.ds-score{font-size:.75rem;font-weight:700;color:var(--text-dark);width:22px;text-align:right}
.dash-stats{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.dash-stat{padding:12px 14px;border-radius:12px;border:1px solid var(--border-light);background:var(--bg-subtle)}
.ds-icon{font-size:1.125rem;margin-bottom:5px}
.ds-lbl{font-size:.7rem;color:var(--text-muted);margin-bottom:3px;text-transform:uppercase;letter-spacing:.05em}
.ds-val{font-family:var(--font-h);font-size:1.1rem;font-weight:800;color:var(--text-dark)}
.hero-writing-card{position:absolute;top:-20px;right:-24px;background:#fff;border:1px solid var(--border-light);border-radius:14px;padding:12px 16px;box-shadow:var(--shadow-md);min-width:160px;animation:float 6s ease-in-out infinite 1s}
.hwc-title{font-size:.7rem;color:var(--text-muted);margin-bottom:4px;font-weight:600;text-transform:uppercase}
.hwc-val{font-family:var(--font-h);font-size:1.125rem;font-weight:800;color:var(--text-dark)}
.hwc-sub{font-size:.72rem;color:var(--green-600);font-weight:600;margin-top:2px}

/* Stats bar */
.stats-bar{background:var(--bg-white);border:1px solid var(--border-light);border-radius:var(--radius-2xl);box-shadow:var(--shadow-sm);display:grid;grid-template-columns:repeat(4,1fr);margin-top:56px;overflow:hidden;position:relative}
.stats-bar::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad-brand)}
.stat-it{padding:28px 24px;text-align:center;border-right:1px solid var(--border-light)}
.stat-it:last-child{border-right:none}
.stat-val{font-family:var(--font-h);font-size:2rem;font-weight:900;margin-bottom:4px}
.stat-lbl{font-size:.875rem;color:var(--text-muted);font-weight:500}

/* Goal bar */
.goal-bar{background:var(--bg-white);border:1px solid var(--border-light);border-radius:var(--radius-2xl);box-shadow:var(--shadow-sm);padding:28px 36px;display:flex;align-items:center;gap:24px;flex-wrap:wrap}
.goal-bar-left{flex:1}
.goal-bar-left p{font-size:.875rem;color:var(--text-muted);margin-top:4px}
.goal-bar-left h3{font-family:var(--font-h);font-size:1.125rem;font-weight:700;color:var(--text-dark)}
.goal-ctrl{display:flex;align-items:center;gap:12px;flex-shrink:0}
.goal-select{padding:11px 16px;border:1.5px solid var(--border-mid);border-radius:var(--radius-lg);font-family:var(--font-b);font-size:.9375rem;font-weight:600;color:var(--text-dark);background:var(--bg-subtle);appearance:none;cursor:pointer;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='7'%3E%3Cpath d='M0 0l6 7 6-7z' fill='%2364748B'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 14px center;padding-right:40px;min-width:110px;transition:all var(--dur)}
.goal-select:focus{outline:none;border-color:var(--blue-500);background-color:var(--blue-50)}
#roadmapResult{display:none;margin-top:20px;padding:18px 22px;border-radius:var(--radius-lg);background:var(--blue-50);border:1px solid var(--blue-100);font-size:.9375rem;color:var(--text-body);line-height:1.7}

/* Features */
.feat-row{display:grid;grid-template-columns:repeat(4,1fr);gap:20px}
.feat-card{padding:28px 22px;text-align:center}
.feat-icon{width:56px;height:56px;border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:1.375rem;margin:0 auto 16px}
.feat-name{font-family:var(--font-h);font-size:1.0625rem;font-weight:700;color:var(--text-dark);margin-bottom:10px}
.feat-desc{font-size:.875rem;color:var(--text-muted);line-height:1.65;margin-bottom:14px}
.feat-link{font-size:.875rem;color:var(--blue-600);font-weight:600;display:inline-flex;align-items:center;gap:5px;transition:gap var(--dur)}
.feat-link:hover{gap:9px}
.fi-w{background:#EFF6FF;color:#2563EB}
.fi-s{background:#F0FDF4;color:#16A34A}
.fi-r{background:#FFFBEB;color:#D97706}
.fi-l{background:#EEF2FF;color:#4F46E5}

/* Roadmap */
.roadmap-steps{display:flex;align-items:flex-start;gap:0;position:relative;margin-top:48px}
.roadmap-steps::before{content:'';position:absolute;top:28px;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--blue-200),var(--indigo-500),var(--purple-500))}
.rs{flex:1;display:flex;flex-direction:column;align-items:center;text-align:center;gap:12px;position:relative}
.rs-node{width:56px;height:56px;border-radius:50%;display:flex;align-items:center;justify-content:center;border:2px solid;position:relative;z-index:1;transition:transform var(--dur) var(--ease);background:var(--bg-white)}
.rs-node:hover{transform:scale(1.1)}
.rs-node i{font-size:1.1875rem}
.rs-done{border-color:var(--blue-500);color:var(--blue-600);background:var(--blue-50);box-shadow:0 4px 14px rgba(37,99,235,.18)}
.rs-curr{border-color:var(--indigo-500);background:var(--grad-brand);color:#fff;box-shadow:0 4px 18px rgba(99,102,241,.28)}
.rs-next{border-color:var(--border-mid);color:var(--text-light)}
.rs-lbl{font-size:.875rem;font-weight:600;color:var(--text-dark)}
.rs-sub{font-size:.78rem;color:var(--text-muted)}

/* AI Demo */
.ai-demo-grid{display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center}
.demo-win{background:#fff;border:1px solid var(--border-light);border-radius:18px;box-shadow:var(--shadow-lg);overflow:hidden}
.demo-topbar{background:var(--bg-subtle);border-bottom:1px solid var(--border-light);padding:10px 16px;display:flex;align-items:center;gap:10px}
.demo-dots{display:flex;gap:5px}
.demo-dots span{width:9px;height:9px;border-radius:50%}
.dd-r{background:#EF4444}.dd-y{background:#F59E0B}.dd-g{background:#22C55E}
.demo-topbar-title{font-size:.78rem;color:var(--text-muted);font-weight:500;margin-left:4px}
.demo-body{padding:20px}
.demo-essay{font-size:.875rem;color:var(--text-body);line-height:1.8;margin-bottom:16px}
.hl{border-radius:3px;padding:1px 3px}
.hl-r{background:#FEF2F2;border-bottom:2px solid var(--red-500);color:#B91C1C}
.hl-y{background:#FFFBEB;border-bottom:2px solid var(--amber-500);color:#92400E}
.hl-g{background:#F0FDF4;border-bottom:2px solid var(--green-500);color:var(--green-600)}
.demo-tags{display:flex;flex-wrap:wrap;gap:7px;margin-bottom:14px}
.dtag{display:inline-flex;align-items:center;gap:5px;padding:4px 11px;border-radius:var(--radius-full);font-size:.75rem;font-weight:600;border:1px solid}
.dt-r{background:#FEF2F2;border-color:#FCA5A5;color:#B91C1C}
.dt-y{background:#FFFBEB;border-color:#FDE68A;color:#92400E}
.dt-g{background:#F0FDF4;border-color:#86EFAC;color:var(--green-600)}
.dt-b{background:var(--blue-50);border-color:var(--blue-200);color:var(--blue-700)}
.demo-score-row{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-radius:12px;background:linear-gradient(135deg,#EFF6FF,#EEF2FF);border:1px solid var(--blue-100)}
.demo-score-lbl{font-size:.8125rem;color:var(--text-muted)}
.demo-score-val{font-family:var(--font-h);font-size:2.25rem;font-weight:900;color:var(--blue-600)}

/* Placement Test */
.pl-card{background:linear-gradient(135deg,#EFF6FF 0%,#EEF2FF 100%);border:1px solid var(--blue-100);border-radius:var(--radius-2xl);padding:60px;display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center;position:relative;overflow:hidden}
.pl-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad-cta)}
.pl-features{display:flex;flex-direction:column;gap:13px;margin:24px 0}
.pl-feat{display:flex;align-items:center;gap:11px}
.pl-feat-icon{width:28px;height:28px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.875rem;flex-shrink:0}
.pl-feat-text{font-size:.9375rem;color:var(--text-body)}
.pl-visual{background:#fff;border:1px solid var(--border-light);border-radius:20px;padding:28px;box-shadow:var(--shadow-lg);text-align:center}
.pl-ring{width:140px;height:140px;border-radius:50%;margin:0 auto 20px;background:conic-gradient(var(--blue-600) 0% 67%,#F1F5F9 67% 100%);display:flex;align-items:center;justify-content:center}
.pl-ring-in{width:100px;height:100px;background:#fff;border-radius:50%;display:flex;flex-direction:column;align-items:center;justify-content:center}
.pl-band{font-family:var(--font-h);font-size:2.25rem;font-weight:900;color:var(--text-dark)}
.pl-band-lbl{font-size:.7rem;color:var(--text-muted)}
.pl-skills{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-top:16px}
.pl-sk{background:var(--bg-subtle);border:1px solid var(--border-light);border-radius:10px;padding:9px 12px;text-align:left}
.pl-sk-name{font-size:.72rem;color:var(--text-muted);margin-bottom:2px}
.pl-sk-val{font-family:var(--font-h);font-size:1rem;font-weight:800}

/* Mock Tests */
.swiper-mock{padding:16px 4px 32px}
.mock-card{padding:24px;height:auto}
.mock-badge{display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:var(--radius-full);font-size:.72rem;font-weight:600;margin-bottom:12px;border:1px solid}
.mb-ac{background:var(--blue-50);border-color:var(--blue-100);color:var(--blue-600)}
.mb-gt{background:#F0FDF4;border-color:#BBF7D0;color:var(--green-600)}
.mock-name{font-family:var(--font-h);font-size:1rem;font-weight:700;color:var(--text-dark);margin-bottom:8px}
.mock-meta{font-size:.8125rem;color:var(--text-muted);display:flex;flex-wrap:wrap;gap:10px;margin-bottom:16px}
.mock-meta i{margin-right:3px}
.diff-dot{width:5px;height:5px;border-radius:50%;display:inline-block;margin-left:1px}

/* Testimonials */
.testi-card{padding:26px}
.stars{color:var(--amber-400);font-size:.875rem;margin-bottom:12px}
.testi-quote{font-size:.9375rem;color:var(--text-body);line-height:1.7;margin-bottom:16px;font-style:italic}
.testi-person{display:flex;align-items:center;gap:11px}
.testi-av{width:44px;height:44px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;color:#fff;font-size:1rem;flex-shrink:0}
.testi-name{font-weight:700;font-size:.9375rem;color:var(--text-dark)}
.testi-role{font-size:.8125rem;color:var(--text-muted)}
.testi-result{display:flex;align-items:center;gap:8px;margin-top:12px;padding:8px 12px;background:#F0FDF4;border:1px solid #BBF7D0;border-radius:9px;font-size:.8125rem}
.tr-from{color:var(--text-muted)}
.tr-to{font-weight:700;color:var(--green-600)}

/* Pricing */
.pricing-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;align-items:start}
.price-card{padding:30px;position:relative}
.price-card.featured{background:linear-gradient(145deg,#EFF6FF,#EEF2FF);border-color:var(--blue-200);transform:translateY(-6px);box-shadow:var(--shadow-xl)}

.price-badge{position:absolute;top:-11px;left:50%;transform:translateX(-50%);background:var(--grad-brand);color:#fff;padding:3px 14px;border-radius:var(--radius-full);font-size:.72rem;font-weight:700;white-space:nowrap}
.price-plan{font-size:.8125rem;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px}
.price-amount{display:flex;align-items:baseline;gap:3px;margin-bottom:6px}
.p-cur{font-size:1.1rem;font-weight:600;color:var(--text-muted)}
.p-num{font-family:var(--font-h);font-size:2.75rem;font-weight:900;color:var(--text-dark);}
.p-per{font-size:.875rem;color:var(--text-muted)}
.price-desc{font-size:.875rem;color:var(--text-muted);margin-bottom:22px;line-height:1.6}
.price-feats{display:flex;flex-direction:column;gap:10px;margin-bottom:24px}
.pf{display:flex;align-items:flex-start;gap:9px;font-size:.9rem;color:var(--text-body)}
.pf-ok{color:var(--green-500);flex-shrink:0;margin-top:1px}
.pf-no{color:var(--border-mid);flex-shrink:0;margin-top:1px}
.pf-dis{color:var(--text-light);text-decoration:line-through}

/* FAQ */
.faq-list{max-width:760px;margin:0 auto;display:flex;flex-direction:column;gap:8px}
.faq-item{background:var(--bg-white);border:1px solid var(--border-light);border-radius:var(--radius-xl);overflow:hidden;box-shadow:var(--shadow-xs)}
.faq-item.open{border-color:var(--blue-200);box-shadow:0 4px 16px rgba(37,99,235,.08)}
.faq-q{width:100%;display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 20px;text-align:left;font-size:.9375rem;font-weight:600;color:var(--text-dark);cursor:pointer;background:none;border:none;font-family:inherit;transition:color var(--dur)}
.faq-q:hover{color:var(--blue-600)}
.faq-chev{color:var(--text-muted);font-size:.875rem;transition:transform var(--dur) var(--ease);flex-shrink:0}
.faq-item.open .faq-chev{transform:rotate(180deg);color:var(--blue-600)}
.faq-a{padding:0 20px;max-height:0;overflow:hidden;transition:max-height .4s var(--ease)}
.faq-item.open .faq-a{max-height:240px;padding:0 20px 16px}
.faq-a p{font-size:.9375rem;color:var(--text-muted);line-height:1.72}

/* Blog */
.blog-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.blog-card{overflow:hidden}
.blog-thumb{aspect-ratio:16/9.5;display:flex;align-items:center;justify-content:center;font-size:2.75rem;background:var(--bg-section)}
.blog-body{padding:20px}
.blog-cat{font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:7px;color:var(--blue-600)}
.blog-title{font-family:var(--font-h);font-size:1.0625rem;font-weight:700;color:var(--text-dark);line-height:1.4;margin-bottom:9px}
.blog-excerpt{font-size:.875rem;color:var(--text-muted);line-height:1.65;margin-bottom:12px}
.blog-meta{display:flex;align-items:center;justify-content:space-between;font-size:.8125rem;color:var(--text-light)}
.blog-more{color:var(--blue-600);font-weight:600;display:flex;align-items:center;gap:4px;transition:gap var(--dur)}
.blog-more:hover{gap:8px}

/* Newsletter */
.nl-card{background:linear-gradient(135deg,#EFF6FF 0%,#EEF2FF 50%,#F0FDF4 100%);border:1px solid var(--border-light);border-radius:var(--radius-2xl);padding:56px;text-align:center;position:relative;overflow:hidden}
.nl-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad-brand)}
.nl-form{display:flex;gap:10px;max-width:440px;margin:24px auto 0}
.nl-inp{flex:1;padding:12px 18px;background:#fff;border:1.5px solid var(--border-mid);border-radius:var(--radius-lg);color:var(--text-dark);font-family:inherit;font-size:.9375rem}
.nl-inp::placeholder{color:var(--text-light)}
.nl-inp:focus{outline:none;border-color:var(--blue-500)}

/* Footer */
footer{background:var(--text-dark);color:rgba(255,255,255,.75);padding:56px 0 24px}
.foot-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;margin-bottom:40px}
.foot-desc{font-size:.9375rem;line-height:1.7;margin:12px 0 20px;color:rgba(255,255,255,.55)}
.foot-socials{display:flex;gap:8px}
.fsb{width:34px;height:34px;border-radius:8px;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.06);color:rgba(255,255,255,.55);font-size:.875rem;transition:all var(--dur);border:1px solid rgba(255,255,255,.10)}
.fsb:hover{background:rgba(255,255,255,.12);color:#fff;transform:translateY(-2px)}
.foot-col-hdr{font-size:.8125rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;margin-bottom:16px;color:rgba(255,255,255,.9)}
.foot-links{display:flex;flex-direction:column;gap:9px}
.foot-link{font-size:.9375rem;color:rgba(255,255,255,.55);transition:color var(--dur)}
.foot-link:hover{color:#fff}
.foot-bottom{display:flex;align-items:center;justify-content:space-between;padding-top:20px;border-top:1px solid rgba(255,255,255,.08);font-size:.875rem;color:rgba(255,255,255,.35);flex-wrap:wrap;gap:10px}
.foot-bottom a{color:rgba(255,255,255,.35);margin-left:14px;transition:color var(--dur)}
.foot-bottom a:hover{color:rgba(255,255,255,.7)}


/* Swiper */
.swiper-pagination-bullet{background:var(--border-mid)!important;opacity:1!important}
.swiper-pagination-bullet-active{background:var(--blue-500)!important}

/* Language overlay */
.lang-overlay{position:absolute;top:46px;right:0;background:var(--bg-white);border:1px solid var(--border-light);border-radius:12px;box-shadow:var(--shadow-md);overflow:hidden;display:none;min-width:120px;z-index:100}
.lang-overlay.open{display:block}
.lang-opt{display:flex;align-items:center;gap:8px;padding:10px 16px;font-size:.875rem;color:var(--text-body);cursor:pointer;transition:background var(--dur)}
.lang-opt:hover{background:var(--bg-subtle)}
.lang-opt.active{color:var(--blue-600);font-weight:600}
.lang-wrap{position:relative}

/* Responsive */
@media(max-width:1100px){
  .hero-grid{grid-template-columns:1fr;gap:40px;text-align:center}
  .hero-sub{margin-left:auto;margin-right:auto}
  .hero-cta{justify-content:center}
  .hero-proof{justify-content:center}
  .hero-visual{display:none}
  .feat-row{grid-template-columns:repeat(2,1fr)}
}
@media(max-width:900px){
  .ai-demo-grid,.pl-card{grid-template-columns:1fr}
  .pl-card{padding:36px 24px}
  .pricing-grid{grid-template-columns:1fr}
  .price-card.featured{transform:none}
  .stats-bar{grid-template-columns:1fr 1fr}
  .stat-it:nth-child(2){border-right:none}
  .stat-it:nth-child(3){border-right:1px solid var(--border-light)}
  .foot-grid{grid-template-columns:1fr 1fr}
  .blog-grid{grid-template-columns:1fr}
}
@media(max-width:768px){
  .nav-links,.btn-ghost-sm{display:none}
  .hamburger{display:flex}
  .section{padding:56px 0}
  .feat-row{grid-template-columns:1fr 1fr;gap:14px}
  .goal-bar{flex-direction:column;align-items:stretch}
  .goal-ctrl{flex-direction:column}
  .nl-form{flex-direction:column}
  .blog-grid{grid-template-columns:1fr}
  .foot-grid{grid-template-columns:1fr;gap:24px}
  .foot-bottom{flex-direction:column;align-items:flex-start}
}
@media(max-width:480px){
  .feat-row{grid-template-columns:1fr}
  .stats-bar{grid-template-columns:1fr}
  .stat-it{border-right:none;border-bottom:1px solid var(--border-light)}
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="mainNav">
  <div class="nav-inner">
    <a href="${pageContext.request.contextPath}/" class="nav-logo">
      <div class="nav-logo-mark"><i class="fas fa-graduation-cap"></i></div>
      <span class="nav-logo-text">IELTS<span>Flow</span></span>
    </a>

    <div class="nav-links">
      <a href="${pageContext.request.contextPath}/"                     class="nav-link active">Trang chủ</a>
      <a href="${pageContext.request.contextPath}/candidate/tests"      class="nav-link">Luyện tập</a>
      <a href="${pageContext.request.contextPath}/auth?redirect=tests"  class="nav-link">AI Writing</a>
      <a href="${pageContext.request.contextPath}/auth?redirect=tests" class="nav-link">AI Speaking</a>
      <a href="${pageContext.request.contextPath}/auth?redirect=mock-test"  class="nav-link">Mock Test</a>
      <a href="${pageContext.request.contextPath}/subscription"         class="nav-link">Bảng giá</a>
      <a href="#library-section"                                        class="nav-link">Thư viện</a>
    </div>

    <div class="nav-actions">
      <c:choose>
        <c:when test="${not empty sessionScope.fullName}">
          <c:choose>
            <c:when test="${sessionScope.roleId == 1}">
              <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">Bảng điều khiển</a>
            </c:when>
            <c:when test="${sessionScope.roleId == 2}">
              <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn btn-primary btn-sm">Bảng điều khiển</a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-primary btn-sm">Dashboard</a>
            </c:otherwise>
          </c:choose>
          <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm" style="border:1.5px solid var(--border-mid);border-radius:9px;">Đăng xuất</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/auth?mode=login"    class="btn btn-ghost btn-sm" style="border:1.5px solid var(--border-mid);border-radius:9px;">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-primary btn-sm">Đăng ký miễn phí</a>
        </c:otherwise>
      </c:choose>

      <button class="hamburger" id="mobToggle" aria-expanded="false">
        <span></span><span></span><span></span>
      </button>
    </div>
  </div>
</nav>

<!-- Mobile Menu -->
<div class="mob-menu" id="mobMenu">
  <a href="${pageContext.request.contextPath}/"                     class="mob-link">Trang chủ</a>
  <a href="${pageContext.request.contextPath}/candidate/tests"      class="mob-link">Luyện tập</a>
  <a href="${pageContext.request.contextPath}/auth?redirect=tests"  class="mob-link">AI Writing</a>
  <a href="${pageContext.request.contextPath}/auth?redirect=tests" class="mob-link">AI Speaking</a>
  <a href="${pageContext.request.contextPath}/auth?redirect=mock-test"  class="mob-link">Mock Test</a>
  <a href="${pageContext.request.contextPath}/subscription"         class="mob-link">Bảng giá</a>
  <a href="#library-section"                                        class="mob-link">Thư viện</a>
  <div class="mob-sep"></div>
  <div class="mob-btns">
    <c:choose>
      <c:when test="${not empty sessionScope.fullName}">
        <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-primary">Dashboard</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng xuất</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/auth?mode=login"    class="btn btn-outline">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-primary">Đăng ký miễn phí</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- HERO -->
<section class="hero" id="hero">
  <div class="container">
    <div class="hero-grid">
      <div data-sr="fade-right">
        <div class="hero-badge">
          <span class="hero-dot"></span>
          <i class="fas fa-graduation-cap"></i>
          Thư viện luyện thi IELTS thông minh hàng đầu
        </div>
        <h1 class="hero-title">
          Chinh phục IELTS<br>
          <span class="tg">nhanh hơn với AI</span>
        </h1>
        <p class="hero-sub">
          Làm <strong>Placement Test</strong> miễn phí → AI xây <strong>Lộ trình cá nhân</strong> → Luyện <strong>4 kỹ năng</strong> từ ngân hàng đề Mentor → <strong>AI chấm điểm</strong> Writing &amp; Speaking chi tiết.
        </p>
        <div class="hero-cta">
          <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="btn btn-primary btn-lg">
            <i class="fas fa-bullseye"></i> Làm Placement Test miễn phí
          </a>
          <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-outline btn-lg">
            <i class="fas fa-rocket"></i> Đăng ký ngay
          </a>
        </div>
        <div class="hero-proof">
          <div class="ha-group">
            <div class="ha" style="background:linear-gradient(135deg,#2563EB,#6366F1)">T</div>
            <div class="ha" style="background:linear-gradient(135deg,#16A34A,#2563EB)">A</div>
            <div class="ha" style="background:linear-gradient(135deg,#F59E0B,#EF4444)">M</div>
            <div class="ha" style="background:linear-gradient(135deg,#8B5CF6,#EC4899)">N</div>
            <div class="ha" style="background:linear-gradient(135deg,#14B8A6,#2563EB)">+</div>
          </div>
          <p class="proof-txt"><strong>Học viên tin dùng</strong> &bull; Placement Test &bull; AI Lộ trình &bull; 4 kỹ năng</p>
        </div>
      </div>

      <div class="hero-visual" data-sr="fade-left">
        <div class="hero-dash-card">
          <div class="dash-hdr">
            <span class="dash-title-main">Dự đoán band điểm</span>
            <span style="font-size:.8125rem;color:var(--text-muted);">Tháng 7, 2026</span>
          </div>
          <div style="display:flex;align-items:flex-end;gap:6px;margin-bottom:4px;">
            <div style="font-family:var(--font-h);font-size:.875rem;font-weight:600;color:var(--text-muted);">Overall</div>
            <div class="dash-overall">7.5 <span>&#8593;0.5 so với lần trước</span></div>
          </div>
          <div class="dash-ring-row">
            <div class="dash-ring-wrap">
              <div class="dash-ring"><div class="dash-ring-in">7.5</div></div>
            </div>
            <div class="dash-skills">
              <div class="ds"><span class="ds-name">Listening</span><div class="ds-bar"><div class="ds-fill" style="width:87.5%;background:#2563EB;"></div></div><span class="ds-score">7.0</span></div>
              <div class="ds"><span class="ds-name">Reading</span><div class="ds-bar"><div class="ds-fill" style="width:93.75%;background:#6366F1;"></div></div><span class="ds-score">7.5</span></div>
              <div class="ds"><span class="ds-name">Writing</span><div class="ds-bar"><div class="ds-fill" style="width:87.5%;background:#8B5CF6;"></div></div><span class="ds-score">7.0</span></div>
              <div class="ds"><span class="ds-name">Speaking</span><div class="ds-bar"><div class="ds-fill" style="width:93.75%;background:#14B8A6;"></div></div><span class="ds-score">7.5</span></div>
            </div>
          </div>
          <div class="dash-stats">
            <div class="dash-stat"><div class="ds-icon">🔥</div><div class="ds-lbl">Chuỗi học tập</div><div class="ds-val">21 ngày</div></div>
            <div class="dash-stat"><div class="ds-icon">📚</div><div class="ds-lbl">Từ vựng mới</div><div class="ds-val">1.250 từ</div></div>
          </div>
          <div class="hero-writing-card">
            <div class="hwc-title">Writing Task 2</div>
            <div class="hwc-val">Band 7.0</div>
            <div class="hwc-sub">⭐ Good</div>
          </div>
        </div>
      </div>
    </div>

    <div class="stats-bar" data-sr="fade-up" style="position:relative;z-index:1;">
      <div class="stat-it"><div class="stat-val tg" data-counter="4" data-suffix=" kỹ năng">4 kỹ năng</div><div class="stat-lbl">Listening · Reading · Writing · Speaking</div></div>
      <div class="stat-it"><div class="stat-val" style="background:linear-gradient(135deg,#16A34A,#2563EB);-webkit-background-clip:text;-webkit-text-fill-color:transparent;" data-counter="100" data-suffix="%">100%</div><div class="stat-lbl">Đề do Mentor soạn, chuẩn định dạng IELTS</div></div>
      <div class="stat-it"><div class="stat-val" style="background:linear-gradient(135deg,#6366F1,#8B5CF6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;">AI</div><div class="stat-lbl">Chấm điểm Writing &amp; Speaking tức thì</div></div>
      <div class="stat-it"><div class="stat-val" style="background:linear-gradient(135deg,#F59E0B,#EF4444);-webkit-background-clip:text;-webkit-text-fill-color:transparent;">Miễn phí</div><div class="stat-lbl">Placement Test đánh giá đầu vào</div></div>
    </div>
  </div>
</section>

<!-- GOAL GENERATOR -->
<section style="padding:40px 0;background:var(--bg-white);border-top:1px solid var(--border-light);border-bottom:1px solid var(--border-light);">
  <div class="container">
    <div class="goal-bar" data-sr="fade-up">

      <%-- Đã đăng nhập và có CandidateTarget --%>
      <c:choose>
        <c:when test="${not empty sessionScope.userId and not empty candidateTarget}">
          <div class="goal-bar-left">
            <h3>🎯 Mục tiêu của bạn: Band <span style="color:var(--blue-600);">${candidateTarget.targetBand}</span></h3>
            <p>
              Trình độ hiện tại:
              <c:choose>
                <c:when test="${not empty candidateTarget.currentBand}">
                  <strong>Band ${candidateTarget.currentBand}</strong> &rarr;
                </c:when>
                <c:otherwise>Chưa đánh giá &rarr;</c:otherwise>
              </c:choose>
              Mục tiêu: <strong>Band ${candidateTarget.targetBand}</strong>.
              AI đã xây lộ trình cá nhân cho bạn!
            </p>
          </div>
          <div class="goal-ctrl">
            <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-primary">
              <i class="fas fa-map"></i> Xem lộ trình học
            </a>
            <a href="${pageContext.request.contextPath}/ielts-target" class="btn btn-outline">
              <i class="fas fa-edit"></i> Cập nhật mục tiêu
            </a>
          </div>
        </c:when>

        <%-- Đã đăng nhập nhưng chưa có target --%>
        <c:when test="${not empty sessionScope.userId}">
          <div class="goal-bar-left">
            <h3>🚀 Bắt đầu hành trình của bạn!</h3>
            <p>Làm <strong>Placement Test miễn phí</strong> để AI đánh giá trình độ và tạo lộ trình cá nhân hóa cho bạn.</p>
          </div>
          <div class="goal-ctrl">
            <a href="${pageContext.request.contextPath}/placement-test" class="btn btn-primary">
              <i class="fas fa-bullseye"></i> Làm Placement Test ngay
            </a>
          </div>
        </c:when>

        <%-- Chưa đăng nhập – form JS chọn band --%>
        <c:otherwise>
          <div class="goal-bar-left">
            <h3>Bạn muốn đạt band điểm nào?</h3>
            <p>Chọn mục tiêu để xem lộ trình học gợi ý. Đăng ký để AI tạo lộ trình cá nhân hóa chính xác hơn.</p>
          </div>
          <div class="goal-ctrl">
            <select class="goal-select" id="targetBand">
              <option value="">Chọn band...</option>
              <option value="5.0">5.0</option>
              <option value="5.5">5.5</option>
              <option value="6.0">6.0</option>
              <option value="6.5" selected>6.5</option>
              <option value="7.0">7.0</option>
              <option value="7.5">7.5</option>
              <option value="8.0">8.0</option>
              <option value="8.5">8.5</option>
            </select>
            <button class="btn btn-primary" onclick="generateRoadmap()" id="genBtn">
              <i class="fas fa-wand-magic-sparkles"></i> Xem lộ trình gợi ý &rarr;
            </button>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
    <div id="roadmapResult">
      <strong style="color:var(--blue-600);">💡 Lộ trình gợi ý cho Band <span id="selBand">6.5</span>:</strong>
      <div id="roadmapContent" style="margin-top:8px;"></div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="section" id="features" style="background:var(--bg-page);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-blue"><i class="fas fa-star"></i> Tính năng cốt lõi</div>
      <h2 class="sec-title">Hệ thống học IELTS<br><span class="tg">toàn diện từ A đến Z</span></h2>
      <p class="sec-sub">Từ đánh giá đầu vào, xây lộ trình, luyện 4 kỹ năng đến chấm điểm AI – tất cả trong một nền tảng.</p>
    </div>
    <div class="feat-row">
      <div class="card feat-card" data-sr="zoom-in">
        <div class="feat-icon" style="background:#EEF2FF;color:#4F46E5;"><i class="fas fa-bullseye"></i></div>
        <div class="feat-name">Placement Test</div>
        <div class="feat-desc">Bài kiểm tra đầu vào miễn phí đánh giá trình độ cả 4 kỹ năng, xác định điểm mạnh yếu của bạn.</div>
        <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="feat-link">Làm ngay miễn phí <i class="fas fa-arrow-right"></i></a>
      </div>
      <div class="card feat-card" data-sr="zoom-in" data-sr-delay="80">
        <div class="feat-icon" style="background:#FFFBEB;color:#D97706;"><i class="fas fa-map"></i></div>
        <div class="feat-name">AI Lộ trình cá nhân</div>
        <div class="feat-desc">AI tự động xây lộ trình học tập cá nhân hóa theo kết quả Placement Test và mục tiêu band điểm của bạn.</div>
        <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="feat-link">Tạo lộ trình ngay <i class="fas fa-arrow-right"></i></a>
      </div>
      <div class="card feat-card" data-sr="zoom-in" data-sr-delay="160">
        <div class="feat-icon" style="background:#F0FDF4;color:#16A34A;"><i class="fas fa-dumbbell"></i></div>
        <div class="feat-name">Luyện 4 kỹ năng</div>
        <div class="feat-desc">Ngân hàng đề luyện tập phong phú do Mentor soạn: Listening, Reading, Writing Task 1 &amp; 2, Speaking.</div>
        <a href="${pageContext.request.contextPath}/candidate/tests" class="feat-link">Luyện tập ngay <i class="fas fa-arrow-right"></i></a>
      </div>
      <div class="card feat-card" data-sr="zoom-in" data-sr-delay="240">
        <div class="feat-icon fi-w"><i class="fas fa-robot"></i></div>
        <div class="feat-name">AI Chấm điểm</div>
        <div class="feat-desc">AI chấm Writing &amp; Speaking theo tiêu chí IELTS thực tế, phân tích lỗi sai và gợi ý cải thiện tức thì.</div>
        <a href="${pageContext.request.contextPath}/auth?redirect=tests" class="feat-link">Thử ngay <i class="fas fa-arrow-right"></i></a>
      </div>
    </div>
  </div>
</section>

<!-- ROADMAP STEPS -->
<section class="section" style="background:var(--bg-white);border-top:1px solid var(--border-light);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-indigo"><i class="fas fa-route"></i> Lộ trình học</div>
      <h2 class="sec-title">Học IELTS theo lộ trình<br><span class="tg">cá nhân hóa</span></h2>
      <p class="sec-sub">AI sẽ phân tích trình độ hiện tại và tạo lộ trình tối ưu cho bạn.</p>
    </div>
    <div data-sr="fade-up" data-sr-delay="200" style="overflow-x:auto;">
      <div class="roadmap-steps" style="min-width:600px;">
        <div class="rs">
          <div class="rs-node rs-done"><i class="fas fa-search"></i></div>
          <div class="rs-lbl">Kiểm tra trình độ</div>
          <div class="rs-sub">Đánh giá cả năng lực 4 kỹ năng</div>
        </div>
        <div class="rs">
          <div class="rs-node rs-done"><i class="fas fa-robot"></i></div>
          <div class="rs-lbl">Phân tích AI</div>
          <div class="rs-sub">Xác định điểm mạnh, yếu</div>
        </div>
        <div class="rs">
          <div class="rs-node rs-curr"><i class="fas fa-map"></i></div>
          <div class="rs-lbl">Lộ trình cá nhân</div>
          <div class="rs-sub">Xây dựng kế hoạch học tập</div>
        </div>
        <div class="rs">
          <div class="rs-node rs-next"><i class="fas fa-dumbbell"></i></div>
          <div class="rs-lbl">Học &amp; luyện tập</div>
          <div class="rs-sub">Thực hành theo lộ trình</div>
        </div>
        <div class="rs">
          <div class="rs-node rs-next"><i class="fas fa-trophy"></i></div>
          <div class="rs-lbl">Đạt mục tiêu</div>
          <div class="rs-sub">Chinh phục band điểm mơ ước</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- AI DEMO -->
<section class="section" style="background:var(--bg-section);">
  <div class="container">
    <div class="ai-demo-grid">
      <div data-sr="fade-right">
        <div class="label lb-blue"><i class="fas fa-robot"></i> AI Writing Evaluator</div>
        <h2 class="sec-title">AI Phân Tích Bài Viết<br><span class="tg">Trong 5 Giây</span></h2>
        <p class="sec-sub" style="margin-bottom:24px;">Hệ thống AI chấm bài theo tiêu chí Cambridge thực tế. Phân tích ngữ pháp, từ vựng, mạch lạc và dự đoán band điểm chính xác.</p>
        <div style="display:flex;flex-direction:column;gap:12px;">
          <div style="display:flex;align-items:center;gap:11px;padding:13px 16px;background:var(--bg-white);border:1px solid var(--border-light);border-radius:12px;box-shadow:var(--shadow-xs);">
            <div style="width:30px;height:30px;border-radius:8px;background:#EFF6FF;display:flex;align-items:center;justify-content:center;color:var(--blue-600);flex-shrink:0;"><i class="fas fa-check"></i></div>
            <div><div style="font-weight:600;font-size:.9375rem;color:var(--text-dark);">Kiểm tra ngữ pháp toàn diện</div><div style="font-size:.8125rem;color:var(--text-muted);">Phát hiện và giải thích từng lỗi sai</div></div>
          </div>
          <div style="display:flex;align-items:center;gap:11px;padding:13px 16px;background:var(--bg-white);border:1px solid var(--border-light);border-radius:12px;box-shadow:var(--shadow-xs);">
            <div style="width:30px;height:30px;border-radius:8px;background:#F0FDF4;display:flex;align-items:center;justify-content:center;color:var(--green-600);flex-shrink:0;"><i class="fas fa-language"></i></div>
            <div><div style="font-weight:600;font-size:.9375rem;color:var(--text-dark);">Gợi ý từ vựng band cao</div><div style="font-size:.8125rem;color:var(--text-muted);">Đề xuất cách dùng từ chính xác hơn</div></div>
          </div>
          <div style="display:flex;align-items:center;gap:11px;padding:13px 16px;background:var(--bg-white);border:1px solid var(--border-light);border-radius:12px;box-shadow:var(--shadow-xs);">
            <div style="width:30px;height:30px;border-radius:8px;background:#EEF2FF;display:flex;align-items:center;justify-content:center;color:var(--indigo-600);flex-shrink:0;"><i class="fas fa-chart-bar"></i></div>
            <div><div style="font-weight:600;font-size:.9375rem;color:var(--text-dark);">Dự đoán band điểm chính xác</div><div style="font-size:.8125rem;color:var(--text-muted);">Theo 4 tiêu chí của Cambridge IELTS</div></div>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/auth?redirect=tests" class="btn btn-primary" style="margin-top:24px;">
          <i class="fas fa-pen-nib"></i> Thử ngay miễn phí
        </a>
      </div>
      <div data-sr="fade-left">
        <div class="demo-win">
          <div class="demo-topbar">
            <div class="demo-dots"><span class="dd-r"></span><span class="dd-y"></span><span class="dd-g"></span></div>
            <span class="demo-topbar-title">IELTSFLOW AI Writing Evaluator &mdash; Task 2</span>
          </div>
          <div class="demo-body">
            <div class="demo-essay">
              &ldquo;<span class="hl hl-r">Despite of</span> the rapid growth of technology,
              many people <span class="hl hl-y">argue that</span> traditional education
              remains <span class="hl hl-g">indispensable</span> to society.
              This essay will <span class="hl hl-r">discuss about</span> both perspectives
              and provide a <span class="hl hl-g">balanced assessment</span>...&rdquo;
            </div>
            <div class="demo-tags">
              <span class="dtag dt-r"><i class="fas fa-exclamation-circle"></i> 2 Lỗi ngữ pháp</span>
              <span class="dtag dt-y"><i class="fas fa-lightbulb"></i> 3 Gợi ý từ vựng</span>
              <span class="dtag dt-g"><i class="fas fa-check-circle"></i> Mạch lạc tốt</span>
              <span class="dtag dt-b"><i class="fas fa-chart-line"></i> Task Achievement: B6</span>
            </div>
            <div class="demo-score-row">
              <div>
                <div class="demo-score-lbl">🤖 AI Estimated Band Score</div>
                <div style="font-size:.8125rem;color:var(--text-muted);margin-top:2px;">Grammar: 6.0 &bull; Lexical: 6.5 &bull; Coherence: 7.0</div>
              </div>
              <div class="demo-score-val">6.5</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- PLACEMENT TEST -->
<section class="section" style="background:var(--bg-white);">
  <div class="container">
    <div class="pl-card" data-sr="fade-up">
      <div>
        <div class="label lb-green"><i class="fas fa-bullseye"></i> Miễn phí</div>
        <h2 class="sec-title">Khám phá trình độ<br><span class="tg">IELTS hiện tại</span></h2>
        <p class="sec-sub" style="margin-bottom:0;">Bài test AI 15 phút đánh giá cả 4 kỹ năng, dự đoán band score và tạo lộ trình học cá nhân cho bạn.</p>
        <div class="pl-features">
          <div class="pl-feat"><div class="pl-feat-icon" style="background:#EFF6FF;color:var(--blue-600);"><i class="fas fa-robot"></i></div><span class="pl-feat-text">AI Assessment thông minh - chính xác cao</span></div>
          <div class="pl-feat"><div class="pl-feat-icon" style="background:#F0FDF4;color:var(--green-600);"><i class="fas fa-chart-bar"></i></div><span class="pl-feat-text">Estimated Band Score cho từng kỹ năng</span></div>
          <div class="pl-feat"><div class="pl-feat-icon" style="background:#FFFBEB;color:#D97706;"><i class="fas fa-triangle-exclamation"></i></div><span class="pl-feat-text">Weak Skill Analysis - biết rõ điểm yếu</span></div>
          <div class="pl-feat"><div class="pl-feat-icon" style="background:#EEF2FF;color:var(--indigo-600);"><i class="fas fa-map"></i></div><span class="pl-feat-text">Personalized Study Plan - lộ trình 60 ngày</span></div>
        </div>
        <!-- Nút này redirect sang auth nếu chưa đăng nhập, auth sau đó redirect sang placement-test -->
        <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="btn btn-primary btn-lg">
          <i class="fas fa-play-circle"></i> Kiểm tra trình độ ngay miễn phí
        </a>
      </div>
      <div data-sr="zoom-in" data-sr-delay="200">
        <div class="pl-visual">
          <div style="font-size:.8125rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:.08em;margin-bottom:16px;font-weight:600;">Kết quả mẫu AI</div>
          <div class="pl-ring">
            <div class="pl-ring-in">
              <div class="pl-band tg">6.0</div>
              <div class="pl-band-lbl">Band Score</div>
            </div>
          </div>
          <div class="pl-skills">
            <div class="pl-sk"><div class="pl-sk-name">Listening</div><div class="pl-sk-val" style="color:var(--indigo-600);">6.5</div></div>
            <div class="pl-sk"><div class="pl-sk-name">Reading</div><div class="pl-sk-val" style="color:#D97706;">6.0</div></div>
            <div class="pl-sk"><div class="pl-sk-name">Writing</div><div class="pl-sk-val" style="color:var(--blue-600);">5.5</div></div>
            <div class="pl-sk"><div class="pl-sk-name">Speaking</div><div class="pl-sk-val" style="color:var(--green-600);">6.0</div></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- MOCK TESTS -->
<section class="section" style="background:var(--bg-section);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-blue"><i class="fas fa-file-alt"></i> Mock Tests</div>
      <h2 class="sec-title">Thi thử với đề từ<br><span class="tg">Ngân hàng đề thi</span></h2>
      <p class="sec-sub">Lấy ngẫu nhiên một bộ đề thi thử chuẩn định dạng IELTS do Mentor soạn để đánh giá chính xác năng lực của bạn.</p>
      <p style="font-size:.8125rem;color:var(--text-light);margin-top:6px;"><i class="fas fa-info-circle"></i> Đề do Mentor IELTSFlow soạn, không phải đề Cambridge chính thức.</p>
    </div>
    
    <div class="mock-feature-wrapper" style="max-width: 800px; margin: 0 auto;" data-sr="fade-up" data-sr-delay="200">
      <div class="card" style="padding: 2rem; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 1.5rem;">
        <div style="display: flex; gap: 2rem; flex-wrap: wrap; justify-content: center; margin-bottom: 1rem;">
          <div class="mock-feature-item" style="display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
            <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(37, 99, 235, 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
              <i class="fas fa-random"></i>
            </div>
            <h4 style="font-size: 1rem; font-weight: 600; color: var(--text-dark);">Đề ngẫu nhiên</h4>
            <span style="font-size: 0.875rem; color: var(--text-light);">Lấy ngẫu nhiên từ ngân hàng đề</span>
          </div>
          <div class="mock-feature-item" style="display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
            <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(16, 185, 129, 0.1); color: var(--green-600); display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
              <i class="fas fa-compress-arrows-alt"></i>
            </div>
            <h4 style="font-size: 1rem; font-weight: 600; color: var(--text-dark);">Focus Mode</h4>
            <span style="font-size: 0.875rem; color: var(--text-light);">Chế độ tập trung thi mô phỏng</span>
          </div>
          <div class="mock-feature-item" style="display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
            <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(139, 92, 246, 0.1); color: #8b5cf6; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
              <i class="fas fa-robot"></i>
            </div>
            <h4 style="font-size: 1rem; font-weight: 600; color: var(--text-dark);">AI Chấm Điểm</h4>
            <span style="font-size: 0.875rem; color: var(--text-light);">Dự đoán Overall Band bằng AI</span>
          </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/auth?redirect=mock-test" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 1.1rem;">Bắt đầu lấy đề và thi <i class="fas fa-arrow-right"></i></a>
      </div>
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="section" style="background:var(--bg-white);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-amber"><i class="fas fa-star"></i> Thành công</div>
      <h2 class="sec-title">Học viên nói gì về<br><span class="tg">IELTSFlow</span></h2>
    </div>
    <div class="swiper" id="testiSwiper" data-sr="fade-up" data-sr-delay="200">
      <div class="swiper-wrapper">
        <div class="swiper-slide"><div class="card testi-card">
          <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
          <div class="testi-quote">"Tôi đã dùng IELTSFlow trong 3 tháng và cải thiện được 2 band! AI Writing feedback cực kỳ chi tiết, giải thích rõ từng lỗi sai. Highly recommend!"</div>
          <div class="testi-person">
            <div class="testi-av" style="background:linear-gradient(135deg,#2563EB,#6366F1)">N</div>
            <div><div class="testi-name">Nguyễn Thị Anh</div><div class="testi-role">Đại học Ngoại thương, Hà Nội</div></div>
          </div>
          <div class="testi-result"><span class="tr-from">Band 5.5</span><span style="color:var(--text-muted);">→</span><span class="tr-to">🏆 Band 7.5 sau 3 tháng</span></div>
        </div></div>
        <div class="swiper-slide"><div class="card testi-card">
          <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
          <div class="testi-quote">"AI Speaking coach là điểm mạnh nhất. Ghi âm và nhận feedback ngay lập tức về pronunciation và fluency, rất tiết kiệm thời gian!"</div>
          <div class="testi-person">
            <div class="testi-av" style="background:linear-gradient(135deg,#16A34A,#14B8A6)">T</div>
            <div><div class="testi-name">Trần Minh Khoa</div><div class="testi-role">Software Engineer, TP.HCM</div></div>
          </div>
          <div class="testi-result"><span class="tr-from">Band 6.0</span><span style="color:var(--text-muted);">→</span><span class="tr-to">🏆 Band 7.5 sau 2 tháng</span></div>
        </div></div>
        <div class="swiper-slide"><div class="card testi-card">
          <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
          <div class="testi-quote">"Mock tests Cambridge đầy đủ và phân tích sau khi thi rất chi tiết. Placement test giúp tôi biết chính xác điểm yếu cần cải thiện."</div>
          <div class="testi-person">
            <div class="testi-av" style="background:linear-gradient(135deg,#F59E0B,#EF4444)">P</div>
            <div><div class="testi-name">Phạm Thị Thanh Hương</div><div class="testi-role">Giáo viên, Đà Nẵng</div></div>
          </div>
          <div class="testi-result"><span class="tr-from">Band 6.5</span><span style="color:var(--text-muted);">→</span><span class="tr-to">🏆 Band 8.0 sau 4 tháng</span></div>
        </div></div>
        <div class="swiper-slide"><div class="card testi-card">
          <div class="stars">&#9733;&#9733;&#9733;&#9733;⭐</div>
          <div class="testi-quote">"AI Mentor luôn sẵn sàng giải thích mọi thứ rõ ràng. Như có gia sư riêng mà không tốn quá nhiều tiền. App rất dễ dùng!"</div>
          <div class="testi-person">
            <div class="testi-av" style="background:linear-gradient(135deg,#8B5CF6,#EC4899)">L</div>
            <div><div class="testi-name">Lê Quang Huy</div><div class="testi-role">Sinh viên năm 3, Cần Thơ</div></div>
          </div>
          <div class="testi-result"><span class="tr-from">Band 5.0</span><span style="color:var(--text-muted);">→</span><span class="tr-to">🏆 Band 7.0 sau 5 tháng</span></div>
        </div></div>
      </div>
      <div class="swiper-pagination" id="testiPag" style="padding-top:16px;position:relative;"></div>
    </div>
  </div>
</section>

<!-- PRICING – Dynamic from DB -->
<section class="section" id="pricing-section" style="background:var(--bg-section);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-indigo"><i class="fas fa-gem"></i> Bảng giá</div>
      <h2 class="sec-title">Chọn gói phù hợp<br><span class="tg">với mục tiêu</span></h2>
      <p class="sec-sub">Bắt đầu miễn phí. Nâng cấp khi cần. Huỷ bất cứ lúc nào.</p>
    </div>

    <c:choose>
      <c:when test="${not empty packages}">
        <%-- Render gói từ DB --%>
        <div class="pricing-grid" data-sr="fade-up" data-sr-delay="200"
             style="grid-template-columns: repeat(${fn:length(packages) > 3 ? 3 : fn:length(packages)}, 1fr);">

          <%-- Gói miễn phí (hardcoded vì không lưu DB) --%>
          <div class="card price-card">
            <div class="price-plan">Miễn phí</div>
            <div class="price-amount"><span class="p-num">0 ₫</span><span class="p-per">&nbsp;/ mãi mãi</span></div>
            <div class="price-desc">Bắt đầu hành trình IELTS không cần thanh toán. Trải nghiệm đầy đủ tính năng cơ bản.</div>
            <div class="price-feats">
              <div class="pf"><i class="fas fa-check pf-ok"></i> Placement Test miễn phí</div>
              <div class="pf"><i class="fas fa-check pf-ok"></i> 5 lượt chấm Writing/tháng</div>
              <div class="pf"><i class="fas fa-check pf-ok"></i> 3 buổi Speaking/tháng</div>
              <div class="pf"><i class="fas fa-check pf-ok"></i> 1 bài Mock Test đầy đủ</div>
              <div class="pf"><i class="fas fa-times pf-no"></i> <span class="pf-dis">Luyện tập không giới hạn</span></div>
              <div class="pf"><i class="fas fa-times pf-no"></i> <span class="pf-dis">Lộ trình AI cá nhân hóa</span></div>
            </div>
            <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-outline btn-full">Bắt đầu miễn phí</a>
          </div>

          <%-- Các gói từ DB --%>
          <c:forEach var="pkg" items="${packages}" varStatus="st">
            <div class="card price-card ${st.index == 0 ? 'featured' : ''}">
              <c:if test="${st.index == 0}">
                <div class="price-badge">⭐ Phổ biến nhất</div>
              </c:if>
              <div class="price-plan" style="${st.index == 0 ? 'color:var(--blue-600);' : 'color:#D97706;'}">
                ${pkg.name}
              </div>
              <div class="price-amount">
                <span class="p-num ${st.index == 0 ? 'tg' : ''}" style="${st.index > 0 ? 'background:linear-gradient(135deg,#F59E0B,#EF4444);-webkit-background-clip:text;-webkit-text-fill-color:transparent;' : ''}">
                  <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true"/>
                </span>
                <span class="p-per">&nbsp;₫&nbsp;/&nbsp;${pkg.durationMonths} tháng</span>
              </div>
              <div class="price-desc">
                <c:choose>
                  <c:when test="${not empty pkg.description}">${pkg.description}</c:when>
                  <c:otherwise>Truy cập đầy đủ tất cả tính năng trong ${pkg.durationMonths} tháng.</c:otherwise>
                </c:choose>
              </div>
              <div class="price-feats">
                <div class="pf"><i class="fas fa-check pf-ok"></i> Placement Test đánh giá đầu vào</div>
                <div class="pf"><i class="fas fa-check pf-ok"></i> AI Lộ trình học cá nhân hóa</div>
                <div class="pf"><i class="fas fa-check pf-ok"></i> <strong>Không giới hạn</strong> chấm Writing</div>
                <div class="pf"><i class="fas fa-check pf-ok"></i> <strong>Không giới hạn</strong> Speaking AI</div>
                <div class="pf"><i class="fas fa-check pf-ok"></i> Toàn bộ Mock Tests trong ngân hàng đề</div>
                <div class="pf"><i class="fas fa-check pf-ok"></i> Analytics Dashboard theo dõi tiến độ</div>
              </div>
              <a href="${pageContext.request.contextPath}/subscription" class="btn ${st.index == 0 ? 'btn-primary' : ''} btn-full"
                 style="${st.index > 0 ? 'background:#FFFBEB;border:1.5px solid #FDE68A;color:#92400E;' : ''}">
                <c:choose>
                  <c:when test="${st.index == 0}">Đăng ký ngay</c:when>
                  <c:otherwise>Chọn gói ${pkg.name}</c:otherwise>
                </c:choose>
              </a>
            </div>
          </c:forEach>
        </div>
      </c:when>

      <c:otherwise>
        <%-- Fallback khi DB không có gói nào --%>
        <div style="text-align:center;padding:48px 24px;background:var(--bg-white);border:1px solid var(--border-light);border-radius:var(--radius-2xl);max-width:560px;margin:0 auto;" data-sr="fade-up">
          <div style="font-size:3rem;margin-bottom:16px;">📋</div>
          <h3 style="font-family:var(--font-h);font-size:1.5rem;font-weight:700;color:var(--text-dark);margin-bottom:10px;">Bảng giá đang được cập nhật</h3>
          <p style="color:var(--text-muted);margin-bottom:24px;">Vui lòng liên hệ với chúng tôi để biết thông tin về các gói đăng ký phù hợp với nhu cầu của bạn.</p>
          <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-primary">Đăng ký miễn phí ngay</a>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</section>

<!-- FAQ -->
<section class="section" style="background:var(--bg-white);">
  <div class="container">
    <div class="sec-hdr center" data-sr="fade-up">
      <div class="label lb-blue"><i class="fas fa-circle-question"></i> FAQ</div>
      <h2 class="sec-title">Câu hỏi <span class="tg">thường gặp</span></h2>
    </div>
    <div class="faq-list" data-sr="fade-up" data-sr-delay="200">
      <div class="faq-item" id="faq1">
        <button class="faq-q" onclick="faqToggle('faq1')">IELTSFlow có khác gì so với các app luyện IELTS khác? <i class="fas fa-chevron-down faq-chev"></i></button>
        <div class="faq-a"><p>IELTSFlow tích hợp AI đánh giá bài viết và speaking theo tiêu chí Cambridge thực tế, không chỉ là bài tập trắc nghiệm. Hệ thống AI phân tích từng câu, từng từ và đưa ra gợi ý cải thiện cụ thể với band score dự đoán chính xác.</p></div>
      </div>
      <div class="faq-item" id="faq2">
        <button class="faq-q" onclick="faqToggle('faq2')">AI chấm bài Writing có chính xác không? <i class="fas fa-chevron-down faq-chev"></i></button>
        <div class="faq-a"><p>AI của chúng tôi được huấn luyện trên hàng trăm nghìn bài IELTS đã được giám khảo Cambridge chấm điểm. Độ chính xác dự đoán band score đạt 92% so với điểm thực tế.</p></div>
      </div>
      <div class="faq-item" id="faq3">
        <button class="faq-q" onclick="faqToggle('faq3')">Cần bao lâu để cải thiện được 1 band score? <i class="fas fa-chevron-down faq-chev"></i></button>
        <div class="faq-a"><p>Trung bình học viên luyện 2 tiếng/ngày với IELTSFlow cải thiện được 0.5-1.0 band sau 6-8 tuần. Kết quả tốt nhất khi luyện đều đặn mỗi ngày.</p></div>
      </div>
      <div class="faq-item" id="faq4">
        <button class="faq-q" onclick="faqToggle('faq4')">IELTSFlow hỗ trợ cả IELTS Academic và General Training không? <i class="fas fa-chevron-down faq-chev"></i></button>
        <div class="faq-a"><p>Có! IELTSFlow hỗ trợ đầy đủ cả Academic và General Training. Bạn có thể chọn loại bài thi ngay khi đăng ký và hệ thống sẽ tự động điều chỉnh nội dung phù hợp.</p></div>
      </div>
      <div class="faq-item" id="faq5">
        <button class="faq-q" onclick="faqToggle('faq5')">Tôi có thể huỷ gói Pro bất cứ lúc nào không? <i class="fas fa-chevron-down faq-chev"></i></button>
        <div class="faq-a"><p>Có, bạn có thể huỷ gói Pro bất kỳ lúc nào mà không bị phạt. Sau khi huỷ, bạn vẫn tiếp tục sử dụng được đến hết chu kỳ thanh toán hiện tại.</p></div>
      </div>
    </div>
  </div>
</section>

<!-- THƯ VIỆN ÔN TẬP – Dynamic from DB (Lessons) -->
<section class="section" id="library-section" style="background:var(--bg-section);">
  <div class="container">
    <div class="sec-hdr" data-sr="fade-up" style="display:flex;align-items:flex-end;justify-content:space-between;flex-wrap:wrap;gap:16px;margin-bottom:32px;">
      <div>
        <div class="label lb-indigo"><i class="fas fa-book-open"></i> Thư viện ôn tập</div>
        <h2 class="sec-title" style="margin-bottom:0;">Bài học từ Mentor<br><span class="tg">được cập nhật liên tục</span></h2>
      </div>
      <a href="${pageContext.request.contextPath}/candidate/lessons" class="btn btn-outline btn-sm">Xem tất cả <i class="fas fa-arrow-right"></i></a>
    </div>

    <c:choose>
      <c:when test="${not empty recentLessons}">
        <div class="blog-grid" data-sr="fade-up" data-sr-delay="200">
          <c:forEach var="lesson" items="${recentLessons}" end="2">
            <div class="card blog-card">
              <%-- Thumb icon theo skill --%>
              <div class="blog-thumb" style="background:var(--bg-section);font-size:2.5rem;">
                <c:choose>
                  <c:when test="${lesson.skill == 'Listening'}">🎧</c:when>
                  <c:when test="${lesson.skill == 'Reading'}">📖</c:when>
                  <c:when test="${lesson.skill == 'Writing'}">✍️</c:when>
                  <c:when test="${lesson.skill == 'Speaking'}">🎙️</c:when>
                  <c:otherwise>📚</c:otherwise>
                </c:choose>
              </div>
              <div class="blog-body">
                <%-- Skill tag với màu tương ứng --%>
                <div class="blog-cat"
                     style="color:
                       <c:choose>
                         <c:when test="${lesson.skill == 'Listening'}">var(--indigo-600)</c:when>
                         <c:when test="${lesson.skill == 'Reading'}">#D97706</c:when>
                         <c:when test="${lesson.skill == 'Writing'}">var(--blue-600)</c:when>
                         <c:when test="${lesson.skill == 'Speaking'}">var(--green-600)</c:when>
                         <c:otherwise>var(--text-muted)</c:otherwise>
                       </c:choose>;
                     ">
                  <c:choose>
                    <c:when test="${lesson.skill == 'Listening'}"><i class="fas fa-headphones"></i></c:when>
                    <c:when test="${lesson.skill == 'Reading'}"><i class="fas fa-book-open"></i></c:when>
                    <c:when test="${lesson.skill == 'Writing'}"><i class="fas fa-pen-nib"></i></c:when>
                    <c:when test="${lesson.skill == 'Speaking'}"><i class="fas fa-microphone-lines"></i></c:when>
                    <c:otherwise><i class="fas fa-graduation-cap"></i></c:otherwise>
                  </c:choose>
                  &nbsp;${empty lesson.skill ? 'General' : lesson.skill}
                </div>
                <div class="blog-title">${lesson.title}</div>
                <div class="blog-excerpt">
                  <c:choose>
                    <c:when test="${not empty lesson.content and fn:length(lesson.content) > 130}">
                      ${fn:substring(lesson.content, 0, 130)}...
                    </c:when>
                    <c:when test="${not empty lesson.content}">${lesson.content}</c:when>
                    <c:otherwise>Xem chi tiết bài học này từ Mentor IELTSFlow.</c:otherwise>
                  </c:choose>
                </div>
                <div class="blog-meta">
                  <span><i class="fas fa-user-tie"></i> Mentor IELTSFlow</span>
                  <a href="${pageContext.request.contextPath}/candidate/lesson-detail?id=${lesson.lessonId}" class="blog-more">
                    Xem bài học <i class="fas fa-arrow-right"></i>
                  </a>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>

        <%-- Nếu có nhiều hơn 3 bài: hiển thị thêm 1 card CTA --%>
        <c:if test="${fn:length(recentLessons) > 3}">
          <div style="text-align:center;margin-top:28px;" data-sr="fade-up">
            <a href="${pageContext.request.contextPath}/candidate/lessons" class="btn btn-primary">
              <i class="fas fa-book-open"></i> Khám phá toàn bộ thư viện (${fn:length(recentLessons)}+ bài học)
            </a>
          </div>
        </c:if>

      </c:when>

      <c:otherwise>
        <%-- Fallback khi chưa có bài học nào --%>
        <div style="text-align:center;padding:48px 24px;background:var(--bg-white);border:1px dashed var(--border-mid);border-radius:var(--radius-2xl);" data-sr="fade-up">
          <div style="font-size:3rem;margin-bottom:16px;">📚</div>
          <h3 style="font-family:var(--font-h);font-size:1.25rem;font-weight:700;color:var(--text-dark);margin-bottom:8px;">Thư viện đang được xây dựng</h3>
          <p style="color:var(--text-muted);margin-bottom:20px;">Các Mentor đang soạn bài học chất lượng cao cho bạn. Hãy đăng ký để nhận thông báo khi có bài mới!</p>
          <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-primary">
            <i class="fas fa-bell"></i> Đăng ký để nhận bài học mới nhất
          </a>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</section>



<!-- NEWSLETTER -->
<section class="section" style="background:var(--bg-white); padding-bottom: 56px;">
  <div class="container">
    <div class="nl-card" data-sr="fade-up">
      <h2 class="sec-title" style="margin-bottom:8px;">Nhận tin tức &amp; Bài giảng mới</h2>
      <p style="color:var(--text-muted);font-size:1.0625rem;max-width:500px;margin:0 auto;">Đăng ký email để nhận các bộ tài liệu độc quyền và thông báo sớm nhất từ IELTSFlow.</p>
      <div class="nl-form">
        <input type="email" class="nl-inp" id="nlEmail" placeholder="Nhập địa chỉ email của bạn..." />
        <button class="btn btn-primary" id="nlBtn" onclick="nlSubscribe()" style="border-radius:var(--radius-lg);padding:0 24px;">
          <i class="fas fa-paper-plane"></i> Đăng ký
        </button>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="container">
    <div class="foot-grid">
      <div>
        <div class="nav-logo" style="margin-bottom:12px;">
          <div class="nav-logo-mark"><i class="fas fa-graduation-cap"></i></div>
          <span class="nav-logo-text" style="color:#fff;">IELTS<span style="color:var(--blue-200);">Flow</span></span>
        </div>
        <p class="foot-desc">Nền tảng luyện thi IELTS thông minh hàng đầu Việt Nam. AI-powered, Cambridge-aligned, học viên là trung tâm.</p>
        <div class="foot-socials">
          <a href="#" class="fsb"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="fsb"><i class="fab fa-youtube"></i></a>
          <a href="#" class="fsb"><i class="fab fa-github"></i></a>
          <a href="#" class="fsb"><i class="fab fa-linkedin-in"></i></a>
          <a href="#" class="fsb"><i class="fab fa-tiktok"></i></a>
        </div>
      </div>
      <div>
        <div class="foot-col-hdr">Sản phẩm</div>
        <div class="foot-links">
          <a href="${pageContext.request.contextPath}/auth?redirect=tests"   class="foot-link">AI Writing</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=tests"  class="foot-link">AI Speaking</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=mock-test" class="foot-link">Mock Tests</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="foot-link">Placement Test</a>
          <a href="${pageContext.request.contextPath}/subscription"            class="foot-link">Bảng giá</a>
        </div>
      </div>
      <div>
        <div class="foot-col-hdr">Học tập</div>
        <div class="foot-links">
          <a href="#library-section"                                              class="foot-link">Thư viện bài học</a>
          <a href="${pageContext.request.contextPath}/candidate/lessons"           class="foot-link">Tất cả bài học</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=tests"       class="foot-link">AI Writing</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=tests"      class="foot-link">AI Speaking</a>
          <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="foot-link">Placement Test</a>
        </div>
      </div>
      <div>
        <div class="foot-col-hdr">Hỗ trợ</div>
        <div class="foot-links">
          <a href="#"             class="foot-link">Hỏi đáp (FAQ)</a>
          <a href="#"             class="foot-link">Điều khoản sử dụng</a>
          <a href="#"             class="foot-link">Chính sách bảo mật</a>
          <a href="#"             class="foot-link">Liên hệ hỗ trợ</a>
        </div>
      </div>
    </div>
    <div class="foot-bottom">
      <span>&copy; 2026 IELTSFlow. Phát triển bởi Nhóm 2 SWP301. All rights reserved.</span>
      <div><a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a></div>
    </div>
  </div>
</footer>



<!-- Back to top -->
<button id="bttBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})" title="Về đầu trang"
  style="position:fixed;bottom:90px;right:20px;width:40px;height:40px;border-radius:10px;background:var(--bg-white);border:1.5px solid var(--border-mid);color:var(--text-muted);display:flex;align-items:center;justify-content:center;z-index:499;opacity:0;pointer-events:none;transition:all .25s;box-shadow:var(--shadow-md);">
  <i class="fas fa-chevron-up"></i>
</button>

<!-- SCRIPTS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
/* ── Scroll reveal ──────────────────────────────────────── */
(function(){
  var map={'fade-up':'sr-up','fade-left':'sr-right','fade-right':'sr-left','zoom-in':'sr-zoom'};
  var els=document.querySelectorAll('[data-sr]');
  if(!('IntersectionObserver' in window))return;
  var obs=new IntersectionObserver(function(entries){
    entries.forEach(function(e){
      if(e.isIntersecting){
        var el=e.target,delay=parseInt(el.getAttribute('data-sr-delay')||0);
        setTimeout(function(){el.classList.remove('sr-up','sr-left','sr-right','sr-zoom');},delay);
        obs.unobserve(el);
      }
    });
  },{threshold:.08,rootMargin:'0px 0px -40px 0px'});
  requestAnimationFrame(function(){
    setTimeout(function(){
      els.forEach(function(el){
        var c=map[el.getAttribute('data-sr')]||'sr-up';
        el.classList.add(c);obs.observe(el);
      });
    },60);
  });
})();

/* ── Navbar scroll ──────────────────────────────────────── */
var nav=document.getElementById('mainNav');
var btt=document.getElementById('bttBtn');
window.addEventListener('scroll',function(){
  var s=window.scrollY>50;
  nav.classList.toggle('scrolled',s);
  btt.style.opacity=s?'1':'0';
  btt.style.pointerEvents=s?'all':'none';
});

/* ── Mobile menu ────────────────────────────────────────── */
var mobOpen=false;
document.getElementById('mobToggle').addEventListener('click',function(){
  mobOpen=!mobOpen;
  document.getElementById('mobMenu').classList.toggle('open',mobOpen);
  this.setAttribute('aria-expanded',String(mobOpen));
  document.body.style.overflow=mobOpen?'hidden':'';
  var sp=this.querySelectorAll('span');
  if(mobOpen){
    sp[0].style.transform='rotate(45deg) translate(5px,5px)';
    sp[1].style.opacity='0';
    sp[2].style.transform='rotate(-45deg) translate(5px,-5px)';
  } else {
    sp[0].style.transform=sp[2].style.transform='';
    sp[1].style.opacity='';
  }
});
document.querySelectorAll('.mob-link,.mob-btns a').forEach(function(el){
  el.addEventListener('click',function(){
    mobOpen=false;
    document.getElementById('mobMenu').classList.remove('open');
    document.body.style.overflow='';
  });
});




/* ── Counter animation ──────────────────────────────────── */
function animCounter(el){
  var t=parseInt(el.getAttribute('data-counter')),sf=el.getAttribute('data-suffix')||'',start=performance.now();
  (function tick(now){
    var p=Math.min((now-start)/2000,1),val=Math.floor((1-Math.pow(1-p,3))*t);
    el.textContent=t>=1000000?(val/1000000).toFixed(1)+'M'+sf:t>=1000?(val/1000).toFixed(0)+'K'+sf:val+sf;
    if(p<1)requestAnimationFrame(tick);
  })(start);
}
document.querySelectorAll('[data-counter]').forEach(function(el){
  new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting&&!e.target.dataset.done){e.target.dataset.done='1';animCounter(e.target);}});
  },{threshold:.5}).observe(el);
});

/* ── FAQ ────────────────────────────────────────────────── */
function faqToggle(id){
  var item=document.getElementById(id),isOpen=item.classList.contains('open');
  document.querySelectorAll('.faq-item').forEach(function(i){i.classList.remove('open');});
  if(!isOpen)item.classList.add('open');
}

/* ── Goal/Roadmap generator ─────────────────────────────── */
var roadmapData={
  '5.0':'8 tuần: Tập trung Listening và Reading cơ bản. 2h/ngày. AI Writing 3x/tuần.',
  '5.5':'8 tuần: Vocabulary 20 từ/ngày. Grammar AI correction. 2 Mock Tests/tháng.',
  '6.0':'10 tuần: Academic vocabulary, complex grammar. Writing Task 2 hàng ngày với AI feedback.',
  '6.5':'10 tuần: Nâng cao cohesion trong Writing. Speaking fluency và pronunciation. Reading skimming.',
  '7.0':'12 tuần: Advanced academic writing. Speaking tự nhiên với idioms. Reading time management.',
  '7.5':'12 tuần: Native-level vocabulary. Speaking với Band 7+ variety. Thi thử 1x/tuần.',
  '8.0':'16 tuần: Expert-level writing style. Speaking với minimal errors. Mastery of all question types.',
  '8.5':'16 tuần: Near-native proficiency. Perfect task achievement. Naturally fluent Speaking.'
};
function generateRoadmap(){
  var val=document.getElementById('targetBand').value;
  if(!val){document.getElementById('targetBand').style.borderColor='#EF4444';setTimeout(function(){document.getElementById('targetBand').style.borderColor='';},2000);return;}
  var btn=document.getElementById('genBtn');
  btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Đang tạo...';
  btn.disabled=true;
  setTimeout(function(){
    document.getElementById('selBand').textContent=val;
    document.getElementById('roadmapContent').innerHTML=
      roadmapData[val]+
      '<br><br><strong>Lịch trình khuyến nghị:</strong><br>'+
      '• Buổi sáng: Từ vựng (30 phút)<br>'+
      '• Buổi chiều: Luyện kỹ năng (60 phút)<br>'+
      '• Buổi tối: AI Writing/Speaking Review (30 phút)'+
      '<br><br><a href="'+window.contextPath+'/auth?redirect=placement-test" style="color:#2563EB;font-weight:600;">→ Bắt đầu với Placement Test miễn phí</a>';
    document.getElementById('roadmapResult').style.display='block';
    btn.innerHTML='<i class="fas fa-check"></i> Đã tạo lộ trình!';
    setTimeout(function(){btn.innerHTML='<i class="fas fa-wand-magic-sparkles"></i> Tạo lộ trình ngay →';btn.disabled=false;},3000);
  },1200);
}

/* ── Newsletter ─────────────────────────────────────────── */
function nlSubscribe(){
  var email=document.getElementById('nlEmail').value.trim();
  var btn=document.getElementById('nlBtn');
  if(!email||email.indexOf('@')===-1){
    document.getElementById('nlEmail').style.borderColor='#EF4444';
    setTimeout(function(){document.getElementById('nlEmail').style.borderColor='';},2000);
    return;
  }
  btn.innerHTML='<i class="fas fa-spinner fa-spin"></i>';btn.disabled=true;
  setTimeout(function(){
    btn.innerHTML='<i class="fas fa-check"></i> Đã đăng ký!';
    btn.style.background='linear-gradient(135deg,#16A34A,#22C55E)';
    document.getElementById('nlEmail').value='';
    setTimeout(function(){btn.innerHTML='<i class="fas fa-paper-plane"></i> Đăng ký';btn.style.background='';btn.disabled=false;},3500);
  },1200);
}

/* ── Swipers ────────────────────────────────────────────── */
new Swiper('#testiSwiper',{
  slidesPerView:1,spaceBetween:16,
  autoplay:{delay:5000,disableOnInteraction:false,pauseOnMouseEnter:true},
  pagination:{el:'#testiPag',clickable:true},
  breakpoints:{768:{slidesPerView:2},1100:{slidesPerView:3}}
});
</script>
</body>
</html>
