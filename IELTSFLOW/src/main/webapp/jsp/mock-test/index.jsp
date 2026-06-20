<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mock Test – IELTSFLOW</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── Mock Test Index Styles ─────────────────────────── */
        .mock-hero {
            text-align: center;
            padding: 20px 0 30px;
        }
        .mock-hero .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(99,102,241,.12);
            border: 1px solid rgba(99,102,241,.25);
            border-radius: 100px;
            padding: 6px 18px;
            font-size: 0.78rem;
            color: #6366f1;
            font-weight: 600;
            letter-spacing: .06em;
            text-transform: uppercase;
            margin-bottom: 20px;
        }
        .mock-hero .hero-badge::before {
            content: '';
            width: 8px; height: 8px;
            border-radius: 50%;
            background: #6366f1;
            animation: hero-pulse 2s infinite;
        }
        @keyframes hero-pulse { 0%,100%{opacity:1} 50%{opacity:.3} }

        .mock-hero h1 {
            font-size: 2.4rem;
            font-weight: 800;
            margin-bottom: 12px;
        }
        .mock-hero p {
            color: var(--text-secondary);
            font-size: 1rem;
            max-width: 520px;
            margin: 0 auto;
            line-height: 1.7;
        }

        /* Exam Card */
        .exam-card {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 32px;
            max-width: 600px;
            margin: 0 auto;
        }
        .exam-meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 24px;
        }
        .meta-item {
            background: rgba(0,0,0,0.04);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 14px 18px;
        }
        .meta-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: .08em;
            color: var(--text-secondary);
            margin-bottom: 4px;
        }
        .meta-value {
            font-size: 1.05rem;
            font-weight: 700;
        }

        /* Rules box */
        .rules-box {
            background: rgba(99,102,241,.06);
            border: 1px solid rgba(99,102,241,.2);
            border-radius: 12px;
            padding: 18px 20px;
            margin-bottom: 24px;
        }
        .rules-box h3 {
            font-size: 0.9rem;
            color: #6366f1;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .rules-box ul {
            list-style: none;
            margin: 0; padding: 0;
        }
        .rules-box ul li {
            font-size: 0.875rem;
            color: var(--text-secondary);
            padding: 4px 0;
            display: flex;
            align-items: flex-start;
            gap: 8px;
            line-height: 1.55;
        }
        .rules-box ul li::before {
            content: '•';
            color: #6366f1;
            flex-shrink: 0;
        }

        /* Start button */
        .btn-start-mock {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            font-size: 1.05rem;
            font-weight: 700;
            font-family: inherit;
            transition: all .3s;
            letter-spacing: .02em;
        }
        .btn-start-mock:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(99,102,241,.35);
        }

        /* No exam state */
        .no-exam-card {
            text-align: center;
            padding: 48px 32px;
            color: var(--text-secondary);
        }
        .no-exam-card svg {
            width: 60px; height: 60px;
            margin: 0 auto 16px;
            display: block;
            opacity: .35;
        }
    </style>
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-2"></div>

    <div class="layout-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}</div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Target: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Weekly Plan</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Library</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="nav-link active">🎯 Test</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 History &amp; Redo</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="mock-hero animate-fade-up">
                <div class="hero-badge">🎯 Mock Test</div>
                <h1>Thi Thử IELTS</h1>
                <p>Trải nghiệm thi thực tế với đề ngẫu nhiên từ ngân hàng đề của Mentor. Kết quả được ghi vào hồ sơ học tập.</p>
            </div>

            <div class="animate-fade-up" style="animation-delay:0.1s;">
                <c:choose>
                    <c:when test="${exam != null}">
                        <div class="exam-card">
                            <div class="exam-meta-grid">
                                <div class="meta-item">
                                    <div class="meta-label">Đề thi</div>
                                    <div class="meta-value">${exam.title}</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Thời gian</div>
                                    <div class="meta-value" style="color:var(--accent-blue);">${exam.duration} phút</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Loại đề</div>
                                    <div class="meta-value">${exam.type}</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Kỹ năng</div>
                                    <div class="meta-value">${exam.skillFocus}</div>
                                </div>
                            </div>

                            <div class="rules-box">
                                <h3>⚠️ Quy định phòng thi</h3>
                                <ul>
                                    <li>Bài thi sẽ bắt đầu ở chế độ <strong>Toàn màn hình</strong>.</li>
                                    <li>Nếu bạn thoát toàn màn hình hoặc chuyển tab quá <strong>3 lần</strong>, bài thi sẽ tự động nộp và bị đánh dấu vi phạm.</li>
                                    <li>Câu hỏi được <strong>sắp xếp ngẫu nhiên</strong> mỗi lần thi.</li>
                                    <li>Bạn có thể xem lại đáp án chi tiết và AI Feedback sau khi nộp bài.</li>
                                </ul>
                            </div>

                            <form action="${pageContext.request.contextPath}/candidate/mock-test" method="post">
                                <input type="hidden" name="action" value="start">
                                <button type="submit" class="btn-start-mock" id="btn-start-mock-test">
                                    🚀 Bắt đầu thi ngay
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="exam-card no-exam-card">
                            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414A1 1 0 0119 9.414V19a2 2 0 01-2 2z"/>
                            </svg>
                            <p>Hiện tại chưa có đề thi Mock Test nào.<br>Mentor đang chuẩn bị đề thi, vui lòng quay lại sau!</p>
                            <a href="${pageContext.request.contextPath}/candidate/dashboard"
                               style="display:inline-block;margin-top:16px;color:var(--accent-blue);text-decoration:none;font-weight:600;">
                                ← Về Dashboard
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>
