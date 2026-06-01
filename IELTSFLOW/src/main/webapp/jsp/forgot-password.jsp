<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quên mật khẩu - IELTS Flow</title>
  <link rel="stylesheet" href="../css/auth.css">
  <style>
    .step { display: none; }
    .step.active { display: block; }
    .otp-box-row { display: flex; gap: 10px; justify-content: center; margin: 20px 0; }
    .otp-box { width: 48px; height: 56px; text-align: center; font-size: 22px; font-weight: 700;
      border: 2px solid #d1d5db; border-radius: 12px; outline: none; transition: border-color 0.2s;
      background: rgba(255,255,255,0.08); color: inherit; }
    .otp-box:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.2); }
    .countdown-bar { height: 4px; background: #e5e7eb; border-radius: 4px; margin: 16px 0; overflow: hidden; }
    .countdown-fill { height: 100%; background: linear-gradient(90deg,#6366f1,#8b5cf6); border-radius: 4px;
      width: 100%; transition: width 1s linear; }
    .resend-row { text-align: center; font-size: 0.85rem; color: #6b7280; margin-top: 12px; }
    #resend-btn { background: none; border: none; color: #6366f1; font-weight: 600; cursor: pointer;
      font-size: 0.85rem; padding: 0; }
    #resend-btn:disabled { color: #9ca3af; cursor: not-allowed; }
    .pw-input-wrap { position: relative; }
    .pw-input-wrap input { padding-right: 44px; }
    .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
      background: none; border: none; cursor: pointer; color: #6b7280; }
  </style>
</head>
<body>
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>

  <div class="otp-container">
    <div class="glass-card otp-card" style="max-width:460px;">
      <button class="back-btn" id="back-btn" onclick="goBack()">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        Quay lại
      </button>

      <!-- BUOC 1: Nhap Email -->
      <div class="step active" id="step-email">
        <div style="text-align:center; margin-bottom:2rem;">
          <div style="font-size:3rem; margin-bottom:1rem;">&#128273;</div>
          <h1 class="text-2xl fw-extrabold" style="margin-bottom:0.5rem;">Quên mật khẩu?</h1>
          <p class="text-secondary text-sm" style="line-height:1.65;">
            Nhập email đăng ký. Chúng tôi sẽ gửi mã OTP 6 số để đặt lại mật khẩu.
          </p>
        </div>
        <div class="form-group" style="margin-bottom:1.5rem;">
          <label class="form-label" for="fp-email">Địa chỉ Email</label>
          <div class="form-input-wrap">
            <input type="email" id="fp-email" class="form-input" placeholder="email@example.com" autocomplete="email">
            <div class="input-icon">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
              </svg>
            </div>
          </div>
          <span class="form-error hidden" id="fp-email-error" style="color:#ef4444;font-size:0.8rem;"></span>
        </div>
        <button class="auth-submit-btn" id="btn-send-otp" onclick="sendOTP()">
          <span id="send-otp-text">Gửi mã OTP đến email &#9993;</span>
        </button>
        <p class="text-center text-xs" style="margin-top:1.5rem;color:#9ca3af;">
          Nhớ mật khẩu rồi? <a href="auth.jsp" style="color:#6366f1;font-weight:600;">Đăng nhập ngay</a>
        </p>
      </div>

      <!-- BUOC 2: Nhap OTP -->
      <div class="step" id="step-otp">
        <div style="text-align:center; margin-bottom:1.5rem;">
          <div style="font-size:3rem; margin-bottom:1rem;">&#128272;</div>
          <h1 class="text-2xl fw-extrabold" style="margin-bottom:0.5rem;">Nhập mã xác thực</h1>
          <p class="text-secondary text-sm">
            Đã gửi mã OTP 6 số đến<br>
            <strong id="otp-email-show" style="color:#6366f1;">email@example.com</strong>
          </p>
        </div>

        <div class="otp-box-row" id="otp-boxes">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o0">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o1">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o2">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o3">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o4">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o5">
        </div>

        <div class="countdown-bar">
          <div class="countdown-fill" id="countdown-fill"></div>
        </div>
        <div style="text-align:center; font-size:0.85rem; color:#6b7280; margin-bottom:16px;">
          Mã hết hiệu lực sau: <strong id="countdown-text" style="color:#6366f1;">05:00</strong>
        </div>

        <button class="auth-submit-btn" id="btn-verify-otp" onclick="verifyOTPStep()" disabled>
          <span id="verify-otp-text">Xác thực mã OTP</span>
        </button>

        <div class="resend-row" style="margin-top:16px;">
          Không nhận được mã?
          <button id="resend-btn" onclick="resendOTP()" disabled>Gửi lại mã</button>
          <span id="resend-timer"> (sau <span id="resend-sec">60</span>s)</span>
        </div>
      </div>

      <!-- BUOC 3: Dat lai mat khau -->
      <div class="step" id="step-reset">
        <div style="text-align:center; margin-bottom:2rem;">
          <div style="font-size:3rem; margin-bottom:1rem;">&#128737;</div>
          <h1 class="text-2xl fw-extrabold" style="margin-bottom:0.5rem;">Đặt lại mật khẩu</h1>
          <p class="text-secondary text-sm">Tạo mật khẩu mới mạnh và an toàn.</p>
        </div>

        <div class="form-group" style="margin-bottom:1.25rem;">
          <label class="form-label" for="new-pw">Mật khẩu mới</label>
          <div class="pw-input-wrap">
            <input type="password" id="new-pw" class="form-input" placeholder="Tối thiểu 8 ký tự">
            <button type="button" class="toggle-pw" onclick="togglePw('new-pw')">&#128065;</button>
          </div>
        </div>
        <div class="form-group" style="margin-bottom:1.5rem;">
          <label class="form-label" for="confirm-pw">Xác nhận mật khẩu</label>
          <div class="pw-input-wrap">
            <input type="password" id="confirm-pw" class="form-input" placeholder="Nhập lại mật khẩu mới">
            <button type="button" class="toggle-pw" onclick="togglePw('confirm-pw')">&#128065;</button>
          </div>
          <span class="form-error hidden" id="pw-error" style="color:#ef4444;font-size:0.8rem;"></span>
        </div>
        <button class="auth-submit-btn" id="btn-reset-pw" onclick="resetPassword()">
          <span id="reset-pw-text">Lưu mật khẩu mới</span>
        </button>
      </div>

    </div>
  </div>

  <div id="toast-container" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:9999;display:flex;flex-direction:column;gap:.75rem;"></div>

<script>
var currentEmail = '';
var resetToken = '';
var countdownInterval = null;
var resendInterval = null;

function showToast(msg, type) {
  var tc = document.getElementById('toast-container');
  var t = document.createElement('div');
  var bg = type === 'success' ? '#10b981' : type === 'warning' ? '#f59e0b' : '#ef4444';
  t.style.cssText = 'background:' + bg + ';color:#fff;padding:12px 20px;border-radius:10px;font-size:0.9rem;font-weight:500;box-shadow:0 4px 12px rgba(0,0,0,0.2);max-width:320px;animation:fadeIn 0.3s ease';
  t.textContent = msg;
  tc.appendChild(t);
  setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 3500);
}

function setLoading(btnId, textId, loading, original) {
  var btn = document.getElementById(btnId);
  var span = document.getElementById(textId);
  btn.disabled = loading;
  if (loading) {
    span.innerHTML = '<span style="display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,0.4);border-top-color:#fff;border-radius:50%;animation:spin 0.8s linear infinite;vertical-align:middle;"></span> Đang xử lý...';
  } else {
    span.innerHTML = original;
  }
}

function showStep(name) {
  document.querySelectorAll('.step').forEach(function(s) { s.classList.remove('active'); });
  document.getElementById('step-' + name).classList.add('active');
}

function goBack() {
  var active = document.querySelector('.step.active');
  if (active && active.id === 'step-otp') {
    clearInterval(countdownInterval);
    clearInterval(resendInterval);
    showStep('email');
  } else if (active && active.id === 'step-reset') {
    showStep('otp');
  } else {
    history.back();
  }
}

function sendOTP() {
  var email = document.getElementById('fp-email').value.trim();
  var errEl = document.getElementById('fp-email-error');
  if (!email) {
    errEl.textContent = 'Vui lòng nhập email';
    errEl.style.display = 'block';
    return;
  }
  errEl.style.display = 'none';
  setLoading('btn-send-otp', 'send-otp-text', true, 'Gửi mã OTP đến email &#9993;');

  fetch('/IELTSFLOW/api/auth/forgot-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: email })
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    setLoading('btn-send-otp', 'send-otp-text', false, 'Gửi mã OTP đến email &#9993;');
    if (data.success) {
      currentEmail = email;
      document.getElementById('otp-email-show').textContent = email;
      showStep('otp');
      startCountdown(300);
      startResendTimer(60);
      setupOtpBoxes();
      showToast('Đã gửi mã OTP đến ' + email, 'success');
    } else {
      showToast(data.message || 'Có lỗi xảy ra', 'error');
    }
  })
  .catch(function() {
    setLoading('btn-send-otp', 'send-otp-text', false, 'Gửi mã OTP đến email &#9993;');
    showToast('Lỗi kết nối. Vui lòng thử lại.', 'error');
  });
}

