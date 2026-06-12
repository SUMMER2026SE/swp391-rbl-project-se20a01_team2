<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>IELTSFlow - Gói Đăng Ký</title>
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

            /* Utility classes */
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
                text-align: center;
            }

            .btn-cta:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(234, 88, 12, 0.4);
            }

            /* Pricing Section */
            .pricing {
                padding: 80px 0 100px;
                text-align: center;
            }

            .section-title {
                font-size: 40px;
                font-weight: 800;
                margin: 0 0 16px;
            }

            .section-subtitle {
                font-size: 18px;
                color: var(--color-secondary-text);
                margin-bottom: 64px;
            }

            .pricing-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                gap: 32px;
                margin: 0 auto;
                text-align: left;
            }

            .pricing-card {
                background: white;
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
                border: 2px solid #E2E8F0;
                position: relative;
                box-sizing: border-box;
                transition: all 0.3s ease;
                display: flex;
                flex-direction: column;
            }

            .pricing-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.08);
                border-color: #CBD5E1;
            }

            .pricing-title {
                font-size: 24px;
                font-weight: 700;
                margin: 0 0 12px;
            }

            .pricing-price {
                font-size: 40px;
                font-weight: 800;
                margin: 0 0 8px;
                color: var(--color-primary-text);
                display: flex;
                align-items: baseline;
                gap: 4px;
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
                flex-grow: 1;
            }

            .pricing-features li {
                padding: 12px 0;
                display: flex;
                align-items: flex-start;
                gap: 12px;
                color: var(--color-secondary-text);
            }

            .pricing-features li::before {
                content: "✓";
                color: #10B981;
                font-weight: bold;
            }

            .pkg-desc {
                background: #F1F5F9;
                padding: 12px 16px;
                border-radius: 8px;
                color: var(--color-secondary-text);
                font-style: italic;
                font-size: 14px;
                margin-top: 16px;
                border-left: 4px solid #CBD5E1;
            }

            .btn-full {
                width: 100%;
                display: block;
            }

            /* Pagination Styles */
            .pagination {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 64px;
                list-style: none;
                padding: 0;
            }

            .pagination li a {
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 40px;
                height: 40px;
                border-radius: 8px;
                background: white;
                color: var(--color-primary-text);
                text-decoration: none;
                font-weight: 600;
                border: 1px solid #E2E8F0;
                transition: all 0.2s;
                padding: 0 16px;
            }

            .pagination li a:hover {
                background: #F1F5F9;
                border-color: #CBD5E1;
            }

            .pagination li.active a {
                background: var(--grad-cta);
                color: white;
                border: none;
            }

            .pagination li.disabled a {
                color: #94A3B8;
                pointer-events: none;
                background: #F8FAFC;
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

            @media (max-width: 768px) {
                .nav-links, .nav-actions {
                    display: none;
                }
                .pricing-cards {
                    grid-template-columns: 1fr;
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
        <nav class="navbar">
            <div class="container navbar-content">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <span class="logo-icon">IF</span>
                    IELTS Flow
                </a>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/#features" class="nav-link">Tính năng</a>
                    <a href="${pageContext.request.contextPath}/#pricing" class="nav-link">Bảng giá</a>
                    <a href="${pageContext.request.contextPath}/subscription" class="nav-link active">Gói Đăng Ký</a>
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
        <section class="pricing">
            <div class="container">
                <h1 class="section-title">Chọn Hành Trình IELTS Của Bạn</h1>
                <p style="color: #64748b; font-size: 15px; display: flex; align-items: center; justify-content: center; gap: 12px; margin: 3rem 0;">
                    <span style="flex: 1; height: 1px; background: #cbd5e1; max-width: 100px;"></span>
                    Chọn gói đăng ký phù hợp nhất để đạt được band điểm mục tiêu của bạn.
                    <span style="flex: 1; height: 1px; background: #cbd5e1; max-width: 100px;"></span>
                </p>

                <div class="pricing-cards">
                    <c:forEach var="pkg" items="${packages}">
                        <div class="pricing-card">
                            <h3 class="pricing-title">${pkg.name}</h3>
                            <div class="pricing-price">
                                ${pkg.price} <span>VND</span>
                            </div>

                            <ul class="pricing-features">
                                <li>Truy cập trong ${pkg.durationMonths} Tháng</li>
                                <li>Đầy đủ Bài thi thử & Luyện tập</li>
                                <li>AI Tự động tạo Lộ trình học</li>
                                    <c:if test="${not empty pkg.description}">
                                    <div class="pkg-desc">${pkg.description}</div>
                                </c:if>
                            </ul>

                            <form method="POST" action="${pageContext.request.contextPath}/checkout">
                                <input type="hidden" name="packageId" value="${pkg.packageId}">
                                <button type="submit" class="btn-cta btn-full">Bắt Đầu Ngay</button>
                            </form>
                        </div>
                    </c:forEach>

                    <c:if test="${empty packages}">
                        <div style="grid-column: 1 / -1; text-align: center; color: var(--color-secondary-text); padding: 40px; background: white; border-radius: 24px; border: 1px dashed #CBD5E1;">
                            Hiện tại chưa có gói thành viên nào.
                        </div>
                    </c:if>
                </div>

                <%-- Pagination --%>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="${currentPage == 1 ? 'disabled' : ''}">
                            <a href="${pageContext.request.contextPath}/subscription?page=${currentPage - 1}">Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="${currentPage == i ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/subscription?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="${currentPage == totalPages ? 'disabled' : ''}">
                            <a href="${pageContext.request.contextPath}/subscription?page=${currentPage + 1}">Sau</a>
                        </li>
                    </ul>
                </c:if>

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

    </body>
</html>
