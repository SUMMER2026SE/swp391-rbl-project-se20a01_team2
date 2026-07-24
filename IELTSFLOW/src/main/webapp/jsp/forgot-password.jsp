<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --font-h: 'Inter', sans-serif;
            --font-b: 'Inter', sans-serif;
            --blue-600: #2563EB;
            --grad-brand: linear-gradient(135deg, #2563EB 0%, #4F46E5 100%);
            --text-dark: #0F172A;
            --text-body: #334155;
            --text-muted: #64748B;
            --border: #E2E8F0;
            --border-focus: #3B82F6;
            --radius: 12px;
            --shadow-sm: 0 2px 8px rgba(15,23,42,.04);
            --shadow-md: 0 4px 20px rgba(15,23,42,.08);
            background: #F8FAFC;
        }

        body.dark-mode {
            --text-dark: #F1F5F9;
            --text-body: #CBD5E1;
            --text-muted: #94A3B8;
            --border: #1E3A5F;
            --border-focus: #3B82F6;
            --shadow-sm: 0 2px 8px rgba(0,0,0,.3);
            --shadow-md: 0 4px 20px rgba(0,0,0,.35);
            background: #0F172A;
        }

        body {
            font-family: var(--font-b);
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: var(--text-body);
            transition: background 0.3s;
        }

        .auth-right {
            width: 100%;
            max-width: 480px;
            background: #fff;
            padding: 40px 48px;
            border-radius: 24px;
            box-shadow: var(--shadow-md);
            position: relative;
            transition: background 0.3s, box-shadow 0.3s;
        }

        body.dark-mode .auth-right {
            background: #1E293B;
        }

        /* Top-right controls */
        .right-controls {
            position: absolute;
            top: 24px;
            right: 28px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .rc-btn {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: .8125rem;
            font-weight: 600;
            color: var(--text-muted);
            background: #fff;
            cursor: pointer;
            transition: all .2s;
        }
        .rc-btn:hover { border-color: #CBD5E1; color: var(--text-dark); }
        
        body.dark-mode .rc-btn { background: #0F172A; border-color: #1E3A5F; color: #94A3B8; }
        body.dark-mode .rc-btn:hover { border-color: #3B82F6; color: #93C5FD; }

        /* Welcome */
        .auth-welcome { margin-bottom: 28px; text-align: center; }
        .auth-welcome h2 {
            font-family: var(--font-h);
            font-size: 1.625rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 6px;
        }
        .auth-welcome p {
            font-size: .9375rem;
            color: var(--text-muted);
            line-height: 1.6;
        }

        /* Form elements */
        .fgrp { margin-bottom: 18px; }
        .fgrp label {
            display: block;
            font-size: .875rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 7px;
        }
        body.dark-mode .fgrp label { color: #E2E8F0; }

        .inp-wrap { position: relative; }
        .inp-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: .875rem;
            pointer-events: none;
        }
        .inp-wrap input {
            width: 100%;
            padding: 12px 16px 12px 40px;
            border: 1.5px solid var(--border);
            border-radius: var(--radius);
            font-family: var(--font-b);
            font-size: .9375rem;
            color: var(--text-dark);
            background: #fff;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
            box-sizing: border-box;
        }
        .inp-wrap input:focus {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(37,99,235,.10);
        }
        .inp-wrap input::placeholder { color: var(--text-muted); }
        
        body.dark-mode .inp-wrap input { background: #0F172A; border-color: #1E3A5F; color: #F1F5F9; }
        body.dark-mode .inp-wrap input:focus { border-color: #3B82F6; box-shadow: 0 0 0 3px rgba(59,130,246,.15); }
        body.dark-mode .inp-wrap input::placeholder { color: #475569; }

        .btn-cta {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: var(--radius);
            background: var(--grad-brand);
            color: #fff;
            font-family: var(--font-b);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all .25s;
            box-shadow: 0 4px 16px rgba(37,99,235,.28);
            margin-top: 10px;
        }
        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37,99,235,.36);
        }
        .btn-cta:active { transform: scale(.98); }

        .switch-cta {
            text-align: center;
            margin-top: 24px;
            font-size: .875rem;
            color: var(--text-muted);
        }
        .switch-cta a {
            color: var(--blue-600);
            font-weight: 700;
            text-decoration: none;
        }
        body.dark-mode .switch-cta a { color: #93C5FD; }

        .alert-err {
            background: #FEF2F2;
            border: 1px solid #FCA5A5;
            color: #B91C1C;
            padding: 11px 15px;
            border-radius: 10px;
            margin-bottom: 18px;
            font-size: .875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        body.dark-mode .alert-err { background: rgba(239,68,68,.1); border-color: rgba(239,68,68,.3); color: #FCA5A5; }

        .alert-ok {
            background: #F0FDF4;
            border: 1px solid #86EFAC;
            color: #166534;
            padding: 11px 15px;
            border-radius: 10px;
            margin-bottom: 18px;
            font-size: .875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        body.dark-mode .alert-ok { background: rgba(34,197,94,.1); border-color: rgba(34,197,94,.3); color: #86EFAC; }

        @media(max-width: 480px) {
            .auth-right { padding: 32px 24px; border-radius: 0; min-height: 100vh; display: flex; flex-direction: column; justify-content: center; }
            .right-controls { top: 16px; right: 16px; }
        }
    </style>
</head>
<body>

<div class="auth-right">
    <div class="right-controls">
        <button class="rc-btn" id="darkToggle" onclick="toggleDark()">
            <i class="fas fa-moon" id="darkIcon"></i>
        </button>
    </div>

    <c:if test="${not empty error}">
        <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert-ok"><i class="fas fa-check-circle"></i> ${successMessage}</div>
    </c:if>

    <div class="auth-welcome">
        <c:choose>
            <c:when test="${empty step || step == 'sendOtp'}">
                <h2>Khôi phục mật khẩu</h2>
                <p>Nhập email của bạn và chúng tôi sẽ gửi mã OTP gồm 6 chữ số để đặt lại mật khẩu.</p>
            </c:when>
            <c:when test="${step == 'verifyOtp'}">
                <h2>Xác thực OTP</h2>
                <p>Vui lòng kiểm tra hòm thư của <b>${sessionScope.resetEmail}</b> và nhập mã 6 số bạn nhận được.</p>
            </c:when>
            <c:when test="${step == 'resetPassword'}">
                <h2>Đặt mật khẩu mới</h2>
                <p>Tạo mật khẩu mới cho tài khoản của bạn. Mật khẩu nên có ít nhất 8 ký tự.</p>
            </c:when>
        </c:choose>
    </div>

    <c:choose>
        <%-- STEP 1: SEND OTP --%>
        <c:when test="${empty step || step == 'sendOtp'}">
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="action" value="sendOtp">
                <div class="fgrp">
                    <label>Địa chỉ Email</label>
                    <div class="inp-wrap">
                        <i class="fas fa-envelope inp-icon"></i>
                        <input type="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                </div>
                <button type="submit" class="btn-cta">
                    <span>Gửi mã OTP</span> <i class="fas fa-arrow-right"></i>
                </button>
            </form>
        </c:when>

        <%-- STEP 2: VERIFY OTP --%>
        <c:when test="${step == 'verifyOtp'}">
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="action" value="verifyOtp">
                <div class="fgrp">
                    <label>Mã OTP</label>
                    <div class="inp-wrap">
                        <i class="fas fa-key inp-icon"></i>
                        <input type="text" name="otp" placeholder="Nhập 6 số..." maxlength="6" pattern="\d{6}" required>
                    </div>
                </div>
                <button type="submit" class="btn-cta">
                    <span>Xác thực</span> <i class="fas fa-check"></i>
                </button>
            </form>
        </c:when>

        <%-- STEP 3: RESET PASSWORD --%>
        <c:when test="${step == 'resetPassword'}">
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="action" value="resetPassword">
                <div class="fgrp">
                    <label>Mật khẩu mới</label>
                    <div class="inp-wrap">
                        <i class="fas fa-lock inp-icon"></i>
                        <input type="password" name="newPassword" placeholder="Ít nhất 8 ký tự" required minlength="8">
                    </div>
                </div>
                <div class="fgrp">
                    <label>Xác nhận mật khẩu</label>
                    <div class="inp-wrap">
                        <i class="fas fa-lock inp-icon"></i>
                        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required minlength="8">
                    </div>
                </div>
                <button type="submit" class="btn-cta">
                    <span>Đổi mật khẩu</span> <i class="fas fa-save"></i>
                </button>
            </form>
        </c:when>
    </c:choose>

    <div class="switch-cta">
        <a href="${pageContext.request.contextPath}/auth">&larr; Quay lại Đăng nhập</a>
    </div>
</div>

<script>
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
</script>

</body>
</html>