function startCountdown(seconds) {
  clearInterval(countdownInterval);
  var fill = document.getElementById('countdown-fill');
  var text = document.getElementById('countdown-text');
  var total = seconds;
  function update() {
    var m = Math.floor(seconds / 60);
    var s = seconds % 60;
    text.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    fill.style.width = (seconds / total * 100) + '%';
    if (seconds <= 0) {
      clearInterval(countdownInterval);
      text.textContent = 'Hết hạn';
      fill.style.width = '0%';
    }
    seconds--;
  }
  update();
  countdownInterval = setInterval(update, 1000);
}

function startResendTimer(seconds) {
  clearInterval(resendInterval);
  var btn = document.getElementById('resend-btn');
  var sec = document.getElementById('resend-sec');
  var timerSpan = document.getElementById('resend-timer');
  btn.disabled = true;
  timerSpan.style.display = 'inline';
  function tick() {
    sec.textContent = seconds;
    if (seconds <= 0) {
      clearInterval(resendInterval);
      btn.disabled = false;
      timerSpan.style.display = 'none';
    }
    seconds--;
  }
  tick();
  resendInterval = setInterval(tick, 1000);
}

function resendOTP() {
  if (!currentEmail) return;
  document.getElementById('resend-btn').disabled = true;
  fetch('/IELTSFLOW/api/auth/forgot-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: currentEmail })
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) {
      showToast('Đã gửi lại mã OTP!', 'success');
      startCountdown(300);
      startResendTimer(60);
    } else {
      showToast(data.message || 'Không thể gửi lại mã', 'error');
      document.getElementById('resend-btn').disabled = false;
    }
  })
  .catch(function() {
    showToast('Lỗi kết nối', 'error');
    document.getElementById('resend-btn').disabled = false;
  });
}

