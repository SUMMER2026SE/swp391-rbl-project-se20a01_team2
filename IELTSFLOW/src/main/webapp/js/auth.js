// auth.js
document.addEventListener('DOMContentLoaded', () => {
    // Check if user is already logged in
    fetch('/IELTSFLOW/api/user/me', {
        method: 'GET',
        headers: { 'Accept': 'application/json' }
    })
    .then(res => {
        if (res.ok) return res.json();
        throw new Error('Not logged in');
    })
    .then(data => {
        if (data && data.data) {
            // Đã đăng nhập → Hiển thị banner thay vì auto redirect
            const dashUrl = data.data.roleId === 1
                ? '/IELTSFLOW/jsp/admin/dashboard.jsp'
                : '/IELTSFLOW/jsp/account.jsp';
            const name = data.data.fullName || data.data.email || 'Bạn';

            // Inject banner vào đầu trang auth-right
            const rightPanel = document.querySelector('.auth-right');
            if (rightPanel) {
                const banner = document.createElement('div');
                banner.style.cssText = `
                    position: absolute; top: 0; left: 0; right: 0;
                    background: #1e293b; color: white;
                    padding: 14px 24px;
                    display: flex; align-items: center; justify-content: space-between;
                    font-size: 14px; z-index: 10;
                `;
                banner.innerHTML = `
                    <span>👤 Xin chào, <strong>${name}</strong> — Bạn đang đăng nhập</span>
                    <div style="display:flex;gap:10px;">
                        <a href="${dashUrl}" style="background:#3b82f6;color:white;padding:6px 14px;border-radius:6px;text-decoration:none;font-weight:600;font-size:13px;">Vào Dashboard</a>
                        <button onclick="logoutAndStay()" style="background:#ef4444;color:white;padding:6px 14px;border-radius:6px;border:none;cursor:pointer;font-weight:600;font-size:13px;">Đăng xuất</button>
                    </div>
                `;
                rightPanel.insertBefore(banner, rightPanel.firstChild);
            }

            // Vẫn khởi tạo form bình thường (không redirect)
            initAuthPage();
        } else {
            initAuthPage();
        }
    })
    .catch(() => {
        // Not logged in, proceed with page initialization
        initAuthPage();
    });
});

// Logout and stay on auth page
window.logoutAndStay = async function() {
    try {
        await fetch('/IELTSFLOW/api/auth/logout', { method: 'POST' });
    } catch(e) {}
    window.location.reload();
};


// ── Google Identity Services ──────────────────────────────────────────────
const GOOGLE_CLIENT_ID = '1025181632456-ioq6p3hghb8t161f22n9pg90qn0mvufc.apps.googleusercontent.com';
let tokenClient;

function initGoogleSignIn() {
    if (typeof google === 'undefined' || !google.accounts || !google.accounts.oauth2) {
        setTimeout(initGoogleSignIn, 300);
        return;
    }
    tokenClient = google.accounts.oauth2.initTokenClient({
        client_id: GOOGLE_CLIENT_ID,
        scope: 'email profile openid',
        callback: window.handleGoogleCredentialResponse,
    });
}

// Try init on script onload AND after DOMContentLoaded as fallback
window.onGoogleLibraryLoad = initGoogleSignIn;
document.addEventListener('DOMContentLoaded', () => setTimeout(initGoogleSignIn, 500));

