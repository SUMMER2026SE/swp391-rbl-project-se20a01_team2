<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <script>window.contextPath = '${pageContext.request.contextPath}';</script>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Chọn gói đăng ký IELTSFlow phù hợp với mục tiêu IELTS của bạn. Bắt đầu miễn phí, nâng cấp khi cần.">
  <title>Bảng giá – IELTSFlow</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* ================================================================
   IELTSFLOW SUBSCRIPTION – Synced với Index Light Theme
================================================================ */
:root {
  --blue-50:#EFF6FF;--blue-100:#DBEAFE;--blue-200:#BFDBFE;
  --blue-500:#3B82F6;--blue-600:#2563EB;--blue-700:#1D4ED8;
  --indigo-600:#4F46E5;--green-500:#22C55E;--green-600:#16A34A;
  --amber-400:#FBBF24;
  --grad-brand:linear-gradient(135deg,#2563EB 0%,#6366F1 100%);
  --bg-page:#F8FAFF;--bg-white:#FFFFFF;--bg-subtle:#F1F5F9;--bg-section:#F0F4FF;
  --text-dark:#0F172A;--text-body:#334155;--text-muted:#64748B;--text-light:#94A3B8;
  --border-light:#E2E8F0;--border-mid:#CBD5E1;
  --shadow-sm:0 2px 8px rgba(15,23,42,.08);--shadow-md:0 4px 20px rgba(15,23,42,.10);
  --shadow-lg:0 12px 40px rgba(15,23,42,.12);--shadow-xl:0 24px 60px rgba(15,23,42,.14);
  --radius-md:10px;--radius-lg:14px;--radius-xl:20px;--radius-2xl:28px;
  --font-h:'Inter',sans-serif;--font-b:'Inter',sans-serif;
}
body.dark-mode {
  --bg-page:#0F172A;--bg-white:#1E293B;--bg-subtle:#162032;--bg-section:#162032;
  --text-dark:#F1F5F9;--text-body:#CBD5E1;--text-muted:#94A3B8;
  --border-light:#1E3A5F;--border-mid:#1E3A5F;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:var(--font-b);background:var(--bg-page);color:var(--text-body);-webkit-font-smoothing:antialiased;min-height:100vh}
a{text-decoration:none;color:inherit}
img{display:block;max-width:100%}

/* ── Navbar ── */
.navbar{
  position:sticky;top:0;z-index:500;
  background:rgba(248,250,255,.92);backdrop-filter:blur(20px);
  border-bottom:1px solid var(--border-light);
  transition:box-shadow .25s;
}
.navbar.scrolled{box-shadow:0 2px 16px rgba(15,23,42,.08)}
.nav-inner{max-width:1200px;margin:0 auto;padding:0 24px;height:66px;display:flex;align-items:center;justify-content:space-between;gap:24px}
.nav-logo{display:flex;align-items:center;gap:9px;font-family:var(--font-h);font-weight:800;font-size:1.125rem;color:var(--text-dark)}
.nav-logo-mark{width:34px;height:34px;background:var(--grad-brand);border-radius:9px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.875rem;box-shadow:0 4px 12px rgba(37,99,235,.3)}
.nav-logo-text span{color:var(--blue-600)}
.nav-links{display:flex;align-items:center;gap:6px}
.nav-link{padding:6px 14px;border-radius:8px;font-size:.9375rem;font-weight:500;color:var(--text-muted);transition:all .2s}
.nav-link:hover,.nav-link.active{color:var(--text-dark);background:rgba(15,23,42,.05)}
.nav-actions{display:flex;align-items:center;gap:8px}
.btn{display:inline-flex;align-items:center;gap:6px;padding:9px 18px;border-radius:var(--radius-md);font-family:var(--font-b);font-size:.9375rem;font-weight:600;cursor:pointer;transition:all .25s;border:none;text-decoration:none}
.btn-ghost{background:transparent;color:var(--text-body);border:1.5px solid var(--border-mid)}
.btn-ghost:hover{border-color:var(--blue-500);color:var(--blue-600);background:var(--blue-50)}
.btn-primary{background:var(--grad-brand);color:#fff;box-shadow:0 4px 14px rgba(37,99,235,.28)}
.btn-primary:hover{transform:translateY(-2px);box-shadow:0 8px 22px rgba(37,99,235,.36)}
.btn-sm{padding:7px 14px;font-size:.875rem}
.nav-icon-btn{width:36px;height:36px;border-radius:9px;border:1.5px solid var(--border-light);background:var(--bg-white);color:var(--text-muted);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .2s}
.nav-icon-btn:hover{border-color:var(--blue-500);color:var(--blue-600)}
/* user avatar */
.user-pill{display:flex;align-items:center;gap:8px;padding:4px 12px 4px 4px;border:1.5px solid var(--border-light);border-radius:var(--radius-full,9999px);background:var(--bg-white);cursor:pointer;transition:border-color .2s;font-size:.875rem;font-weight:500;color:var(--text-dark)}
.user-pill:hover{border-color:var(--blue-500)}
.u-av{width:28px;height:28px;border-radius:50%;background:var(--grad-brand);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8125rem;flex-shrink:0}
.u-av img{width:100%;height:100%;border-radius:50%;object-fit:cover}

/* ── Hero ── */
.sub-hero{padding:72px 0 48px;text-align:center;background:var(--bg-white);border-bottom:1px solid var(--border-light)}
.sub-hero .label{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;border-radius:9999px;background:var(--blue-50);border:1px solid var(--blue-100);color:var(--blue-700);font-size:.8125rem;font-weight:600;margin-bottom:20px}
.sub-hero h1{font-family:var(--font-h);font-size:clamp(2rem,4vw,2.75rem);font-weight:800;color:var(--text-dark);line-height:1.12;margin-bottom:16px}
.tg{background:var(--grad-brand);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.sub-hero p{font-size:1.0625rem;color:var(--text-muted);max-width:520px;margin:0 auto 12px;line-height:1.7}
.sub-hero .badge-row{display:flex;align-items:center;justify-content:center;gap:16px;flex-wrap:wrap;margin-top:20px}
.sub-badge{display:flex;align-items:center;gap:5px;font-size:.8125rem;color:var(--text-muted)}
.sub-badge i{color:var(--green-500)}

/* Alert */
.alert-box{max-width:600px;margin:0 auto 32px;padding:14px 20px;border-radius:var(--radius-lg);font-size:.9rem;font-weight:500;display:flex;align-items:center;gap:10px}
.alert-warn{background:#FEF2F2;border:1px solid #FCA5A5;color:#B91C1C}

/* ── Pricing Grid ── */
.sub-main{padding:56px 0 80px}
.container{max-width:1200px;margin:0 auto;padding:0 24px}
.pricing-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px;align-items:start}

.price-card{background:var(--bg-white);border:1.5px solid var(--border-light);border-radius:var(--radius-2xl);padding:36px;position:relative;transition:all .3s;display:flex;flex-direction:column}
.price-card:hover{transform:translateY(-6px);box-shadow:var(--shadow-xl);border-color:var(--blue-200)}
.price-card.featured{background:linear-gradient(145deg,var(--blue-50),#EEF2FF);border-color:var(--blue-200);box-shadow:var(--shadow-xl);transform:translateY(-8px)}
body.dark-mode .price-card{background:var(--bg-white)}
body.dark-mode .price-card.featured{background:linear-gradient(145deg,#1a2744,#1e2040)}

.price-badge{position:absolute;top:-13px;left:50%;transform:translateX(-50%);background:var(--grad-brand);color:#fff;padding:4px 16px;border-radius:9999px;font-size:.72rem;font-weight:700;white-space:nowrap;letter-spacing:.05em}
.price-plan{font-size:.8125rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.09em;margin-bottom:10px}
.price-plan.pro{color:var(--blue-600)}
.price-amount{display:flex;align-items:baseline;gap:4px;margin-bottom:8px}
.p-val{font-family:var(--font-h);font-size:2.5rem;font-weight:900;color:var(--text-dark);line-height:1}
.p-cur{font-size:.9375rem;color:var(--text-muted);font-weight:500;align-self:flex-start;margin-top:6px}
.p-per{font-size:.875rem;color:var(--text-muted);align-self:flex-end;margin-bottom:4px}
.price-desc{font-size:.875rem;color:var(--text-muted);line-height:1.6;margin-bottom:24px;padding-bottom:24px;border-bottom:1px solid var(--border-light)}
.price-feats{display:flex;flex-direction:column;gap:11px;margin-bottom:28px;flex:1}
.pf{display:flex;align-items:flex-start;gap:10px;font-size:.9rem;color:var(--text-body)}
.pf-ok{color:var(--green-500);flex-shrink:0;width:18px;margin-top:1px}
.pf-name{line-height:1.5}

.btn-subscribe{width:100%;padding:13px;border:none;border-radius:var(--radius-lg);font-family:var(--font-b);font-size:.9375rem;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:all .25s}
.btn-subscribe.primary{background:var(--grad-brand);color:#fff;box-shadow:0 4px 16px rgba(37,99,235,.28)}
.btn-subscribe.primary:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(37,99,235,.36)}
.btn-subscribe.outline{background:transparent;color:var(--blue-600);border:2px solid var(--blue-200)}
.btn-subscribe.outline:hover{background:var(--blue-50);border-color:var(--blue-500)}
.btn-subscribe:disabled{opacity:.6;cursor:not-allowed;transform:none!important}

.active-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 11px;background:#F0FDF4;border:1px solid #BBF7D0;border-radius:9999px;color:var(--green-600);font-size:.78rem;font-weight:600;margin-bottom:14px}

/* Empty state */
.empty-state{text-align:center;padding:60px 24px;background:var(--bg-white);border:1.5px dashed var(--border-mid);border-radius:var(--radius-2xl)}
.empty-state i{font-size:2.5rem;color:var(--text-light);margin-bottom:16px}
.empty-state h3{font-family:var(--font-h);font-size:1.25rem;color:var(--text-dark);margin-bottom:8px}
.empty-state p{color:var(--text-muted);font-size:.9375rem}

/* Pagination */
.pag{display:flex;justify-content:center;gap:6px;margin-top:48px;flex-wrap:wrap}
.pag-btn{display:flex;align-items:center;justify-content:center;min-width:38px;height:38px;padding:0 12px;border-radius:9px;border:1.5px solid var(--border-light);background:var(--bg-white);color:var(--text-body);font-size:.875rem;font-weight:600;transition:all .2s;cursor:pointer}
.pag-btn:hover{border-color:var(--blue-500);color:var(--blue-600)}
.pag-btn.active{background:var(--grad-brand);color:#fff;border-color:transparent}
.pag-btn.disabled{opacity:.45;pointer-events:none}

/* FAQ strip */
.faq-strip{background:var(--bg-section);border-top:1px solid var(--border-light);padding:56px 0}
.faq-strip h2{font-family:var(--font-h);font-size:1.5rem;font-weight:800;color:var(--text-dark);text-align:center;margin-bottom:32px}
.faq-list{max-width:680px;margin:0 auto;display:flex;flex-direction:column;gap:10px}
.faq-item{background:var(--bg-white);border:1.5px solid var(--border-light);border-radius:var(--radius-lg);overflow:hidden;transition:border-color .2s}
.faq-item.open{border-color:var(--blue-200)}
.faq-q{padding:16px 20px;font-weight:600;font-size:.9375rem;color:var(--text-dark);display:flex;align-items:center;justify-content:space-between;cursor:pointer;gap:12px}
.faq-q i{color:var(--text-muted);font-size:.75rem;transition:transform .3s;flex-shrink:0}
.faq-item.open .faq-q i{transform:rotate(180deg);color:var(--blue-600)}
.faq-a{display:none;padding:0 20px 16px;color:var(--text-muted);font-size:.9rem;line-height:1.7}
.faq-item.open .faq-a{display:block}

/* CTA Banner */
.cta-banner{padding:64px 0;background:var(--grad-brand);text-align:center}
.cta-banner h2{font-family:var(--font-h);font-size:clamp(1.5rem,3vw,2rem);font-weight:800;color:#fff;margin-bottom:10px}
.cta-banner p{color:rgba(255,255,255,.82);font-size:1rem;margin-bottom:28px}
.btn-white{background:#fff;color:var(--blue-700);padding:13px 28px;border-radius:var(--radius-lg);font-weight:700;font-size:.9375rem;transition:all .2s;display:inline-flex;align-items:center;gap:8px}
.btn-white:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(0,0,0,.15)}

/* Footer */
footer{background:var(--text-dark);padding:40px 0 24px}
.foot-inner{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:20px;padding-bottom:24px;border-bottom:1px solid rgba(255,255,255,.08);margin-bottom:20px}
.foot-logo{display:flex;align-items:center;gap:8px;font-family:var(--font-h);font-weight:800;color:#fff;font-size:1rem}
.foot-logo-mark{width:30px;height:30px;background:var(--grad-brand);border-radius:8px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.75rem}
.foot-links-row{display:flex;gap:20px;flex-wrap:wrap}
.foot-links-row a{color:rgba(255,255,255,.5);font-size:.875rem;transition:color .2s}
.foot-links-row a:hover{color:#fff}
.foot-copy{font-size:.8125rem;color:rgba(255,255,255,.35);text-align:center}

/* Dark mode toggle */
.dark-toggle{width:36px;height:36px;border-radius:9px;border:1.5px solid var(--border-light);background:var(--bg-white);color:var(--text-muted);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .2s}
.dark-toggle:hover{border-color:var(--blue-500);color:var(--blue-600)}

@media(max-width:900px){
  .pricing-grid{grid-template-columns:1fr}
  .price-card.featured{transform:none}
  .price-card.featured:hover{transform:translateY(-4px)}
  .sub-hero{padding:48px 0 32px}
}
@media(max-width:600px){
  .nav-links{display:none}
  .sub-hero h1{font-size:1.75rem}
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="subNav">
  <div class="nav-inner">
    <a href="${pageContext.request.contextPath}/" class="nav-logo">
      <div class="nav-logo-mark"><i class="fas fa-graduation-cap"></i></div>
      <span class="nav-logo-text">IELTS<span>Flow</span></span>
    </a>

    <div class="nav-links">
      <a href="${pageContext.request.contextPath}/"                            class="nav-link">Trang chủ</a>
      <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="nav-link">Placement Test</a>
      <a href="${pageContext.request.contextPath}/auth?redirect=mock-test"      class="nav-link">Practice &amp; Mock</a>
      <a href="${pageContext.request.contextPath}/subscription"                 class="nav-link active">Bảng giá</a>
    </div>

    <div class="nav-actions">
      <button class="dark-toggle" id="darkToggle" onclick="toggleDark()" title="Chuyển chế độ tối">
        <i class="fas fa-moon" id="darkIcon"></i>
      </button>
      <c:choose>
        <c:when test="${not empty sessionScope.fullName}">
          <c:if test="${sessionScope.roleId == 1}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">
              <i class="fas fa-gauge-high"></i> Admin
            </a>
          </c:if>
          <c:if test="${sessionScope.roleId == 2}">
            <a href="${pageContext.request.contextPath}/mentor/dashboard" class="btn btn-primary btn-sm">
              <i class="fas fa-gauge-high"></i> Mentor
            </a>
          </c:if>
          <c:if test="${sessionScope.roleId != 1 && sessionScope.roleId != 2}">
            <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-ghost btn-sm">
              <i class="fas fa-gauge-high"></i> Dashboard
            </a>
          </c:if>
          <div class="user-pill">
            <div class="u-av">
              <c:choose>
                <c:when test="${not empty sessionScope.profilePic}">
                  <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" alt="Avatar">
                </c:when>
                <c:otherwise>${sessionScope.fullName.substring(0, 1)}</c:otherwise>
              </c:choose>
            </div>
            ${sessionScope.fullName}
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/auth?mode=login"    class="btn btn-ghost btn-sm">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/auth?mode=register" class="btn btn-primary btn-sm">Đăng ký miễn phí</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>

<!-- HERO -->
<section class="sub-hero">
  <div class="container">
    <div class="label"><i class="fas fa-gem"></i> Bảng giá</div>
    <h1>Chọn gói phù hợp<br><span class="tg">với mục tiêu của bạn</span></h1>
    <p>Bắt đầu miễn phí, nâng cấp bất cứ lúc nào. Không ràng buộc, huỷ dễ dàng.</p>
    <div class="badge-row">
      <div class="sub-badge"><i class="fas fa-shield-halved"></i> Thanh toán bảo mật</div>
      <div class="sub-badge"><i class="fas fa-rotate-left"></i> Hoàn tiền trong 7 ngày</div>
      <div class="sub-badge"><i class="fas fa-headset"></i> Hỗ trợ 24/7</div>
    </div>
  </div>
</section>

<!-- MAIN CONTENT -->
<section class="sub-main">
  <div class="container">

    <!-- Error alerts -->
    <c:if test="${not empty param.error}">
      <div class="alert-box alert-warn">
        <i class="fas fa-circle-exclamation"></i>
        <span>
          <c:choose>
            <c:when test="${param.error == 'premium_required'}">Bạn cần đăng ký gói thành viên để truy cập tính năng này.</c:when>
            <c:when test="${param.error == 'premium_required_mocktest'}">Bạn cần đăng ký gói thành viên để làm bài thi Mock Test.</c:when>
            <c:when test="${param.error == 'premium_required_placement'}">Bạn đã sử dụng hết lượt thi Placement Test miễn phí. Vui lòng nâng cấp để tiếp tục.</c:when>
            <c:when test="${param.error == 'premium_required_result'}">Bạn cần đăng ký gói thành viên để xem chi tiết kết quả và nhận xét từ AI.</c:when>
            <c:otherwise>Vui lòng nâng cấp gói thành viên để sử dụng tính năng này.</c:otherwise>
          </c:choose>
        </span>
      </div>
    </c:if>

    <!-- Pricing cards -->
    <c:choose>
      <c:when test="${not empty packages}">
        <div class="pricing-grid">
          <c:forEach var="pkg" items="${packages}" varStatus="status">
            <div class="price-card ${status.index == 1 ? 'featured' : ''}">
              <c:if test="${status.index == 1}">
                <div class="price-badge">PHỔ BIẾN NHẤT</div>
              </c:if>

              <c:if test="${hasActiveSub}">
                <div class="active-badge"><i class="fas fa-check-circle"></i> Đang sử dụng</div>
              </c:if>

              <div class="price-plan ${pkg.price > 0 ? 'pro' : ''}">${pkg.name}</div>

              <div class="price-amount">
                <span class="p-cur">₫</span>
                <span class="p-val">
                  <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true"/>
                </span>
                <c:if test="${pkg.price > 0}">
                  <span class="p-per">/ ${pkg.durationMonths} tháng</span>
                </c:if>
              </div>

              <div class="price-desc">
                <c:choose>
                  <c:when test="${not empty pkg.description}">${pkg.description}</c:when>
                  <c:when test="${pkg.price == 0}">Truy cập miễn phí các tính năng cơ bản.</c:when>
                  <c:otherwise>Truy cập đầy đủ tính năng trong ${pkg.durationMonths} tháng.</c:otherwise>
                </c:choose>
              </div>

              <div class="price-feats">
                <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Placement Test (xác định trình độ)</span></div>
                <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Practice Test (luyện từng kỹ năng)</span></div>
                <c:choose>
                  <c:when test="${pkg.price > 0}">
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Mock Test không giới hạn</span></div>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">AI Mentor chat không giới hạn</span></div>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Lộ trình học cá nhân hóa AI</span></div>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Báo cáo tiến độ chi tiết</span></div>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Xem lại kết quả chi tiết từ AI</span></div>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">Hỗ trợ ưu tiên 24/7</span></div>
                  </c:when>
                  <c:otherwise>
                    <div class="pf"><i class="fas fa-check pf-ok"></i><span class="pf-name">AI Mentor (giới hạn)</span></div>
                    <div class="pf" style="opacity:.5"><i class="fas fa-xmark pf-ok" style="color:var(--text-light)"></i><span class="pf-name">Mock Test nâng cao</span></div>
                    <div class="pf" style="opacity:.5"><i class="fas fa-xmark pf-ok" style="color:var(--text-light)"></i><span class="pf-name">Báo cáo chi tiết từ AI</span></div>
                  </c:otherwise>
                </c:choose>
              </div>

              <form method="POST" action="${pageContext.request.contextPath}/checkout">
                <input type="hidden" name="packageId" value="${pkg.packageId}">
                <button type="submit" class="btn-subscribe ${status.index == 1 || pkg.price > 0 ? 'primary' : 'outline'}">
                  <i class="fas fa-${hasActiveSub ? 'rotate-right' : 'rocket'}"></i>
                  <c:choose>
                    <c:when test="${hasActiveSub}">Gia hạn gói</c:when>
                    <c:when test="${hasAnySub}">Đăng ký ngay</c:when>
                    <c:when test="${pkg.price == 0}">Bắt đầu miễn phí</c:when>
                    <c:otherwise>Nâng cấp ngay</c:otherwise>
                  </c:choose>
                </button>
              </form>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <i class="fas fa-box-open"></i>
          <h3>Chưa có gói đăng ký</h3>
          <p>Hiện tại chưa có gói thành viên nào. Vui lòng quay lại sau.</p>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
      <div class="pag">
        <a href="${pageContext.request.contextPath}/subscription?page=${currentPage - 1}"
           class="pag-btn ${currentPage == 1 ? 'disabled' : ''}">
          <i class="fas fa-chevron-left"></i>
        </a>
        <c:forEach begin="1" end="${totalPages}" var="i">
          <a href="${pageContext.request.contextPath}/subscription?page=${i}"
             class="pag-btn ${currentPage == i ? 'active' : ''}">${i}</a>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/subscription?page=${currentPage + 1}"
           class="pag-btn ${currentPage == totalPages ? 'disabled' : ''}">
          <i class="fas fa-chevron-right"></i>
        </a>
      </div>
    </c:if>
  </div>
</section>

<!-- FAQ -->
<section class="faq-strip">
  <div class="container">
    <h2>Câu hỏi thường gặp</h2>
    <div class="faq-list">
      <div class="faq-item" id="faq1">
        <div class="faq-q" onclick="faqToggle('faq1')">Tôi có thể huỷ gói đăng ký không? <i class="fas fa-chevron-down"></i></div>
        <div class="faq-a">Có, bạn có thể liên hệ hỗ trợ để huỷ gói bất cứ lúc nào. Chúng tôi có chính sách hoàn tiền trong 7 ngày nếu bạn không hài lòng.</div>
      </div>
      <div class="faq-item" id="faq2">
        <div class="faq-q" onclick="faqToggle('faq2')">Gói miễn phí có những gì? <i class="fas fa-chevron-down"></i></div>
        <div class="faq-a">Gói miễn phí cho phép bạn làm Placement Test, Practice Test cơ bản và sử dụng AI Mentor với số lần giới hạn để trải nghiệm nền tảng.</div>
      </div>
      <div class="faq-item" id="faq3">
        <div class="faq-q" onclick="faqToggle('faq3')">Tôi có thể nâng cấp gói bất cứ lúc nào không? <i class="fas fa-chevron-down"></i></div>
        <div class="faq-a">Có. Bạn có thể nâng cấp lên gói cao hơn bất cứ lúc nào và được tính phần thời gian còn lại của gói cũ.</div>
      </div>
      <div class="faq-item" id="faq4">
        <div class="faq-q" onclick="faqToggle('faq4')">Phương thức thanh toán nào được hỗ trợ? <i class="fas fa-chevron-down"></i></div>
        <div class="faq-a">Chúng tôi hỗ trợ thanh toán qua SePay (QR Banking). Giao dịch được mã hóa và bảo mật hoàn toàn.</div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cta-banner">
  <div class="container">
    <h2>Bắt đầu hành trình IELTS ngay hôm nay</h2>
    <p>Làm Placement Test miễn phí để biết trình độ của bạn và nhận lộ trình học phù hợp</p>
    <a href="${pageContext.request.contextPath}/auth?redirect=placement-test" class="btn-white">
      <i class="fas fa-rocket"></i> Làm Placement Test miễn phí
    </a>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="container">
    <div class="foot-inner">
      <div class="foot-logo">
        <div class="foot-logo-mark"><i class="fas fa-graduation-cap"></i></div>
        IELTSFlow
      </div>
      <div class="foot-links-row">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/auth?redirect=placement-test">Placement Test</a>
        <a href="${pageContext.request.contextPath}/auth?redirect=mock-test">Practice &amp; Mock</a>
        <a href="${pageContext.request.contextPath}/auth?mode=login">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/auth?mode=register">Đăng ký</a>
      </div>
    </div>
    <div class="foot-copy">&copy; 2026 IELTSFlow. Phát triển bởi Nhóm 2 SWP301. All rights reserved.</div>
  </div>
</footer>

<script>
/* Dark mode */
function toggleDark() {
  var dark = document.body.classList.toggle('dark-mode');
  document.getElementById('darkIcon').className = dark ? 'fas fa-sun' : 'fas fa-moon';
  localStorage.setItem('ieltsflow-dark', dark ? '1' : '0');
}
(function(){
  if (localStorage.getItem('ieltsflow-dark') === '1') {
    document.body.classList.add('dark-mode');
    var icon = document.getElementById('darkIcon');
    if (icon) icon.className = 'fas fa-sun';
  }
})();

/* Navbar scroll */
window.addEventListener('scroll', function(){
  document.getElementById('subNav').classList.toggle('scrolled', window.scrollY > 40);
});

/* FAQ */
function faqToggle(id) {
  var item = document.getElementById(id);
  var isOpen = item.classList.contains('open');
  document.querySelectorAll('.faq-item').forEach(function(i){ i.classList.remove('open'); });
  if (!isOpen) item.classList.add('open');
}
</script>
</body>
</html>
