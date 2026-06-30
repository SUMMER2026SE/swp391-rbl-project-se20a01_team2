<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .admin-table th { padding: 15px 10px; color: var(--text-secondary); font-weight: 500; font-size: 0.9rem; text-transform: uppercase; border-bottom: 1px solid var(--glass-border); cursor: pointer; user-select: none; }
        .admin-table th:hover { color: var(--primary-color); }
        .admin-table td { padding: 15px 10px; background: rgba(255,255,255,0.02); vertical-align: middle; }
        .admin-table tr td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .admin-table tr td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        .admin-table tr:hover td { background: rgba(255,255,255,0.05); }
        
        .avatar-img { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; margin-right: 10px; vertical-align: middle; border: 2px solid #e2e8f0; }
        .sort-icon { display: inline-block; margin-left: 5px; font-size: 0.8rem; color: #94a3b8; }
        
        /* Modern White Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(15, 23, 42, 0.5); backdrop-filter: blur(4px); opacity: 0; transition: opacity 0.3s ease; }
        .modal.show { opacity: 1; }
        .modal-content { 
            background-color: #ffffff; 
            margin: 8% auto; 
            padding: 30px; 
            border: none; 
            width: 400px; 
            border-radius: 24px; 
            color: #1e293b; 
            box-shadow: 0 20px 40px rgba(0,0,0,0.1), 0 1px 3px rgba(0,0,0,0.05);
            transform: translateY(20px) scale(0.95);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .modal.show .modal-content { transform: translateY(0) scale(1); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .modal-title { font-size: 1.25rem; font-weight: 700; color: #0f172a; margin: 0; }
        .close { color: #94a3b8; font-size: 24px; font-weight: bold; cursor: pointer; line-height: 1; padding: 4px; border-radius: 50%; transition: all 0.2s ease; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; background: transparent; }
        .close:hover { background-color: #f1f5f9; color: #ef4444; }
        
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 0.875rem; font-weight: 600; color: #475569; }
        .form-group input, .form-group select { 
            width: 100%; padding: 12px 16px; border-radius: 12px; border: 1px solid #cbd5e1; 
            background: #f8fafc; color: #334155; font-size: 0.95rem; transition: all 0.2s ease; outline: none; box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus { 
            background: #ffffff; border-color: #3b82f6; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15); 
        }
        .form-group select:disabled { background: #e2e8f0; color: #94a3b8; cursor: not-allowed; border-color: #e2e8f0; }
        
        .btn-modal { padding: 12px 24px; border: none; border-radius: 12px; cursor: pointer; font-weight: 600; font-size: 0.95rem; transition: all 0.2s ease; display: inline-flex; justify-content: center; align-items: center; width: 100%; box-sizing: border-box; }
        .btn-modal-primary { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25); }
        .btn-modal-primary:hover { box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4); transform: translateY(-1px); }
        .btn-modal-danger { background: linear-gradient(135deg, #ef4444, #f43f5e); color: white; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25); width: auto; flex: 1; }
        .btn-modal-danger:hover { box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4); transform: translateY(-1px); }
        .btn-modal-secondary { background: #f1f5f9; color: #475569; width: auto; flex: 1; }
        .btn-modal-secondary:hover { background: #e2e8f0; color: #1e293b; }
        
        .modal-footer { display: flex; gap: 12px; margin-top: 25px; }
        
        .pagination { display: flex; justify-content: center; gap: 10px; margin-top: 30px; align-items: center; }
        .page-link { padding: 8px 12px; border-radius: 8px; background: rgba(255,255,255,0.05); color: var(--text-primary); text-decoration: none; border: 1px solid var(--glass-border); transition: 0.2s; }
        .page-link:hover { background: rgba(255,255,255,0.1); }
        .page-link.active { background: var(--accent-orange); border-color: var(--accent-orange); color: white; }
    </style>
</head>
<body>
    <div class="bg-blob blob-1" style="background: var(--accent-red); opacity: 0.1;"></div>
    
    <div class="layout-wrapper">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="active" value="${isMentorView ? 'mentors' : 'users'}" />
        </jsp:include>

        <main class="main-content">
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.2); border: 1px solid #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; color: #fca5a5;">
                    ${error}
                </div>
            </c:if>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1 class="animate-fade-up">Quản lý người dùng</h1>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/users?action=export" class="btn btn-secondary animate-fade-up" style="background: rgba(255,255,255,0.1); border: 1px solid var(--glass-border);">⬇️ Xuất CSV</a>
                    <button class="btn btn-primary animate-fade-up" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);" onclick="openUserModal('create')">+ Thêm người dùng mới</button>
                </div>
            </div>
            
            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/users">
                <!-- Keep sorting state -->
                <input type="hidden" name="sortBy" value="${sortBy}">
                <input type="hidden" name="sortOrder" value="${sortOrder}">
                
                <div class="search-pill animate-fade-up" style="animation-delay: 0.1s; display: flex; gap: 10px; flex-wrap: wrap;">
                    <input type="text" name="search" value="${search}" placeholder="Tìm kiếm theo email hoặc tên..." style="flex: 1; min-width: 250px;">
                    <select name="roleFilter" onchange="this.form.submit()">
                        <option value="all" ${roleFilter == 'all' || empty roleFilter ? 'selected' : ''}>Tất cả vai trò</option>
                        <option value="1" ${roleFilter == '1' ? 'selected' : ''}>Admin</option>
                        <option value="2" ${roleFilter == '2' ? 'selected' : ''}>Mentor</option>
                        <option value="3" ${roleFilter == '3' ? 'selected' : ''}>Học viên</option>
                    </select>
                    <select name="statusFilter" onchange="this.form.submit()">
                        <option value="all" ${statusFilter == 'all' || empty statusFilter ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="Active" ${statusFilter == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${statusFilter == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        <option value="Banned" ${statusFilter == 'Banned' ? 'selected' : ''}>Banned</option>
                    </select>
                    <select name="limit" onchange="this.form.submit()">
                        <option value="10" ${limit == 10 ? 'selected' : ''}>10 dòng/trang</option>
                        <option value="20" ${limit == 20 ? 'selected' : ''}>20 dòng/trang</option>
                        <option value="50" ${limit == 50 ? 'selected' : ''}>50 dòng/trang</option>
                    </select>
                    <button type="submit" class="btn btn-secondary" style="padding: 10px 20px;">Lọc</button>
                </div>
            </form>

            <form id="bulkActionForm" method="post" action="${pageContext.request.contextPath}/admin/users" class="animate-fade-up" style="animation-delay: 0.2s; margin-top: 20px;">
                <input type="hidden" name="action" value="bulk_action">
                
                <div style="margin-bottom: 15px; display: flex; gap: 10px; align-items: center;">
                    <select name="actionType" style="padding: 8px 12px; border-radius: 8px; background: #1e293b; color: white; border: 1px solid var(--glass-border);">
                        <option value="">-- Chọn thao tác hàng loạt --</option>
                        <option value="lock">Khóa tài khoản</option>
                        <option value="unlock">Mở khóa tài khoản</option>
                        <option value="delete">Xóa tài khoản</option>
                    </select>
                    <button type="button" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.85rem;" onclick="submitBulkAction()">Áp dụng</button>
                </div>

                <div style="overflow-x: auto;">
                    <table class="admin-table" id="usersTable">
                        <thead>
                            <tr>
                                <th style="width: 40px; text-align: center;"><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th>
                                <th onclick="sortData('userId')">ID <span class="sort-icon">${sortBy == 'userId' ? (sortOrder == 'ASC' ? '(1→9)' : '(9→1)') : '↕'}</span></th>
                                <th onclick="sortData('fullName')">Họ và tên <span class="sort-icon">${sortBy == 'fullName' ? (sortOrder == 'ASC' ? '(A→Z)' : '(Z→A)') : '↕'}</span></th>
                                <th onclick="sortData('email')">Email <span class="sort-icon">${sortBy == 'email' ? (sortOrder == 'ASC' ? '(A→Z)' : '(Z→A)') : '↕'}</span></th>
                                <th onclick="sortData('createdAt')">Ngày tạo <span class="sort-icon">${sortBy == 'createdAt' ? (sortOrder == 'ASC' ? '(Cũ→Mới)' : '(Mới→Cũ)') : '↕'}</span></th>
                                <th onclick="sortData('status')">Trạng thái <span class="sort-icon">${sortBy == 'status' ? (sortOrder == 'ASC' ? '(A→Z)' : '(Z→A)') : '↕'}</span></th>
                                <th onclick="sortData('roleId')">Vai trò <span class="sort-icon">${sortBy == 'roleId' ? (sortOrder == 'ASC' ? '▲' : '▼') : '↕'}</span></th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td style="text-align: center;"><input type="checkbox" name="userIds" value="${user.userId}" class="user-checkbox"></td>
                                    <td>#${user.userId}</td>
                                    <td class="uname">
                                        <div style="display: flex; align-items: center;">
                                            <c:set var="defaultAvatar" value="https://ui-avatars.com/api/?name=${user.fullName}&background=e2e8f0&color=475569" />
                                            <img src="${not empty user.profilePic ? user.profilePic : defaultAvatar}" 
                                                 onerror="this.onerror=null; this.src='${defaultAvatar}'" 
                                                 class="avatar-img" alt="Avatar">
                                            <span>${user.fullName}</span>
                                        </div>
                                    </td>
                                    <td class="uemail">${user.email}</td>
                                    <td class="date-format">${user.createdAt}</td>
                                    <td>
                                        <span style="color: ${user.status == 'Active' ? 'var(--accent-green, #10B981)' : 'var(--accent-red, #ef4444)'}; font-weight: 600; padding: 4px 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
                                            ${user.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.roleId == 1}">Admin</c:when>
                                            <c:when test="${user.roleId == 2}">Mentor</c:when>
                                            <c:otherwise>Candidate</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="display: flex; gap: 5px; flex-wrap: wrap;">
                                        <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem;" onclick="openUserModal('update', ${user.userId}, '${user.fullName.replace('\'', '\\\'')}', '${user.email.replace('\'', '\\\'')}', ${user.roleId}, '${user.status}')">✎ Sửa</button>
                                        <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem;" onclick="openPasswordModal(${user.userId}, '${user.fullName.replace('\'', '\\\'')}')">🔑 Mật khẩu</button>
                                        
                                        <c:if test="${user.status == 'Active'}">
                                            <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: #fca5a5; border-color: rgba(239, 68, 68, 0.2);" onclick="openConfirmModal('lock', ${user.userId}, 'Khóa', '${user.fullName.replace('\'', '\\\'')}')">🔒 Khóa</button>
                                        </c:if>
                                        <c:if test="${user.status != 'Active'}">
                                            <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: #6ee7b7; border-color: rgba(16, 185, 129, 0.2);" onclick="openConfirmModal('unlock', ${user.userId}, 'Mở khóa', '${user.fullName.replace('\'', '\\\'')}')">🔓 Mở khóa</button>
                                        </c:if>
                                        <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: #ef4444; border-color: rgba(239, 68, 68, 0.3);" onclick="openConfirmModal('delete', ${user.userId}, 'Xóa', '${user.fullName.replace('\'', '\\\'')}')">🗑 Xóa</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 30px;">Không tìm thấy người dùng nào phù hợp.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </form>
            
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:url var="pageUrl" value="/admin/users">
                            <c:param name="page" value="${p}" />
                            <c:param name="limit" value="${limit}" />
                            <c:if test="${not empty search}"><c:param name="search" value="${search}" /></c:if>
                            <c:if test="${not empty roleFilter}"><c:param name="roleFilter" value="${roleFilter}" /></c:if>
                            <c:if test="${not empty statusFilter}"><c:param name="statusFilter" value="${statusFilter}" /></c:if>
                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}" /></c:if>
                            <c:if test="${not empty sortOrder}"><c:param name="sortOrder" value="${sortOrder}" /></c:if>
                        </c:url>
                        <a href="${pageUrl}" class="page-link ${currentPage == p ? 'active' : ''}">${p}</a>
                    </c:forEach>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Hidden form for single actions (Lock, Unlock, Delete) -->
    <form id="singleActionForm" method="post" action="${pageContext.request.contextPath}/admin/users" style="display:none;">
        <input type="hidden" name="action" id="saAction">
        <input type="hidden" name="id" id="saId">
    </form>

    <!-- User Modal Form (Create/Edit) -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title" id="modalTitle">Thêm người dùng mới</h2>
                <span class="close" onclick="closeModal('userModal')">&times;</span>
            </div>
            <form id="userForm" method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="formUserId" value="0">
                
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="fullName" id="formFullName" required placeholder="Nhập họ và tên...">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="formEmail" required placeholder="example@email.com">
                </div>
                <div class="form-group">
                    <label>Vai trò</label>
                    <input type="hidden" name="roleId" id="formRoleId">
                    <select id="formRoleIdDisplay" onchange="document.getElementById('formRoleId').value = this.value;">
                        <option value="3">Học viên (Candidate)</option>
                        <option value="2">Mentor</option>
                        <option value="1">Admin</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="formStatus">
                        <option value="Active">Active (Hoạt động)</option>
                        <option value="Inactive">Inactive (Vô hiệu/Khóa)</option>
                        <option value="Banned">Banned (Cấm vĩnh viễn)</option>
                    </select>
                </div>
                <button type="submit" class="btn-modal btn-modal-primary" style="margin-top: 10px;">Lưu người dùng</button>
            </form>
        </div>
    </div>

    <!-- Password Reset Modal -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Đổi mật khẩu</h2>
                <span class="close" onclick="closeModal('passwordModal')">&times;</span>
            </div>
            <p style="margin-bottom: 20px; color: #64748b; font-size: 0.9rem;">Đặt lại mật khẩu cho <b id="pwdUserName"></b>.</p>
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="change_password">
                <input type="hidden" name="id" id="pwdUserId">
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="text" name="newPassword" required minlength="8" placeholder="Nhập mật khẩu mới (ít nhất 8 ký tự)">
                </div>
                <button type="submit" class="btn-modal btn-modal-primary">Đổi mật khẩu</button>
            </form>
        </div>
    </div>

    <!-- Confirm Action Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content" style="width: 350px; text-align: center;">
            <div id="confirmIconContainer" style="background: #fee2e2; color: #ef4444; width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 28px;">
                ⚠️
            </div>
            <h2 class="modal-title" id="confirmTitle" style="margin-bottom: 10px; justify-content: center;">Xác nhận</h2>
            <p id="confirmMessage" style="color: #64748b; font-size: 0.95rem; margin-bottom: 25px; line-height: 1.5;"></p>
            <div class="modal-footer">
                <button type="button" class="btn-modal btn-modal-secondary" onclick="closeModal('confirmModal')">Hủy</button>
                <button type="button" class="btn-modal btn-modal-danger" id="confirmBtn" onclick="submitSingleAction()">Đồng ý</button>
            </div>
        </div>
    </div>

    <script>
        // JS Date Formatter
        document.addEventListener("DOMContentLoaded", function() {
            const dateCells = document.querySelectorAll(".date-format");
            dateCells.forEach(cell => {
                if(cell.innerText.trim() !== "") {
                    const dateObj = new Date(cell.innerText);
                    if(!isNaN(dateObj)) {
                        cell.innerText = dateObj.toLocaleDateString('vi-VN', {
                            day: '2-digit', month: '2-digit', year: 'numeric',
                            hour: '2-digit', minute:'2-digit'
                        });
                    }
                }
            });
        });

        // Sorting
        function sortData(column) {
            const form = document.getElementById("filterForm");
            const sortByInput = form.querySelector('input[name="sortBy"]');
            const sortOrderInput = form.querySelector('input[name="sortOrder"]');
            
            if (sortByInput.value === column) {
                sortOrderInput.value = sortOrderInput.value === 'ASC' ? 'DESC' : 'ASC';
            } else {
                sortByInput.value = column;
                sortOrderInput.value = 'ASC';
            }
            form.submit();
        }

        // Bulk Selection
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.user-checkbox');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }

        function submitBulkAction() {
            const form = document.getElementById('bulkActionForm');
            const actionType = form.querySelector('select[name="actionType"]').value;
            const checkboxes = document.querySelectorAll('.user-checkbox:checked');
            
            if (!actionType) {
                alert("Vui lòng chọn một thao tác.");
                return;
            }
            if (checkboxes.length === 0) {
                alert("Vui lòng chọn ít nhất một người dùng.");
                return;
            }
            if (confirm("Bạn có chắc chắn muốn áp dụng thao tác này lên " + checkboxes.length + " người dùng đã chọn?")) {
                form.submit();
            }
        }

        // Modals Logic
        function showModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.style.display = 'block';
            setTimeout(() => modal.classList.add('show'), 10);
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.remove('show');
            setTimeout(() => modal.style.display = 'none', 300);
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                closeModal(event.target.id);
            }
        }

        // Create/Edit Modal
        function openUserModal(action, id, name, email, role, status) {
            document.getElementById('modalTitle').innerText = action === 'create' ? 'Thêm người dùng mới' : 'Chỉnh sửa người dùng';
            document.getElementById('formAction').value = action;
            document.getElementById('formUserId').value = id || 0;
            document.getElementById('formFullName').value = name || '';
            document.getElementById('formEmail').value = email || '';
            document.getElementById('formRoleId').value = role || 3;
            document.getElementById('formRoleIdDisplay').value = role || 3;
            document.getElementById('formStatus').value = status || 'Active';
            
            document.getElementById('formRoleIdDisplay').disabled = (role == 1);
            showModal('userModal');
        }

        // Password Modal
        function openPasswordModal(id, name) {
            document.getElementById('pwdUserId').value = id;
            document.getElementById('pwdUserName').innerText = name;
            showModal('passwordModal');
        }

        // Confirm Single Action Modal
        function openConfirmModal(action, id, actionText, userName) {
            document.getElementById('saAction').value = action;
            document.getElementById('saId').value = id;
            
            document.getElementById('confirmTitle').innerText = actionText + ' tài khoản';
            
            let message = 'Bạn có chắc chắn muốn <b>' + actionText.toLowerCase() + '</b> tài khoản <b>' + userName + '</b>?';
            if(action === 'delete') {
                message = 'Hành động này sẽ đánh dấu tài khoản <b>' + userName + '</b> là đã xóa. Người dùng sẽ không thể đăng nhập nữa. Bạn có chắc chắn?';
            }
            document.getElementById('confirmMessage').innerHTML = message;
            
            const btn = document.getElementById('confirmBtn');
            const iconContainer = document.getElementById('confirmIconContainer');
            
            if(action === 'unlock') {
                btn.className = 'btn-modal btn-modal-primary';
                iconContainer.style.background = '#d1fae5';
                iconContainer.style.color = '#10b981';
                iconContainer.innerText = '🔓';
            } else {
                btn.className = 'btn-modal btn-modal-danger';
                iconContainer.style.background = '#fee2e2';
                iconContainer.style.color = '#ef4444';
                iconContainer.innerText = action === 'delete' ? '🗑️' : '🔒';
            }
            
            showModal('confirmModal');
        }

        function submitSingleAction() {
            document.getElementById('singleActionForm').submit();
        }
    </script>
</body>
</html>
