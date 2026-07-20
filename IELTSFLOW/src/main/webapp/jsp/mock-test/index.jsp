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

        /* Search and Filter container */
        .filter-container {
            display: flex;
            flex-direction: column;
            gap: 16px;
            margin-bottom: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .search-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            background: rgba(255,255,255,0.8);
            font-size: 1.05rem;
            outline: none;
            transition: all 0.3s ease;
            color: var(--text-primary);
        }
        .search-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99,102,241,.15);
            background: #fff;
        }
        
        /* Skill Radio Cards */
        .skill-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 12px;
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
        .skill-card:hover .card-content {
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
        
        /* Exam Grid */
        .exam-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            max-width: 1000px;
            margin: 0 auto;
        }
        .exam-card-item {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }
        .exam-card-item::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, #6366f1, #8b5cf6);
            opacity: 0;
            transition: opacity 0.3s;
        }
        .exam-card-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.06);
            border-color: rgba(99,102,241,.3);
        }
        .exam-card-item:hover::before {
            opacity: 1;
        }
        .exam-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: var(--text-primary);
            line-height: 1.4;
        }
        .exam-info {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 24px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .exam-badge {
            background: rgba(99,102,241,.1);
            color: #6366f1;
            padding: 4px 12px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: .02em;
        }
        .btn-exam-start {
            margin-top: auto;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            background: rgba(99,102,241,.1);
            color: #6366f1;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .exam-card-item:hover .btn-exam-start {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            box-shadow: 0 8px 16px rgba(99,102,241,.25);
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

        /* No exam state */
        .no-exam-card {
            text-align: center;
            padding: 48px 32px;
            color: var(--text-secondary);
            background: var(--bg-surface);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            max-width: 600px;
            margin: 0 auto;
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
        <main class="main-content" id="appMainContent">
            <div class="mock-hero animate-fade-up">
                <div class="hero-badge">🎯 ${empty param.mode or param.mode eq 'practice' ? 'Practice Test' : 'Mock Test'}</div>
                <h1>${empty param.mode or param.mode eq 'practice' ? 'Luyện Tập Kỹ Năng' : 'Thi Thử IELTS'}</h1>
                <p>${empty param.mode or param.mode eq 'practice' ? 'Luyện tập các kỹ năng IELTS với đề thi được chọn.' : 'Trải nghiệm thi thực tế với đề ngẫu nhiên từ ngân hàng đề của Mentor. Kết quả được ghi vào hồ sơ học tập.'}</p>
            </div>

            <div class="animate-fade-up" style="animation-delay:0.1s;">
                <c:choose>
                    <c:when test="${not empty exams}">
                        
                        <div class="filter-container">
                            <input type="hidden" id="hiddenTestMode" value="${empty param.mode ? 'practice' : param.mode}">
                            
                            <c:if test="${empty param.mode or param.mode eq 'practice'}">
                                <div style="text-align: center; margin-bottom: 12px; font-weight: 600; color: var(--text-primary); font-size: 1.05rem;">🎯 Chọn kỹ năng luyện tập</div>
                                <div class="skill-grid" id="skillGrid" style="margin-bottom: 24px;">
                                    <label class="skill-card">
                                        <input type="radio" name="skillFocusFilter" value="All" checked onchange="filterExams()">
                                        <div class="card-content">
                                            <span class="skill-icon">🏆</span>
                                            <span>Full Test</span>
                                        </div>
                                    </label>
                                    <label class="skill-card">
                                        <input type="radio" name="skillFocusFilter" value="Listening" onchange="filterExams()">
                                        <div class="card-content">
                                            <span class="skill-icon">🎧</span>
                                            <span>Listening</span>
                                        </div>
                                    </label>
                                    <label class="skill-card">
                                        <input type="radio" name="skillFocusFilter" value="Reading" onchange="filterExams()">
                                        <div class="card-content">
                                            <span class="skill-icon">📖</span>
                                            <span>Reading</span>
                                        </div>
                                    </label>
                                    <label class="skill-card">
                                        <input type="radio" name="skillFocusFilter" value="Writing" onchange="filterExams()">
                                        <div class="card-content">
                                            <span class="skill-icon">✍️</span>
                                            <span>Writing</span>
                                        </div>
                                    </label>
                                    <label class="skill-card">
                                        <input type="radio" name="skillFocusFilter" value="Speaking" onchange="filterExams()">
                                        <div class="card-content">
                                            <span class="skill-icon">🎙️</span>
                                            <span>Speaking</span>
                                        </div>
                                    </label>
                                </div>
                            </c:if>

                            <input type="text" id="examSearchInput" class="search-input" placeholder="🔍 Tìm kiếm bài thi theo tên..." onkeyup="filterExams()">
                        </div>

                        <div class="exam-cards-grid" id="examListContainer">
                            <c:forEach var="ex" items="${exams}">
                                <div class="exam-card-item" data-title="${ex.title.toLowerCase()}" data-skill="${ex.skillFocus}">
                                    <div>
                                        <div class="exam-title">${ex.title}</div>
                                        <div class="exam-info">
                                            <span>⏱️ ${ex.duration} phút</span>
                                            <span class="exam-badge">${ex.skillFocus eq 'All' ? 'Full Test' : ex.skillFocus}</span>
                                        </div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/candidate/mock-test" method="post" style="margin-top: auto;">
                                        <input type="hidden" name="action" value="start">
                                        <input type="hidden" name="testMode" value="${empty param.mode ? 'practice' : param.mode}">
                                        <input type="hidden" name="examId" value="${ex.examId}">
                                        <input type="hidden" name="skillFocus" class="hidden-skill-input" value="All">
                                        
                                        <button type="submit" class="btn-exam-start">
                                            🚀 Bắt đầu thi
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="rules-box" style="max-width: 1000px; margin: 40px auto 0;">
                            <h3>⚠️ Quy định phòng thi</h3>
                            <ul>
                                <li>Bài thi sẽ bắt đầu ở chế độ <strong>Toàn màn hình</strong>.</li>
                                <li>Nếu bạn thoát toàn màn hình hoặc chuyển tab quá <strong>3 lần</strong>, bài thi sẽ tự động nộp và bị đánh dấu vi phạm.</li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-exam-card">
                            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414A1 1 0 0119 9.414V19a2 2 0 01-2 2z"/>
                            </svg>
                            <p style="margin-bottom: 20px;">Hiện tại chưa có đề thi Mock Test nào.<br>Mentor đang chuẩn bị đề thi, vui lòng quay lại sau!</p>
                            <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn-exam-start"
                               style="display:inline-block; text-decoration:none; max-width: 200px;">
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
        function filterExams() {
            const searchInput = document.getElementById('examSearchInput');
            const searchText = searchInput ? searchInput.value.toLowerCase() : '';
            
            let selectedSkill = 'All';
            const modeVal = document.getElementById('hiddenTestMode').value;
            
            if (modeVal === 'practice') {
                const checkedRadio = document.querySelector('input[name="skillFocusFilter"]:checked');
                if (checkedRadio) {
                    selectedSkill = checkedRadio.value;
                }
                
                // Update hidden inputs in all forms
                document.querySelectorAll('.hidden-skill-input').forEach(input => {
                    input.value = selectedSkill;
                });
            }

            const cards = document.querySelectorAll('.exam-card-item');
            cards.forEach(card => {
                const title = card.getAttribute('data-title');
                const cardSkill = card.getAttribute('data-skill');
                
                let matchesSearch = title.includes(searchText);
                let matchesSkill = true;
                
                if (modeVal === 'practice' && selectedSkill !== 'All') {
                    if (cardSkill !== 'All' && cardSkill !== selectedSkill) {
                        matchesSkill = false;
                    }
                }
                
                if (matchesSearch && matchesSkill) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            filterExams();
        });
    </script>
</body>
</html>

