<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi Hệ Thống - IELTSFlow</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; color: #333; text-align: center; padding: 50px; }
        .error-container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); max-width: 600px; margin: auto; }
        h1 { color: #dc3545; margin-bottom: 20px; }
        .error-msg { font-size: 18px; color: #6c757d; margin-bottom: 30px; word-wrap: break-word; }
        .btn-back { display: inline-block; padding: 10px 20px; background-color: #0d6efd; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .btn-back:hover { background-color: #0b5ed7; }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Opps! Đã xảy ra lỗi</h1>
        <p class="error-msg">${errorMsg}</p>
        <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn-back">Quay lại Trang chủ</a>
    </div>
</body>
</html>
