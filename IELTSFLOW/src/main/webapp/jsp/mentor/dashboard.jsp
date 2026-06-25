<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Mentor – IELTSFlow</title>
    <meta name="description" content="Bảng điều khiển tổng quan dành cho Mentor IELTSFlow.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .mentor-stat-card {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 28px 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            display: flex;
            flex-direction: column;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .mentor-stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.18);
        }
        .stat-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; margin-bottom: 1rem;
        }
        .stat-label {
            font-size: 0.72rem; text-transform: uppercase;
            font-weight: 700; letter-spacing: 0.08em;
            color: var(--text-secondary); margin-bottom: 6px;
        }
        .stat-value {
            font-size: 2.6rem; font-weight: 800;
            color: var(--text-primary); letter-spacing: -0.04em;
            line-height: 1;
        }
        .stat-footer {
            margin-top: auto; padding-top: 1rem;
            font-size: 0.82rem; color: var(--text-secondary); font-weight: 500;
        }
        .stat-footer a { color: inherit; text-decoration: none; font-weight: 600; }
        .stat-footer a:hover { color: var(--accent-blue); }

        /* AI Skill Cards */
        .skill-card {
            background: var(--bg-surface);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .skill-card h4 {
            font-size: 1.1rem; font-weight: 700; margin-bottom: 1.2rem;
            display: flex; align-items: center; gap: 10px;
        }
        .band-badge {
            display: inline-flex; align-items: center;
            padding: 4px 14px; border-radius: 20px;
            font-size: 1.1rem; font-weight: 800;
            background: rgba(59,130,246,0.12); color: var(--accent-blue);
        }
        .skill-meta { font-size: 0.82rem; color: var(--text-secondary); margin-bottom: 1.2rem; }
        .skill-meta span { margin-right: 1.2rem; }
        .chart-container { position: relative; height: 190px; }
        .empty-chart {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            height: 190px; color: var(--text-secondary);
            font-size: 0.9rem; gap: 8px;
        }
        .empty-chart i { font-size: 2rem; opacity: 0.4; }

        /* Quick Actions */
        .action-btn {
            flex: 1 1 160px; padding: 16px 20px;
            border-radius: 14px; border: none;
            font-weight: 600; font-size: 0.9rem;
            cursor: pointer; transition: all 0.3s;
            display: flex; align-items: center; gap: 10px;
            text-decoration: none; color: white;
        }
        .action-btn:hover { transform: translateY(-3px); filter: brightness(1.1); color: white; }
        .action-btn i { font-size: 1.1rem; }

        /* Ticket table */
        .ticket-table { width: 100%; border-collapse: collapse; }
        .ticket-table th {
            font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--text-secondary); font-weight: 700;
            padding: 10px 14px; border-bottom: 1px solid var(--glass-border);
            text-align: left;
        }
        .ticket-table td {
            padding: 14px; border-bottom: 1px solid rgba(0,0,0,0.04);
            font-size: 0.88rem; vertical-align: middle;
        }
        .ticket-table tr:last-child td { border-bottom: none; }
        .ticket-table tr:hover td { background: rgba(0,0,0,0.02); }
        .status-badge {
            padding: 3px 12px; border-radius: 20px;
            font-size: 0.76rem; font-weight: 600; display: inline-block;
        }
        .status-open    { background: rgba(245,158,11,0.15); color: #f59e0b; }
        .status-closed  { background: rgba(16,185,129,0.15); color: #10b981; }
        .status-pending { background: rgba(59,130,246,0.15); color: #3b82f6; }

        /* Page header */
        .page-greeting { font-size: 1.9rem; font-weight: 800; margin-bottom: 4px; }
        .page-subtitle  { color: var(--text-secondary); font-size: 0.95rem; }
    </style>
</head>
<body>
    <div class="bg-blob blob-1" style="background: var(--accent-green); opacity: 0.08;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.08;"></div>

    <div class="layout-wrapper">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="active" value="dashboard"/>
        </jsp:include>

        <main class="main-content">

            <%-- ===== HEADER ===== --%>
            <header class="animate-fade-up" style="margin-bottom: 2.5rem;">
                <h1 class="page-greeting">
                    Chào mừng trở lại, ${sessionScope.user != null ? sessionScope.user.fullName : 'Mentor'} 👋
                </h1>
                <p class="page-subtitle">Đây là tổng quan hoạt động của bạn trên IELTSFlow.</p>
            </header>

            <%-- ===== STAT CARDS ===== --%>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem;">

                <%-- Câu hỏi --%>
                <div class="mentor-stat-card animate-fade-up" style="animation-delay:0.05s;">
                    <div class="stat-icon" style="background:rgba(59,130,246,0.12); color:var(--accent-blue);">
                        <i class="fa-solid fa-circle-question"></i>
                    </div>
                    <div class="stat-label">Câu hỏi đã tạo</div>
                    <div class="stat-value">${questionCount}</div>
                    <div class="stat-footer">
                        <a href="${pageContext.request.contextPath}/mentor/questions">
                            Quản lý câu hỏi <i class="fa-solid fa-arrow-right" style="font-size:0.7rem;"></i>
                        </a>
                    </div>
                </div>

                <%-- Bài học --%>
                <div class="mentor-stat-card animate-fade-up" style="animation-delay:0.1s;">
                    <div class="stat-icon" style="background:rgba(16,185,129,0.12); color:var(--accent-green);">
                        <i class="fa-solid fa-book-open"></i>
                    </div>
                    <div class="stat-label">Bài học đã tạo</div>
                    <div class="stat-value">${lessonCount}</div>
                    <div class="stat-footer">
                        <a href="${pageContext.request.contextPath}/mentor/lessons">
                            Quản lý bài học <i class="fa-solid fa-arrow-right" style="font-size:0.7rem;"></i>
                        </a>
                    </div>
                </div>

                <%-- Đề thi --%>
                <div class="mentor-stat-card animate-fade-up" style="animation-delay:0.15s;">
                    <div class="stat-icon" style="background:rgba(139,92,246,0.12); color:var(--accent-purple);">
                        <i class="fa-solid fa-file-pen"></i>
                    </div>
                    <div class="stat-label">Đề thi đã tạo</div>
                    <div class="stat-value">${examCount}</div>
                    <div class="stat-footer">
                        <a href="${pageContext.request.contextPath}/mentor/exams">
                            Quản lý đề thi <i class="fa-solid fa-arrow-right" style="font-size:0.7rem;"></i>
                        </a>
                    </div>
                </div>

                <%-- Bài nộp --%>
                <div class="mentor-stat-card animate-fade-up" style="animation-delay:0.2s;">
                    <div class="stat-icon" style="background:rgba(245,158,11,0.12); color:var(--accent-orange);">
                        <i class="fa-solid fa-chart-column"></i>
                    </div>
                    <div class="stat-label">Lượt nộp bài</div>
                    <div class="stat-value">${submissionCount}</div>
                    <div class="stat-footer">Tổng bài nộp trên đề của bạn</div>
                </div>

            </div>

            <%-- ===== AI SKILL STATS ===== --%>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem;">

                <c:forEach var="entry" items="${stats}">
                    <c:set var="sk" value="${entry.value}"/>
                    <div class="skill-card animate-fade-up" style="animation-delay:0.25s;">
                        <h4>
                            <c:choose>
                                <c:when test="${entry.key == 'Writing'}">✍️ Writing</c:when>
                                <c:otherwise>🎙️ Speaking</c:otherwise>
                            </c:choose>
                            <span class="band-badge ms-auto">
                                Band&nbsp;<fmt:formatNumber value="${sk.avgBand}" maxFractionDigits="1" minFractionDigits="1"/>
                            </span>
                        </h4>
                        <div class="skill-meta">
                            <span><i class="fa-solid fa-check-to-slot" style="margin-right:4px;"></i>${sk.submissionCount} bài đã chấm</span>
                            <span><i class="fa-solid fa-triangle-exclamation" style="margin-right:4px;"></i>${sk.totalMistakes} lỗi phát hiện</span>
                        </div>

                        <c:choose>
                            <c:when test="${sk.submissionCount > 0}">
                                <div class="chart-container">
                                    <canvas id="chart-${entry.key}"></canvas>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-chart">
                                    <i class="fa-regular fa-chart-bar"></i>
                                    <span>Chưa có dữ liệu AI chấm bài</span>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Serialize mistake map to JSON for Chart.js --%>
                        <c:if test="${sk.submissionCount > 0}">
                            <script>
                            (function(){
                                var labels = [];
                                var data   = [];
                                var colorPalette = [
                                    'rgba(59,130,246,0.75)',
                                    'rgba(139,92,246,0.75)',
                                    'rgba(16,185,129,0.75)',
                                    'rgba(245,158,11,0.75)',
                                    'rgba(239,68,68,0.75)',
                                    'rgba(99,102,241,0.75)'
                                ];
                                <c:forEach var="cat" items="${sk.mistakesByCategory}">
                                    labels.push('${cat.key}');
                                    data.push(${cat.value});
                                </c:forEach>
                                if (labels.length === 0) return;
                                var ctx = document.getElementById('chart-${entry.key}').getContext('2d');
                                new Chart(ctx, {
                                    type: 'doughnut',
                                    data: {
                                        labels: labels,
                                        datasets: [{
                                            data: data,
                                            backgroundColor: colorPalette.slice(0, labels.length),
                                            borderWidth: 0,
                                            hoverOffset: 8
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        maintainAspectRatio: false,
                                        plugins: {
                                            legend: {
                                                position: 'right',
                                                labels: {
                                                    color: '#475569',
                                                    font: { family: "'Outfit', sans-serif", size: 12 },
                                                    padding: 14,
                                                    boxWidth: 14
                                                }
                                            },
                                            tooltip: {
                                                callbacks: {
                                                    label: function(ctx) {
                                                        var total = ctx.dataset.data.reduce(function(a,b){return a+b;}, 0);
                                                        var pct = total > 0 ? Math.round(ctx.raw / total * 100) : 0;
                                                        return ' ' + ctx.label + ': ' + ctx.raw + ' (' + pct + '%)';
                                                    }
                                                }
                                            }
                                        },
                                        cutout: '65%'
                                    }
                                });
                            })();
                            </script>
                        </c:if>
                    </div>
                </c:forEach>

            </div>

            <%-- ===== QUICK ACTIONS ===== --%>
            <div class="glass-panel animate-fade-up" style="margin-bottom: 2.5rem; animation-delay:0.3s;">
                <h4 style="font-weight: 800; font-size: 1.15rem; margin-bottom: 1.5rem;">
                    Thao tác nhanh ⚡
                </h4>
                <div style="display: flex; flex-wrap: wrap; gap: 1rem;">
                    <a id="btn-new-question" href="${pageContext.request.contextPath}/mentor/questions?action=new"
                       class="action-btn"
                       style="background: linear-gradient(135deg, #3b82f6, #8b5cf6); box-shadow: 0 4px 15px rgba(59,130,246,0.3);">
                        <i class="fa-solid fa-plus"></i> Tạo câu hỏi mới
                    </a>
                    <a id="btn-new-lesson" href="${pageContext.request.contextPath}/mentor/lessons?action=new"
                       class="action-btn"
                       style="background: linear-gradient(135deg, #10b981, #059669); box-shadow: 0 4px 15px rgba(16,185,129,0.3);">
                        <i class="fa-solid fa-plus"></i> Tạo bài học mới
                    </a>
                    <a id="btn-new-exam" href="${pageContext.request.contextPath}/mentor/exams?action=new"
                       class="action-btn"
                       style="background: linear-gradient(135deg, #8b5cf6, #6d28d9); box-shadow: 0 4px 15px rgba(139,92,246,0.3);">
                        <i class="fa-solid fa-plus"></i> Tạo đề thi mới
                    </a>
                    <a id="btn-open-tickets" href="${pageContext.request.contextPath}/candidate/tickets?status=Open"
                       class="action-btn"
                       style="background: linear-gradient(135deg, #f59e0b, #d97706); box-shadow: 0 4px 15px rgba(245,158,11,0.3);">
                        <i class="fa-solid fa-ticket"></i> Xem ticket chưa trả lời
                    </a>
                </div>
            </div>

            <%-- ===== RECENT OPEN TICKETS ===== --%>
            <div class="glass-panel animate-fade-up" style="animation-delay:0.35s;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem;">
                    <h4 style="font-weight: 800; font-size: 1.15rem; margin: 0;">
                        🎫 Ticket đang chờ trả lời
                    </h4>
                    <a href="${pageContext.request.contextPath}/candidate/tickets"
                       style="font-size: 0.85rem; font-weight: 600; color: var(--accent-blue); text-decoration: none;">
                        Xem tất cả <i class="fa-solid fa-arrow-right" style="font-size:0.7rem;"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty recentTickets}">
                        <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                            <i class="fa-regular fa-circle-check" style="font-size: 2.5rem; opacity: 0.4; display:block; margin-bottom: 12px;"></i>
                            Tuyệt vời! Không có ticket nào đang chờ xử lý.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto;">
                            <table class="ticket-table">
                                <thead>
                                    <tr>
                                        <th>#ID</th>
                                        <th>Tiêu đề</th>
                                        <th>Học viên</th>
                                        <th>Ngày tạo</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ticket" items="${recentTickets}">
                                        <tr>
                                            <td style="font-weight: 700; color: var(--text-secondary);">#${ticket.ticketId}</td>
                                            <td style="font-weight: 600; max-width: 260px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                ${ticket.subject}
                                            </td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <div style="width: 28px; height: 28px; border-radius: 8px;
                                                                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
                                                                color: white; display: flex; align-items: center;
                                                                justify-content: center; font-size: 0.75rem; font-weight: 700;">
                                                        ${ticket.user.fullName.substring(0,1)}
                                                    </div>
                                                    ${ticket.user.fullName}
                                                </div>
                                            </td>
                                            <td style="color: var(--text-secondary); font-size: 0.83rem;">
                                                ${ticket.createdAt.toString().replace('T', ' ').substring(0, 16)}
                                            </td>
                                            <td>
                                                <span class="status-badge
                                                    ${ticket.status == 'Open' ? 'status-open' :
                                                      ticket.status == 'Closed' ? 'status-closed' : 'status-pending'}">
                                                    ${ticket.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/candidate/tickets?id=${ticket.ticketId}"
                                                   style="color: var(--accent-blue); text-decoration: none; font-weight: 600; font-size: 0.82rem;">
                                                    Trả lời <i class="fa-solid fa-reply" style="font-size: 0.75rem;"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
