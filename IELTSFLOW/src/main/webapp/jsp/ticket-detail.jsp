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
                <div class="ticket-date">&#128197; G&#7917;i l&#250;c: ${ticket.createdAt}</div>
            </div>



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

            <c:if test="${sessionScope.roleId == 2 && ticket.status != 'Closed' && empty ticket.adminReply}">
                <form method="POST" action="${pageContext.request.contextPath}/tickets" style="margin-bottom:20px; background:#f8fafc; padding:20px; border-radius:12px; border:1px solid #e2e8f0;">
                    <h3 style="margin-top:0; color:#1e293b;">Vi&#7871;t ph&#7843;n h&#7891;i</h3>
                    <input type="hidden" name="action" value="reply">
                    <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                    <textarea name="replyContent" rows="4" style="width:100%; padding:12px; border:1px solid #cbd5e1; border-radius:8px; margin-bottom:12px; font-family:inherit;" required></textarea>
                    <button type="submit" style="background:#10b981; color:white; padding:10px 20px; border:none; border-radius:8px; cursor:pointer; font-weight:bold;">G&#7917;i ph&#7843;n h&#7891;i</button>
                </form>
            </c:if>

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