function initAuthPage() {
    // UI Elements
    const tabSlider = document.getElementById('tabSlider');
    const tabLoginBtn = document.getElementById('tabLoginBtn');
    const tabRegisterBtn = document.getElementById('tabRegisterBtn');
    const loginFormArea = document.getElementById('loginFormArea');
    const registerFormArea = document.getElementById('registerFormArea');
    
    // Switch Tabs Logic
    function switchTab(tab) {
        if (tab === 'register') {
            tabSlider.style.transform = 'translateX(100%)';
            tabLoginBtn.classList.remove('active');
            tabRegisterBtn.classList.add('active');
            loginFormArea.classList.remove('active');
            registerFormArea.classList.add('active');
            window.history.pushState({}, '', '?tab=register');
        } else {
            tabSlider.style.transform = 'translateX(0)';
            tabRegisterBtn.classList.remove('active');
            tabLoginBtn.classList.add('active');
            registerFormArea.classList.remove('active');
            loginFormArea.classList.add('active');
            window.history.pushState({}, '', window.location.pathname);
        }
    }

    tabLoginBtn.addEventListener('click', () => switchTab('login'));
    tabRegisterBtn.addEventListener('click', () => switchTab('register'));

    // Check URL params for initial tab
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'register') {
        switchTab('register');
    }

    // Toggle Password Visibility
    document.querySelectorAll('.toggle-password').forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                this.textContent = '🔒'; // Optional: change icon to signify unlocked/visible
            } else {
                input.type = 'password';
                this.textContent = '👁️';
            }
        });
    });

    // Password Strength Logic
    const regPassword = document.getElementById('regPassword');
    const strengthWrapper = document.getElementById('strengthWrapper');
    const segments = [
        document.getElementById('seg1'),
        document.getElementById('seg2'),
        document.getElementById('seg3'),
        document.getElementById('seg4')
    ];
    const strengthText = document.getElementById('strengthText');

    function getPasswordStrength(password) {
        let score = 0;
        if (!password) return score;
        if (password.length >= 8) score += 1;
        if (/[A-Z]/.test(password)) score += 1;
        if (/[0-9]/.test(password)) score += 1;
        if (/[^A-Za-z0-9]/.test(password)) score += 1;
        return score; // 0 to 4
    }

    function updateStrengthBar(password) {
        if (password.length > 0) {
            strengthWrapper.style.display = 'block';
        } else {
            strengthWrapper.style.display = 'none';
        }
        
        const score = getPasswordStrength(password);
        
        // Reset segments
        segments.forEach(seg => seg.style.background = '#e2e8f0');
        
        let color = '#ef4444'; // Red
        let text = 'Rất yếu';
        
        if (score === 2) { color = '#f59e0b'; text = 'Yếu'; } // Orange
        if (score === 3) { color = '#3b82f6'; text = 'Trung bình'; } // Blue
        if (score === 4) { color = '#22c55e'; text = 'Mạnh'; } // Green
        
        for (let i = 0; i < score; i++) {
            segments[i].style.background = color;
        }
        
        strengthText.textContent = text;
        strengthText.style.color = color;
    }

    regPassword.addEventListener('input', (e) => {
        updateStrengthBar(e.target.value);
    });

    // Google Button Click Handlers
    window.triggerGoogleLogin = function() {
        if (tokenClient) {
            tokenClient.requestAccessToken();
        } else {
            showToast('Đang tải Google Sign-In, vui lòng thử lại sau giây lát...', 'warning', 2500);
            initGoogleSignIn();
        }
    };

    // Validation Utilities
    function isValidEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    }

    function setError(inputEl, errorEl, message) {
        inputEl.classList.add('error');
        errorEl.textContent = message;
        errorEl.style.display = 'block';
    }

    function clearError(inputEl, errorEl) {
        inputEl.classList.remove('error');
        errorEl.textContent = '';
        errorEl.style.display = 'none';
    }

    function setLoading(btn, isLoading) {
        const span = btn.querySelector('.btn-text');
        if (isLoading) {
            btn.disabled = true;
            btn.dataset.originalText = span.innerHTML;
            span.innerHTML = '<div class="spinner"></div>';
        } else {
            btn.disabled = false;
            span.innerHTML = btn.dataset.originalText || '';
        }
    }

    // Global Toast Function
    window.showToast = function(message, type = 'success', duration = 3000) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        
        let icon = '✓';
        if (type === 'error') icon = '✕';
        if (type === 'warning') icon = '⚠';
        
        toast.innerHTML = `<span>${icon}</span> <span>${message}</span>`;
        container.appendChild(toast);
        
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    };

    // Handle Login Submit
    const loginForm = document.getElementById('loginForm');
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const emailInput = document.getElementById('loginEmail');
        const passwordInput = document.getElementById('loginPassword');
        const emailErr = document.getElementById('loginEmailErr');
        const passwordErr = document.getElementById('loginPasswordErr');
        const submitBtn = document.getElementById('loginSubmit');
        
        // Reset errors
        clearError(emailInput, emailErr);
        clearError(passwordInput, passwordErr);
        
        let hasError = false;
        
        if (!isValidEmail(emailInput.value)) {
            setError(emailInput, emailErr, 'Email không hợp lệ');
            hasError = true;
        }
        
        if (!passwordInput.value) {
            setError(passwordInput, passwordErr, 'Vui lòng nhập mật khẩu');
            hasError = true;
        }
        
        if (hasError) return;
        
        setLoading(submitBtn, true);
        
        try {
            const response = await fetch('/IELTSFLOW/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    email: emailInput.value.trim(),
                    password: passwordInput.value
                })
            });
            
            const data = await response.json();
            
            if (response.ok && data.success) {
                showToast('Đăng nhập thành công! Đang chuyển hướng...', 'success');
                // Redirect based on role - dùng absolute path
                if (Number(data.data.roleId) === 1) {
                    setTimeout(() => window.location.href = '/IELTSFLOW/jsp/admin/dashboard.jsp', 800);
                } else {
                    setTimeout(() => window.location.href = '/IELTSFLOW/jsp/account.jsp', 800);
                }
            } else {
                handleErrorResponse(response.status, data.message, emailInput.value.trim());
            }
        } catch (error) {
            showToast('Lỗi kết nối. Vui lòng thử lại sau.', 'error');
        } finally {
            setLoading(submitBtn, false);
        }
    });

    // Handle Register Submit
    const registerForm = document.getElementById('registerForm');
    registerForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const nameInput = document.getElementById('regName');
        const emailInput = document.getElementById('regEmail');
        const passwordInput = document.getElementById('regPassword');
        const confirmInput = document.getElementById('regConfirmPassword');
        const termsInput = document.getElementById('regTerms');
        
        const nameErr = document.getElementById('regNameErr');
        const emailErr = document.getElementById('regEmailErr');
        const passwordErr = document.getElementById('regPasswordErr');
        const confirmErr = document.getElementById('regConfirmPasswordErr');
        const termsErr = document.getElementById('regTermsErr');
        
        const submitBtn = document.getElementById('registerSubmit');
        
        // Reset errors
        clearError(nameInput, nameErr);
        clearError(emailInput, emailErr);
        clearError(passwordInput, passwordErr);
        clearError(confirmInput, confirmErr);
        clearError(termsInput, termsErr);
        
        let hasError = false;
        
        if (!nameInput.value.trim()) {
            setError(nameInput, nameErr, 'Vui lòng nhập họ và tên');
            hasError = true;
        }
        
        if (!isValidEmail(emailInput.value)) {
            setError(emailInput, emailErr, 'Email không hợp lệ');
            hasError = true;
        }
        
        if (passwordInput.value.length < 8) {
            setError(passwordInput, passwordErr, 'Mật khẩu phải có ít nhất 8 ký tự');
            hasError = true;
        }
        
        if (passwordInput.value !== confirmInput.value) {
            setError(confirmInput, confirmErr, 'Mật khẩu không khớp');
            hasError = true;
        }
        
        if (!termsInput.checked) {
            termsErr.textContent = 'Bạn phải đồng ý với điều khoản';
            termsErr.style.display = 'block';
            hasError = true;
        }
        
        if (hasError) return;
        
        setLoading(submitBtn, true);
        
        try {
            const response = await fetch('/IELTSFLOW/api/auth/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    fullName: nameInput.value.trim(),
                    email: emailInput.value.trim(),
                    password: passwordInput.value
                })
            });
            
            const data = await response.json();
            
            if (response.ok && data.success) {
                showToast('Đăng ký thành công! Vui lòng xác thực email.', 'success');
                sessionStorage.setItem('pendingEmail', emailInput.value.trim());
                setTimeout(() => {
                    window.location.href = 'verify-email.jsp';
                }, 1500);
            } else {
                handleErrorResponse(response.status, data.message, emailInput.value.trim());
            }
        } catch (error) {
            showToast('Lỗi kết nối. Vui lòng thử lại sau.', 'error');
        } finally {
            setLoading(submitBtn, false);
        }
    });

    function handleErrorResponse(status, defaultMessage, email = '') {
        switch (status) {
            case 400:
                showToast(defaultMessage || 'Thông tin không hợp lệ.', 'error');
                break;
            case 401:
                showToast(defaultMessage || 'Email hoặc mật khẩu không chính xác.', 'error');
                break;
            case 403:
                if (defaultMessage && defaultMessage.toLowerCase().includes('inactive')) {
                    showToast('Tài khoản chưa được kích hoạt. Chuyển hướng...', 'warning');
                    if (email) sessionStorage.setItem('pendingEmail', email);
                    setTimeout(() => {
                        window.location.href = 'verify-email.jsp';
                    }, 2000);
                } else if (defaultMessage && defaultMessage.toLowerCase().includes('ban')) {
                    showToast('Tài khoản của bạn đã bị khóa.', 'error', 5000);
                } else {
                    showToast(defaultMessage || 'Bạn không có quyền truy cập.', 'error');
                }
                break;
            case 429:
                showToast('Quá nhiều yêu cầu. Vui lòng thử lại sau.', 'error');
                break;
            default:
                showToast(defaultMessage || 'Có lỗi xảy ra, vui lòng thử lại.', 'error');
        }
    }
}

