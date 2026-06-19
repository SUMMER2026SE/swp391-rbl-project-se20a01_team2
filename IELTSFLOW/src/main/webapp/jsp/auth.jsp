<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực - IELTSFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <script>
        window.CONTEXT_PATH = '${pageContext.request.contextPath}';
        window.GOOGLE_CLIENT_ID = '<%= System.getProperty("GOOGLE_CLIENT_ID") != null ? System.getProperty("GOOGLE_CLIENT_ID") : "" %>';
    </script>
    <script src="https://accounts.google.com/gsi/client" async defer onload="if(window.onGoogleLibraryLoad) window.onGoogleLibraryLoad();"></script>
    <style>
        :root { --grad-brand-dark: linear-gradient(135deg, #0f2027, #203a43, #2c5364); }
        body { margin: 0; padding: 0; font-family: 'Inter', sans-serif; background-color: #f9fafb; display: flex; min-height: 100vh; }
        .auth-container { display: flex; width: 100%; min-height: 100vh; }

        /* Left Panel */
        .auth-left { width: 45%; background: var(--grad-brand-dark); color: white; padding: 40px; display: flex; flex-direction: column; justify-content: space-between; position: relative; overflow: hidden; }
        .floating-shapes .shape { position: absolute; background: rgba(255,255,255,0.05); border-radius: 50%; animation: float 6s infinite ease-in-out; }
        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; }
        .shape-2 { width: 150px; height: 150px; bottom: 20%; right: -50px; animation-duration: 8s; }
        .shape-3 { width: 100px; height: 100px; top: 40%; left: 20%; animation-duration: 5s; border-radius: 20%; transform: rotate(45deg); }
        @keyframes float { 0% { transform: translateY(0px) rotate(0deg); } 50% { transform: translateY(-20px) rotate(10deg); } 100% { transform: translateY(0px) rotate(0deg); } }
        .auth-left-content { position: relative; z-index: 2; }
        .brand-logo { display: flex; align-items: center; gap: 12px; font-size: 24px; font-weight: 700; margin-bottom: 40px; text-decoration: none; color: white; }
        .brand-logo svg { width: 40px; height: 40px; }
        .hero-text h1 { font-size: 40px; margin: 0 0 16px 0; line-height: 1.2; }
        .hero-text p { font-size: 18px; color: rgba(255,255,255,0.8); margin: 0 0 40px 0; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 40px; }
        .stat-card { background: rgba(255,255,255,0.08); padding: 20px; text-align: center; border-radius: 12px; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); }
        .stat-val { font-size: 24px; font-weight: 700; margin-bottom: 4px; color: #ff9800; }
        .stat-label { font-size: 12px; color: rgba(255,255,255,0.7); }
        .features-list { list-style: none; padding: 0; margin: 0 0 40px 0; }
        .features-list li { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; font-size: 16px; color: rgba(255,255,255,0.9); }
        .testimonial { background: rgba(0,0,0,0.2); padding: 24px; border-radius: 16px; border-left: 4px solid #ff9800; }
        .testimonial p { font-style: italic; margin: 0 0 12px 0; line-height: 1.5; }
        .testimonial span { font-size: 14px; color: rgba(255,255,255,0.7); }

        /* Right Panel */
        .auth-right { width: 55%; display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 40px; position: relative; background: white; }
        .auth-form-wrapper { width: 100%; max-width: 440px; }
        .mobile-logo { display: none; text-align: center; margin-bottom: 32px; font-size: 24px; font-weight: 700; color: #1e293b; text-decoration: none; }

        /* Tab Switcher */
        .tab-switcher { display: flex; position: relative; background: #f1f5f9; border-radius: 12px; padding: 4px; margin-bottom: 32px; }
        .tab-btn { flex: 1; text-align: center; padding: 12px 24px; font-size: 16px; font-weight: 600; color: #64748b; cursor: pointer; border: none; background: none; z-index: 2; transition: color 0.3s ease; }
        .tab-btn.active { color: #0f172a; }
        .tab-slider { position: absolute; top: 4px; left: 4px; width: calc(50% - 4px); height: calc(100% - 8px); background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); z-index: 1; }

        /* Form Areas */
        .form-area { display: none; animation: fadeIn 0.4s ease forwards; }
        .form-area.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .btn-google { display: flex; align-items: center; justify-content: center; gap: 12px; width: 100%; padding: 12px; background: white; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 16px; font-weight: 500; color: #334155; cursor: pointer; transition: background 0.2s, box-shadow 0.2s; margin-bottom: 24px; }
        .btn-google:hover { background: #f8fafc; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .divider { display: flex; align-items: center; text-align: center; margin-bottom: 24px; color: #94a3b8; font-size: 14px; }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid #e2e8f0; }
        .divider::before { margin-right: 16px; }
        .divider::after { margin-left: 16px; }

        .form-group { margin-bottom: 20px; position: relative; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; font-size: 14px; color: #334155; }
        .input-wrapper { position: relative; }
        .input-wrapper input { width: 100%; padding: 12px 16px 12px 40px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none; transition: border-color 0.2s, box-shadow 0.2s; box-sizing: border-box; }
        .input-wrapper input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
        .input-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 18px; }
        .input-action { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; cursor: pointer; font-size: 18px; background: none; border: none; padding: 0; }

        .row-between { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 14px; }
        .checkbox-group { display: flex; align-items: center; gap: 8px; color: #475569; }
        .link { color: #2563eb; text-decoration: none; font-weight: 500; }
        .link:hover { text-decoration: underline; }
        .btn-cta { background-color: #f97316; color: white; border: none; padding: 14px; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; width: 100%; transition: background 0.2s, transform 0.1s; display: flex; justify-content: center; align-items: center; gap: 8px; }
        .btn-cta:hover { background-color: #ea580c; }
        .btn-cta:active { transform: scale(0.98); }
        .btn-full { width: 100%; }

        .strength-wrapper { margin-top: 8px; display: none; }
        .strength-bar { display: flex; gap: 4px; height: 4px; margin-bottom: 4px; }
        .strength-seg { flex: 1; background: #e2e8f0; border-radius: 2px; transition: background 0.3s; }
        .strength-seg.weak { background: #ef4444; }
        .strength-seg.medium { background: #f59e0b; }
        .strength-seg.strong { background: #10b981; }
        .strength-text { font-size: 12px; color: #64748b; }
        .terms-text { text-align: center; font-size: 13px; color: #64748b; margin-top: 24px; line-height: 1.5; }
        .error-text { color: #ef4444; font-size: 13px; margin-top: 6px; display: none; }

        .alert-error { color: #ef4444; background: #fee2e2; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 500; font-size: 14px; }
        .alert-success { color: #10b981; background: #d1fae5; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 500; font-size: 14px; }

        @media (max-width: 900px) {
            .auth-left { display: none; }
            .auth-right { width: 100%; padding: 24px; }
            .mobile-logo { display: block; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <!-- Left Panel -->
        <div class="auth-left">
            <div class="floating-shapes">
                <div class="shape shape-1"></div>
                <div class="shape shape-2"></div>
                <div class="shape shape-3"></div>
            </div>

            <div class="auth-left-content">
                <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo">
                    <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect width="40" height="40" rx="8" fill="#f97316"/>
                        <path d="M12 28V12H16V28H12ZM20 12H28V16H24V20H28V24H24V28H20V12Z" fill="white"/>
                    </svg>
                    IELTS Flow
                </a>

                <div class="hero-text">
                    <h1>Chinh ph&#7909;c IELTS c&#249;ng AI</h1>
                    <p>H&#224;nh tr&#236;nh &#273;&#7841;t band &#273;i&#7875;m m&#417; &#432;&#7899;c c&#7911;a b&#7841;n b&#7855;t &#273;&#7847;u t&#7915; &#273;&#226;y.</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-val">50K+</div>
                        <div class="stat-label">H&#7885;c vi&#234;n</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-val">7.2</div>
                        <div class="stat-label">Band TB</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-val">94%</div>
                        <div class="stat-label">&#272;&#7841;t m&#7909;c ti&#234;u</div>
                    </div>
                </div>

                <ul class="features-list">
                    <li>&#10024; L&#7897; tr&#236;nh h&#7885;c c&#225; nh&#226;n h&#243;a b&#7857;ng AI</li>
                    <li>&#128221; Ch&#7845;m &#273;i&#7875;m Writing/Speaking theo ti&#234;u chu&#7849;n IELTS</li>
                    <li>&#128200; Theo d&#245;i ti&#7871;n &#273;&#7897; h&#7885;c t&#7853;p chi ti&#7871;t</li>
                </ul>
            </div>

            <div class="testimonial auth-left-content">
                <p>"IELTSFlow &#273;&#227; gi&#250;p m&#236;nh t&#259;ng t&#7915; 5.5 l&#234;n 7.5 ch&#7881; trong 3 th&#225;ng. C&#244;ng c&#7909; ch&#7845;m Writing c&#7921;c k&#7923; chi ti&#7871;t v&#224; h&#7919;u &#237;ch!"</p>
                <span>&#8212; Nguy&#7877;n Tr&#7847;n Mai Anh, IELTS 7.5</span>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="auth-right">
            <div class="auth-form-wrapper">
                <a href="${pageContext.request.contextPath}/index.jsp" class="mobile-logo">IELTS Flow</a>

                <div class="tab-switcher">
                    <div class="tab-slider" id="tabSlider"></div>
                    <button class="tab-btn active" id="tabLoginBtn">&#272;&#259;ng nh&#7853;p</button>
                    <button class="tab-btn" id="tabRegisterBtn">&#272;&#259;ng k&#253;</button>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert-error">${error}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty param.successMessage}">
                    <div class="alert-success">${param.successMessage}</div>
                </c:if>
                <c:if test="${not empty param.redirect_error}">
                    <div class="alert-error">${param.redirect_error}</div>
                </c:if>

                <!-- Sign In Form -->
                <div class="form-area active" id="loginFormArea">
                    <div id="googleLoginBtn" style="display:flex; justify-content:center; margin-bottom: 24px; width: 100%;"></div>

                    <div class="divider">ho&#7863;c &#273;&#259;ng nh&#7853;p b&#7857;ng email</div>

                    <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="POST">
                        <input type="hidden" name="action" value="login">
                        <div class="form-group">
                            <label for="loginEmail">Email</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#9993;</span>
                                <input type="email" id="loginEmail" name="email" placeholder="you@example.com" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="loginPassword">M&#7853;t kh&#7849;u</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#128274;</span>
                                <input type="password" id="loginPassword" name="password" placeholder="Nh&#7853;p m&#7853;t kh&#7849;u" required>
                                <button type="button" class="input-action toggle-password">&#128065;</button>
                            </div>
                        </div>

                        <div class="row-between">
                            <label class="checkbox-group">
                                <input type="checkbox" id="rememberMe">
                                Ghi nh&#7899; &#273;&#259;ng nh&#7853;p
                            </label>
                            <a href="${pageContext.request.contextPath}/forgot-password" class="link text-sm" style="font-weight: 500;">Qu&#234;n m&#7853;t kh&#7849;u?</a>
                        </div>

                        <button type="submit" class="btn-cta btn-full">
                            <span>&#272;&#259;ng nh&#7853;p &rarr;</span>
                        </button>
                    </form>

                    <p class="terms-text">
                        B&#7857;ng vi&#7879;c &#273;&#259;ng nh&#7853;p, b&#7841;n &#273;&#7891;ng &#253; v&#7899;i
                        <a href="#" class="link">&#272;i&#7873;u kho&#7843;n</a> v&#224;
                        <a href="#" class="link">Ch&#237;nh s&#225;ch b&#7843;o m&#7853;t</a>.
                    </p>
                </div>

                <!-- Sign Up Form -->
                <div class="form-area" id="registerFormArea">
                    <div id="googleRegisterBtn" style="display:flex; justify-content:center; margin-bottom: 24px; width: 100%;"></div>

                    <div class="divider">ho&#7863;c &#273;&#259;ng k&#253; b&#7857;ng email</div>

                    <form id="registerForm" action="${pageContext.request.contextPath}/auth" method="POST">
                        <input type="hidden" name="action" value="register">
                        <div class="form-group">
                            <label for="regName">H&#7885; v&#224; t&#234;n</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#128100;</span>
                                <input type="text" id="regName" name="fullName" placeholder="Nguy&#7877;n V&#259;n A" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="regEmail">Email</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#9993;</span>
                                <input type="email" id="regEmail" name="email" placeholder="you@example.com" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="regPassword">M&#7853;t kh&#7849;u</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#128274;</span>
                                <input type="password" id="regPassword" name="password" placeholder="&#205;t nh&#7845;t 8 k&#253; t&#7921;" required>
                                <button type="button" class="input-action toggle-password">&#128065;</button>
                            </div>
                            <div class="strength-wrapper" id="strengthWrapper">
                                <div class="strength-bar">
                                    <div class="strength-seg" id="seg1"></div>
                                    <div class="strength-seg" id="seg2"></div>
                                    <div class="strength-seg" id="seg3"></div>
                                    <div class="strength-seg" id="seg4"></div>
                                </div>
                                <div class="strength-text" id="strengthText">&#272;&#7897; m&#7841;nh m&#7853;t kh&#7849;u</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="regConfirmPassword">X&#225;c nh&#7853;n m&#7853;t kh&#7849;u</label>
                            <div class="input-wrapper">
                                <span class="input-icon">&#128274;</span>
                                <input type="password" id="regConfirmPassword" name="confirmPassword" placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u" required>
                                <button type="button" class="input-action toggle-password">&#128065;</button>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 24px;">
                            <label class="checkbox-group">
                                <input type="checkbox" id="regTerms" required>
                                <span>T&#244;i &#273;&#7891;ng &#253; v&#7899;i c&#225;c <a href="#" class="link">&#272;i&#7873;u kho&#7843;n</a> v&#224; <a href="#" class="link">B&#7843;o m&#7853;t</a></span>
                            </label>
                        </div>

                        <button type="submit" class="btn-cta btn-full">
                            <span>T&#7841;o t&#224;i kho&#7843;n &rarr;</span>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/auth.js?v=3"></script>
    <script>
        // Tab switching with register tab support from server
        const tabLogin = document.getElementById('tabLoginBtn');
        const tabRegister = document.getElementById('tabRegisterBtn');
        const loginArea = document.getElementById('loginFormArea');
        const registerArea = document.getElementById('registerFormArea');
        const slider = document.getElementById('tabSlider');

        function switchToLogin() {
            tabLogin.classList.add('active');
            tabRegister.classList.remove('active');
            loginArea.classList.add('active');
            registerArea.classList.remove('active');
            slider.style.transform = 'translateX(0)';
        }
        function switchToRegister() {
            tabRegister.classList.add('active');
            tabLogin.classList.remove('active');
            registerArea.classList.add('active');
            loginArea.classList.remove('active');
            slider.style.transform = 'translateX(100%)';
        }

        tabLogin.addEventListener('click', switchToLogin);
        tabRegister.addEventListener('click', switchToRegister);

        // Auto-switch to register tab if server says so
        <c:if test="${tab == 'register'}">switchToRegister();</c:if>

        // Also check URL param
        if (new URLSearchParams(window.location.search).get('tab') === 'register') switchToRegister();
    </script>
</body>
</html>
