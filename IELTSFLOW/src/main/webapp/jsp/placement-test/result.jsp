<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            </div>

            <%-- Violation notice --%>
            <c:if test="${submission.cheated}">
                <div class="violation-notice animate-fade-up" style="animation-delay:.05s;">
                    ⚠️
                    <span>Bài thi này đã bị đánh dấu <strong>vi phạm</strong> (thoát màn hình / chuyển tab quá ${submission.violationCount} lần). Kết quả có thể không phản ánh đúng trình độ.</span>
                </div>
            </c:if>

            <%-- Band Scores --%>
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

            <%-- Actions --%>
            <div class="result-actions animate-fade-up" style="animation-delay:.15s;">
                <a href="${pageContext.request.contextPath}/candidate/placement-test"
                   class="btn-result primary" id="btn-retake">
                    🔄 Thi lại
                </a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises"
                   class="btn-result outline" id="btn-history">
                    📋 Xem lịch sử
                </a>
                <a href="${pageContext.request.contextPath}/candidate/dashboard"
                   class="btn-result outline" id="btn-dashboard">
                    📊 Về Dashboard
                </a>
            </div>
        </main>
    </div>
</body>
</html>
