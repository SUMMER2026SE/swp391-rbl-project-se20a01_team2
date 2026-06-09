<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ Admin - IELTSFlow</title>
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/admin-style.css" rel="stylesheet">
</head>
<body>

<div class="admin-layout">
    
    <!-- Mobile Overlay -->
    <div class="mobile-overlay" id="mobileOverlay"></div>

    <!-- Sidebar -->
    <aside class="admin-sidebar" id="adminSidebar">
        <div class="sidebar-header">
            IELTSFlow
        </div>
        
        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Tổng quan</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
                    <i class="fa-solid fa-house"></i>
                    Dashboard
                </a>
            </div>
            
            <div class="nav-section">
                <div class="nav-section-title">Quản lý Người dùng</div>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                    <i class="fa-solid fa-users-gear"></i>
                    Thêm/Sửa/Khóa TK
                </a>
                <a href="${pageContext.request.contextPath}/admin/users/mentors" class="nav-item">
                    <i class="fa-solid fa-user-shield"></i>
                    Phân quyền Mentor
                </a>
            </div>
            
            <div class="nav-section">
                <div class="nav-section-title">Tài chính & Doanh thu</div>
                <a href="${pageContext.request.contextPath}/admin/packages" class="nav-item">
                    <i class="fa-solid fa-box-open"></i>
                    Gói Thành Viên
                </a>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-item">
                    <i class="fa-solid fa-money-check-dollar"></i>
                    Giao Dịch
                </a>
            </div>
            
            <div class="nav-section">
                <div class="nav-section-title">Hệ thống</div>
                <a href="${pageContext.request.contextPath}/admin/logs" class="nav-item">
                    <i class="fa-solid fa-server"></i>
                    Log Hệ Thống
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        
        <header class="main-header animate-on-scroll">
            <button class="hamburger" id="hamburgerBtn">
                <i class="fa-solid fa-bars"></i>
            </button>
            <h1 class="page-title">Dashboard Tổng Quan</h1>
            <div class="header-actions" style="display: flex; align-items: center; gap: 1.5rem;">
                <%-- 
                    [NOTE GHÉP CODE - LOGIN]: 
                    Người code phần Đăng Nhập (Hòa) lưu ý: Sau khi xác thực thành công,
                    cần set object chứa thông tin User vào session với tên biến là "user".
                    Ví dụ: request.getSession().setAttribute("user", loggedInUser);
                    Hệ thống đang gọi hàm getFullName() để hiển thị tên.
                --%>
                <div class="user-profile" style="display: flex; align-items: center; gap: 0.75rem;">
                    <div class="avatar" style="width: 40px; height: 40px; border-radius: 50%; background-color: var(--accent-color, #4F46E5); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; text-transform: uppercase;">
                        ${sessionScope.user != null ? sessionScope.user.fullName.substring(0,1) : 'A'}
                    </div>
                    <div class="user-info" style="display: flex; flex-direction: column;">
                        <span style="font-weight: 600; color: var(--text-primary, #111827); font-size: 0.9rem;">
                            ${sessionScope.user != null ? sessionScope.user.fullName : 'Quản trị viên'}
                        </span>
                        <span style="font-size: 0.75rem; color: var(--text-secondary, #6B7280);">Admin</span>
                    </div>
                </div>

                <!-- 
                    [NOTE GHÉP CODE - PROFILE]: 
                    Hòa lưu ý: Khi làm xong trang Quản lý tài khoản cá nhân, 
                    hãy đổi href="/profile" bên dưới thành URL Mapping chuẩn của Servlet đó nhé.
                -->
                <!-- Link tới trang quản lý tài khoản cá nhân (Hòa làm) -->
                <a href="${pageContext.request.contextPath}/profile" title="Quản lý tài khoản cá nhân" style="color: var(--text-secondary, #6B7280); text-decoration: none; font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--accent-color, #4F46E5)'" onmouseout="this.style.color='var(--text-secondary, #6B7280)'">
                    <i class="fa-solid fa-user-gear"></i>
                </a>

                <!-- 
                    [NOTE GHÉP CODE - LOGOUT]: 
                    Nhắc người code Logout Servlet: mapping URL là "/logout",
                    bên trong gọi request.getSession().invalidate() sau đó sendRedirect về trang "/login".
                -->
                <!-- Nút Đăng Xuất -->
                <a href="${pageContext.request.contextPath}/logout" title="Đăng xuất" style="color: var(--text-secondary, #6B7280); text-decoration: none; font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='#ef4444'" onmouseout="this.style.color='var(--text-secondary, #6B7280)'">
                    <i class="fa-solid fa-right-from-bracket"></i>
                </a>
            </div>
        </header>

        <!-- Thống Kê Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; margin-bottom: 3rem;">
            
            <!-- Doanh Thu -->
            <div class="db-card-shell animate-on-scroll">
                <div class="db-card-core">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">Tổng Doanh Thu</span>
                            <h2 style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">$ ${totalRevenue != null ? totalRevenue : '0'}</h2>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(79, 70, 229, 0.1); color: var(--accent-color); display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                            <i class="fa-solid fa-wallet"></i>
                        </div>
                    </div>
                    <div style="margin-top: auto;">
                        <a href="${pageContext.request.contextPath}/admin/transactions?status=Success" style="color: var(--accent-color); text-decoration: none; font-weight: 600; font-size: 0.875rem;">
                            Xem chi tiết giao dịch <i class="fa-solid fa-arrow-right" style="margin-left: 0.5rem; font-size: 0.75rem;"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- User Active -->
            <div class="db-card-shell animate-on-scroll">
                <div class="db-card-core">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">User Hoạt Động</span>
                            <h2 style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">${totalUsers != null ? totalUsers : '0'}</h2>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(16, 185, 129, 0.1); color: #10B981; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                            <i class="fa-solid fa-user-check"></i>
                        </div>
                    </div>
                    <div style="margin-top: auto;">
                        <span style="color: var(--text-secondary); font-size: 0.875rem; font-weight: 500;">Toàn hệ thống hiện tại</span>
                    </div>
                </div>
            </div>

            <!-- Tổng Test -->
            <div class="db-card-shell animate-on-scroll">
                <div class="db-card-core">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-secondary); letter-spacing: 0.1em;">Tổng Bài Test</span>
                            <h2 style="font-size: 3rem; font-weight: 800; margin: 0; color: var(--text-primary); letter-spacing: -0.04em;">${totalTests != null ? totalTests : '0'}</h2>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(245, 158, 11, 0.1); color: #F59E0B; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                            <i class="fa-solid fa-file-pen"></i>
                        </div>
                    </div>
                    <div style="margin-top: auto;">
                        <span style="color: var(--text-secondary); font-size: 0.875rem; font-weight: 500;">Bài thi thử đã được thực hiện</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Thao Tác Nhanh -->
        <div class="animate-on-scroll" style="margin-top: 4rem;">
            <div style="display: flex; align-items: center; margin-bottom: 1.5rem;">
                <div style="width: 12px; height: 12px; border-radius: 50%; background: var(--accent-color); margin-right: 1rem;"></div>
                <h4 style="margin: 0; font-weight: 800; font-size: 1.25rem; letter-spacing: -0.02em;">Thao Tác Nhanh</h4>
            </div>
            
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/admin/packages?action=add" class="btn-nested">
                    Tạo Gói Pro Mới
                    <span class="btn-icon"><i class="fa-solid fa-plus"></i></span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="btn-nested" style="background-color: #10B981;">
                    Kiểm Tra Giao Dịch
                    <span class="btn-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/logs" class="btn-nested" style="background-color: #6B7280;">
                    Log Hệ Thống
                    <span class="btn-icon"><i class="fa-solid fa-triangle-exclamation"></i></span>
                </a>
            </div>
        </div>

    </main>
</div>

<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/js/admin-script.js"></script>
</body>
</html>
