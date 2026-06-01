<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đặt lại mật khẩu – IELTS Flow</title>
  <meta name="description" content="Tạo mật khẩu mới an toàn cho tài khoản IELTS Flow của bạn.">
  <link rel="stylesheet" href="../css/auth.css">
</head>
<body>
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>

  <div class="otp-container">
    <div class="glass-card otp-card" style="max-width:480px;">
      <div style="text-align:center; margin-bottom:2rem;">
        <div style="font-size:3rem; margin-bottom:1rem;" class="animate-bounce-in">🛡️</div>
        <h1 class="text-2xl fw-extrabold" style="margin-bottom:0.5rem;">Đặt lại mật khẩu</h1>
        <p class="text-secondary text-sm" style="line-height:1.65;">
          Tạo mật khẩu mới mạnh và an toàn để bảo vệ tài khoản học tập của bạn.
        </p>
      </div>

      <form id="reset-pw-form" novalidate>
        <div style="display:flex; flex-direction:column; gap:1.25rem;">
          <div class="form-group">
            <label class="form-label" for="new-password">Mật khẩu mới</label>
            <div class="form-input-wrap">
              <input type="password" id="new-password" class="form-input" placeholder="Tối thiểu 8 ký tự" autocomplete="new-password" required>
              <div class="input-icon">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="11" width="18" height="11" rx="2"/>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
              </div>
              <button type="button" class="input-action" id="toggle-new-pw">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                </svg>
              </button>
            </div>
            <div class="strength-bar" id="reset-strength-bar">
              <div class="strength-seg" id="r-seg-1"></div>
              <div class="strength-seg" id="r-seg-2"></div>
              <div class="strength-seg" id="r-seg-3"></div>
              <div class="strength-seg" id="r-seg-4"></div>
            </div>
            <div class="strength-label text-muted" id="reset-strength-label">Nhập mật khẩu để kiểm tra</div>
            <span class="form-error hidden" id="new-pw-error"></span>
          </div>

          <div class="form-group">
            <label class="form-label" for="confirm-new-password">Xác nhận mật khẩu mới</label>
            <div class="form-input-wrap">
              <input type="password" id="confirm-new-password" class="form-input" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password" required>
              <div class="input-icon">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="11" width="18" height="11" rx="2"/>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
              </div>
              <span class="input-action" id="confirm-match-icon" style="display:none; font-size:1rem;"></span>
            </div>
            <span class="form-error hidden" id="confirm-new-pw-error"></span>
          </div>

          <!-- Password Requirements -->
          <div style="padding:1rem; background:rgba(255,255,255,0.03); border:1px solid var(--clr-border); border-radius:0.75rem;">
            <div class="text-xs fw-semibold text-secondary" style="margin-bottom:0.625rem; text-transform:uppercase; letter-spacing:0.05em;">Yêu cầu mật khẩu</div>
            <div style="display:flex; flex-direction:column; gap:0.5rem;">
              <div class="req-item" id="req-length" style="display:flex; align-items:center; gap:0.5rem; font-size:0.75rem; color:var(--clr-text-muted);">
                <span class="req-icon">○</span> Tối thiểu 8 ký tự
              </div>
              <div class="req-item" id="req-upper" style="display:flex; align-items:center; gap:0.5rem; font-size:0.75rem; color:var(--clr-text-muted);">
                <span class="req-icon">○</span> Ít nhất 1 chữ hoa (A-Z)
              </div>
              <div class="req-item" id="req-number" style="display:flex; align-items:center; gap:0.5rem; font-size:0.75rem; color:var(--clr-text-muted);">
                <span class="req-icon">○</span> Ít nhất 1 chữ số (0-9)
              </div>
              <div class="req-item" id="req-special" style="display:flex; align-items:center; gap:0.5rem; font-size:0.75rem; color:var(--clr-text-muted);">
                <span class="req-icon">○</span> Ít nhất 1 ký tự đặc biệt (!@#$...)
              </div>
            </div>
          </div>

          <button type="submit" class="auth-submit-btn" id="reset-submit">
            <span class="spinner"></span>
            <span class="btn-text">Lưu mật khẩu mới</span>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
          </button>
        </div>
      </form>

      <div style="margin-top:1.25rem; padding:0.75rem 1rem; background:rgba(16,185,129,0.06); border:1px solid rgba(16,185,129,0.15); border-radius:0.75rem; display:flex; gap:0.625rem; align-items:flex-start;">
        <span style="font-size:1rem; flex-shrink:0;">🔒</span>
        <p class="text-xs text-secondary" style="line-height:1.6;">
          Mật khẩu được băm bằng <strong style="color:var(--clr-success-400);">bcrypt (cost factor 12)</strong> trước khi lưu. Ngay cả admin cũng không thể xem mật khẩu của bạn.
        </p>
      </div>
    </div>
  </div>

  <div id="toast-container" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:500;display:flex;flex-direction:column;gap:.75rem;"></div>
  <script src="../js/auth.js"></script>
</body>
</html>
