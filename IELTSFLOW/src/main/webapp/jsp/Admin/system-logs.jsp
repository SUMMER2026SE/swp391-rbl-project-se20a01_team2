<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Hệ Thống - IELTSFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); font-size: 0.875rem; }
        .table-custom tbody tr:hover { background-color: rgba(79, 70, 229, 0.02); }
        
        @media print {
            .admin-sidebar, .mobile-overlay, .header-actions, .hamburger {
                display: none !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
                width: 100% !important;
            }
            body, .layout-wrapper {
                background-color: white !important;
            }
            .glass-panel {
                box-shadow: none !important;
                border: none !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            .table-custom th {
                color: black !important;
                background-color: #f8f9fa !important;
                border-bottom: 2px solid #000 !important;
            }
            .table-custom td {
                color: black !important;
                border-bottom: 1px solid #ccc !important;
            }
            .page-title {
                text-align: center;
                margin-bottom: 20px;
                color: black !important;
            }
        }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="logs" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Lịch Sử Thao Tác Hệ Thống ⚙️</h1>
            <div class="header-actions d-flex gap-2">
                <button class="btn btn-outline-primary rounded-pill fw-bold shadow-sm" onclick="window.print()">
                    <i class="fa-solid fa-print me-2"></i> In Log
                </button>
                <button class="btn btn-outline-secondary rounded-pill fw-bold shadow-sm" onclick="location.reload()">
                    <i class="fa-solid fa-rotate-right me-2"></i> Làm mới Log
                </button>
            </div>
        </header>

        <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; padding: 0; overflow: hidden;">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Người Dùng (ID)</th>
                                <th>Hành Động</th>
                                <th>Thực Thể Tác Động</th>
                                <th>Chi Tiết</th>
                                <th class="pe-4">Thời Gian</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td class="ps-4 text-black-50">#${log.logId}</td>
                                    <td class="fw-bold" style="color: var(--accent-color);">
                                        <i class="fa-solid fa-user-astronaut me-2 text-black-50"></i>
                                        ${log.userId != null ? 'User #'.concat(log.userId) : 'Hệ Thống (Auto)'}
                                    </td>
                                    <td>
                                        <span style="background: rgba(0,0,0,0.05); padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-weight: 700;">
                                            ${log.action}
                                        </span>
                                    </td>
                                    <td>
                                        <code style="background: #f9fafb; padding: 0.25rem 0.5rem; border-radius: 0.25rem; color: #db2777; border: 1px solid var(--border-color);">
                                            ${log.entity}
                                        </code>
                                    </td>
                                    <td class="text-secondary">${log.details}</td>
                                    <td class="text-muted pe-4">
                                        <i class="fa-regular fa-calendar me-1"></i>
                                        ${log.createdAt}
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">Chưa có log hệ thống nào được ghi nhận.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
        </div>

    </main>
</div>

<!-- <script src="${pageContext.request.contextPath}/js/admin-script.js"></script> -->
</body>
</html>
