<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ học viên - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(59, 130, 246, 0.03); }
        .truncate-text { max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-orange); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="tickets" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Hỗ trợ học viên 🎫</h1>
            <p class="text-secondary mt-2">Quản lý và phản hồi các yêu cầu hỗ trợ từ học viên</p>
        </header>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-fade-up">${error}</div>
        </c:if>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Ticket ID</th>
                            <th>Tiêu đề</th>
                            <th>Học viên</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-center pe-4">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr>
                                <td class="ps-4 text-secondary">#${ticket.ticketId}</td>
                                <td class="fw-bold" style="color: var(--text-primary);">
                                    <span class="truncate-text" title="${ticket.subject}">${ticket.subject}</span>
                                </td>
                                <td>${ticket.user.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ticket.status == 'Open'}"><span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-2 py-1">Đang mở</span></c:when>
                                        <c:when test="${ticket.status == 'Resolved'}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">Đã giải quyết</span></c:when>
                                        <c:when test="${ticket.status == 'Closed'}"><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">Đã đóng</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${ticket.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="text-center pe-4">
                                    <a href="${pageContext.request.contextPath}/mentor/tickets/${ticket.ticketId}" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold" style="font-size: 0.8rem;">
                                        Xem & Trả lời <i class="fa-solid fa-arrow-right ms-1"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty tickets}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">Không có ticket nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>
