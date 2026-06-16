<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi ti&#7871;t Ticket - IELTSFlow</title>
    <link rel="stylesheet" href="../../css/design-system.css">
    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #f8fafc; }
        .page-wrapper { max-width: 760px; margin: 0 auto; padding: 40px 20px; }
        .back-link {
            display: inline-flex; align-items: center; gap: 6px; color: #64748b;
            text-decoration: none; font-size: 14px; margin-bottom: 24px;
            transition: color 0.2s;
        }
        .back-link:hover { color: #f97316; }

        .ticket-box {
            background: white; border-radius: 14px; padding: 30px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08); margin-bottom: 20px;
        }
        .ticket-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .ticket-id { font-size: 12px; color: #94a3b8; font-weight: 600; margin-bottom: 6px; }
        .ticket-subject { font-size: 1.3rem; font-weight: 700; color: #1e293b; margin: 0; }
        .status-badge {
            padding: 6px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; white-space: nowrap;
        }
        .badge-Open { background: #dbeafe; color: #1d4ed8; }
        .badge-InProgress { background: #fef3c7; color: #b45309; }
        .badge-Resolved { background: #dcfce7; color: #15803d; }
        .badge-Closed { background: #f1f5f9; color: #64748b; }

        .ticket-content { color: #475569; line-height: 1.7; white-space: pre-wrap; }
        .ticket-date { font-size: 12px; color: #94a3b8; margin-top: 16px; }

        .ai-box {
            background: #fdf4ff; border: 1px solid #f0abfc; border-radius: 12px; padding: 20px;
            margin-top: 20px; color: #4a044e;
        }
        .ai-title { font-weight: 700; display: flex; align-items: center; gap: 8px; margin: 0 0 12px; font-size: 0.95rem; }
        .ai-score { display: inline-block; background: #c026d3; color: white; padding: 4px 10px; border-radius: 6px; font-weight: bold; }
        .ai-feedback { margin-bottom: 16px; font-size: 0.9rem; line-height: 1.6; }
        .ai-errors { background: white; border-radius: 8px; padding: 12px; margin-bottom: 8px; border-left: 4px solid #ef4444; }
        .err-mistake { color: #ef4444; text-decoration: line-through; margin-right: 8px; }
        .err-correct { color: #10b981; font-weight: 600; }
        
        #processingUI {
            background: #f0fdfa; border: 1px solid #5eead4; border-radius: 12px; padding: 20px;
            text-align: center; color: #0f766e; margin-bottom: 20px;
        }

        .reply-box {
            background: linear-gradient(135deg, #eff6ff, #f0fdf4);
            border: 1px solid #bfdbfe; border-radius: 14px; padding: 24px;
            margin-bottom: 20px;
        }
        .reply-title { font-weight: 700; color: #1e40af; margin: 0 0 12px; font-size: 0.9rem; }
        .reply-content { color: #1e293b; line-height: 1.7; white-space: pre-wrap; }
        .reply-date { font-size: 12px; color: #64748b; margin-top: 10px; }

        .pending-box {
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 12px; padding: 20px;
            text-align: center; color: #92400e; margin-bottom: 20px;
        }

        .btn-close {
            display: inline-flex; align-items: center; gap: 6px;
            background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0;
            padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 500;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-close:hover { background: #e2e8f0; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <a href="${pageContext.request.contextPath}/tickets" class="back-link">
        &larr; Quay l&#7841;i danh s&#225;ch
    </a>

    <c:choose>
        <c:when test="${empty ticket}">
            <div style="text-align:center;padding:60px;color:#94a3b8;">
                <p>Kh&#244;ng t&#236;m th&#7845;y ticket n&#224;y.</p>
            </div>
        </c:when>
        <c:otherwise>
            <!-- N&#7897;i dung ticket -->
            <div class="ticket-box">
                <div class="ticket-header">
                    <div>
                        <div class="ticket-id">TICKET #${ticket.ticketId}</div>
                        <div class="ticket-subject">${ticket.subject}</div>
                    </div>
                    <span class="status-badge badge-${ticket.status}">
                        <c:choose>
                            <c:when test="${ticket.status == 'Open'}">M&#7903;</c:when>
                            <c:when test="${ticket.status == 'InProgress'}">&#272;ang x&#7917; l&#253;</c:when>
                            <c:when test="${ticket.status == 'Resolved'}">&#272;&#227; gi&#7843;i quy&#7871;t</c:when>
                            <c:otherwise>&#272;&#227; &#273;&#243;ng</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="ticket-content">${ticket.content}</div>
                
                <c:if test="${not empty ticket.mediaUrl}">
                    <div style="margin-top: 16px;">
                        <audio controls src="${ticket.mediaUrl}" style="width: 100%;"></audio>
                    </div>
                </c:if>
                <c:if test="${not empty ticket.transcript}">
                    <div style="margin-top: 12px; font-style: italic; color: #64748b; background: #f8fafc; padding: 12px; border-radius: 8px;">
                        <strong>Transcript (AI nghe &#273;&#432;&#7907;c):</strong><br>
                        ${ticket.transcript}
                    </div>
                </c:if>

                <div id="aiReportContainer">
                    <c:if test="${not empty ticket.aiReport}">
                        <textarea id="aiReportData" style="display:none;"><c:out value="${ticket.aiReport}" /></textarea>
                        <script>
                            try {
                                const rawJson = document.getElementById('aiReportData').value;
                                const report = JSON.parse(rawJson);
                                let html = `<div class="ai-box">
                                    <div class="ai-title">&#129302; AI Pre-screening <span class="ai-score">Band \${report.score}</span></div>
                                    <div class="ai-feedback">\${report.feedback}</div>`;
                                
                                if(report.grammar_errors && report.grammar_errors.length > 0) {
                                    html += `<div><strong>C&#225;c l&#7895;i ng&#7919; ph&#225;p c&#417; b&#7843;n:</strong></div>`;
                                    report.grammar_errors.forEach(err => {
                                        html += `<div class="ai-errors">
                                            <span class="err-mistake">\${err.mistake}</span> &rarr; 
                                            <span class="err-correct">\${err.correction}</span>
                                        </div>`;
                                    });
                                }
                                html += `</div>`;
                                document.write(html);
                            } catch(e) {
                                document.write(`<div class="ai-box">Kh\u00f4ng th\u1ec3 \u0111\u1ecdc b\u00e1o c\u00e1o AI (\${e.message})</div>`);
                            }
                        </script>
                    </c:if>
                </div>

                <div class="ticket-date">&#128197; G&#7917;i l&#250;c: ${ticket.createdAt}</div>
            </div>

            <!-- Processing UI -->
            <c:if test="${ticket.status == 'Processing'}">
                <div id="processingUI">
                    <div style="font-size: 24px; margin-bottom: 8px;">&#8987;</div>
                    <div style="font-weight: 600;">H&#7879; th&#7889;ng AI &#273;ang ch&#7845;m &#273;i&#7875;m s&#417; b&#7897;...</div>
                    <div style="font-size: 13px; margin-top: 4px;">Vui l&#242;ng &#273;&#7907;i v&#224;i gi&#226;y, trang s&#7869; t&#7921; &#273;&#7897;ng c&#7853;p nh&#7853;t k&#7871;t qu&#7843;.</div>
                </div>
                <script>
                    let pollInterval = setInterval(async () => {
                        try {
                            const res = await fetch('${pageContext.request.contextPath}/api/ticket/status?id=${ticket.ticketId}');
                            const data = await res.json();
                            if (data.status !== 'Processing') {
                                clearInterval(pollInterval);
                                window.location.reload(); // reload \u0111\u1ec3 th\u1ea5y b\u00e1o c\u00e1o
                            }
                        } catch(e) { console.error(e); }
                    }, 3000);
                </script>
            </c:if>

            <!-- Ph&#7843;n h&#7891;i t&#7915; Mentor -->
            <c:choose>
                <c:when test="${not empty ticket.adminReply}">
                    <div class="reply-box">
                        <div class="reply-title">&#128172; Ph&#7843;n h&#7891;i t&#7915; Mentor</div>
                        <div class="reply-content">${ticket.adminReply}</div>
                        <div class="reply-date">Ph&#7843;n h&#7891;i l&#250;c: ${ticket.repliedAt}</div>
                    </div>
                </c:when>
                <c:when test="${ticket.status != 'Closed'}">
                    <div class="pending-box">
                        &#8987; &#272;ang ch&#7901; Mentor ph&#7843;n h&#7891;i. Ch&#250;ng t&#244;i s&#7869; tr&#7843; l&#7901;i trong v&#242;ng 24 gi&#7897;.
                    </div>
                </c:when>
            </c:choose>

            <!-- N&#250;t &#273;&#243;ng ticket -->
            <c:if test="${ticket.status == 'Open' || ticket.status == 'Resolved'}">
                <form method="POST" action="${pageContext.request.contextPath}/tickets">
                    <input type="hidden" name="action" value="close">
                    <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                    <button type="submit" class="btn-close">&#10005; &#272;&#243;ng ticket</button>
                </form>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