function setupOtpBoxes() {
  var boxes = document.querySelectorAll('.otp-box');
  boxes.forEach(function(box, i) {
    box.value = '';
    box.oninput = function() {
      this.value = this.value.replace(/[^0-9]/g, '');
      if (this.value && i < boxes.length - 1) boxes[i + 1].focus();
      checkOtpComplete();
    };
    box.onkeydown = function(e) {
      if (e.key === 'Backspace' && !this.value && i > 0) boxes[i - 1].focus();
    };
  });
  boxes[0].focus();
}

function checkOtpComplete() {
  var boxes = document.querySelectorAll('.otp-box');
  var all = true;
  boxes.forEach(function(b) { if (!b.value) all = false; });
  document.getElementById('btn-verify-otp').disabled = !all;
}

function verifyOTPStep() {
  var boxes = document.querySelectorAll('.otp-box');
  var otp = '';
  boxes.forEach(function(b) { otp += b.value; });
  if (otp.length !== 6) { showToast('Vui lòng nhập đủ 6 số', 'warning'); return; }

  setLoading('btn-verify-otp', 'verify-otp-text', true, 'Xác thực mã OTP');
  fetch('/IELTSFLOW/api/auth/verify-otp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: currentEmail, otp: otp })
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    setLoading('btn-verify-otp', 'verify-otp-text', false, 'Xác thực mã OTP');
    if (data.success) {
      resetToken = (data.data && data.data.resetToken) ? data.data.resetToken : (data.resetToken || '');
      clearInterval(countdownInterval);
      clearInterval(resendInterval);
      showToast('Xác thực thành công!', 'success');
      showStep('reset');
    } else {
      showToast(data.message || 'OTP không hợp lệ', 'error');
      boxes.forEach(function(b) { b.value = ''; });
      boxes[0].focus();
      document.getElementById('btn-verify-otp').disabled = true;
    }
  })
  .catch(function() {
    setLoading('btn-verify-otp', 'verify-otp-text', false, 'Xác thực mã OTP');
    showToast('Lỗi kết nối', 'error');
  });
}

function resetPassword() {
  var pw = document.getElementById('new-pw').value;
  var confirm = document.getElementById('confirm-pw').value;
  var errEl = document.getElementById('pw-error');
  if (pw.length < 8) {
    errEl.textContent = 'Mật khẩu phải có ít nhất 8 ký tự';
    errEl.style.display = 'block'; return;
  }
  if (pw !== confirm) {
    errEl.textContent = 'Mật khẩu không khớp';
    errEl.style.display = 'block'; return;
  }
  errEl.style.display = 'none';
  setLoading('btn-reset-pw', 'reset-pw-text', true, 'Lưu mật khẩu mới');
  fetch('/IELTSFLOW/api/auth/reset-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: currentEmail, resetToken: resetToken, newPassword: pw })
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    setLoading('btn-reset-pw', 'reset-pw-text', false, 'Lưu mật khẩu mới');
    if (data.success) {
      showToast('Đổi mật khẩu thành công! Đang chuyển trang...', 'success');
      setTimeout(function() { window.location.href = 'auth.jsp'; }, 1500);
    } else {
      showToast(data.message || 'Lỗi đổi mật khẩu', 'error');
    }
  })
  .catch(function() {
    setLoading('btn-reset-pw', 'reset-pw-text', false, 'Lưu mật khẩu mới');
    showToast('Lỗi kết nối', 'error');
  });
}

function togglePw(id) {
  var inp = document.getElementById(id);
  inp.type = inp.type === 'password' ? 'text' : 'password';
}
</script>
<style>
@keyframes spin { to { transform: rotate(360deg); } }
@keyframes fadeIn { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
</style>
</body>
</html>
