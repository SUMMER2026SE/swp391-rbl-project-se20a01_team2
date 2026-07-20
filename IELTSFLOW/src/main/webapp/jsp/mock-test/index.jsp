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

        /* Select box styles (Legacy - removed) */

        /* New Search & Grid Styles */
        .exam-list-container {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 32px;
            max-width: 800px;
            margin: 0 auto;
        }
        .search-filter-bar {
            display: flex;
            flex-direction: column;
            gap: 16px;
            margin-bottom: 24px;
        }
        .search-input-wrapper {
            position: relative;
            width: 100%;
        }
        .search-input-wrapper svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }
        .search-input {
            width: 100%;
            padding: 12px 16px 12px 42px;
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            background: rgba(255,255,255,0.8);
            font-size: 1rem;
            font-weight: 500;
            font-family: inherit;
            color: var(--text-primary);
            outline: none;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99,102,241,.15);
            background: #fff;
        }
        
        .filter-chips {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter-chip {
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            background: rgba(255,255,255,0.5);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
            user-select: none;
        }
        .filter-chip.active {
            background: #6366f1;
            color: white;
            border-color: #6366f1;
            box-shadow: 0 4px 12px rgba(99,102,241, 0.2);
        }
        .filter-chip:hover:not(.active) {
            background: rgba(99,102,241,0.1);
        }

        .exam-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
            max-height: 400px;
            overflow-y: auto;
            padding-right: 8px;
        }
        .exam-grid::-webkit-scrollbar { width: 6px; }
        .exam-grid::-webkit-scrollbar-track { background: transparent; }
        .exam-grid::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.15); border-radius: 10px; }
        .exam-grid::-webkit-scrollbar-thumb:hover { background: rgba(0,0,0,0.25); }

        .exam-item-card {
            background: #fff;
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .exam-item-card:hover {
            border-color: rgba(99,102,241, 0.4);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }
        .exam-item-card.selected {
            border-color: #6366f1;
            background: rgba(99,102,241, 0.03);
            box-shadow: 0 8px 20px rgba(99,102,241, 0.15);
        }
        .exam-item-card.selected::after {
            content: '✓';
            position: absolute;
            top: 12px;
            right: 12px;
            background: #6366f1;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: bold;
        }
        .exam-item-title {
            font-weight: 700;
            font-size: 1rem;
            color: var(--text-primary);
            line-height: 1.4;
            padding-right: 24px;
        }
        .exam-item-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
        }
        .exam-skill-badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 8px;
            background: rgba(99,102,241, 0.1);
            color: #6366f1;
            text-transform: uppercase;
        }
        .exam-duration {
            font-size: 0.8rem;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .no-results {
            text-align: center;
            padding: 32px;
            color: var(--text-secondary);
            grid-column: 1 / -1;
            font-weight: 500;
        }

        /* Skill Radio Cards (Legacy - removed) */

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
        <main class="main-content" id="appMainContent">
            <div class="mock-hero animate-fade-up">
                <div class="hero-badge">🎯 ${empty param.mode or param.mode eq 'practice' ? 'Practice Test' : 'Mock Test'}</div>
                <h1>${empty param.mode or param.mode eq 'practice' ? 'Luyện Tập Kỹ Năng' : 'Thi Thử IELTS'}</h1>
                <p>${empty param.mode or param.mode eq 'practice' ? 'Luyện tập các kỹ năng IELTS với đề thi được chọn.' : 'Trải nghiệm thi thực tế với đề ngẫu nhiên từ ngân hàng đề của Mentor. Kết quả được ghi vào hồ sơ học tập.'}</p>
            </div>

            <div class="animate-fade-up" style="animation-delay:0.1s;">
                <c:choose>
                    <c:when test="${not empty exams}">
                        <div class="exam-list-container">
                            <form action="${pageContext.request.contextPath}/candidate/mock-test" method="post" id="mockTestForm">
                                <input type="hidden" name="action" value="start">
                                <input type="hidden" name="testMode" id="hiddenTestMode" value="${empty param.mode ? 'practice' : param.mode}">
                                <input type="hidden" name="examId" id="selectedExamId" value="" required>
                                <input type="hidden" name="skillFocus" id="selectedSkillFocus" value="All">
                                
                                <div class="search-filter-bar">
                                    <div class="search-input-wrapper">
                                        <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                        </svg>
                                        <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm đề thi..." onkeyup="filterExams()">
                                    </div>
                                    <div class="filter-chips" id="filterChips">
                                        <div class="filter-chip active" data-skill="All" onclick="setFilter('All')">Tất cả</div>
                                        <div class="filter-chip" data-skill="Listening" onclick="setFilter('Listening')">Listening</div>
                                        <div class="filter-chip" data-skill="Reading" onclick="setFilter('Reading')">Reading</div>
                                        <div class="filter-chip" data-skill="Writing" onclick="setFilter('Writing')">Writing</div>
                                        <div class="filter-chip" data-skill="Speaking" onclick="setFilter('Speaking')">Speaking</div>
                                        <div class="filter-chip" id="fullTestChip" data-skill="FullTest" onclick="setFilter('FullTest')">Full Test</div>
                                    </div>
                                </div>

                                <div class="exam-grid" id="examGrid">
                                    <c:forEach var="ex" items="${exams}">
                                        <div class="exam-item-card" 
                                             data-id="${ex.examId}" 
                                             data-skill="${ex.skillFocus}" 
                                             data-title="${ex.title.toLowerCase()}"
                                             onclick="selectExam(this, '${ex.examId}', '${empty ex.skillFocus ? 'All' : ex.skillFocus}')">
                                            <div class="exam-item-title">${ex.title}</div>
                                            <div class="exam-item-meta">
                                                <div class="exam-skill-badge">${empty ex.skillFocus or ex.skillFocus eq 'All' ? 'Full Test' : ex.skillFocus}</div>
                                                <div class="exam-duration">
                                                    <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                    </svg>
                                                    ${ex.duration} phút
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <div id="noResultsMsg" class="no-results" style="display: none;">
                                        Không tìm thấy đề thi phù hợp.
                                    </div>
                                </div>

                                <div class="rules-box">
                                    <h3>⚠️ Quy định phòng thi</h3>
                                    <ul>
                                        <li>Bài thi sẽ bắt đầu ở chế độ <strong>Toàn màn hình</strong>.</li>
                                        <li>Nếu bạn thoát toàn màn hình hoặc chuyển tab quá <strong>3 lần</strong>, bài thi sẽ tự động nộp và bị đánh dấu vi phạm.</li>
                                    </ul>
                                </div>

                                <button type="submit" class="btn-start-mock" id="btn-start-mock-test" disabled style="opacity: 0.6; cursor: not-allowed;">
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
        let currentFilter = 'All';

        function setFilter(skill) {
            currentFilter = skill;
            document.querySelectorAll('.filter-chip').forEach(chip => {
                if (chip.getAttribute('data-skill') === skill) {
                    chip.classList.add('active');
                } else {
                    chip.classList.remove('active');
                }
            });
            filterExams();
        }

        function filterExams() {
            const searchInput = document.getElementById('searchInput');
            if (!searchInput) return; // Guard in case of empty exams
            const searchTerm = searchInput.value.toLowerCase();
            const cards = document.querySelectorAll('.exam-item-card');
            let visibleCount = 0;

            cards.forEach(card => {
                // If hidden by mode, skip
                if (card.classList.contains('hidden-by-mode')) {
                    card.style.display = 'none';
                    return;
                }
                
                const title = card.getAttribute('data-title');
                const skill = card.getAttribute('data-skill'); 
                
                let matchesSearch = title.includes(searchTerm);
                let matchesFilter = false;
                
                if (currentFilter === 'All') {
                    matchesFilter = true;
                } else if (currentFilter === 'FullTest') {
                    matchesFilter = (skill === 'All' || !skill);
                } else {
                    matchesFilter = (skill === currentFilter);
                }

                if (matchesSearch && matchesFilter) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const noResultsMsg = document.getElementById('noResultsMsg');
            if (noResultsMsg) {
                noResultsMsg.style.display = visibleCount === 0 ? 'block' : 'none';
            }
        }

        function selectExam(card, id, skill) {
            document.querySelectorAll('.exam-item-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            
            document.getElementById('selectedExamId').value = id;
            document.getElementById('selectedSkillFocus').value = skill;

            const btn = document.getElementById('btn-start-mock-test');
            if (btn) {
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor = 'pointer';
            }
        }

        function handleModeChange() {
            const modeVal = document.getElementById('hiddenTestMode');
            if (!modeVal) return;
            const fullTestChip = document.getElementById('fullTestChip');
            
            if (modeVal.value === 'practice') {
                if (fullTestChip) fullTestChip.style.display = 'none';
                
                // Hide Full tests in practice mode
                document.querySelectorAll('.exam-item-card').forEach(card => {
                    const skill = card.getAttribute('data-skill');
                    if (skill === 'All' || !skill) {
                        card.classList.add('hidden-by-mode');
                    }
                });
            } else {
                if (fullTestChip) fullTestChip.style.display = 'block';
            }
            
            filterExams();
        }

        document.addEventListener('DOMContentLoaded', () => {
            handleModeChange();
        });
    </script>
</body>
</html>

