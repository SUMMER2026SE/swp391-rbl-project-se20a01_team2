<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực - IELTSFlow</title>
    <link rel="stylesheet" href="../css/design-system.css">
    <script src="https://accounts.google.com/gsi/client" async defer onload="if(window.onGoogleLibraryLoad) window.onGoogleLibraryLoad();"></script>
    <style>
        /* Specific styles for auth page */
        :root {
            --grad-brand-dark: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
        }
        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            display: flex;
            min-height: 100vh;
        }

        .auth-container {
            display: flex;
            width: 100%;
            height: 100vh;
        }

        /* Left Panel */
        .auth-left {
            width: 45%;
            background: var(--grad-brand-dark);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .floating-shapes .shape {
            position: absolute;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            animation: float 6s infinite ease-in-out;
        }
        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; }
        .shape-2 { width: 150px; height: 150px; bottom: 20%; right: -50px; animation-duration: 8s; }
        .shape-3 { width: 100px; height: 100px; top: 40%; left: 20%; animation-duration: 5s; border-radius: 20%; transform: rotate(45deg); }

        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
            100% { transform: translateY(0px) rotate(0deg); }
        }

        .auth-left-content {
            position: relative;
            z-index: 2;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 40px;
            text-decoration: none;
            color: white;
        }
        .brand-logo svg {
            width: 40px;
            height: 40px;
        }

        .hero-text h1 {
            font-size: 40px;
            margin: 0 0 16px 0;
            line-height: 1.2;
        }
        .hero-text p {
            font-size: 18px;
            color: rgba(255,255,255,0.8);
            margin: 0 0 40px 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: rgba(255,255,255,0.1);
            padding: 16px;
            border-radius: 12px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
        }
        .stat-val { font-size: 24px; font-weight: 700; margin-bottom: 4px; color: #ff9800; }
        .stat-label { font-size: 12px; color: rgba(255,255,255,0.7); }

        .features-list {
            list-style: none;
            padding: 0;
            margin: 0 0 40px 0;
        }
        .features-list li {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            font-size: 16px;
            color: rgba(255,255,255,0.9);
        }

        .testimonial {
            background: rgba(0,0,0,0.2);
            padding: 24px;
            border-radius: 16px;
            border-left: 4px solid #ff9800;
        }
        .testimonial p { font-style: italic; margin: 0 0 12px 0; line-height: 1.5; }
        .testimonial span { font-size: 14px; color: rgba(255,255,255,0.7); }

        /* Right Panel */
        .auth-right {
            width: 55%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            position: relative;
            background: white;
            overflow-y: auto;
        }

        .auth-form-wrapper {
            width: 100%;
            max-width: 440px;
        }

        .mobile-logo {
            display: none;
            text-align: center;
            margin-bottom: 32px;
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            text-decoration: none;
        }

        /* Tab Switcher */
        .tab-switcher {
            display: flex;
            position: relative;
            background: #f1f5f9;
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 32px;
        }
        .tab-btn {
            flex: 1;
            text-align: center;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            border: none;
            background: none;
            z-index: 2;
            transition: color 0.3s ease;
        }
        .tab-btn.active {
            color: #0f172a;
        }
        .tab-slider {
            position: absolute;
            top: 4px;
            left: 4px;
            width: calc(50% - 4px);
            height: calc(100% - 8px);
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1;
        }

        /* Form Areas */
        .form-area {
            display: none;
            animation: fadeIn 0.4s ease forwards;
        }
        .form-area.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .btn-google {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            width: 100%;
            padding: 12px;
            background: white;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            color: #334155;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
            margin-bottom: 24px;
        }
        .btn-google:hover {
            background: #f8fafc;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin-bottom: 24px;
            color: #94a3b8;
            font-size: 14px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }
        .divider::before { margin-right: 16px; }
        .divider::after { margin-left: 16px; }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            font-size: 14px;
            color: #334155;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper input {
            width: 100%;
            padding: 12px 16px 12px 40px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }
        .input-wrapper input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .input-wrapper input.error {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239,68,68,0.1);
        }
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 18px;
        }
        .input-action {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            cursor: pointer;
            font-size: 18px;
            background: none;
            border: none;
            padding: 0;
        }
        .error-text {
            color: #ef4444;
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }

        .row-between {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 14px;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #475569;
        }
        .link {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
        }
        .link:hover { text-decoration: underline; }

        .btn-cta {
            background-color: #f97316;
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: background 0.2s, transform 0.1s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }
        .btn-cta:hover { background-color: #ea580c; }
        .btn-cta:active { transform: scale(0.98); }
        .btn-cta:disabled {
            background-color: #fdba74;
            cursor: not-allowed;
            transform: none;
        }

        /* Password Strength */
        .strength-wrapper {
            margin-top: 8px;
            display: none;
        }
        .strength-bar {
            display: flex;
            gap: 4px;
            height: 4px;
            margin-bottom: 4px;
        }
        .strength-seg {
            flex: 1;
            background: #e2e8f0;
            border-radius: 2px;
            transition: background 0.3s;
        }
        .strength-text {
            font-size: 12px;
            color: #64748b;
        }

        .terms-text {
            text-align: center;
            font-size: 13px;
            color: #64748b;
            margin-top: 24px;
            line-height: 1.5;
        }

        /* Toast */
        #toast-container {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 1000;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .toast {
            padding: 16px 20px;
            border-radius: 8px;
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 300px;
            animation: slideIn 0.3s ease forwards;
            font-size: 14px;
            font-weight: 500;
            color: #1e293b;
            border-left: 4px solid transparent;
        }
        .toast.success { border-left-color: #22c55e; }
        .toast.error { border-left-color: #ef4444; }
        .toast.warning { border-left-color: #f59e0b; }
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
        
        .spinner {
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: white;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* Google Sign-In Button Wrapper */
        .btn-google-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            margin-bottom: 24px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            transition: box-shadow 0.2s;
            min-height: 44px;
        }
        .btn-google-wrapper:hover {
            box-shadow: 0 1px 4px rgba(0,0,0,0.12);
            border-color: #94a3b8;
        }
        /* Force Google button iframe to be full width */
        .btn-google-wrapper > div {
            width: 100% !important;
        }
        .btn-google-wrapper iframe {
            width: 100% !important;
        }
        /* Loading state */
        .g-btn-loading {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 11px;
            font-size: 15px;
            color: #475569;
        }
        .g-btn-loading svg { flex-shrink: 0; }
        @media (max-width: 900px) {
            .auth-left { display: none; }
            .auth-right { width: 100%; padding: 24px; }
            .mobile-logo { display: block; }
        }
    </style>
</head>
<body>
    <div id="toast-container"></div>
    <div class="auth-container">
        <!-- Left Panel -->
        <div class="auth-left">
            <div class="floating-shapes">
                <div class="shape shape-1"></div>
                <div class="shape shape-2"></div>
                <div class="shape shape-3"></div>
            </div>
            
            <div class="auth-left-content">
                <a href="../index.html" class="brand-logo">
                    <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect width="40" height="40" rx="8" fill="#f97316"/>
                        <path d="M12 28V12H16V28H12ZM20 12H28V16H24V20H28V24H24V28H20V12Z" fill="white"/>
                    </svg>
                    IELTS Flow
                </a>
                
                <div class="hero-text">
                    <h1>Chinh phục IELTS cùng AI</h1>
                    <p>Hành trình đạt band điểm mơ ước của bạn bắt đầu từ đây.</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-val">50K+</div>
                        <div class="stat-label">Học viên</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-val">7.2</div>
                        <div class="stat-label">Band TB</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-val">94%</div>
                        <div class="stat-label">Đạt mục tiêu</div>
                    </div>
                </div>

                <ul class="features-list">
                    <li>✨ Lộ trình học cá nhân hóa bằng AI</li>
                    <li>📝 Chấm điểm Writing/Speaking theo tiêu chuẩn IELTS</li>
                    <li>📈 Theo dõi tiến độ học tập chi tiết</li>
                </ul>
            </div>

            <div class="testimonial auth-left-content">
                <p>"IELTSFlow đã giúp mình tăng từ 5.5 lên 7.5 chỉ trong 3 tháng. Công cụ chấm Writing cực kỳ chi tiết và hữu ích!"</p>
                <span>— Nguyễn Trần Mai Anh, IELTS 7.5</span>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="auth-right">
            <div class="auth-form-wrapper">
                <a href="../index.html" class="mobile-logo">IELTS Flow</a>
                
                <div class="tab-switcher">
                    <div class="tab-slider" id="tabSlider"></div>
                    <button class="tab-btn active" id="tabLoginBtn">Đăng nhập</button>
                    <button class="tab-btn" id="tabRegisterBtn">Đăng ký</button>
                </div>

                <!-- Sign In Form -->
                <div class="form-area active" id="loginFormArea">
                    <button type="button" class="btn-google" id="googleLoginBtn" onclick="triggerGoogleLogin()">
                        <svg width="20" height="20" viewBox="0 0 24 24">
                            <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                            <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                            <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                            <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                        </svg>
                        Tiếp tục với Google
                    </button>

                    <div class="divider">hoặc đăng nhập bằng email</div>

                    <form id="loginForm">
                        <div class="form-group">
                            <label for="loginEmail">Email</label>
                            <div class="input-wrapper">
                                <span class="input-icon">📧</span>
                                <input type="email" id="loginEmail" placeholder="you@example.com" required>
                            </div>
                            <div class="error-text" id="loginEmailErr"></div>
                        </div>

                        <div class="form-group">
                            <label for="loginPassword">Mật khẩu</label>
                            <div class="input-wrapper">
                                <span class="input-icon">🔒</span>
                                <input type="password" id="loginPassword" placeholder="••••••••" required>
                                <button type="button" class="input-action toggle-password">👁️</button>
                            </div>
                            <div class="error-text" id="loginPasswordErr"></div>
                        </div>

                        <div class="row-between">
                            <label class="checkbox-group">
                                <input type="checkbox" id="rememberMe">
                                Ghi nhớ đăng nhập
                            </label>
                            <a href="forgot-password.jsp" class="link">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn-cta btn-full" id="loginSubmit">
                            <span class="btn-text">Đăng nhập &rarr;</span>
                        </button>
                    </form>

                    <p class="terms-text">
                        Bằng việc đăng nhập, bạn đồng ý với <a href="#" class="link">Điều khoản dịch vụ</a> và <a href="#" class="link">Chính sách bảo mật</a> của chúng tôi.
                    </p>
                </div>

                <!-- Sign Up Form -->
                <div class="form-area" id="registerFormArea">
                    <button type="button" class="btn-google" id="googleRegisterBtn" onclick="triggerGoogleLogin()">
                        <svg width="20" height="20" viewBox="0 0 24 24">
                            <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                            <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                            <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                            <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                        </svg>
                        Tiếp tục với Google
                    </button>

                    <div class="divider">hoặc đăng ký bằng email</div>

                    <form id="registerForm">
                        <div class="form-group">
                            <label for="regName">Họ và tên</label>
                            <div class="input-wrapper">
                                <span class="input-icon">👤</span>
                                <input type="text" id="regName" placeholder="Nguyễn Văn A" required>
                            </div>
                            <div class="error-text" id="regNameErr"></div>
                        </div>

                        <div class="form-group">
                            <label for="regEmail">Email</label>
                            <div class="input-wrapper">
                                <span class="input-icon">📧</span>
                                <input type="email" id="regEmail" placeholder="you@example.com" required>
                            </div>
                            <div class="error-text" id="regEmailErr"></div>
                        </div>

                        <div class="form-group">
                            <label for="regPassword">Mật khẩu</label>
                            <div class="input-wrapper">
                                <span class="input-icon">🔒</span>
                                <input type="password" id="regPassword" placeholder="Ít nhất 8 ký tự" required>
                                <button type="button" class="input-action toggle-password">👁️</button>
                            </div>
                            <div class="strength-wrapper" id="strengthWrapper">
                                <div class="strength-bar">
                                    <div class="strength-seg" id="seg1"></div>
                                    <div class="strength-seg" id="seg2"></div>
                                    <div class="strength-seg" id="seg3"></div>
                                    <div class="strength-seg" id="seg4"></div>
                                </div>
                                <div class="strength-text" id="strengthText">Độ mạnh mật khẩu</div>
                            </div>
                            <div class="error-text" id="regPasswordErr"></div>
                        </div>

                        <div class="form-group">
                            <label for="regConfirmPassword">Xác nhận mật khẩu</label>
                            <div class="input-wrapper">
                                <span class="input-icon">🔒</span>
                                <input type="password" id="regConfirmPassword" placeholder="Nhập lại mật khẩu" required>
                                <button type="button" class="input-action toggle-password">👁️</button>
                            </div>
                            <div class="error-text" id="regConfirmPasswordErr"></div>
                        </div>

                        <div class="form-group" style="margin-bottom: 24px;">
                            <label class="checkbox-group">
                                <input type="checkbox" id="regTerms" required>
                                <span>Tôi đồng ý với các <a href="#" class="link">Điều khoản</a> và <a href="#" class="link">Bảo mật</a></span>
                            </label>
                            <div class="error-text" id="regTermsErr"></div>
                        </div>

                        <button type="submit" class="btn-cta btn-full" id="registerSubmit">
                            <span class="btn-text">Tạo tài khoản &rarr;</span>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Google Identity init is handled by auth.js -->
    <script src="../js/auth.js"></script>
</body>
</html>
