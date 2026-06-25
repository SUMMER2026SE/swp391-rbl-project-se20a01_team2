<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Ticket - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .ticket-box { background: rgba(255, 255, 255, 0.9); border-radius: 14px; padding: 30px; box-shadow: 0 4px 16px rgba(0,0,0,0.05); margin-bottom: 20px; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2); }
        .ticket-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .ticket-id { font-size: 12px; color: var(--text-secondary); font-weight: 600; margin-bottom: 6px; }
        .ticket-subject { font-size: 1.3rem; font-weight: 700; color: var(--text-primary); margin: 0; }
        
        .reply-box { border-radius: 14px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .candidate-reply { background: white; border: 1px solid var(--border-color); }
        .candidate-reply .reply-title { color: var(--text-secondary); }
        
        .mentor-reply { background: linear-gradient(135deg, rgba(245, 158, 11, 0.05), rgba(245, 158, 11, 0.1)); border: 1px solid rgba(245, 158, 11, 0.2); }
        .mentor-reply .reply-title { font-weight: 700; color: var(--accent-orange); }
        
        .reply-title { font-weight: 700; margin: 0 0 12px; font-size: 0.9rem; }
        .reply-content { color: var(--text-primary); line-height: 1.7; white-space: pre-wrap; }
        .reply-date { font-size: 12px; color: var(--text-secondary); margin-top: 10px; }
        
        .reply-form-box { background: white; border-radius: 14px; padding: 20px; box-shadow: 0 4px 16px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid var(--border-color); }
        .form-textarea { width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 8px; font-family: inherit; font-size: 14px; resize: vertical; min-height: 120px; box-sizing: border-box; transition: border-color 0.2s; }
        .form-textarea:focus { outline: none; border-color: var(--accent-orange); box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1); }
        .btn-submit { background: var(--accent-orange); color: white; border: none; padding: 10px 24px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; transition: background 0.2s; }
        .btn-submit:hover { background: #d97706; color: white; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-orange); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="tickets" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <a href="${pageContext.request.contextPath}/mentor/tickets" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">Chi tiết Ticket</h1>
            </div>
        </header>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty ticket}">
                <div class="glass-panel text-center py-5">
                    <p class="text-muted">Không tìm thấy ticket này.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="ticket-box animate-fade-up" style="animation-delay: 0.1s;">
                    <div class="ticket-header">
                        <div>
                            <div class="ticket-id">TICKET #${ticket.ticketId} - <span class="fw-bold">${ticket.user.fullName}</span></div>
                            <div class="ticket-subject">${ticket.subject}</div>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${ticket.status == 'Open'}"><span class="badge bg-warning text-dark border border-warning px-3 py-2 rounded-pill">Đang mở</span></c:when>
                                <c:when test="${ticket.status == 'Resolved'}"><span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill">Đã giải quyết</span></c:when>
                                <c:when test="${ticket.status == 'Closed'}"><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-3 py-2 rounded-pill">Đã đóng</span></c:when>
                                <c:otherwise><span class="badge bg-secondary px-3 py-2 rounded-pill">${ticket.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="chat-history animate-fade-up" style="animation-delay: 0.2s;">
                    <c:forEach var="reply" items="${ticket.replies}">
                        <c:choose>
                            <c:when test="${reply.sender.userId == ticket.user.userId}">
                                <!-- Tin nhắn của học viên -->
                                <div class="reply-box candidate-reply">
                                    <div class="reply-title"><i class="fa-solid fa-user me-2"></i> Học viên (${reply.sender.fullName})</div>
                                    <div class="reply-content">${reply.message}</div>
                                    <div class="reply-date">${reply.createdAt}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Tin nhắn của Mentor/Admin -->
                                <div class="reply-box mentor-reply">
                                    <div class="reply-title"><i class="fa-solid fa-user-tie me-2"></i> Mentor (${reply.sender.fullName})</div>
                                    <div class="reply-content">${reply.message}</div>
                                    <div class="reply-date">${reply.createdAt}</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <c:if test="${ticket.status != 'Closed'}">
                    <div class="reply-form-box animate-fade-up" style="animation-delay: 0.3s;">
                        <form method="POST" action="${pageContext.request.contextPath}/mentor/tickets">
                            <input type="hidden" name="action" value="reply">
                            <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                            <div class="mb-3">
                                <label class="fw-bold mb-2">Phản hồi của bạn</label>
                                <textarea name="content" class="form-textarea" placeholder="Nhập nội dung phản hồi cho học viên..." required></textarea>
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn-submit">
                                    <i class="fa-solid fa-paper-plane me-2"></i> Gửi phản hồi
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <c:if test="${ticket.status == 'Closed'}">
                    <div class="alert alert-secondary text-center mt-4">
                        Ticket này đã đóng và không thể phản hồi thêm.
                    </div>
                </c:if>

            </c:otherwise>
        </c:choose>
    </main>
</div>

</body>
</html>
