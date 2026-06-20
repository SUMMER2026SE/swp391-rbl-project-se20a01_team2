<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <title>Exam History – IELTSFLOW</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        /* ── Stat Summary Cards ─────────────────────────── */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 24px 20px;
            text-align: center;
            transition: transform 0.3s;
        }
        .summary-card:hover { transform: translateY(-4px); }
        .summary-card .s-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }
        .summary-card .s-value {
            font-size: 2.2rem;
            font-weight: 800;
        }
        .s-value.blue   { color: var(--accent-blue); }
        .s-value.green  { color: var(--accent-green); }
        .s-value.orange { color: var(--accent-orange); }

        /* ── Chart Panel ─────────────────────────────────── */
        .chart-panel {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 28px;
            margin-bottom: 30px;
        }
        .chart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .chart-header h2 { font-size: 1.05rem; font-weight: 700; }
        .legend {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }
        .legend-dot {
            width: 10px; height: 10px; border-radius: 50%;
        }
        .chart-scroll-wrap {
            position: relative;
            height: 280px;
            overflow-x: auto;
            overflow-y: hidden;
            scrollbar-width: thin;
            scrollbar-color: var(--accent-blue) rgba(0,0,0,0.05);
        }
        .chart-scroll-wrap::-webkit-scrollbar { height: 5px; }
        .chart-scroll-wrap::-webkit-scrollbar-thumb {
            background: var(--accent-blue);
            border-radius: 3px;
        }
        .chart-inner { height: 100%; min-width: 100%; }

        .empty-chart {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }
        .empty-chart svg {
            width: 52px; height: 52px;
            margin: 0 auto 12px;
            display: block;
            opacity: 0.3;
        }

        /* ── History Table Panel ─────────────────────────── */
        .history-panel {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 28px;
            margin-bottom: 30px;
        }
        .history-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .history-panel-header h2 { font-size: 1.05rem; font-weight: 700; }

        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .history-table th {
            text-align: left;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--text-secondary);
            padding: 10px 14px;
            border-bottom: 1px solid var(--glass-border);
        }
        .history-table td {
            padding: 14px;
            font-size: 0.88rem;
            border-bottom: 1px solid rgba(0,0,0,0.04);
            vertical-align: middle;
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover td { background: rgba(0,0,0,0.02); }

        /* Band chip */
        .band-chip {
            display: inline-block;
            width: 42px;
            text-align: center;
            padding: 3px 5px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .band-chip.has-val {
            background: rgba(59, 130, 246, 0.15);
            color: var(--accent-blue);
        }
        .band-chip.no-val {
            background: rgba(0,0,0,0.05);
            color: var(--text-secondary);
        }

        /* Status badge */
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.72rem;
            font-weight: 600;
        }
        .status-badge.Completed  { background: rgba(16,185,129,.15); color: var(--accent-green); }
        .status-badge.Abandoned  { background: rgba(239,68,68,.15);  color: var(--accent-red); }
        .status-badge.InProgress { background: rgba(245,158,11,.15); color: var(--accent-orange); }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }
        .empty-state svg {
            width: 52px; height: 52px;
            margin: 0 auto 12px;
            display: block;
            opacity: 0.3;
        }
        .empty-state a { color: var(--accent-blue); text-decoration: none; }

        @media (max-width: 768px) {
            .summary-grid { grid-template-columns: 1fr; }
            .history-table th:nth-child(n+4),
            .history-table td:nth-child(n+4) { display: none; }
        }
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
                <div class="avatar" style="overflow: hidden;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.profilePic}">
                            <img src="${pageContext.request.contextPath}${sessionScope.profilePic}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            ${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Mục tiêu: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link">📅 Kế hoạch tuần</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Thư viện</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="nav-link">🎯 Bài thi</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link active">🔄 Lịch sử & Làm lại</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Đăng xuất</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="animate-fade-up">
                <h1 style="margin-bottom: 8px;">📊 Exam History</h1>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">
                    Theo dõi tiến trình Band Score và xem lại kết quả các bài thi đã làm.
                </p>
            </div>

            <%-- Hiển thị lỗi nếu có --%>
            <c:if test="${not empty historyError}">
                <div class="animate-fade-up" style="background: rgba(239,68,68,.1); border:1px solid rgba(239,68,68,.3);
                            border-radius:12px; padding:16px; margin-bottom:20px; color:var(--accent-red);">
                    ⚠️ ${historyError}
                </div>
            </c:if>

            <%-- ── STAT SUMMARY CARDS ────────────────────────── --%>
            <div class="summary-grid animate-fade-up" style="animation-delay:0.05s;">
                <div class="summary-card">
                    <div class="s-label">Tổng bài đã thi</div>
                    <div class="s-value blue">${totalTests}</div>
                </div>
                <div class="summary-card">
                    <div class="s-label">Band trung bình</div>
                    <div class="s-value green">
                        <c:choose>
                            <c:when test="${avgBand > 0}"><fmt:formatNumber value="${avgBand}" pattern="0.0"/></c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="s-label">Band cao nhất</div>
                    <div class="s-value orange">
                        <c:choose>
                            <c:when test="${maxBand > 0}"><fmt:formatNumber value="${maxBand}" pattern="0.0"/></c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- ── PROGRESS CHART ────────────────────────────── --%>
            <div class="chart-panel animate-fade-up" style="animation-delay:0.1s;">
                <div class="chart-header">
                    <h2>📈 Biểu đồ tiến độ Band Score</h2>
                    <div class="legend">
                        <div class="legend-item"><div class="legend-dot" style="background:#10b981;"></div>Listening</div>
                        <div class="legend-item"><div class="legend-dot" style="background:#3b82f6;"></div>Reading</div>
                        <div class="legend-item"><div class="legend-dot" style="background:#f59e0b;"></div>Writing</div>
                        <div class="legend-item"><div class="legend-dot" style="background:#ec4899;"></div>Speaking</div>
                        <div class="legend-item"><div class="legend-dot" style="background:#8b5cf6;"></div>Overall</div>
                    </div>
                </div>
                <div class="chart-scroll-wrap">
                    <c:choose>
                        <c:when test="${totalTests > 0}">
                            <div class="chart-inner" id="chartContainerInner">
                                <canvas id="progressChart"></canvas>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-chart">
                                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                          d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                                </svg>
                                <p>Chưa có dữ liệu. Hãy hoàn thành bài thi đầu tiên!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- ── HISTORY TABLE ──────────────────────────────── --%>
            <div class="history-panel animate-fade-up" style="animation-delay:0.15s;">
                <div class="history-panel-header">
                    <h2>📋 Lịch sử bài thi</h2>
                </div>
                <c:choose>
                    <c:when test="${not empty submissions}">
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Đề thi</th>
                                    <th>Ngày thi</th>
                                    <th>L</th><th>R</th><th>W</th><th>S</th>
                                    <th>Overall</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sub" items="${submissions}" varStatus="st">
                                    <tr>
                                        <td style="color:var(--text-secondary);">#${st.count}</td>
                                        <td style="font-weight:600; max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                            ${sub.examTitle}
                                            <c:if test="${not empty sub.examType}">
                                                <span class="badge badge-blue" style="margin-left:6px;font-size:0.7rem;">${sub.examType}</span>
                                            </c:if>
                                        </td>
                                        <td style="color:var(--text-secondary);">
                                            <fmt:formatDate value="${sub.startTimeAsDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <%-- Band chips: L R W S --%>
                                        <c:set var="bands" value="${[sub.listeningBand, sub.readingBand, sub.writingBand, sub.speakingBand]}"/>
                                        <c:forEach var="b" items="${bands}">
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b != null}">
                                                        <span class="band-chip has-val"><fmt:formatNumber value="${b}" pattern="0.0"/></span>
                                                    </c:when>
                                                    <c:otherwise><span class="band-chip no-val">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:forEach>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sub.overallBand != null}">
                                                    <strong style="color:var(--accent-blue);">
                                                        <fmt:formatNumber value="${sub.overallBand}" pattern="0.0"/>
                                                    </strong>
                                                </c:when>
                                                <c:otherwise><span style="color:var(--text-secondary);">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge ${sub.status}">${sub.status}</span>
                                            <c:if test="${sub.cheated}">
                                                <span title="Vi phạm" style="color:var(--accent-red);font-size:.75rem;margin-left:4px;">⚠️</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                            </svg>
                            <p>Bạn chưa làm bài thi nào.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <script>
    (function () {
        var labels        = ${chartLabels};
        var listeningData = ${chartListening};
        var readingData   = ${chartReading};
        var writingData   = ${chartWriting};
        var speakingData  = ${chartSpeaking};
        var overallData   = ${chartOverall};

        if (labels.length > 0 && document.getElementById('progressChart')) {
            var N = labels.length;
            var inner = document.getElementById('chartContainerInner');
            if (inner) {
                inner.style.width = (N > 10 ? N * 80 : '100%');
                if (N > 10) inner.style.minWidth = (N * 80) + 'px';
            }

            var ctx = document.getElementById('progressChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        { label: 'Listening', data: listeningData, borderColor: '#10b981', backgroundColor: 'rgba(16,185,129,.1)', tension: .4, spanGaps: true, pointRadius: 5, pointHoverRadius: 8 },
                        { label: 'Reading',   data: readingData,   borderColor: '#3b82f6', backgroundColor: 'rgba(59,130,246,.1)',  tension: .4, spanGaps: true, pointRadius: 5, pointHoverRadius: 8 },
                        { label: 'Writing',   data: writingData,   borderColor: '#f59e0b', backgroundColor: 'rgba(245,158,11,.1)', tension: .4, spanGaps: true, pointRadius: 5, pointHoverRadius: 8 },
                        { label: 'Speaking',  data: speakingData,  borderColor: '#ec4899', backgroundColor: 'rgba(236,72,153,.1)', tension: .4, spanGaps: true, pointRadius: 5, pointHoverRadius: 8 },
                        { label: 'Overall',   data: overallData,   borderColor: '#8b5cf6', backgroundColor: 'rgba(139,92,246,.1)', tension: .4, spanGaps: true, pointRadius: 6, pointHoverRadius: 9, borderWidth: 2.5 }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(255,255,255,0.95)',
                            titleColor: '#0f172a',
                            bodyColor: '#475569',
                            borderColor: 'rgba(0,0,0,0.08)',
                            borderWidth: 1,
                            padding: 12,
                            callbacks: {
                                label: function(c) {
                                    return c.dataset.label + ': ' + (c.raw !== null ? c.raw : '—');
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { color: 'rgba(0,0,0,0.04)' },
                            ticks: { color: '#475569', font: { family: 'Outfit', size: 12 } }
                        },
                        y: {
                            min: 0, max: 9,
                            grid: { color: 'rgba(0,0,0,0.04)' },
                            ticks: { color: '#475569', font: { family: 'Outfit', size: 12 }, stepSize: 0.5 }
                        }
                    }
                }
            });

            // Auto-scroll đến cuối (bài thi mới nhất)
            var wrap = document.querySelector('.chart-scroll-wrap');
            if (wrap) setTimeout(function() { wrap.scrollLeft = wrap.scrollWidth; }, 150);
        }
    })();
    </script>
</body>
</html>
