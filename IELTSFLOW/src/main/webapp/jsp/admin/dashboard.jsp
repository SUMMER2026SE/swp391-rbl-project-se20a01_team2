<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Chủ Admin - IELTSFlow</title>
        <!-- FontAwesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    </head>

    <body>

        <div class="bg-blob blob-1" style="background: var(--accent-blue); opacity: 0.1;"></div>
        <div class="bg-blob blob-3" style="background: var(--accent-purple); opacity: 0.1;"></div>

        <div class="layout-wrapper">
            <jsp:include page="sidebar.jsp">
                <jsp:param name="active" value="dashboard" />
            </jsp:include>

            <main class="main-content">

                <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
                    <h1 class="page-title" style="font-size: 2rem; margin-bottom: 5px;">Tổng Quan Hệ Thống</h1>
                    <p style="color: var(--text-secondary);">Chào mừng trở lại, cùng xem hôm nay hệ thống có gì mới nhé!
                    </p>
                </header>

                <!-- Thống Kê Cards -->
                <div
                    style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; margin-bottom: 3rem;">

                    <!-- Doanh Thu -->
                    <div class="glass-panel animate-fade-up"
                        style="animation-delay: 0.1s; display: flex; flex-direction: column;">
                        <div
                            style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                            <div>
                                <span
                                    style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">Tổng
                                    Doanh Thu</span>
                                <h2
                                    style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">
                                    ${totalRevenue != null ? totalRevenue : '0'} ₫</h2>
                            </div>
                            <div
                                style="width: 48px; height: 48px; border-radius: 50%; background: rgba(59, 130, 246, 0.1); color: var(--accent-blue); display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                                <i class="fa-solid fa-wallet"></i>
                            </div>
                        </div>
                        <div style="margin-top: auto;">
                            <a href="${pageContext.request.contextPath}/admin/transactions?status=Success"
                                style="color: var(--accent-blue); text-decoration: none; font-weight: 600; font-size: 0.875rem;">
                                Xem chi tiết giao dịch <i class="fa-solid fa-arrow-right"
                                    style="margin-left: 0.5rem; font-size: 0.75rem;"></i>
                            </a>
                        </div>
                    </div>

                    <!-- User Active -->
                    <div class="glass-panel animate-fade-up"
                        style="animation-delay: 0.2s; display: flex; flex-direction: column;">
                        <div
                            style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                            <div>
                                <span
                                    style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">Người
                                    Dùng Hoạt Động</span>
                                <h2
                                    style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">
                                    ${totalUsers != null ? totalUsers : '0'}</h2>
                            </div>
                            <div
                                style="width: 48px; height: 48px; border-radius: 50%; background: rgba(16, 185, 129, 0.1); color: #10B981; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                                <i class="fa-solid fa-user-check"></i>
                            </div>
                        </div>
                        <div style="margin-top: auto;">
                            <span style="color: var(--text-secondary); font-size: 0.875rem; font-weight: 500;">Toàn hệ
                                thống hiện tại</span>
                        </div>
                    </div>

                    <!-- Tổng Test -->
                    <div class="glass-panel animate-fade-up"
                        style="animation-delay: 0.3s; display: flex; flex-direction: column;">
                        <div
                            style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                            <div>
                                <span
                                    style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">Tổng
                                    Bài Kiểm Tra</span>
                                <h2
                                    style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">
                                    ${totalTests != null ? totalTests : '0'}</h2>
                            </div>
                            <div
                                style="width: 48px; height: 48px; border-radius: 50%; background: rgba(245, 158, 11, 0.1); color: #F59E0B; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                                <i class="fa-solid fa-file-pen"></i>
                            </div>
                        </div>
                        <div style="margin-top: auto;">
                            <span style="color: var(--text-secondary); font-size: 0.875rem; font-weight: 500;">Bài thi
                                thử đã được thực hiện</span>
                        </div>
                    </div>

                </div>

                <div class="glass-panel animate-fade-up" style="margin-top: 2rem; animation-delay: 0.4s;">
                    <div style="display: flex; align-items: center; margin-bottom: 1.5rem;">
                        <h4 style="margin: 0; font-weight: 800; font-size: 1.25rem;">Thao Tác Nhanh ⚡</h4>
                    </div>

                    <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                        <button class="btn btn-primary"
                            onclick="window.location.href='${pageContext.request.contextPath}/admin/packages?action=add'">
                            Tạo Gói Pro Mới <i class="fa-solid fa-plus ms-2"></i>
                        </button>
                        <button class="btn btn-primary"
                            style="background: linear-gradient(135deg, var(--accent-green), #059669); box-shadow: 0 4px 15px rgba(16,185,129,0.3);"
                            onclick="window.location.href='${pageContext.request.contextPath}/admin/transactions'">
                            Kiểm Tra Giao Dịch <i class="fa-solid fa-magnifying-glass ms-2"></i>
                        </button>
                        <button class="btn btn-primary"
                            style="background: linear-gradient(135deg, #64748b, #475569); box-shadow: 0 4px 15px rgba(100,116,139,0.3);"
                            onclick="window.location.href='${pageContext.request.contextPath}/admin/logs'">
                            Nhật Ký Hệ Thống <i class="fa-solid fa-triangle-exclamation ms-2"></i>
                        </button>
                    </div>
                </div>

            </main>
        </div>

        <!-- <script src="${pageContext.request.contextPath}/js/admin-script.js"></script> -->
    </body>

    </html>