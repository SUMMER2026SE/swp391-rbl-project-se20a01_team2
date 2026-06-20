<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Result – IELTSFLOW</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
    <style>
        .result-header { text-align: center; padding: 30px 20px 24px; }
        .result-badge {
            display: inline-block; padding: 5px 18px; border-radius: 100px;
            font-size: 0.78rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .06em; margin-bottom: 16px;
        }
        .result-badge.completed { background: rgba(16,185,129,.15); color: var(--accent-green); border: 1px solid rgba(16,185,129,.3); }
        .result-badge.abandoned { background: rgba(239,68,68,.15);  color: var(--accent-red);   border: 1px solid rgba(239,68,68,.3); }
        .result-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 8px; }
        .result-header p  { color: var(--text-secondary); font-size: 0.95rem; }

        .violation-notice {
            max-width: 880px; margin: 0 auto 20px; padding: 14px 20px;
            background: rgba(239,68,68,.1); border: 1px solid rgba(239,68,68,.3);
            border-radius: 12px; display: flex; align-items: center; gap: 12px;
            font-size: .9rem; color: var(--accent-red);
        }

        .band-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 16px; max-width: 880px; margin: 0 auto 30px;
        }
        .band-card {
            background: var(--bg-surface); border: 1px solid var(--glass-border);
            border-radius: 20px; padding: 24px 20px; text-align: center;
            position: relative; overflow: hidden; transition: transform .2s;
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

        .result-actions {
            display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; margin-bottom: 40px;
        }
        .btn-result {
            padding: 12px 28px; border-radius: 12px; font-family: inherit;
            font-size: .9rem; font-weight: 700; cursor: pointer; transition: all .2s;
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px; border: none;
        }
        .btn-result.primary { background: linear-gradient(135deg, var(--accent-blue), #8b5cf6); color: #fff; }
        .btn-result.primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(59,130,246,.35); }
        .btn-result.outline { background: transparent; color: var(--text-primary); border: 1px solid var(--glass-border); }
        .btn-result.outline:hover { border-color: var(--accent-blue); color: var(--accent-blue); }

        /* Chart container */
        .chart-section {
            max-width: 880px; margin: 0 auto 30px;
            background: var(--bg-surface); border: 1px solid var(--glass-border);
            border-radius: 20px; padding: 24px;
        }
        .chart-section h2 { margin-bottom: 16px; font-size: 1.2rem; }
        .chart-wrapper { position: relative; height: 300px; }

        /* History table */
        .history-section {
            max-width: 880px; margin: 0 auto 40px;
            background: var(--bg-surface); border: 1px solid var(--glass-border);
            border-radius: 20px; padding: 24px;
        }
        .history-section h2 { margin-bottom: 16px; font-size: 1.2rem; }
        .history-table { width: 100%; border-collapse: collapse; }
        .history-table th {
            text-align: left; padding: 10px 12px; font-size: .75rem;
            text-transform: uppercase; letter-spacing: .06em;
            color: var(--text-secondary); border-bottom: 1px solid var(--glass-border);
        }
        .history-table td {
            padding: 12px; font-size: .88rem; border-bottom: 1px solid var(--glass-border);
        }
        .history-table tr:hover td { background: rgba(99,102,241,.04); }
        .status-badge {
            padding: 3px 10px; border-radius: 20px; font-size: .72rem; font-weight: 600;
        }
        .status-badge.completed { background: rgba(16,185,129,.15); color: #10b981; }
        .status-badge.abandoned { background: rgba(239,68,68,.15); color: #ef4444; }
        .status-badge.inprogress { background: rgba(245,158,11,.15); color: #f59e0b; }
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
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 History & Redo</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Notifications</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Support</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Settings</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="result-header animate-fade-up">
                <div class="result-badge ${submission.status == 'Completed' ? 'completed' : 'abandoned'}">
                    ${submission.status == 'Completed' ? '✅ Completed' : '⚠️ Interrupted'}
                </div>
                <h1>${submission.examTitle}</h1>
                <p>Test Result • ${submission.examType}</p>
            </div>

            <%-- Violation notice --%>
            <c:if test="${submission.cheated}">
                <div class="violation-notice animate-fade-up" style="animation-delay:.05s;">
                    ⚠️
                    <span>This test was flagged for <strong>violations</strong> (${submission.violationCount} tab switches / fullscreen exits). Results may not reflect true proficiency.</span>
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
                        <c:otherwise><div class="band-pending">N/A</div></c:otherwise>
                    </c:choose>
                </div>
                <div class="band-card reading">
                    <div class="band-icon">📖</div>
                    <div class="band-label">Reading</div>
                    <c:choose>
                        <c:when test="${submission.readingBand != null}">
                            <div class="band-score reading"><fmt:formatNumber value="${submission.readingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">N/A</div></c:otherwise>
                    </c:choose>
                </div>
                <div class="band-card writing">
                    <div class="band-icon">✍️</div>
                    <div class="band-label">Writing</div>
                    <c:choose>
                        <c:when test="${submission.writingBand != null}">
                            <div class="band-score writing"><fmt:formatNumber value="${submission.writingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">N/A</div></c:otherwise>
                    </c:choose>
                </div>
                <div class="band-card speaking">
                    <div class="band-icon">🗣️</div>
                    <div class="band-label">Speaking</div>
                    <c:choose>
                        <c:when test="${submission.speakingBand != null}">
                            <div class="band-score speaking"><fmt:formatNumber value="${submission.speakingBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">N/A</div></c:otherwise>
                    </c:choose>
                </div>
                <div class="band-card overall">
                    <div class="band-icon">🏆</div>
                    <div class="band-label">Overall Band</div>
                    <c:choose>
                        <c:when test="${submission.overallBand != null}">
                            <div class="band-score overall"><fmt:formatNumber value="${submission.overallBand}" pattern="0.0"/></div>
                        </c:when>
                        <c:otherwise><div class="band-pending">Calculating...</div></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Actions --%>
            <div class="result-actions animate-fade-up" style="animation-delay:.15s;">
                <a href="${pageContext.request.contextPath}/candidate/tests" class="btn-result primary">🔄 Take Another Test</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="btn-result outline">📋 Full History</a>
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn-result outline">📊 Dashboard</a>
            </div>

            <%-- Progress Chart --%>
            <c:if test="${not empty history && history.size() > 1}">
            <div class="chart-section animate-fade-up" style="animation-delay:.2s;">
                <h2>📈 Band Score Progress</h2>
                <div class="chart-wrapper">
                    <canvas id="progressChart"></canvas>
                </div>
            </div>
            </c:if>

            <%-- History Table --%>
            <c:if test="${not empty history}">
            <div class="history-section animate-fade-up" style="animation-delay:.25s;">
                <h2>📋 Test History</h2>
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Exam</th>
                            <th>Type</th>
                            <th>L</th>
                            <th>R</th>
                            <th>W</th>
                            <th>S</th>
                            <th>Overall</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${history}" varStatus="st">
                        <tr>
                            <td>${st.count}</td>
                            <td>${h.examTitle}</td>
                            <td>${h.examType}</td>
                            <td><c:choose><c:when test="${h.listeningBand != null}"><fmt:formatNumber value="${h.listeningBand}" pattern="0.0"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${h.readingBand != null}"><fmt:formatNumber value="${h.readingBand}" pattern="0.0"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${h.writingBand != null}"><fmt:formatNumber value="${h.writingBand}" pattern="0.0"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                            <td><c:choose><c:when test="${h.speakingBand != null}"><fmt:formatNumber value="${h.speakingBand}" pattern="0.0"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                            <td style="font-weight:700;"><c:choose><c:when test="${h.overallBand != null}"><fmt:formatNumber value="${h.overallBand}" pattern="0.0"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                            <td>
                                <span class="status-badge ${h.status == 'Completed' ? 'completed' : (h.status == 'Abandoned' ? 'abandoned' : 'inprogress')}">
                                    ${h.status}
                                </span>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            </c:if>
        </main>
    </div>

    <%-- Chart.js Script --%>
    <c:if test="${not empty history && history.size() > 1}">
    <script>
        // Build data arrays from history (reversed so oldest first)
        const labels = [];
        const listening = [], reading = [], writing = [], speaking = [], overall = [];
        <c:forEach var="h" items="${history}">
            labels.unshift('${h.examTitle}');
            listening.unshift(${h.listeningBand != null ? h.listeningBand : 'null'});
            reading.unshift(${h.readingBand != null ? h.readingBand : 'null'});
            writing.unshift(${h.writingBand != null ? h.writingBand : 'null'});
            speaking.unshift(${h.speakingBand != null ? h.speakingBand : 'null'});
            overall.unshift(${h.overallBand != null ? h.overallBand : 'null'});
        </c:forEach>

        new Chart(document.getElementById('progressChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    { label: 'Listening', data: listening, borderColor: '#10b981', backgroundColor: 'rgba(16,185,129,0.1)', tension: 0.3, spanGaps: true },
                    { label: 'Reading',   data: reading,   borderColor: '#6366f1', backgroundColor: 'rgba(99,102,241,0.1)', tension: 0.3, spanGaps: true },
                    { label: 'Writing',   data: writing,   borderColor: '#f59e0b', backgroundColor: 'rgba(245,158,11,0.1)', tension: 0.3, spanGaps: true },
                    { label: 'Speaking',  data: speaking,  borderColor: '#ec4899', backgroundColor: 'rgba(236,72,153,0.1)', tension: 0.3, spanGaps: true },
                    { label: 'Overall',   data: overall,   borderColor: '#8b5cf6', backgroundColor: 'rgba(139,92,246,0.1)', tension: 0.3, borderWidth: 3, spanGaps: true }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { labels: { color: '#94a3b8', font: { size: 12 } } } },
                scales: {
                    x: { ticks: { color: '#94a3b8', maxRotation: 45 }, grid: { color: 'rgba(255,255,255,0.05)' } },
                    y: { min: 0, max: 9, ticks: { color: '#94a3b8', stepSize: 0.5 }, grid: { color: 'rgba(255,255,255,0.05)' } }
                }
            }
        });
    </script>
    </c:if>
</body>
</html>
