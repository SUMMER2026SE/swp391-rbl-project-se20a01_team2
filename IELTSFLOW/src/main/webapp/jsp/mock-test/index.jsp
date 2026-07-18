<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
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

        /* Select box styles */
        .mock-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            background: rgba(255,255,255,0.8);
            font-size: 1rem;
            font-weight: 500;
            font-family: inherit;
            color: var(--text-primary);
            margin-top: 8px;
            outline: none;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .mock-select:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99,102,241,.15);
            background: #fff;
        }

        /* Skill Radio Cards */
        .skill-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 12px;
            margin-top: 10px;
        }
        .skill-card {
            position: relative;
            cursor: pointer;
        }
        .skill-card input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        .skill-card .card-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 14px 8px;
            background: var(--bg-surface);
            border: 2px solid var(--glass-border);
            border-radius: 14px;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: center;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
        }
        .skill-card:hover:not(.disabled) .card-content {
            border-color: rgba(99,102,241, 0.4);
            background: rgba(99,102,241, 0.03);
            transform: translateY(-2px);
        }
        .skill-card input:checked ~ .card-content {
            border-color: #6366f1;
            background: rgba(99,102,241, 0.08);
            color: #6366f1;
            box-shadow: 0 8px 20px rgba(99,102,241, 0.15);
            transform: translateY(-2px);
        }
        .skill-card input:disabled ~ .card-content {
            opacity: 0.4;
            cursor: not-allowed;
            background: rgba(0,0,0,0.02);
            border-color: transparent;
            transform: none;
        }
        .skill-icon {
            font-size: 1.6rem;
            margin-bottom: 6px;
            display: block;
        }
        
        @media (max-width: 600px) {
            .skill-grid {
                grid-template-columns: repeat(3, 1fr);
            }
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
        <jsp:include page="/jsp/candidate/sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <main class="main-content">
            <div class="mock-hero animate-fade-up">
                <div class="hero-badge">🎯 Mock Test</div>
                <h1>Thi Thử IELTS</h1>
                <p>Trải nghiệm thi thực tế với đề ngẫu nhiên từ ngân hàng đề của Mentor. Kết quả được ghi vào hồ sơ học tập.</p>
            </div>

            <div class="animate-fade-up" style="animation-delay:0.1s;">
                <c:choose>
                    <c:when test="${not empty exams}">
                        <div class="exam-card">
                            <form action="${pageContext.request.contextPath}/candidate/mock-test" method="post" id="mockTestForm">
                                <input type="hidden" name="action" value="start">
                                <div class="exam-meta-grid">
                                    <div class="meta-item" style="grid-column: span 2; background: rgba(255,255,255,0.4);">
                                        <div class="meta-label">📚 Chọn đề thi</div>
                                        <select name="examId" id="examSelect" class="mock-select" required onchange="handleExamChange()">
                                            <c:forEach var="ex" items="${exams}">
                                                <option value="${ex.examId}" data-skill="${ex.skillFocus}">${ex.title} (Thời gian: ${ex.duration} phút)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="meta-item" style="grid-column: span 2; background: transparent; border: none; padding: 0;">
                                        <div class="meta-label" style="font-size: 0.8rem;">🎯 Chọn kỹ năng luyện tập</div>
                                        <div class="skill-grid" id="skillGrid">
                                            <label class="skill-card">
                                                <input type="radio" name="skillFocus" value="All" checked>
                                                <div class="card-content">
                                                    <span class="skill-icon">🏆</span>
                                                    <span>Full Test</span>
                                                </div>
                                            </label>
                                            <label class="skill-card">
                                                <input type="radio" name="skillFocus" value="Listening">
                                                <div class="card-content">
                                                    <span class="skill-icon">🎧</span>
                                                    <span>Listening</span>
                                                </div>
                                            </label>
                                            <label class="skill-card">
                                                <input type="radio" name="skillFocus" value="Reading">
                                                <div class="card-content">
                                                    <span class="skill-icon">📖</span>
                                                    <span>Reading</span>
                                                </div>
                                            </label>
                                            <label class="skill-card">
                                                <input type="radio" name="skillFocus" value="Writing">
                                                <div class="card-content">
                                                    <span class="skill-icon">✍️</span>
                                                    <span>Writing</span>
                                                </div>
                                            </label>
                                            <label class="skill-card">
                                                <input type="radio" name="skillFocus" value="Speaking">
                                                <div class="card-content">
                                                    <span class="skill-icon">🎙️</span>
                                                    <span>Speaking</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="rules-box">
                                    <h3>⚠️ Quy định phòng thi</h3>
                                    <ul>
                                        <li>Bài thi sẽ bắt đầu ở chế độ <strong>Toàn màn hình</strong>.</li>
                                        <li>Nếu bạn thoát toàn màn hình hoặc chuyển tab quá <strong>3 lần</strong>, bài thi sẽ tự động nộp và bị đánh dấu vi phạm.</li>
                                        <li>Câu hỏi được <strong>sắp xếp ngẫu nhiên</strong> mỗi lần thi (nếu là Full Test).</li>
                                        <li>Bạn có thể xem lại đáp án chi tiết và AI Feedback sau khi nộp bài.</li>
                                    </ul>
                                </div>

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
    <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
    <script>
        function handleExamChange() {
            const select = document.getElementById('examSelect');
            if (!select) return;
            const selectedOption = select.options[select.selectedIndex];
            const examSkill = selectedOption.getAttribute('data-skill');
            
            const radios = document.querySelectorAll('input[name="skillFocus"]');
            let anyEnabledAndChecked = false;
            
            radios.forEach(radio => {
                const label = radio.closest('.skill-card');
                if (!examSkill || examSkill === 'All' || examSkill === '') {
                    // Full test, all options available
                    radio.disabled = false;
                    label.classList.remove('disabled');
                } else {
                    // Specific skill test, disable others
                    if (radio.value === examSkill) {
                        radio.disabled = false;
                        radio.checked = true;
                        label.classList.remove('disabled');
                    } else {
                        radio.disabled = true;
                        label.classList.add('disabled');
                    }
                }
                
                if (!radio.disabled && radio.checked) {
                    anyEnabledAndChecked = true;
                }
            });
            
            // Default to 'All' if the currently checked one became disabled
            if (!anyEnabledAndChecked) {
                const allRadio = document.querySelector('input[name="skillFocus"][value="All"]');
                if (allRadio && !allRadio.disabled) {
                    allRadio.checked = true;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', handleExamChange);
    </script>
</body>
</html>

