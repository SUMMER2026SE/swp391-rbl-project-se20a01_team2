<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Giao Dịch - IELTSFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .table-custom th { background-color: var(--sidebar-bg); color: var(--text-secondary); font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; border-bottom: 2px solid var(--border-color); }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .table-custom tbody tr:hover { background-color: rgba(79, 70, 229, 0.02); }
        .filter-select { border-radius: 1rem; padding: 0.75rem 1rem; border: 1px solid var(--border-color); font-weight: 600; color: var(--text-primary); }
    </style>
</head>
<body>

    <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="transactions" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <h1 class="page-title" style="font-size: 2rem; margin: 0;">Lịch sử Đối Soát Thanh Toán 💳</h1>
        </header>

        <!-- Bộ Lọc -->
        <div class="animate-fade-up" style="margin-bottom: 2rem; max-width: 400px; animation-delay: 0.1s;">
            <form action="${pageContext.request.contextPath}/admin/transactions" method="get" class="d-flex gap-2">
                <select name="status" class="form-select filter-select flex-grow-1 shadow-sm" style="background-color: var(--bg-surface); color: var(--text-primary); border: 1px solid var(--glass-border);">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="Pending" ${currentStatus == 'Pending' ? 'selected' : ''}>Đang chờ (Pending)</option>
                    <option value="Success" ${currentStatus == 'Success' ? 'selected' : ''}>Thành công (Success)</option>
                    <option value="Failed" ${currentStatus == 'Failed' ? 'selected' : ''}>Thất bại (Failed)</option>
                </select>
                <button type="submit" class="btn btn-primary" style="border-radius: 1rem; padding: 0 1.5rem; font-weight: 700;">Lọc</button>
            </form>
        </div>

        <!-- Bảng Dữ Liệu -->
        <div class="glass-panel animate-fade-up" style="animation-delay: 0.2s; padding: 0; overflow: hidden;">
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Mã Giao Dịch</th>
                                <th>Mã Đối Soát (SePay)</th>
                                <th>Người Dùng (ID)</th>
                                <th>Tên Gói Mua</th>
                                <th>Số Tiền</th>
                                <th>Phương Thức</th>
                                <th>Trạng Thái</th>
                                <th class="pe-4">Thời Gian</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="txn" items="${transactions}">
                                <tr>
                                    <td class="ps-4 font-monospace text-secondary" style="font-size: 0.875rem;">
                                        <div style="color: var(--text-primary); font-weight: 600;">
                                            <i class="fa-solid fa-hashtag text-black-50 me-1" style="font-size: 0.75rem;"></i>
                                            <fmt:formatNumber value="${txn.transactionId}" pattern="00"/>
                                        </div>
                                    </td>
                                    <td class="font-monospace text-secondary" style="font-size: 0.875rem;">
                                        <c:if test="${txn.gatewayTransactionId != null}">
                                            <span style="color: #64748b; background: var(--bg-surface); padding: 0.25rem 0.5rem; border-radius: 0.25rem; border: 1px solid var(--border-color);">
                                                <i class="fa-solid fa-building-columns me-1"></i>${txn.gatewayTransactionId}
                                            </span>
                                        </c:if>
                                        <c:if test="${txn.gatewayTransactionId == null}">
                                            <span class="text-muted" style="font-size: 0.75rem;">-</span>
                                        </c:if>
                                    </td>
                                    <td class="fw-bold" style="color: var(--text-primary);">User #${txn.userId}</td>
                                    <td class="fw-medium">${txn.subscriptionPackage.name}</td>
                                    <td class="fw-bold" style="color: #10B981;">${txn.amount} ₫</td>
                                    <td>
                                        <span style="background: var(--bg-color); padding: 0.25rem 0.75rem; border-radius: 0.5rem; font-size: 0.75rem; font-weight: 700; border: 1px solid var(--border-color);">
                                            ${txn.paymentMethod != null ? txn.paymentMethod : 'N/A'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${txn.status == 'Success'}">
                                            <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success px-3">Thành công</span>
                                        </c:if>
                                        <c:if test="${txn.status == 'Failed'}">
                                            <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger border border-danger px-3">Thất bại</span>
                                        </c:if>
                                        <c:if test="${txn.status != 'Success' && txn.status != 'Failed'}">
                                            <span class="badge rounded-pill bg-warning bg-opacity-10 text-warning border border-warning px-3 text-dark">${txn.status}</span>
                                        </c:if>
                                    </td>
                                    <td class="text-secondary pe-4" style="font-size: 0.875rem;">
                                        <i class="fa-regular fa-clock me-1"></i>
                                        ${txn.paymentDate != null ? txn.paymentDate : txn.createdAt}
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty transactions}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">Không tìm thấy giao dịch nào phù hợp.</td>
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
