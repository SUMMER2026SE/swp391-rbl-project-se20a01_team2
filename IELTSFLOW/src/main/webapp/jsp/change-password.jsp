<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>&#272;&#7893;i m&#7853;t kh&#7849;u - IELTSFlow</title>
    <link rel="stylesheet" href="../css/design-system.css">
    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #f8fafc; }
        .page-wrapper { max-width: 480px; margin: 60px auto; padding: 0 20px; }
        .card {
            background: white; border-radius: 16px; padding: 36px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
        }
        .card-title { font-size: 1.5rem; font-weight: 700; color: #1e293b; margin: 0 0 8px; }
        .card-subtitle { color: #64748b; font-size: 14px; margin: 0 0 28px; }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
        .form-label span { color: #ef4444; }
        .form-input {
            width: 100%; padding: 11px 14px; border: 1.5px solid #e2e8f0;
            border-radius: 9px; font-size: 14px; font-family: inherit; box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus {
            outline: none; border-color: #f97316; box-shadow: 0 0 0 3px rgba(249,115,22,0.12);
        }
        .btn-submit {
            width: 100%; padding: 13px; background: #f97316; color: white;
            border: none; border-radius: 9px; font-size: 15px; font-weight: 600;
            cursor: pointer; transition: background 0.2s; margin-top: 8px;
        }
        .btn-submit:hover { background: #ea580c; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
        .alert-error { background: #fef2f2; border: 1px solid #fca5a5; color: #b91c1c; }
        .alert-success { background: #dcfce7; border: 1px solid #86efac; color: #15803d; }
        .back-link {
            display: block; text-align: center; margin-top: 18px;
            color: #64748b; font-size: 14px; text-decoration: none;
        }
        .back-link:hover { color: #f97316; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="card">
        <div class="card-title">&#128272; &#272;&#7893;i m&#7853;t kh&#7849;u</div>
        <div class="card-subtitle">Nh&#7853;p m&#7853;t kh&#7849;u hi&#7879;n t&#7841;i v&#224; m&#7853;t kh&#7849;u m&#7899;i &#273;&#7875; c&#7853;p nh&#7853;t b&#7843;o m&#7853;t t&#224;i kho&#7843;n.</div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">&#10060; ${error}</div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">&#9989; ${param.success}</div>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/change-password">
            <div class="form-group">
                <label class="form-label" for="currentPassword">
                    M&#7853;t kh&#7849;u hi&#7879;n t&#7841;i <span>*</span>
                </label>
                <input type="password" id="currentPassword" name="currentPassword"
                       class="form-input" placeholder="Nh&#7853;p m&#7853;t kh&#7849;u hi&#7879;n t&#7841;i" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="newPassword">
                    M&#7853;t kh&#7849;u m&#7899;i <span>*</span>
                </label>
                <input type="password" id="newPassword" name="newPassword"
                       class="form-input" placeholder="&#205;t nh&#7845;t 8 k&#253; t&#7921;" required minlength="8">
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">
                    X&#225;c nh&#7853;n m&#7853;t kh&#7849;u m&#7899;i <span>*</span>
                </label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       class="form-input" placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u m&#7899;i" required minlength="8">
            </div>

            <button type="submit" class="btn-submit">C&#7853;p nh&#7853;t m&#7853;t kh&#7849;u &rarr;</button>
        </form>

        <a href="${pageContext.request.contextPath}/account" class="back-link">&larr; Quay l&#7841;i t&#224;i kho&#7843;n</a>
    </div>
</div>

<script>
    // Ki&#7875;m tra kh&#7899;p m&#7853;t kh&#7849;u ph&#237;a client
    document.querySelector('form').addEventListener('submit', function(e) {
        const np = document.getElementById('newPassword').value;
        const cp = document.getElementById('confirmPassword').value;
        if (np !== cp) {
            e.preventDefault();
            alert('M&#7853;t kh&#7849;u m&#7899;i v&#224; x&#225;c nh&#7853;n kh&#244;ng kh&#7899;p!');
        }
    });
</script>
</body>
</html>
