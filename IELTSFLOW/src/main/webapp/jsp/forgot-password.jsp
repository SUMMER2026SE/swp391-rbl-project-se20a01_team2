<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - IELTSFlow</title>
    <!-- Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--color-bg);
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        .auth-container {
            width: 100%;
            max-width: 460px;
            padding: 24px;
        }

        .auth-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            padding: 40px;
        }

        .logo {
            text-align: center;
            font-size: 24px;
            font-weight: 800;
            color: var(--color-primary-600);
            text-decoration: none;
            display: block;
            margin-bottom: 24px;
        }

        h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 8px;
            font-size: 20px;
            color: var(--color-text);
        }

        p.subtitle {
            text-align: center;
            color: var(--color-text-secondary);
            font-size: 14px;
            margin-bottom: 24px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--color-text-secondary);
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid var(--color-border);
            border-radius: 10px;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--color-primary-500);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background: var(--grad-primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .btn-submit:hover {
            opacity: 0.9;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 24px;
            color: var(--color-text-secondary);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        .back-link:hover {
            color: var(--color-primary-600);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 24px;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fca5a5;
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #15803d;
            border: 1px solid #86efac;
        }
    </style>
</head>
<body>

<div class="auth-container">
    <div class="auth-card">
        <a href="${pageContext.request.contextPath}/" class="logo">IELTS Flow</a>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <c:choose>
            <%-- STEP 1: SEND OTP --%>
            <c:when test="${empty step || step == 'sendOtp'}">
                <h2>Khôi phục mật khẩu</h2>
                <p class="subtitle">Nhập email của bạn và chúng tôi sẽ gửi mã OTP gồm 6 chữ số để đặt lại mật khẩu.</p>
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <input type="hidden" name="action" value="sendOtp">
                    <div class="form-group">
                        <label>Địa chỉ Email</label>
                        <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
                    </div>
                    <button type="submit" class="btn-submit">Gửi mã OTP</button>
                </form>
            </c:when>

            <%-- STEP 2: VERIFY OTP --%>
            <c:when test="${step == 'verifyOtp'}">
                <h2>Xác thực OTP</h2>
                <p class="subtitle">Vui lòng kiểm tra hòm thư của <b>${sessionScope.resetEmail}</b> và nhập mã 6 số bạn nhận được.</p>
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <input type="hidden" name="action" value="verifyOtp">
                    <div class="form-group">
                        <label>Mã OTP</label>
                        <input type="text" name="otp" class="form-control" placeholder="Nhập 6 số..." maxlength="6" pattern="\d{6}" required>
                    </div>
                    <button type="submit" class="btn-submit">Xác thực</button>
                </form>
            </c:when>

            <%-- STEP 3: RESET PASSWORD --%>
            <c:when test="${step == 'resetPassword'}">
                <h2>Đặt mật khẩu mới</h2>
                <p class="subtitle">Tạo mật khẩu mới cho tài khoản của bạn. Mật khẩu nên có ít nhất 8 ký tự.</p>
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <input type="hidden" name="action" value="resetPassword">
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control" placeholder="Ít nhất 8 ký tự" required minlength="8">
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required minlength="8">
                    </div>
                    <button type="submit" class="btn-submit">Đổi mật khẩu</button>
                </form>
            </c:when>
        </c:choose>

        <a href="${pageContext.request.contextPath}/jsp/auth.jsp" class="back-link">&larr; Quay lại Đăng nhập</a>
    </div>
</div>

</body>
</html>