// Global Google Auth callback
window.handleGoogleCredentialResponse = async function(response) {
    if (response.access_token || response.credential) {
        showToast('Đang xác thực với Google...', 'success', 2000);
        
        try {
            const formData = new URLSearchParams();
            if (response.access_token) {
                formData.append('accessToken', response.access_token);
            } else if (response.credential) {
                formData.append('idToken', response.credential);
            }

            const res = await fetch('/IELTSFLOW/api/auth/google', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: formData.toString()
            });
            
            const data = await res.json();
            
            if (res.ok && data.success) {
                showToast('Đăng nhập Google thành công! Đang chuyển hướng...', 'success');
                if (data.data && Number(data.data.roleId) === 1) {
                    setTimeout(() => window.location.href = '/IELTSFLOW/jsp/admin/dashboard.jsp', 800);
                } else {
                    setTimeout(() => window.location.href = '/IELTSFLOW/jsp/account.jsp', 800);
                }
            } else {
                showToast(data.message || 'Đăng nhập Google thất bại.', 'error');
                if (res.status === 403 && data.message && data.message.toLowerCase().includes('inactive')) {
                    setTimeout(() => window.location.href = 'verify-email.jsp', 1500);
                }
            }
        } catch (error) {
            console.error('Google Auth Error:', error);
            showToast('Lỗi kết nối khi đăng nhập Google.', 'error');
        }
    } else {
        showToast('Không lấy được thông tin đăng nhập Google.', 'error');
    }
};

