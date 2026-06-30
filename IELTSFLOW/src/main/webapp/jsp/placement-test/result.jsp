<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thi – IELTSFLOW</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── Result page styles ─────────────────────────────── */
        .result-header {
            text-align: center;
            padding: 30px 20px 24px;
        }
        .result-badge {
            display: inline-block;
            padding: 5px 18px;
            border-radius: 100px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .06em;
            margin-bottom: 16px;
        }
        .result-badge.completed { background: rgba(16,185,129,.15); color: var(--accent-green); border: 1px solid rgba(16,185,129,.3); }
        .result-badge.abandoned { background: rgba(239,68,68,.15);  color: var(--accent-red);   border: 1px solid rgba(239,68,68,.3); }

        .result-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 8px; }
        .result-header p  { color: var(--text-secondary); font-size: 0.95rem; }

        /* Violation notice */
        .violation-notice {
            max-width: 880px;
            margin: 0 auto 20px;
            padding: 14px 20px;
            background: rgba(239,68,68,.1);
            border: 1px solid rgba(239,68,68,.3);
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: .9rem;
            color: var(--accent-red);
        }

        /* Band score grid */
        .band-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 16px;
            max-width: 880px;
            margin: 0 auto 30px;
        }
        .band-card {
            background: var(--bg-surface);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 24px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: transform .2s;
        }
        .band-card:hover { transform: translateY(-3px); }
        .band-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: var(--grad); }
        .band-card.listening { --grad: linear-gradient(90deg,#10b981,#059669); }
        .band-card.reading   { --grad: linear-gradient(90deg,#6366f1,#8b5cf6); }
        .band-card.writing   { --grad: linear-gradient(90deg,#f59e0b,#ef4444); }
        .band-card.speaking  { --grad: linear-gradient(90deg,#ec4899,#a855f7); }
        .band-card.overall   { --grad: linear-gradient(90deg,#6366f1,#ec4899); grid-column: span 2; }
        .band-icon   { font-size: 1.75rem; margin-bottom: 6px; }
        .band-label  { font-size: .72rem; text-transform: uppercase; letter-spacing: .08em; color: var(--text-secondary); margin-bottom: 6px; }
        .band-score  { font-size: 3rem; font-weight: 800; line-height: 1; }
        .band-score.listening { color: #10b981; }
        .band-score.reading   { color: #6366f1; }
        .band-score.writing   { color: #f59e0b; }
        .band-score.speaking  { color: #ec4899; }
        .band-score.overall   { background: linear-gradient(135deg,#6366f1,#ec4899); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .band-pending { font-size: 1rem; color: var(--text-secondary); font-style: italic; }

        /* Action buttons */
        .result-actions {
            display: flex;
            gap: 14px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 40px;
        }
        .btn-result {
            padding: 12px 28px;
            border-radius: 12px;
            font-family: inherit;
            font-size: .9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all .2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
        }
        .btn-result.primary {
            background: linear-gradient(135deg, var(--accent-blue), #8b5cf6);
            color: #fff;
        }
        .btn-result.primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(59,130,246,.35); }
        .btn-result.outline {
            background: transparent;
            color: var(--text-primary);
            border: 1px solid var(--glass-border);
        }
        .btn-result.outline:hover { border-color: var(--accent-blue); color: var(--accent-blue); }
    </style>
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-3"></div>

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
            <div class="result-header animate-fade-up">
                <div class="result-badge ${submission.status == 'Completed' ? 'completed' : 'abandoned'}">
                    ${submission.status == 'Completed' ? '✅ Hoàn thành' : '⚠️ Bị gián đoạn'}
                </div>
                <h1>${submission.examTitle}</h1>
                <p>
                    Kết quả bài thi Placement Test •
                    <fmt:formatDate value="${submission.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm" type="both"/>
                </p>
                <c:if test="${not empty timeTaken}">
                    <p style="margin-top: 8px; color: var(--accent-blue); font-weight: 500;">⏱️ Thời gian làm bài thực tế: ${timeTaken}</p>
                </c:if>
            </div>

            <c:if test="${submission.cheated}">
                <div class="violation-notice animate-fade-up" style="animation-delay:.05s;">
                    ⚠️
                    <span>Bài thi này đã bị đánh dấu <strong>vi phạm</strong> (thoát màn hình / chuyển tab quá ${submission.violationCount} lần). Kết quả có thể không phản ánh đúng trình độ.</span>
                </div>
            </c:if>

            <div class="band-grid animate-fade-up" style="animation-delay:.1s;">
                <div class="band-card listening">
                    <div class="band-icon">🎧</div>
                    <div class="band-label">Listening</div>
                    <c:choose>
                        <c:when test="${submission.listeningBand != null}">
                            <div class="band-score listening"><fmt:formatNumber value="${submission.listeningBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
                    </c:choose>
                </div>

                <div class="band-card reading">
                    <div class="band-icon">📖</div>
                    <div class="band-label">Reading</div>
                    <c:choose>
                        <c:when test="${submission.readingBand != null}">
                            <div class="band-score reading"><fmt:formatNumber value="${submission.readingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
                    </c:choose>
                </div>

                <div class="band-card writing">
                    <div class="band-icon">✍️</div>
                    <div class="band-label">Writing</div>
                    <c:choose>
                        <c:when test="${submission.writingBand != null}">
                            <div class="band-score writing"><fmt:formatNumber value="${submission.writingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
                    </c:choose>
                </div>

                <div class="band-card speaking">
                    <div class="band-icon">🗣️</div>
                    <div class="band-label">Speaking</div>
                    <c:choose>
                        <c:when test="${submission.speakingBand != null}">
                            <div class="band-score speaking"><fmt:formatNumber value="${submission.speakingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
                    </c:choose>
                </div>

                <div class="band-card overall">
                    <div class="band-icon">🏆</div>
                    <div class="band-label">Overall Band Dự đoán</div>
                    <c:choose>
                        <c:when test="${submission.overallBand != null}">
                            <div class="band-score overall"><fmt:formatNumber value="${submission.overallBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Đang tính toán...</div></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="result-actions animate-fade-up" style="animation-delay:.15s;">
                <a href="${pageContext.request.contextPath}/candidate/placement-test" class="btn-result primary" id="btn-retake">🔄 Thi lại</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="btn-result outline" id="btn-history">📋 Xem lịch sử</a>
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn-result outline" id="btn-dashboard">📊 Về Dashboard</a>
            </div>

            <div class="chart-section animate-fade-up" style="animation-delay:.18s;">
                <h2>🤖 Nhận xét & Phân tích chi tiết</h2>
                
                <!-- Tabs -->
                <div class="feedback-tabs">
                    <button class="tab-btn active" onclick="showFeedbackTab(event, 'listening')">🎧 Listening</button>
                    <button class="tab-btn" onclick="showFeedbackTab(event, 'reading')">📖 Reading</button>
                    <button class="tab-btn" onclick="showFeedbackTab(event, 'writing')">✍️ Writing</button>
                    <button class="tab-btn" onclick="showFeedbackTab(event, 'speaking')">🗣️ Speaking</button>
                </div>

                <!-- Tab Contents -->
                <%-- TAB: LISTENING ANSWER REVIEW --%>
                <div id="tab-listening" class="feedback-content" style="display: block;">
                    <c:choose>
                        <c:when test="${not empty listeningReview}">
                            <c:set var="listenCorrect" value="0"/>
                            <c:forEach var="item" items="${listeningReview}">
                                <c:if test="${item.correct}"><c:set var="listenCorrect" value="${listenCorrect + 1}"/></c:if>
                            </c:forEach>
                            <div style="background: rgba(99,179,237,0.1); border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; display: flex; align-items: center; gap: 12px;">
                                <span style="font-size: 2rem; font-weight: 700; color: var(--accent-blue);">${listenCorrect}/${fn:length(listeningReview)}</span>
                                <span style="color: var(--text-secondary);">câu đúng</span>
                            </div>
                            <c:forEach var="item" items="${listeningReview}" varStatus="st">
                                <div style="display:flex; gap:12px; padding:12px; border-radius:10px; margin-bottom:10px;
                                            background: ${item.correct ? 'rgba(16,185,129,0.06)' : 'rgba(239,68,68,0.06)'};
                                            border-left: 4px solid ${item.correct ? '#10b981' : '#ef4444'};">
                                    <div style="font-size:1.4rem; margin-top:2px;">${item.correct ? '✅' : '❌'}</div>
                                    <div style="flex:1;">
                                        <div style="font-weight:600; margin-bottom:6px; font-size:0.95rem;">${st.count}. ${item.questionContent}</div>
                                        <c:if test="${not empty item.options}">
                                            <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:8px;">
                                                <c:forEach var="opt" items="${item.options}">
                                                    <span style="padding: 2px 10px; border-radius: 20px; font-size:0.85rem;
                                                        background: ${opt == item.correctAnswer ? 'rgba(16,185,129,0.2)' : (opt == item.candidateAnswer && !item.correct ? 'rgba(239,68,68,0.15)' : 'rgba(255,255,255,0.05)')};
                                                        border: 1px solid ${opt == item.correctAnswer ? '#10b981' : (opt == item.candidateAnswer && !item.correct ? '#ef4444' : 'transparent')};">
                                                        ${opt}<c:if test="${opt == item.correctAnswer}"> ✓</c:if>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                        <div style="font-size:0.88rem; display:flex; gap:16px; flex-wrap:wrap;">
                                            <span>Bạn trả lời: <strong style="color:${item.correct ? '#10b981' : '#ef4444'};">${empty item.candidateAnswer ? '(bỏ trống)' : item.candidateAnswer}</strong></span>
                                            <c:if test="${!item.correct}">
                                                <span>Đáp án đúng: <strong style="color:#10b981;">${item.correctAnswer}</strong></span>
                                            </c:if>
                                        </div>
                                        <c:if test="${not empty item.explanation}">
                                            <div style="margin-top:6px; font-size:0.85rem; color:var(--text-secondary); font-style:italic;">${item.explanation}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color:var(--text-secondary); font-style:italic;">Bạn không có câu hỏi Listening trong bài thi này.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- TAB: READING ANSWER REVIEW --%>
                <div id="tab-reading" class="feedback-content" style="display: none;">
                    <c:choose>
                        <c:when test="${not empty readingReview}">
                            <c:set var="readCorrect" value="0"/>
                            <c:forEach var="item" items="${readingReview}">
                                <c:if test="${item.correct}"><c:set var="readCorrect" value="${readCorrect + 1}"/></c:if>
                            </c:forEach>
                            <div style="background: rgba(52,211,153,0.1); border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; display: flex; align-items: center; gap: 12px;">
                                <span style="font-size: 2rem; font-weight: 700; color: #10b981;">${readCorrect}/${fn:length(readingReview)}</span>
                                <span style="color: var(--text-secondary);">câu đúng</span>
                            </div>
                            <c:forEach var="item" items="${readingReview}" varStatus="st">
                                <div style="display:flex; gap:12px; padding:12px; border-radius:10px; margin-bottom:10px;
                                            background: ${item.correct ? 'rgba(16,185,129,0.06)' : 'rgba(239,68,68,0.06)'};
                                            border-left: 4px solid ${item.correct ? '#10b981' : '#ef4444'};">
                                    <div style="font-size:1.4rem; margin-top:2px;">${item.correct ? '✅' : '❌'}</div>
                                    <div style="flex:1;">
                                        <div style="font-weight:600; margin-bottom:6px; font-size:0.95rem;">${st.count}. ${item.questionContent}</div>
                                        <c:if test="${not empty item.options}">
                                            <div style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:8px;">
                                                <c:forEach var="opt" items="${item.options}">
                                                    <span style="padding: 2px 10px; border-radius: 20px; font-size:0.85rem;
                                                        background: ${opt == item.correctAnswer ? 'rgba(16,185,129,0.2)' : (opt == item.candidateAnswer && !item.correct ? 'rgba(239,68,68,0.15)' : 'rgba(255,255,255,0.05)')};
                                                        border: 1px solid ${opt == item.correctAnswer ? '#10b981' : (opt == item.candidateAnswer && !item.correct ? '#ef4444' : 'transparent')};">
                                                        ${opt}<c:if test="${opt == item.correctAnswer}"> ✓</c:if>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                        <div style="font-size:0.88rem; display:flex; gap:16px; flex-wrap:wrap;">
                                            <span>Bạn trả lời: <strong style="color:${item.correct ? '#10b981' : '#ef4444'};">${empty item.candidateAnswer ? '(bỏ trống)' : item.candidateAnswer}</strong></span>
                                            <c:if test="${!item.correct}">
                                                <span>Đáp án đúng: <strong style="color:#10b981;">${item.correctAnswer}</strong></span>
                                            </c:if>
                                        </div>
                                        <c:if test="${not empty item.explanation}">
                                            <div style="margin-top:6px; font-size:0.85rem; color:var(--text-secondary); font-style:italic;">${item.explanation}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color:var(--text-secondary); font-style:italic;">Bạn không có câu hỏi Reading trong bài thi này.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="tab-writing" class="feedback-content" style="display: none;">
                    <c:choose>
                        <c:when test="${not empty writingFeedbacks}">
                            <c:forEach var="fw" items="${writingFeedbacks}" varStatus="st">
                                <div style="background: rgba(245, 158, 11, 0.05); padding: 16px; border-radius: 12px; margin-bottom: 16px; border-left: 4px solid var(--accent-orange);">
                                    <h4 style="margin-top: 0; margin-bottom: 10px; color: #d97706;">Task ${st.count}</h4>
                                    
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 12px; font-size: 0.95rem;">
                                        <div><strong>Task Response:</strong> ${fw.taskResponse}</div>
                                        <div><strong>Coherence & Cohesion:</strong> ${fw.coherenceAndCohesion}</div>
                                        <div><strong>Lexical Resource:</strong> ${fw.lexicalResource}</div>
                                        <div><strong>Grammar:</strong> ${fw.grammaticalRangeAndAccuracy}</div>
                                    </div>
                                    
                                    <c:if test="${not empty fw.overallFeedback}">
                                        <div style="margin-bottom: 12px; font-size: 0.95rem;">
                                            <strong>Nhận xét chung:</strong>
                                            <p style="margin-top: 4px; color: var(--text-secondary); line-height: 1.5;">${fw.overallFeedback}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty fw.mistakes}">
                                        <div style="margin-top: 10px; font-size: 0.95rem;">
                                            <strong>Các lỗi cần sửa:</strong>
                                            <ul style="padding-left: 20px; margin-top: 5px; color: var(--text-secondary);">
                                            <c:forEach var="m" items="${fw.mistakes}">
                                                <li style="margin-bottom: 6px;">
                                                    Sai: <span style="color: #ef4444; text-decoration: line-through;">${m.mistake}</span> 
                                                    &rarr; Sửa: <span style="color: #10b981;">${m.correction}</span> 
                                                    (<i>${m.reason}</i>)
                                                </li>
                                            </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${submission.writingBand == null}">
                                    <p style="color: var(--text-secondary); font-style: italic;">Hệ thống AI đang chấm điểm phần thi này. Vui lòng tải lại trang (F5) sau ít phút để xem kết quả chi tiết.</p>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: var(--text-secondary); font-style: italic;">Bạn không có bài thi Writing hoặc không có nhận xét AI cho phần này.</p>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="tab-speaking" class="feedback-content" style="display: none;">
                    <c:choose>
                        <c:when test="${not empty speakingFeedbacks}">
                            <c:forEach var="fs" items="${speakingFeedbacks}" varStatus="st">
                                <div style="background: rgba(236, 72, 153, 0.05); padding: 16px; border-radius: 12px; margin-bottom: 16px; border-left: 4px solid var(--accent-pink);">
                                    <h4 style="margin-top: 0; margin-bottom: 10px; color: #db2777;">Phần ${st.count}</h4>
                                    
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 12px; font-size: 0.95rem;">
                                        <div><strong>Fluency & Coherence:</strong> ${fs.fluencyAndCoherence}</div>
                                        <div><strong>Lexical Resource:</strong> ${fs.lexicalResource}</div>
                                        <div><strong>Grammar:</strong> ${fs.grammaticalRangeAndAccuracy}</div>
                                        <div><strong>Pronunciation:</strong> ${fs.pronunciation}</div>
                                    </div>
                                    
                                    <c:if test="${not empty fs.overallFeedback}">
                                        <div style="margin-bottom: 12px; font-size: 0.95rem;">
                                            <strong>Nhận xét chung:</strong>
                                            <p style="margin-top: 4px; color: var(--text-secondary); line-height: 1.5;">${fs.overallFeedback}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty fs.mistakes}">
                                        <div style="margin-top: 10px; font-size: 0.95rem;">
                                            <strong>Các lỗi cần sửa:</strong>
                                            <ul style="padding-left: 20px; margin-top: 5px; color: var(--text-secondary);">
                                            <c:forEach var="m" items="${fs.mistakes}">
                                                <li style="margin-bottom: 6px;">
                                                    Sai: <span style="color: #ef4444; text-decoration: line-through;">${m.mistake}</span> 
                                                    &rarr; Sửa: <span style="color: #10b981;">${m.correction}</span> 
                                                    (<i>${m.reason}</i>)
                                                </li>
                                            </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${submission.speakingBand == null}">
                                    <p style="color: var(--text-secondary); font-style: italic;">Hệ thống AI đang chấm điểm phần thi này. Vui lòng tải lại trang (F5) sau ít phút để xem kết quả chi tiết.</p>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: var(--text-secondary); font-style: italic;">Bạn không có bài thi Speaking hoặc không có nhận xét AI cho phần này.</p>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
    <script>
        function showFeedbackTab(event, tabId) {
            document.querySelectorAll('.feedback-content').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
            
            document.getElementById('tab-' + tabId).style.display = 'block';
            event.currentTarget.classList.add('active');
        }
    </script>
    <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
</body>
</html>

