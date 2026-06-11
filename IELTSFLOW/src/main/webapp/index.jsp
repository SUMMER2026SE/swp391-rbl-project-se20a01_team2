<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IELTS Flow - Nền tảng luyện thi IELTS bằng AI</title>
    <!-- Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Design System CSS -->
    <link rel="stylesheet" href="css/design-system.css">
    
    <style>
        /* Page-specific styles */
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
            overflow-x: hidden;
        }

        /* Utility classes */
        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            box-sizing: border-box;
        }

        .scroll-reveal {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .scroll-reveal.revealed {
            opacity: 1;
            transform: translateY(0);
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            padding: 16px 0;
            z-index: 1000;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            box-shadow: 0 1px 0 rgba(0,0,0,0.06);
        }

        .navbar.scrolled {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.07);
            padding: 12px 0;
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

        .nav-link:hover {
            color: var(--color-primary-text);
        }

        .nav-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .btn-ghost {
            background: transparent;
            border: none;
            color: var(--color-primary-text);
            font-weight: 600;
            cursor: pointer;
            padding: 10px 20px;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .btn-ghost:hover {
            color: #EA580C;
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
        }

        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(234, 88, 12, 0.4);
        }

        .hamburger {
            display: none;
            flex-direction: column;
            gap: 5px;
            background: none;
            border: none;
            cursor: pointer;
        }

        .hamburger span {
            width: 24px;
            height: 2px;
            background-color: var(--color-primary-text);
            transition: 0.3s;
        }

        /* Hero Section */
        .hero {
            padding: 160px 0 100px;
            position: relative;
            background: radial-gradient(circle at top left, rgba(224,242,254,0.5), transparent 40%),
                        radial-gradient(circle at bottom right, rgba(204,251,241,0.5), transparent 40%);
        }

        .hero-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 48px;
        }

        .hero-text {
            flex: 1;
            max-width: 600px;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            background: rgba(234, 88, 12, 0.1);
            color: #EA580C;
            border-radius: 999px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 24px;
        }

        .hero-title {
            font-size: 56px;
            font-weight: 800;
            line-height: 1.1;
            margin: 0 0 24px;
            letter-spacing: -0.02em;
        }

        .hero-subtitle {
            font-size: 20px;
            color: var(--color-secondary-text);
            margin: 0 0 40px;
        }

        .hero-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .hero-visual {
            flex: 1;
            position: relative;
            height: 400px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .shape {
            position: absolute;
            border-radius: 24px;
            animation: float 6s ease-in-out infinite;
        }

        .shape-1 {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, #38BDF8, #0EA5E9);
            top: 20%;
            left: 20%;
            border-radius: 50%;
            filter: blur(20px);
            opacity: 0.6;
            animation-delay: 0s;
        }

        .shape-2 {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, #34D399, #10B981);
            bottom: 10%;
            right: 20%;
            border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
            filter: blur(20px);
            opacity: 0.6;
            animation-delay: -2s;
        }

        .shape-3 {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #F472B6, #EC4899);
            top: 40%;
            right: 10%;
            transform: rotate(45deg);
            filter: blur(15px);
            opacity: 0.5;
            animation-delay: -4s;
        }

        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
            100% { transform: translateY(0) rotate(0deg); }
        }

        .stats-bar {
            display: flex;
            justify-content: space-between;
            margin-top: 80px;
            padding: 32px;
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 800;
            color: var(--color-primary-text);
            margin-bottom: 4px;
        }

        .stat-label {
            color: var(--color-secondary-text);
            font-size: 14px;
            font-weight: 500;
        }

        /* Features Section */
        .features {
            padding: 100px 0;
            text-align: center;
        }

        .section-label {
            display: inline-block;
            font-size: 14px;
            font-weight: 600;
            color: #4F46E5;
            background: rgba(79, 70, 229, 0.1);
            padding: 6px 16px;
            border-radius: 999px;
            margin-bottom: 16px;
        }

        .section-title {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 64px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 32px;
            text-align: left;
        }

        .card {
            background: white;
            padding: 40px;
            border-radius: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
            box-sizing: border-box;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }

        .card-icon {
            font-size: 40px;
            margin-bottom: 24px;
            display: inline-block;
        }

        .card-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 16px;
        }

        .card-desc {
            color: var(--color-secondary-text);
            margin: 0 0 24px;
        }

        .chip-badge {
            display: inline-block;
            padding: 4px 12px;
            background: #F1F5F9;
            color: #64748B;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        /* Pricing */
        .pricing {
            padding: 100px 0;
            text-align: center;
        }

        .pricing-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 32px;
            max-width: 900px;
            margin: 0 auto;
            text-align: left;
        }

        .pricing-card {
            background: white;
            padding: 48px;
            border-radius: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            border: 2px solid transparent;
            position: relative;
            box-sizing: border-box;
        }

        .pricing-card.free {
            border-color: #E2E8F0;
        }

        .pricing-card.pro {
            border-color: #EA580C;
            box-shadow: 0 20px 40px rgba(234, 88, 12, 0.1);
        }

        .pro-badge {
            position: absolute;
            top: -12px;
            right: 32px;
            background: var(--grad-cta);
            color: white;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        .pricing-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 8px;
        }

        .pricing-price {
            font-size: 48px;
            font-weight: 800;
            margin: 0 0 8px;
        }
        
        .pricing-price span {
            font-size: 16px;
            color: var(--color-secondary-text);
            font-weight: 500;
        }

        .pricing-features {
            list-style: none;
            padding: 0;
            margin: 32px 0;
        }

        .pricing-features li {
            padding: 12px 0;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .pricing-features li.disabled {
            color: #94A3B8;
            text-decoration: line-through;
        }

        .pricing-features li::before {
            content: "✓";
            color: #10B981;
            font-weight: bold;
        }
        
        .pricing-features li.disabled::before {
            content: "✕";
            color: #94A3B8;
        }

        .btn-full {
            width: 100%;
            display: block;
            text-align: center;
            box-sizing: border-box;
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid #E2E8F0;
            color: var(--color-primary-text);
            padding: 10px 24px;
            border-radius: 999px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-block;
        }
        
        .btn-outline:hover {
            border-color: var(--color-primary-text);
        }

        /* Testimonials */
        .testimonials {
            padding: 100px 0;
            text-align: center;
            background: white;
        }

        .carousel-container {
            position: relative;
            max-width: 800px;
            margin: 0 auto;
            overflow: hidden;
            padding: 40px 20px;
        }

        .carousel-track {
            display: flex;
            transition: transform 0.5s ease-in-out;
        }

        .testimonial-slide {
            min-width: 100%;
            padding: 0 20px;
            box-sizing: border-box;
        }

        .testimonial-card {
            background: var(--color-bg);
            padding: 40px;
            border-radius: 24px;
            text-align: left;
        }

        .testimonial-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .avatar {
            width: 48px;
            height: 48px;
            background: #4F46E5;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
        }

        .user-name {
            font-weight: 700;
            font-size: 18px;
            margin: 0;
        }

        .score-improvement {
            color: #10B981;
            font-weight: 600;
            font-size: 14px;
            margin: 0;
        }

        .stars {
            color: #FBBF24;
            letter-spacing: 2px;
        }

        .quote {
            font-size: 18px;
            line-height: 1.8;
            color: var(--color-secondary-text);
            font-style: italic;
            margin: 0;
        }

        .carousel-dots {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 32px;
        }

        .dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #CBD5E1;
            cursor: pointer;
            transition: all 0.3s;
        }

        .dot.active {
            background: var(--grad-cta);
            width: 24px;
            border-radius: 5px;
        }

        /* Bottom CTA */
        .bottom-cta {
            padding: 100px 0;
            background: linear-gradient(135deg, #1E1B4B 0%, #312E81 100%);
            color: white;
            text-align: center;
        }

        .bottom-cta .section-title {
            margin-bottom: 24px;
            color: white;
        }

        .bottom-cta .hero-subtitle {
            color: #A5B4FC;
            margin-bottom: 40px;
        }
        
        .btn-white {
            background: white;
            color: #1E1B4B;
            padding: 12px 32px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 18px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s;
        }
        
        .btn-white:hover {
            transform: translateY(-2px);
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

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .hero-content {
                flex-direction: column;
                text-align: center;
            }
            .hero-actions {
                justify-content: center;
            }
            .stats-bar {
                flex-direction: column;
                gap: 32px;
            }
            .features-grid, .pricing-cards {
                grid-template-columns: 1fr;
            }
            .hero-title {
                font-size: 40px;
            }
            .nav-links, .nav-actions {
                display: none;
            }
            .hamburger {
                display: flex;
            }
            .mobile-menu {
                position: fixed;
                top: 70px;
                left: 0;
                width: 100%;
                background: white;
                padding: 24px;
                box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                gap: 16px;
                transform: translateY(-150%);
                transition: transform 0.3s ease;
                z-index: 999;
                box-sizing: border-box;
            }
            .mobile-menu.active {
                transform: translateY(0);
            }
            .mobile-menu a {
                padding: 12px;
                text-align: center;
                text-decoration: none;
                color: var(--color-primary-text);
                font-weight: 600;
                border-radius: 8px;
            }
            .mobile-menu a.btn-cta {
                color: white;
            }
            .footer-content {
                flex-direction: column;
                gap: 24px;
            }
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar" id="navbar">
        <div class="container navbar-content">
            <a href="#" class="logo">
                <span class="logo-icon">IF</span>
                IELTS Flow
            </a>
            <div class="nav-links">
                <a href="#features" class="nav-link">Tính năng</a>
                <a href="#pricing" class="nav-link">Bảng giá</a>
                <a href="#testimonials" class="nav-link">Đánh giá</a>
                <a href="#" class="nav-link">Blog</a>
            </div>
            <div class="nav-actions" id="desktop-nav-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.fullName}">
                        <div style="display: flex; align-items: center; gap: 12px; font-weight: 500;">
                            <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                <span style="color: var(--color-primary-text); font-size: 14px; line-height: 1.2;">${sessionScope.fullName}</span>
                                <span style="color: var(--color-secondary-text); font-size: 12px;">${sessionScope.userEmail}</span>
                            </div>
                            <a href="/IELTSFLOW/account" class="btn-cta" style="padding: 8px 20px; font-size: 14px;">H&#7891; s&#417;</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="/IELTSFLOW/jsp/auth.jsp" class="btn-ghost">&#272;&#259;ng nh&#7853;p</a>
                        <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-cta">B&#7855;t &#273;&#7847;u mi&#7875;n ph&#237;</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <button class="hamburger" id="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </nav>

    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobile-menu">
        <a href="#features" class="mobile-link">Tính năng</a>
        <a href="#pricing" class="mobile-link">Bảng giá</a>
        <a href="#testimonials" class="mobile-link">Đánh giá</a>
        <a href="#" class="mobile-link">Blog</a>
        <div id="mobile-nav-actions" style="display:flex; flex-direction:column; gap:10px;">
            <c:choose>
                <c:when test="${not empty sessionScope.fullName}">
                    <div style="text-align: center; padding: 10px 0; border-bottom: 1px solid #e2e8f0; margin-bottom: 10px;">
                        <div style="font-weight: 700; color: var(--color-primary-text);">${sessionScope.fullName}</div>
                        <div style="font-size: 13px; color: var(--color-secondary-text);">${sessionScope.userEmail}</div>
                    </div>
                    <a href="/IELTSFLOW/account" class="btn-cta" style="text-align: center;">V&#224;o trang H&#7891; s&#417;</a>
                </c:when>
                <c:otherwise>
                    <a href="/IELTSFLOW/jsp/auth.jsp" class="btn-ghost">&#272;&#259;ng nh&#7853;p</a>
                    <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-cta">B&#7855;t &#273;&#7847;u mi&#7875;n ph&#237;</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <div class="hero-text scroll-reveal">
                    <span class="badge">Nền tảng IELTS #1 Việt Nam · 50,000+ học viên</span>
                    <h1 class="hero-title">Chinh phục IELTS với Lộ trình AI Cá nhân hóa</h1>
                    <p class="hero-subtitle">Mọi công cụ bạn cần để luyện thi IELTS hiệu quả, tiết kiệm thời gian và đạt điểm mục tiêu nhanh chóng.</p>
                    <div class="hero-actions">
                        <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-cta">Bắt đầu miễn phí →</a>
                        <a href="#features" class="btn-ghost">Xem giới thiệu ▶</a>
                    </div>
                </div>
                <div class="hero-visual scroll-reveal" style="transition-delay: 0.2s">
                    <div class="shape shape-1"></div>
                    <div class="shape shape-2"></div>
                    <div class="shape shape-3"></div>
                </div>
            </div>
            
            <div class="stats-bar scroll-reveal" style="transition-delay: 0.4s">
                <div class="stat-item">
                    <div class="stat-value" data-target="50000">0</div>
                    <div class="stat-label">Học viên</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value" data-target="7.2" data-decimal="true">0</div>
                    <div class="stat-label">Band TB</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value" data-target="94" data-suffix="%">0</div>
                    <div class="stat-label">Đạt mục tiêu</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value" data-target="4.9" data-decimal="true" data-suffix="⭐">0</div>
                    <div class="stat-label">Đánh giá</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Partners Marquee -->
    <section class="partners" style="padding: 60px 0; background: var(--color-white); border-top: 1px solid var(--color-border); border-bottom: 1px solid var(--color-border);">
        <div class="container text-center">
            <h2 style="font-size: 36px; font-weight: 800; color: #1a7fa3; margin: 0 0 8px; font-family: 'Inter', sans-serif;">Đối tác của chúng tôi</h2>
            <p style="color: #64748b; font-size: 14px; margin: 0 0 32px; display: flex; align-items: center; justify-content: center; gap: 12px;">
                <span style="flex: 1; height: 1px; background: #e2e8f0; max-width: 120px;"></span>
                IELTS Flow là đối tác chính thức với hàng trăm tổ chức và trường đại học trên thế giới
                <span style="flex: 1; height: 1px; background: #e2e8f0; max-width: 120px;"></span>
            </p>
            <div class="marquee-wrapper">
                <div class="marquee-content" id="marqueeTrack">
                    <!-- Row 1 of university logos -->
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/University_of_Nottingham_logo.svg/1280px-University_of_Nottingham_logo.svg.png" alt="University of Nottingham" style="height:45px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/UoS_Logomark_horizontal_Colour_RGB.svg/2560px-UoS_Logomark_horizontal_Colour_RGB.svg.png" alt="University of Southampton" style="height:40px;">
                    <img src="https://upload.wikimedia.org/wikipedia/en/thumb/b/b6/Newcastle_University_logo.svg/1200px-Newcastle_University_logo.svg.png" alt="Newcastle University" style="height:40px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Queen_Mary_University_of_London_logo.svg/2560px-Queen_Mary_University_of_London_logo.svg.png" alt="Queen Mary University" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/University_of_Leicester_logo.svg/2560px-University_of_Leicester_logo.svg.png" alt="University of Leicester" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/University_of_Exeter_logo.svg/2560px-University_of_Exeter_logo.svg.png" alt="University of Exeter" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/University_of_York_logo.svg/2560px-University_of_York_logo.svg.png" alt="University of York" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/University_of_Reading_logo.svg/2560px-University_of_Reading_logo.svg.png" alt="University of Reading" style="height:38px;">
                    <!-- Duplicates for infinite scroll -->
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/University_of_Nottingham_logo.svg/1280px-University_of_Nottingham_logo.svg.png" alt="University of Nottingham" style="height:45px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/UoS_Logomark_horizontal_Colour_RGB.svg/2560px-UoS_Logomark_horizontal_Colour_RGB.svg.png" alt="University of Southampton" style="height:40px;">
                    <img src="https://upload.wikimedia.org/wikipedia/en/thumb/b/b6/Newcastle_University_logo.svg/1200px-Newcastle_University_logo.svg.png" alt="Newcastle University" style="height:40px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Queen_Mary_University_of_London_logo.svg/2560px-Queen_Mary_University_of_London_logo.svg.png" alt="Queen Mary University" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/University_of_Leicester_logo.svg/2560px-University_of_Leicester_logo.svg.png" alt="University of Leicester" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/University_of_Exeter_logo.svg/2560px-University_of_Exeter_logo.svg.png" alt="University of Exeter" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/University_of_York_logo.svg/2560px-University_of_York_logo.svg.png" alt="University of York" style="height:38px;">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/University_of_Reading_logo.svg/2560px-University_of_Reading_logo.svg.png" alt="University of Reading" style="height:38px;">
                </div>
            </div>
        </div>
    </section>

    <!-- AI Feature Showcase Section -->
    <section class="ai-showcase" style="padding: 80px 0; background: var(--color-bg-alt);">
        <div class="container">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 64px; align-items: center;">
                <!-- Left: YouTube Embed -->
                <div class="scroll-reveal">
                    <div style="position: relative; border-radius: 16px; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.2); background: #000; aspect-ratio: 16/9;">
                        <iframe
                            src="https://www.youtube.com/embed/lJBsAW7lhC4?si=TYkKTarGgqBSU4vX&autoplay=0&rel=0&modestbranding=1"
                            title="LexiPrep AI – IELTS Listening AI Demo"
                            frameborder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowfullscreen
                            style="width:100%; height:100%; display:block;"
                        ></iframe>
                    </div>
                    <!-- Caption -->
                    <div style="display: flex; align-items: center; gap: 12px; margin-top: 16px; padding: 12px 16px; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06);">
                        <div style="width: 36px; height: 36px; background: #ff0000; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
                        </div>
                        <div>
                            <div style="font-weight: 600; font-size: 14px; color: #1e293b;">IELTS AI Reading Assistant</div>
                            <div style="font-size: 12px; color: #64748b;">IELTSFlow AI • Luyện đề thực chiến</div>
                        </div>
                    </div>
                </div>
                
                <!-- Right: Content -->
                <div class="scroll-reveal" style="transition-delay: 0.2s">
                    <div style="display: inline-flex; align-items: center; gap: 6px; background: rgba(249,115,22,0.1); color: #ea580c; padding: 6px 14px; border-radius: 999px; font-size: 14px; font-weight: 600; margin-bottom: 20px;">Powered by AI ✨</div>
                    <h2 style="font-size: 36px; font-weight: 800; color: #1e293b; line-height: 1.2; margin: 0 0 16px;">Luyện đề IELTS Listening với AI 24/7</h2>
                    <p style="font-size: 17px; color: #475569; margin: 0 0 32px; line-height: 1.7;">Tích hợp AI tương tác trực tiếp với giao diện luyện đề IELTS Listening Academic, hướng dẫn làm bài, cung cấp mẹo, trả lời hàng vạn câu hỏi vì sao 24/7.</p>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">💡</span> <span style="font-weight: 500; font-size: 14px;">Gợi ý giải từng câu</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">🕐</span> <span style="font-weight: 500; font-size: 14px;">Giải đáp thắc mắc 24/7</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">📖</span> <span style="font-weight: 500; font-size: 14px;">Định nghĩa từ vựng</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">🎯</span> <span style="font-weight: 500; font-size: 14px;">Chiến thuật làm bài</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">🔦</span> <span style="font-weight: 500; font-size: 14px;">Highlight từ khoá</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; padding: 12px; background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);">
                            <span style="font-size: 18px;">🇻🇳</span> <span style="font-weight: 500; font-size: 14px;">Hỗ trợ tiếng Việt</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <style>
    @media (max-width: 768px) {
        .ai-showcase > .container > div {
            grid-template-columns: 1fr !important;
        }
    }
    </style>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <span class="section-label scroll-reveal">✨ Tính năng nổi bật</span>
            <h2 class="section-title scroll-reveal">Mọi thứ bạn cần để đạt band điểm mơ ước</h2>
            
            <div class="features-grid">
                <div class="card scroll-reveal">
                    <div class="card-icon">🤖</div>
                    <h3 class="card-title">AI tạo lộ trình cá nhân hóa</h3>
                    <p class="card-desc">Hệ thống phân tích điểm yếu, mạnh của bạn thông qua bài test đầu vào để thiết kế lộ trình học tối ưu nhất.</p>
                    <span class="chip-badge">Học thông minh</span>
                </div>
                <div class="card scroll-reveal" style="transition-delay: 0.1s">
                    <div class="card-icon">🎙️</div>
                    <h3 class="card-title">Chấm Speaking/Writing tức thì</h3>
                    <p class="card-desc">Nhận feedback chi tiết về phát âm, từ vựng và ngữ pháp cho các bài thi Nói và Viết chỉ trong vài giây.</p>
                    <span class="chip-badge">AI Chấm điểm</span>
                </div>
                <div class="card scroll-reveal" style="transition-delay: 0.2s">
                    <div class="card-icon">🧘</div>
                    <h3 class="card-title">Thi thử chế độ tập trung</h3>
                    <p class="card-desc">Mô phỏng 100% áp lực phòng thi thật, giúp bạn làm quen với thời gian và giao diện thi máy tính (CD-IELTS).</p>
                    <span class="chip-badge">Mock Test</span>
                </div>
                <div class="card scroll-reveal" style="transition-delay: 0.3s">
                    <div class="card-icon">⏰</div>
                    <h3 class="card-title">Đếm ngược thông minh</h3>
                    <p class="card-desc">Quản lý thời gian học tập, nhắc nhở ôn luyện hàng ngày và đếm ngược đến ngày thi chính thức của bạn.</p>
                    <span class="chip-badge">Quản lý thời gian</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Realistic Social Proof -->
    <section class="social-proof" id="social-proof" style="padding: 80px 0; background: #e8f7fb;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 24px;">
            <!-- Header -->
            <div class="text-center scroll-reveal" style="margin-bottom: 48px;">
                <h2 style="font-size: 48px; font-weight: 800; color: #1e293b; margin: 0 0 16px; line-height: 1.2;">
                    Hàng triệu <span style="color: #0ea5e9;">đánh giá tích<br>cực</span> từ học viên <span style="color: #0ea5e9;">trên toàn<br>thế giới</span>
                </h2>
                <p style="color: #64748b; font-size: 15px; display: flex; align-items: center; justify-content: center; gap: 12px; margin: 0;">
                    <span style="flex: 1; height: 1px; background: #cbd5e1; max-width: 100px;"></span>
                    Từ sự tin tưởng của hàng triệu người học trên toàn thế giới, tại hơn 120 quốc gia
                    <span style="flex: 1; height: 1px; background: #cbd5e1; max-width: 100px;"></span>
                </p>
            </div>

            <!-- Platform Filter Buttons -->
            <div style="display: flex; justify-content: center; gap: 16px; margin-bottom: 40px;" class="scroll-reveal">
                <button onclick="filterSocial('tiktok', this)" style="display: flex; align-items: center; gap: 8px; padding: 12px 28px; background: #1e293b; color: white; border: none; border-radius: 999px; font-weight: 700; font-size: 15px; cursor: pointer; transition: all 0.2s;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64 2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/></svg>
                    TIKTOK <span style="font-size: 12px;">↗</span>
                </button>
                <button onclick="filterSocial('facebook', this)" style="display: flex; align-items: center; gap: 8px; padding: 12px 28px; background: #1e293b; color: white; border: none; border-radius: 999px; font-weight: 700; font-size: 15px; cursor: pointer; transition: all 0.2s;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                    FACEBOOK <span style="font-size: 12px;">↗</span>
                </button>
                <button onclick="filterSocial('youtube', this)" style="display: flex; align-items: center; gap: 8px; padding: 12px 28px; background: #1e293b; color: white; border: none; border-radius: 999px; font-weight: 700; font-size: 15px; cursor: pointer; transition: all 0.2s;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
                    YOUTUBE <span style="font-size: 12px;">↗</span>
                </button>
            </div>

            <!-- Horizontally scrolling mobile screenshots -->
            <div style="overflow-x: auto; padding-bottom: 16px; -webkit-overflow-scrolling: touch; scrollbar-width: none;" class="scroll-reveal">
                <div id="socialGrid" style="display: flex; gap: 16px; width: max-content; align-items: flex-start; padding: 8px 4px;">

                    <!-- Rating Card -->
                    <div style="width: 180px; background: white; border-radius: 20px; padding: 20px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); flex-shrink: 0; display: flex; flex-direction: column; align-items: center; text-align: center; min-height: 280px; justify-content: center;">
                        <div style="font-size: 42px; font-weight: 800; color: #1e293b;">4.8/5</div>
                        <div style="color: #f59e0b; font-size: 20px; margin: 8px 0;">★★★★★</div>
                        <div style="font-size: 12px; color: #64748b; line-height: 1.4;">Reviewed by<br><strong style="color: #1e293b;">35 million learners</strong></div>
                        <div style="margin-top: 16px; display: flex; gap: -8px;">
                            <div style="width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,#f97316,#ea580c);border:2px solid white;margin-right:-8px;"></div>
                            <div style="width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,#3b82f6,#2563eb);border:2px solid white;margin-right:-8px;"></div>
                            <div style="width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);border:2px solid white;"></div>
                        </div>
                    </div>

                    <!-- Zalo Chat Screenshot -->
                    <div class="social-ss" data-type="facebook" style="width: 200px; background: #f0f2f5; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.1); flex-shrink: 0; transition: transform 0.2s;">
                        <div style="background: #0668E1; padding: 10px 14px; display: flex; align-items: center; gap: 8px;">
                            <div style="width: 28px; height: 28px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #0668E1;">M</div>
                            <div style="color: white; font-size: 12px; font-weight: 600;">Messenger</div>
                        </div>
                        <div style="padding: 12px; display: flex; flex-direction: column; gap: 8px; min-height: 250px;">
                            <div style="background: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; box-shadow: 0 1px 2px rgba(0,0,0,0.08);">Cô ơi em giờ kết quả thi a</div>
                            <div style="background: #0668E1; color: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; align-self: flex-end;">Quá xịn lun! Chúc mừng nha 🎉</div>
                            <div style="background: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; box-shadow: 0 1px 2px rgba(0,0,0,0.08);">Em được 7.0 overall ạ!! 😭🙏</div>
                            <div style="background: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; box-shadow: 0 1px 2px rgba(0,0,0,0.08);">Thanks IELTSFlow nhiều lắm ạ! 💙</div>
                            <div style="background: #0668E1; color: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; align-self: flex-end;">Tuyệt vời quá!! ❤️ Em giỏi lắm</div>
                        </div>
                    </div>

                    <!-- TikTok Screenshot 1 - 8.5 Overall -->
                    <div class="social-ss" data-type="tiktok" style="width: 170px; background: #000; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.2); flex-shrink: 0; position: relative; min-height: 300px; transition: transform 0.2s;">
                        <div style="position: absolute; inset: 0; background: linear-gradient(160deg, #1a1a2e, #16213e, #0f3460); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 20px; text-align: center;">
                            <div style="color: white; font-size: 13px; font-weight: 600; margin-bottom: 8px; opacity: 0.8;">🎓 NAM SINH NINH BÌNH</div>
                            <div style="color: #fbbf24; font-size: 48px; font-weight: 900; line-height: 1;">8.5</div>
                            <div style="color: white; font-size: 18px; font-weight: 700; margin-top: 4px;">OVERALL</div>
                            <div style="color: rgba(255,255,255,0.7); font-size: 11px; margin-top: 12px; line-height: 1.5;">Nam sinh chinh phục<br>8.5 IELTS nhờ<br>IELTSFlow Online</div>
                        </div>
                        <div style="position: absolute; bottom: 12px; right: 12px; display: flex; flex-direction: column; gap: 12px; align-items: center;">
                            <div style="color: white; font-size: 20px; text-align: center;">❤️<div style="font-size: 10px;">24K</div></div>
                            <div style="color: white; font-size: 20px; text-align: center;">💬<div style="font-size: 10px;">381</div></div>
                        </div>
                        <div style="position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.5); padding: 3px 8px; border-radius: 4px;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="white"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64 2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/></svg>
                        </div>
                    </div>

                    <!-- Zalo Screenshot -->
                    <div class="social-ss" data-type="facebook" style="width: 200px; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.1); flex-shrink: 0; min-height: 300px; transition: transform 0.2s;">
                        <div style="background: #0068FF; padding: 10px 14px; display: flex; align-items: center; gap: 8px;">
                            <div style="width: 28px; height: 28px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; color: #0068FF;">Z</div>
                            <div style="color: white; font-size: 12px; font-weight: 600;">Zalo • Phụ huynh Quảng M...</div>
                        </div>
                        <div style="padding: 12px; display: flex; flex-direction: column; gap: 8px;">
                            <div style="background: #f0f2f5; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%;">Hôm nay chị kết quả thi thế nào rồi?</div>
                            <div style="background: #0068FF; color: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; align-self: flex-end;">Em được 7.2 ạ! 😭😭</div>
                            <div style="background: #f0f2f5; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%;">Chúc mừng em! 🎉🎉</div>
                            <div style="background: #0068FF; color: white; padding: 10px 12px; border-radius: 12px; font-size: 11px; max-width: 85%; align-self: flex-end;">Cảm ơn IELTSFlow đã giúp em ạ! 🙏</div>
                        </div>
                    </div>

                    <!-- YouTube/Review Screenshot -->
                    <div class="social-ss" data-type="youtube" style="width: 200px; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.1); flex-shrink: 0; background: white; min-height: 280px; transition: transform 0.2s; display: flex; flex-direction: column;">
                        <div style="background: linear-gradient(135deg, #1e3a8a, #2563eb); padding: 20px; flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; position: relative;">
                            <div style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 12px;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="white"><path d="M8 5v14l11-7z"/></svg>
                            </div>
                            <div style="color: white; font-weight: 700; font-size: 13px;">3 mẹ con cùng nhau<br>học IELTS</div>
                            <div style="color: rgba(255,255,255,0.7); font-size: 10px; margin-top: 8px;">IELTSFlow chia sẻ • 2.1M views</div>
                            <div style="position: absolute; bottom: 10px; left: 10px; background: #ff0000; padding: 3px 8px; border-radius: 4px; font-size: 10px; color: white; font-weight: 700;">▶ YouTube</div>
                        </div>
                        <div style="padding: 14px; background: white;">
                            <div style="font-size: 11px; font-weight: 600; color: #1e293b;">IELTSFlow Student Story</div>
                            <div style="font-size: 10px; color: #64748b; margin-top: 4px;">"Cả gia đình cùng chinh phục IELTS, kết quả vượt ngoài mong đợi!"</div>
                            <div style="display: flex; align-items: center; gap: 4px; margin-top: 8px;">
                                <span style="color: #f59e0b; font-size: 12px;">★★★★★</span>
                                <span style="font-size: 10px; color: #64748b;">5.0</span>
                            </div>
                        </div>
                    </div>

                    <!-- TikTok Screenshot 2 -->
                    <div class="social-ss" data-type="tiktok" style="width: 170px; background: #000; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.2); flex-shrink: 0; position: relative; min-height: 300px; transition: transform 0.2s;">
                        <div style="position: absolute; inset: 0; background: linear-gradient(160deg, #0f2027, #203a43, #2c5364); display: flex; flex-direction: column; padding: 16px;">
                            <div style="color: rgba(255,255,255,0.8); font-size: 11px; margin-bottom: 8px;">@k10confessions</div>
                            <div style="flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center;">
                                <div style="color: white; font-size: 13px; font-weight: 700; margin-bottom: 6px;">3 THÁNG HỌC IELTS ONLINE</div>
                                <div style="width: 40px; height: 40px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 8px auto;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M8 5v14l11-7z"/></svg>
                                </div>
                                <div style="color: #ff4500; font-size: 11px; font-weight: 600;">NAM SINH SỸ LA ĐẠT 7.5</div>
                            </div>
                            <div style="color: rgba(255,255,255,0.6); font-size: 10px; text-align: center;">Watching videos on TikTok • Watch now</div>
                        </div>
                        <div style="position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.5); padding: 3px 8px; border-radius: 4px;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="white"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64 2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/></svg>
                        </div>
                        <div style="position: absolute; bottom: 12px; right: 12px; display: flex; flex-direction: column; gap: 12px; align-items: center;">
                            <div style="color: white; font-size: 18px; text-align: center;">❤️<div style="font-size: 10px;">12K</div></div>
                        </div>
                    </div>

                </div>
            </div>

            <style>
            .social-ss:hover { transform: translateY(-6px) scale(1.02); }
            #socialGrid::-webkit-scrollbar { display: none; }
            .social-ss[data-type] { display: flex; flex-direction: column; }
            </style>

            <script>
            function filterSocial(type, btn) {
                document.querySelectorAll('#socialGrid .social-ss').forEach(el => {
                    el.style.display = (el.dataset.type === type || type === 'all') ? 'flex' : 'none';
                });
            }
            </script>
        </div>
    </section>

    <!-- Pricing Section -->
    <section class="pricing" id="pricing">
        <div class="container">
            <span class="section-label scroll-reveal">💎 Bảng giá</span>
            <h2 class="section-title scroll-reveal">Chọn gói phù hợp với mục tiêu của bạn</h2>
            
            <div class="pricing-cards">
                <div class="pricing-card free scroll-reveal">
                    <h3 class="pricing-title">Miễn phí</h3>
                    <div class="pricing-price">0₫<span>/tháng</span></div>
                    <p style="color: var(--color-secondary-text);">Bắt đầu hành trình IELTS</p>
                    <ul class="pricing-features">
                        <li>Placement Test đầu vào</li>
                        <li>Xem tuần 1 lộ trình AI</li>
                        <li>3 bài Mock Test/tháng</li>
                        <li>Tham gia cộng đồng</li>
                        <li class="disabled">Chấm điểm Writing/Speaking</li>
                        <li class="disabled">Thi thử Focus Mode</li>
                    </ul>
                    <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-outline btn-full">Bắt đầu ngay</a>
                </div>
                
                <div class="pricing-card pro scroll-reveal" style="transition-delay: 0.1s">
                    <div class="pro-badge">PHỔ BIẾN</div>
                    <h3 class="pricing-title">Candidate Pro</h3>
                    <div class="pricing-price">299.000₫<span>/tháng</span></div>
                    <p style="color: var(--color-secondary-text);">Mở khóa toàn bộ sức mạnh AI</p>
                    <ul class="pricing-features">
                        <li>Tất cả tính năng của gói Miễn phí</li>
                        <li>Full 3 tháng lộ trình học bằng AI</li>
                        <li>Focus Mode Mock Tests</li>
                        <li>Chấm Writing/Speaking không giới hạn</li>
                        <li>Hỗ trợ ưu tiên 24/7</li>
                    </ul>
                    <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-cta btn-full">Nâng cấp Pro</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="testimonials" id="testimonials">
        <div class="container">
            <span class="section-label scroll-reveal">🌟 Đánh giá</span>
            <h2 class="section-title scroll-reveal">Học viên nói gì về IELTS Flow?</h2>
            
            <div class="carousel-container scroll-reveal">
                <div class="carousel-track" id="testimonialTrack">
                    <!-- Slide 1 -->
                    <div class="testimonial-slide">
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <div class="user-info">
                                    <div class="avatar">NH</div>
                                    <div>
                                        <h4 class="user-name">Nguyễn Hoàng</h4>
                                        <p class="score-improvement">5.5 → 7.0</p>
                                    </div>
                                </div>
                                <div class="stars">⭐⭐⭐⭐⭐</div>
                            </div>
                            <p class="quote">"Tính năng AI chấm Speaking quá tuyệt vời! Mình biết chính xác mình sai phát âm ở đâu và cần sửa từ vựng như thế nào."</p>
                        </div>
                    </div>
                    <!-- Slide 2 -->
                    <div class="testimonial-slide">
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <div class="user-info">
                                    <div class="avatar">TL</div>
                                    <div>
                                        <h4 class="user-name">Trần Linh</h4>
                                        <p class="score-improvement">6.0 → 7.5</p>
                                    </div>
                                </div>
                                <div class="stars">⭐⭐⭐⭐⭐</div>
                            </div>
                            <p class="quote">"Lộ trình học cá nhân hóa giúp mình tiết kiệm rất nhiều thời gian, chỉ tập trung vào những kỹ năng còn yếu. Highly recommend!"</p>
                        </div>
                    </div>
                    <!-- Slide 3 -->
                    <div class="testimonial-slide">
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <div class="user-info">
                                    <div class="avatar">MA</div>
                                    <div>
                                        <h4 class="user-name">Minh Anh</h4>
                                        <p class="score-improvement">5.0 → 6.5</p>
                                    </div>
                                </div>
                                <div class="stars">⭐⭐⭐⭐⭐</div>
                            </div>
                            <p class="quote">"Giao diện Mock Test giống hệt thi thật trên máy tính, nhờ đó mình không còn bị bỡ ngỡ và run khi vào phòng thi."</p>
                        </div>
                    </div>
                    <!-- Slide 4 -->
                    <div class="testimonial-slide">
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <div class="user-info">
                                    <div class="avatar">PQ</div>
                                    <div>
                                        <h4 class="user-name">Phạm Quân</h4>
                                        <p class="score-improvement">6.5 → 8.0</p>
                                    </div>
                                </div>
                                <div class="stars">⭐⭐⭐⭐⭐</div>
                            </div>
                            <p class="quote">"Gói Pro thực sự đáng đồng tiền bát gạo. Việc được chấm Writing không giới hạn giúp mình bứt phá kỹ năng Viết nhanh chóng."</p>
                        </div>
                    </div>
                </div>
                <div class="carousel-dots" id="carouselDots">
                    <!-- Dots generated by JS -->
                </div>
            </div>
        </div>
    </section>

    <!-- Bottom CTA -->
    <section class="bottom-cta">
        <div class="container scroll-reveal">
            <h2 class="section-title">Sẵn sàng chinh phục IELTS?</h2>
            <p class="hero-subtitle">Tham gia cùng hơn 50.000 học viên đã đạt điểm số mơ ước.</p>
            <a href="/IELTSFLOW/jsp/auth.jsp?tab=register" class="btn-white">Bắt đầu miễn phí ngay</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <a href="#" class="logo">
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

    <!-- App Scripts -->
    <script src="js/landing.js?v=2"></script>
</body>
</html>