// === Forgot Password, OTP, Reset Password Logic ===
document.addEventListener('DOMContentLoaded', () => {
    // 1. Forgot Password Form
    const forgotForm = document.getElementById('forgot-form');
    if (forgotForm) {
        forgotForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const emailInput = document.getElementById('forgot-email');
            const emailErr = document.getElementById('forgot-email-error');
            const submitBtn = document.getElementById('forgot-submit');
            
            const email = emailInput.value.trim();
            if (!email) {
                emailInput.classList.add('error');
                emailErr.textContent = 'Vui lòng nhập email';
                emailErr.style.display = 'block';
                return;
            }
            
            emailInput.classList.remove('error');
            emailErr.style.display = 'none';
            
            // Set Loading
            const span = submitBtn.querySelector('.btn-text');
            submitBtn.disabled = true;
            submitBtn.dataset.originalText = span.innerHTML;
            span.innerHTML = '<div class="spinner"></div>';
            
            try {
                const response = await fetch('/IELTSFLOW/api/auth/forgot-password', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email })
                });
                
                const data = await response.json();
                if (response.ok && data.success) {
                    window.showToast(data.message, 'success');
                    sessionStorage.setItem('resetEmail', email);
                    setTimeout(() => window.location.href = 'otp-verify.jsp', 1500);
                } else {
                    window.showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            } catch (err) {
                window.showToast('Lỗi kết nối', 'error');
            } finally {
                submitBtn.disabled = false;
                span.innerHTML = submitBtn.dataset.originalText;
            }
        });
    }

    // 2. Reset Password Form
    const resetPwForm = document.getElementById('reset-pw-form');
    if (resetPwForm) {
        resetPwForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const newPw = document.getElementById('new-password').value;
            const confirmPw = document.getElementById('confirm-new-password').value;
            const submitBtn = document.getElementById('reset-submit');
            
            if (newPw !== confirmPw) {
                window.showToast('Mật khẩu không khớp', 'error');
                return;
            }
            
            const email = sessionStorage.getItem('resetEmail');
            const resetToken = sessionStorage.getItem('resetToken');
            
            if (!email || !resetToken) {
                window.showToast('Phiên làm việc không hợp lệ', 'error');
                setTimeout(() => window.location.href = 'forgot-password.jsp', 1500);
                return;
            }
            
            // Set Loading
            const span = submitBtn.querySelector('.btn-text');
            submitBtn.disabled = true;
            submitBtn.dataset.originalText = span.innerHTML;
            span.innerHTML = '<div class="spinner"></div>';
            
            try {
                const response = await fetch('/IELTSFLOW/api/auth/reset-password', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email, resetToken, newPassword: newPw })
                });
                const data = await response.json();
                if (response.ok && data.success) {
                    window.showToast('Đổi mật khẩu thành công! Đang chuyển hướng...', 'success');
                    sessionStorage.removeItem('resetEmail');
                    sessionStorage.removeItem('resetToken');
                    setTimeout(() => window.location.href = 'auth.jsp', 1500);
                } else {
                    window.showToast(data.message || 'Lỗi đổi mật khẩu', 'error');
                }
            } catch (err) {
                window.showToast('Lỗi kết nối', 'error');
            } finally {
                submitBtn.disabled = false;
                span.innerHTML = submitBtn.dataset.originalText;
            }
        });
    }
});

