<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nhập mã OTP – IELTS Flow</title>
  <meta name="description" content="Nhập mã OTP 6 số đã được gửi đến email của bạn để đặt lại mật khẩu IELTS Flow.">
  <link rel="stylesheet" href="../css/auth.css">
</head>
<body>
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>
  <div class="orb orb-3"></div>

  <div class="otp-container">
    <div class="glass-card otp-card">
      <button class="back-btn" onclick="history.back()">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        Quay lại
      </button>

      <div style="text-align:center; margin-bottom:0.5rem;">
        <div style="font-size:3rem; margin-bottom:1rem;" class="animate-float">🔐</div>
        <h1 class="text-2xl fw-extrabold" style="margin-bottom:0.5rem;">Nhập mã xác thực</h1>
        <p class="text-secondary text-sm" style="line-height:1.65;">
          Chúng tôi đã gửi mã OTP 6 số đến<br>
          <strong id="otp-email-display" style="color:var(--clr-primary-400);">email@example.com</strong>
        </p>
      </div>

      <!-- OTP Inputs -->
      <div class="otp-inputs" id="otp-inputs">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-0" aria-label="Số 1">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-1" aria-label="Số 2">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-2" aria-label="Số 3">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-3" aria-label="Số 4">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-4" aria-label="Số 5">
        <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp-5" aria-label="Số 6">
      </div>

      <!-- Timer -->
      <div class="otp-timer" style="margin-bottom:1.5rem;">
        <span id="timer-status">Mã hết hiệu lực sau </span>
        <span class="time" id="otp-timer-display">05:00</span>
      </div>

      <!-- Progress indicator -->
      <div style="margin-bottom:1.5rem;">
        <div style="height:3px; background:var(--clr-border); border-radius:999px; overflow:hidden;">
          <div id="otp-progress" style="height:100%; background:var(--grad-primary); border-radius:999px; width:100%; transition:width 1s linear;"></div>
        </div>
      </div>

      <button class="auth-submit-btn" id="otp-submit" onclick="verifyOTP()" disabled>
        <span class="spinner"></span>
        <span class="btn-text">Xác thực mã OTP</span>
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
      </button>

      <div style="text-align:center; margin-top:1.25rem; font-size:0.875rem; color:var(--clr-text-secondary);">
        Không nhận được mã?
        <button class="otp-resend" id="btn-resend-otp" onclick="resendOTP()" disabled style="background:none; border:none; font-size:inherit; cursor:not-allowed; color:var(--clr-text-muted);">
          Gửi lại mã
        </button>
        <span id="resend-timer-text" style="font-size:0.75rem; color:var(--clr-text-muted);">(khả dụng sau <span id="resend-countdown">60s</span>)</span>
      </div>

      <!-- Demo hint -->
      <div style="margin-top:1.5rem; padding:0.75rem 1rem; background:rgba(245,158,11,0.06); border:1px solid rgba(245,158,11,0.15); border-radius:0.75rem;">
        <p class="text-xs" style="color:var(--clr-gold-400); display:flex; align-items:center; gap:0.5rem;">
          <span>🎓</span>
          <span><strong>Demo:</strong> Nhập mã <strong>123456</strong> để thử nghiệm tính năng</span>
        </p>
      </div>
    </div>
  </div>

  <div id="toast-container" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:500;display:flex;flex-direction:column;gap:.75rem;"></div>
  <script src="../js/auth.js"></script>
</body>
</html>
