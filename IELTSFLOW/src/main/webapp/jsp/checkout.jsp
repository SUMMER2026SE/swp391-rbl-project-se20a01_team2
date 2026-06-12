<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>IELTSFlow - Thanh Toán</title>
        <!-- Font -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <!-- Design System CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">

        <style>
            :root {
                --color-bg: #F8FAFC;
                --grad-cta: linear-gradient(135deg, #F97316 0%, #EA580C 100%);
                --color-primary-text: #1E293B;
                --color-secondary-text: #475569;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--color-bg);
                color: var(--color-primary-text);
                margin: 0;
                padding: 0;
                line-height: 1.6;
            }

            .container {
                width: 100%;
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 24px;
                box-sizing: border-box;
            }

            /* Navbar */
            .navbar {
                background: rgba(255, 255, 255, 0.97);
                backdrop-filter: blur(16px);
                -webkit-backdrop-filter: blur(16px);
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.07);
                padding: 12px 0;
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .navbar-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-size: 24px;
                font-weight: 800;
                color: var(--color-primary-text);
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .logo-icon {
                background: var(--grad-cta);
                color: white;
                width: 36px;
                height: 36px;
                display: flex;
                justify-content: center;
                align-items: center;
                border-radius: 8px;
                font-size: 16px;
            }

            .nav-links {
                display: flex;
                gap: 32px;
                align-items: center;
            }

            .nav-link {
                text-decoration: none;
                color: var(--color-secondary-text);
                font-weight: 500;
                transition: color 0.2s;
            }

            .nav-link:hover, .nav-link.active {
                color: var(--color-primary-text);
            }

            .nav-actions {
                display: flex;
                gap: 16px;
                align-items: center;
            }

            .btn-cta {
                background: var(--grad-cta);
                color: white;
                border: none;
                padding: 10px 24px;
                border-radius: 999px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                box-shadow: 0 4px 14px 0 rgba(234, 88, 12, 0.39);
                transition: all 0.2s ease;
                display: inline-block;
                text-align: center;
            }

            .btn-cta:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(234, 88, 12, 0.4);
            }

            .checkout-section {
                padding: 40px 0 80px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            
            .checkout-header {
                width: 100%;
                max-width: 900px;
                background: white;
                padding: 20px;
                text-align: center;
                border: 1px solid #E2E8F0;
                border-radius: 8px 8px 0 0;
                font-size: 18px;
                color: var(--color-secondary-text);
            }

            .checkout-container {
                display: flex;
                flex-direction: row;
                width: 100%;
                max-width: 900px;
                background: white;
                border: 1px solid #E2E8F0;
                border-top: none;
                border-radius: 0 0 8px 8px;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            }

            .checkout-col {
                flex: 1;
                padding: 32px;
                display: flex;
                flex-direction: column;
            }

            .checkout-col-left {
                border-right: 1px solid #E2E8F0;
                align-items: center;
            }
            
            .checkout-col-right {
                align-items: center;
            }

            .col-title {
                font-size: 16px;
                font-weight: 700;
                margin-bottom: 24px;
                text-align: center;
            }

            .qr-image {
                max-width: 300px;
                width: 100%;
                height: auto;
                border-radius: 8px;
                margin-bottom: 16px;
            }
            
            .btn-download {
                background: white;
                color: #3B82F6;
                border: 1px solid #3B82F6;
                padding: 8px 16px;
                border-radius: 4px;
                font-size: 14px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 24px;
            }
            
            .btn-download:hover {
                background: #EFF6FF;
            }

            .status-box {
                font-size: 14px;
                color: var(--color-secondary-text);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
            .spinner {
                width: 16px;
                height: 16px;
                border: 2px solid #E2E8F0;
                border-top-color: #3B82F6;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }
            
            @keyframes spin {
                to { transform: rotate(360deg); }
            }

            .bank-info {
                width: 100%;
                max-width: 400px;
            }
            
            .bank-logo-area {
                text-align: center;
                margin-bottom: 24px;
            }
            
            .bank-logo-area img {
                height: 40px;
                margin-bottom: 8px;
            }
            
            .bank-name {
                font-weight: 700;
                font-size: 16px;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 12px 0;
                border-bottom: 1px solid #E2E8F0;
                font-size: 15px;
            }

            .info-label {
                color: var(--color-secondary-text);
            }
            
            .info-value {
                font-weight: 700;
            }

            .note-box {
                background: #F8FAFC;
                padding: 16px;
                border-radius: 4px;
                font-size: 14px;
                color: var(--color-secondary-text);
                margin-top: 24px;
                line-height: 1.5;
            }

            .countdown-timer {
                font-size: 18px;
                font-weight: 700;
                color: #EF4444;
                margin-top: 16px;
                text-align: center;
            }

            @media (max-width: 768px) {
                .checkout-container {
                    flex-direction: column;
                }
                .checkout-col-left {
                    border-right: none;
                    border-bottom: 1px solid #E2E8F0;
                }
            }

            /* Footer */
            .footer {
                background: white;
                padding: 64px 0 32px;
                border-top: 1px solid #E2E8F0;
            }

            .footer-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 32px;
            }

            .footer-links {
                display: flex;
                gap: 24px;
            }

            .footer-links a {
                color: var(--color-secondary-text);
                text-decoration: none;
                font-weight: 500;
                transition: color 0.2s;
            }

            .footer-links a:hover {
                color: var(--color-primary-text);
            }

            .copyright {
                text-align: center;
                color: #94A3B8;
                font-size: 14px;
                padding-top: 32px;
                border-top: 1px solid #E2E8F0;
            }

            .status-btn {
                background: #3B82F6;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
                width: 100%;
            }

            .status-btn:hover {
                background: #2563EB;
            }
        </style>
    </head>
    <body>

        <!-- Navbar -->
        <nav class="navbar">
            <div class="container navbar-content">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <span class="logo-icon">IF</span>
                    IELTS Flow
                </a>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/#features" class="nav-link">Tính năng</a>
                    <a href="${pageContext.request.contextPath}/#pricing" class="nav-link">Bảng giá</a>
                    <a href="${pageContext.request.contextPath}/subscription" class="nav-link">Gói Đăng Ký</a>
                    <a href="${pageContext.request.contextPath}/#testimonials" class="nav-link">Đánh giá</a>
                </div>
                <div class="nav-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.fullName}">
                            <div style="display: flex; align-items: center; gap: 12px; font-weight: 500;">
                                <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                    <span style="color: var(--color-primary-text); font-size: 14px; line-height: 1.2;">${sessionScope.fullName}</span>
                                    <span style="color: var(--color-secondary-text); font-size: 12px;">${sessionScope.userEmail}</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/account" class="btn-cta" style="padding: 8px 20px; font-size: 14px;">Hồ sơ</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/jsp/auth.jsp" class="btn-ghost">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/jsp/auth.jsp?tab=register" class="btn-cta">Bắt đầu miễn phí</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <section class="checkout-section">
            <div class="container" style="display: flex; flex-direction: column; align-items: center;">
                
                <div class="checkout-header" id="checkoutHeader">
                    Hướng dẫn thanh toán qua chuyển khoản ngân hàng
                </div>
                
                <div class="order-summary" id="orderSummary" style="width: 100%; max-width: 900px; background: white; padding: 24px 32px; border-left: 1px solid #E2E8F0; border-right: 1px solid #E2E8F0; text-align: left; box-sizing: border-box; border-bottom: 1px solid #E2E8F0;">
                    <div style="font-weight: 700; margin-bottom: 16px; font-size: 18px;">Thông tin đơn hàng</div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px;">
                        <span style="color: var(--color-secondary-text);">Mã đơn hàng</span>
                        <span style="font-weight: 600;">IF<c:out value="${String.format('%02d', transaction.transactionId)}"/></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px;">
                        <span style="color: var(--color-secondary-text);">Gói đăng ký</span>
                        <span style="font-weight: 600;">${pkg.name}</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding-top: 12px; border-top: 1px dashed #CBD5E1; font-weight: 700; font-size: 18px;">
                        <span style="color: var(--color-secondary-text);">Tổng thanh toán</span>
                        <span style="color: var(--color-primary-text);">${pkg.price} VND</span>
                    </div>
                </div>
                
                <div class="checkout-container" id="checkoutCard">
                    <!-- Cột Trái -->
                    <div class="checkout-col checkout-col-left">
                        <div class="col-title">Cách 1: Mở app ngân hàng và quét mã QR</div>
                        
                        <!-- Logo SePay / VietQR -->
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px; color: #1E3A8A; font-weight: 700; font-size: 24px;">
                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="currentColor"/>
                                <path d="M2 17L12 22L22 17M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            SePay
                        </div>
                        
                        <img src="${qrUrl}" alt="VietQR" class="qr-image" />
                        
                        <a href="${qrUrl}" download="VietQR_IF<c:out value="${String.format('%02d', transaction.transactionId)}"/>.png" target="_blank" class="btn-download">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                            Tải ảnh QR
                        </a>
                        
                        <div class="status-box">
                            Trạng thái: Chờ thanh toán... <div class="spinner"></div>
                        </div>
                        
                        <div class="countdown-timer" id="timer">15:00</div>
                    </div>
                    
                    <!-- Cột Phải -->
                    <div class="checkout-col checkout-col-right">
                        <div class="col-title">Cách 2: Chuyển khoản thủ công theo thông tin</div>
                        
                        <div class="bank-info">
                            <div class="bank-logo-area">
                                <div class="bank-name">Ngân hàng ${bankName}</div>
                            </div>
                            
                            <div class="info-row">
                                <span class="info-label">Chủ tài khoản:</span>
                                <span class="info-value">${bankAccountName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số TK:</span>
                                <span class="info-value">${bankAcc}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số tiền:</span>
                                <span class="info-value">${pkg.price}đ</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Nội dung CK:</span>
                                <span class="info-value">TKPSIF IF<c:out value="${String.format('%02d', transaction.transactionId)}"/></span>
                            </div>
                            
                            <div class="note-box">
                                Lưu ý: Vui lòng giữ nguyên nội dung chuyển khoản TKPSIF IF<c:out value="${String.format('%02d', transaction.transactionId)}"/> để hệ thống tự động xác nhận thanh toán
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="checkout-card" id="timeoutCard" style="display: none; background: white; padding: 40px; border-radius: 24px; border: 2px solid #E2E8F0; text-align: center; margin-top: 40px;">
                    <h1 class="checkout-title" style="color: #EF4444; font-size: 28px; font-weight: 800; margin-bottom: 16px;">Giao Dịch Đã Hết Hạn</h1>
                    <p class="checkout-subtitle" style="color: var(--color-secondary-text); margin-bottom: 32px;">Mã QR này không còn hiệu lực.</p>
                    <a href="${pageContext.request.contextPath}/subscription" class="btn-cta">Quay Lại Chọn Gói</a>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <a href="${pageContext.request.contextPath}/" class="logo">
                        <span class="logo-icon">IF</span>
                        IELTS Flow
                    </a>
                    <div class="footer-links">
                        <a href="#">Blog</a>
                        <a href="#">Điều khoản</a>
                        <a href="#">Bảo mật</a>
                        <a href="#">Liên hệ</a>
                    </div>
                </div>
                <div class="copyright">
                    &copy; 2025 IELTS Flow. All rights reserved.
                </div>
            </div>
        </footer>

        <script>
            let timeleft = 15 * 60; // 15 minutes
            let timerElement = document.getElementById('timer');
            
            let downloadTimer = setInterval(function(){
                if(timeleft <= 0){
                    clearInterval(downloadTimer);
                    document.getElementById("checkoutHeader").style.display = "none";
                    document.getElementById("orderSummary").style.display = "none";
                    document.getElementById("checkoutCard").style.display = "none";
                    document.getElementById("timeoutCard").style.display = "block";
                } else {
                    let minutes = Math.floor(timeleft / 60);
                    let seconds = timeleft % 60;
                    timerElement.innerHTML = (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                }
                timeleft -= 1;
            }, 1000);
            
            // Poll for transaction status every 3 seconds
            let pollInterval = setInterval(function() {
                fetch('${pageContext.request.contextPath}/api/transaction/status?id=${transaction.transactionId}')
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'Success') {
                            clearInterval(pollInterval);
                            clearInterval(downloadTimer);
                            alert("Thanh toán thành công! Hệ thống đang chuyển hướng...");
                            window.location.href = "${pageContext.request.contextPath}/account";
                        } else if (data.status === 'Failed' || data.status === 'Failed/Cancelled') {
                            clearInterval(pollInterval);
                            clearInterval(downloadTimer);
                            alert("Giao dịch đã thất bại hoặc bị hủy.");
                            window.location.href = "${pageContext.request.contextPath}/subscription";
                        }
                    })
                    .catch(err => console.error('Polling error:', err));
            }, 3000);

            function checkStatus() {
                // In a real scenario, this would make an AJAX request to check the transaction status.
                // For simplicity, we just redirect to the account page if the user clicked it, or they can refresh.
                // The webhook updates the database in the background.
                alert("Hệ thống đang kiểm tra trạng thái thanh toán của bạn. Vui lòng kiểm tra mục thông báo hoặc hồ sơ.");
                window.location.href = "${pageContext.request.contextPath}/account";
            }
        </script>
    </body>
</html>