// OTP logic uses global functions
window.verifyOTP = async function() {
    const inputs = document.querySelectorAll('.otp-digit');
    let otp = '';
    inputs.forEach(i => otp += i.value);
    
    if (otp.length !== 6) {
        window.showToast('Vui lòng nhập đủ 6 số OTP', 'warning');
        return;
    }
    
    const email = sessionStorage.getItem('resetEmail');
    if (!email) {
        window.showToast('Lỗi phiên làm việc. Vui lòng thử lại.', 'error');
        setTimeout(() => window.location.href = 'forgot-password.jsp', 1500);
        return;
    }
    
    const submitBtn = document.getElementById('otp-submit');
    const span = submitBtn.querySelector('.btn-text');
    submitBtn.disabled = true;
    submitBtn.dataset.originalText = span.innerHTML;
    span.innerHTML = '<div class="spinner"></div>';
    
    try {
        const response = await fetch('/IELTSFLOW/api/auth/verify-otp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, otp })
        });
        const data = await response.json();
        if (response.ok && data.success) {
            window.showToast('Xác thực thành công!', 'success');
            sessionStorage.setItem('resetToken', data.data ? data.data.resetToken : data.resetToken);
            setTimeout(() => window.location.href = 'reset-password.jsp', 1000);
        } else {
            window.showToast(data.message || 'OTP không hợp lệ', 'error');
            inputs.forEach(i => i.value = '');
            inputs[0].focus();
        }
    } catch (err) {
        window.showToast('Lỗi kết nối', 'error');
    } finally {
        submitBtn.disabled = false;
        span.innerHTML = submitBtn.dataset.originalText;
    }
};

window.resendOTP = async function() {
    const email = sessionStorage.getItem('resetEmail');
    if (!email) return;
    
    try {
        const response = await fetch('/IELTSFLOW/api/auth/forgot-password', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email })
        });
        const data = await response.json();
        if (response.ok && data.success) {
            window.showToast('Đã gửi lại mã OTP', 'success');
        } else {
            window.showToast(data.message || 'Không thể gửi lại mã', 'error');
        }
    } catch (err) {
        window.showToast('Lỗi kết nối', 'error');
    }
};

document.addEventListener('DOMContentLoaded', () => {
    const otpInputs = document.querySelectorAll('.otp-digit');
    if (otpInputs.length > 0) {
        const emailDisplay = document.getElementById('otp-email-display');
        if (emailDisplay) {
            const savedEmail = sessionStorage.getItem('resetEmail');
            if (savedEmail) emailDisplay.textContent = savedEmail;
        }

        otpInputs.forEach((input, index) => {
            input.addEventListener('input', function() {
                if (this.value.length === 1 && index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
                checkOtpFilled();
            });
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && !this.value && index > 0) {
                    otpInputs[index - 1].focus();
                }
            });
        });
        
        function checkOtpFilled() {
            let filled = 0;
            otpInputs.forEach(i => { if (i.value) filled++; });
            document.getElementById('otp-submit').disabled = (filled !== 6);
        }
    }
});
function startOtpTimer() {
    const resendBtn = document.getElementById('btn-resend-otp');
    const timerText = document.getElementById('resend-timer-text');
    const countdownSpan = document.getElementById('resend-countdown');
    
    if (!resendBtn || !timerText || !countdownSpan) return;
    
    let timeLeft = 60;
    resendBtn.disabled = true;
    resendBtn.style.cursor = 'not-allowed';
    timerText.style.display = 'inline';
    
    const interval = setInterval(() => {
        timeLeft--;
        countdownSpan.textContent = timeLeft + 's';
        
        if (timeLeft <= 0) {
            clearInterval(interval);
            resendBtn.disabled = false;
            resendBtn.style.cursor = 'pointer';
            timerText.style.display = 'none';
        }
    }, 1000);
    
    // Also override the resend button to restart the timer
    resendBtn.onclick = async function(e) {
        e.preventDefault();
        await window.resendOTP();
        startOtpTimer(); // restart timer
    };
}
document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('otp-inputs')) {
        startOtpTimer();
    }
});