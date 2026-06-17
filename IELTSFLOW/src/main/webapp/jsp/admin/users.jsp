<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .admin-table th { padding: 15px 20px; color: var(--text-secondary); font-weight: 500; font-size: 0.9rem; text-transform: uppercase; border-bottom: 1px solid var(--glass-border); }
        .admin-table td { padding: 15px 20px; background: rgba(255,255,255,0.02); }
        .admin-table tr td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .admin-table tr td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        .admin-table tr:hover td { background: rgba(255,255,255,0.05); }
        
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
                <button class="btn btn-primary animate-fade-up" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);" onclick="openUserModal('create')">+ Thêm người dùng mới</button>
            </div>
            
            <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                <input type="text" id="local-search-input" placeholder="Tìm kiếm người dùng theo email hoặc tên..." onkeyup="filterTable()">
                <select id="local-role-filter" onchange="filterTable()">
                    <option value="all">Tất cả vai trò</option>
                    <option value="1">Admin</option>
                    <option value="2">Mentor</option>
                    <option value="3">Candidate</option>
                </select>
            </div>

            <div class="animate-fade-up" style="animation-delay: 0.2s;">
                <table class="admin-table" id="usersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Trạng thái</th>
                            <th>Vai trò</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr data-role="${user.roleId}">
                                <td>#${user.userId}</td>
                                <td class="uname">${user.fullName}</td>
                                <td class="uemail">${user.email}</td>
                                <td>
                                    <span style="color: ${user.status == 'Active' ? 'var(--accent-green, #10B981)' : 'var(--accent-red, #ef4444)'}; font-weight: 600;">
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
                                <td style="display: flex; gap: 5px;">
                                    <button class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem;" onclick="openUserModal('update', ${user.userId}, '${user.fullName.replace('\'', '\\\'')}', '${user.email.replace('\'', '\\\'')}', ${user.roleId}, '${user.status}')">Chỉnh sửa</button>
                                    
                                    <form id="lockForm_${user.userId}" method="post" action="${pageContext.request.contextPath}/admin/users" style="margin:0;">
                                        <input type="hidden" name="id" value="${user.userId}">
                                        <input type="hidden" name="action" value="${user.status == 'Active' ? 'lock' : 'unlock'}">
                                        <button type="button" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: ${user.status == 'Active' ? '#fca5a5' : '#6ee7b7'}; border-color: rgba(255, 255, 255, 0.2);" onclick="openConfirmModal(${user.userId}, '${user.status == 'Active' ? 'Khóa' : 'Mở khóa'}', '${user.fullName.replace('\'', '\\\'')}')">
                                            ${user.status == 'Active' ? 'Khóa' : 'Mở khóa'}
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" style="text-align: center;">Không tìm thấy người dùng nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- User Modal Form -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title" id="modalTitle">Thêm người dùng mới</h2>
                <span class="close" onclick="closeUserModal()">&times;</span>
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
                        <option value="3">Học viên</option>
                        <option value="2">Mentor</option>
                        <option value="1">Admin</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="formStatus">
                        <option value="Active">Active (Hoạt động)</option>
                        <option value="Inactive">Inactive (Vô hiệu)</option>
                        <option value="Banned">Banned (Cấm)</option>
                    </select>
                </div>
                <button type="submit" class="btn-modal btn-modal-primary" style="margin-top: 10px;">Lưu người dùng</button>
            </form>
        </div>
    </div>

    <!-- Confirm Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content" style="width: 350px; text-align: center;">
            <div id="confirmIconContainer" style="background: #fee2e2; color: #ef4444; width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 28px;">
                ⚠️
            </div>
            <h2 class="modal-title" id="confirmTitle" style="margin-bottom: 10px; justify-content: center;">Xác nhận</h2>
            <p id="confirmMessage" style="color: #64748b; font-size: 0.95rem; margin-bottom: 25px; line-height: 1.5;"></p>
            <div class="modal-footer">
                <button type="button" class="btn-modal btn-modal-secondary" onclick="closeConfirmModal()">Hủy</button>
                <button type="button" class="btn-modal btn-modal-danger" id="confirmBtn">Đồng ý</button>
            </div>
        </div>
    </div>

    <script>
        // Simple client-side table filter
        function filterTable() {
            var input = document.getElementById("local-search-input").value.toLowerCase();
            var roleFilter = document.getElementById("local-role-filter").value;
            var table = document.getElementById("usersTable");
            var tr = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            for (var i = 0; i < tr.length; i++) {
                if (tr[i].getElementsByTagName("td").length === 1) continue; // skip "No users found" row
                var name = tr[i].querySelector(".uname").innerText.toLowerCase();
                var email = tr[i].querySelector(".uemail").innerText.toLowerCase();
                var role = tr[i].getAttribute("data-role");

                var textMatch = name.includes(input) || email.includes(input);
                var roleMatch = (roleFilter === "all") || (role === roleFilter);

                if (textMatch && roleMatch) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }

        // Modal logic
        function openUserModal(action, id, name, email, role, status) {
            document.getElementById('modalTitle').innerText = action === 'create' ? 'Thêm người dùng mới' : 'Chỉnh sửa người dùng';
            document.getElementById('formAction').value = action;
            document.getElementById('formUserId').value = id || 0;
            document.getElementById('formFullName').value = name || '';
            document.getElementById('formEmail').value = email || '';
            document.getElementById('formRoleId').value = role || 3;
            document.getElementById('formRoleIdDisplay').value = role || 3;
            document.getElementById('formStatus').value = status || 'Active';
            
            if (role == 1) {
                document.getElementById('formRoleIdDisplay').disabled = true;
            } else {
                document.getElementById('formRoleIdDisplay').disabled = false;
            }
            
            const modal = document.getElementById('userModal');
            modal.style.display = 'block';
            setTimeout(() => modal.classList.add('show'), 10);
        }

        function closeUserModal() {
            const modal = document.getElementById('userModal');
            modal.classList.remove('show');
            setTimeout(() => modal.style.display = 'none', 300);
        }

        // Custom Confirm Modal Logic
        let currentTargetFormId = null;

        function openConfirmModal(userId, actionText, userName) {
            currentTargetFormId = 'lockForm_' + userId;
            document.getElementById('confirmTitle').innerText = actionText + ' tài khoản';
            document.getElementById('confirmMessage').innerHTML = 'Bạn có chắc chắn muốn <b>' + actionText.toLowerCase() + '</b> tài khoản của người dùng <b>' + userName + '</b>?';
            
            const btn = document.getElementById('confirmBtn');
            const iconContainer = document.getElementById('confirmIconContainer');
            
            if(actionText === 'Khóa') {
                btn.className = 'btn-modal btn-modal-danger';
                iconContainer.style.background = '#fee2e2';
                iconContainer.style.color = '#ef4444';
                iconContainer.innerText = '🔒';
            } else {
                btn.className = 'btn-modal btn-modal-primary';
                iconContainer.style.background = '#d1fae5';
                iconContainer.style.color = '#10b981';
                iconContainer.innerText = '🔓';
            }
            
            const modal = document.getElementById('confirmModal');
            modal.style.display = 'block';
            setTimeout(() => modal.classList.add('show'), 10);
        }

        function closeConfirmModal() {
            const modal = document.getElementById('confirmModal');
            modal.classList.remove('show');
            setTimeout(() => modal.style.display = 'none', 300);
            currentTargetFormId = null;
        }

        document.getElementById('confirmBtn').onclick = function() {
            if (currentTargetFormId) {
                document.getElementById(currentTargetFormId).submit();
            }
        };

        window.onclick = function(event) {
            if (event.target == document.getElementById('userModal')) {
                closeUserModal();
            }
            if (event.target == document.getElementById('confirmModal')) {
                closeConfirmModal();
            }
        }
    </script>
</body>
</html>
