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
        
        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
        .modal-content { background-color: var(--sidebar-bg, #2a2a2a); margin: 10% auto; padding: 20px; border: 1px solid #888; width: 50%; border-radius: 12px; color: white; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: #fff; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc; background: rgba(255,255,255,0.1); color: white; }
        .btn-form { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; background: var(--accent-red, #ef4444); color: white; font-weight: bold; }
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
                <h1 class="animate-fade-up">
                    <c:choose>
                        <c:when test="${isMentorView}">Mentor Role Management</c:when>
                        <c:otherwise>User Management</c:otherwise>
                    </c:choose>
                </h1>
                <c:if test="${!isMentorView}">
                    <button class="btn btn-primary animate-fade-up" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);" onclick="openUserModal('create')">+ Add New User</button>
                </c:if>
            </div>
            
            <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                <input type="text" id="local-search-input" placeholder="Search users by email or name..." onkeyup="filterTable()">
                <select id="local-role-filter" onchange="filterTable()">
                    <option value="all">All Roles</option>
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
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Role</th>
                            <th>Actions</th>
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
                                    <c:choose>
                                        <c:when test="${isMentorView}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users" style="margin:0;">
                                                <input type="hidden" name="id" value="${user.userId}">
                                                <input type="hidden" name="action" value="revoke_mentor">
                                                <button type="submit" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; border-color: rgba(239, 68, 68, 0.5); color: #fca5a5;" onclick="return confirm('Revoke mentor role?')">Revoke</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem;" onclick="openUserModal('update', ${user.userId}, '${user.fullName.replace('\'', '\\\'')}', '${user.email.replace('\'', '\\\'')}', ${user.roleId}, '${user.status}')">Edit</button>
                                            
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users" style="margin:0;">
                                                <input type="hidden" name="id" value="${user.userId}">
                                                <input type="hidden" name="action" value="lock">
                                                <button type="submit" class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: ${user.status == 'Active' ? '#fca5a5' : '#6ee7b7'}; border-color: rgba(255, 255, 255, 0.2);" onclick="return confirm('Toggle lock for this user?')">
                                                    ${user.status == 'Active' ? 'Lock' : 'Unlock'}
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" style="text-align: center;">No users found.</td>
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
            <span class="close" onclick="closeUserModal()">&times;</span>
            <h2 id="modalTitle">Add New User</h2>
            <form id="userForm" method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="formUserId" value="0">
                
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" id="formFullName" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="formEmail" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="roleId" id="formRoleId">
                        <option value="3">Candidate</option>
                        <option value="2">Mentor</option>
                        <option value="1">Admin</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="status" id="formStatus">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
                <button type="submit" class="btn-form">Save User</button>
            </form>
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
            document.getElementById('modalTitle').innerText = action === 'create' ? 'Add New User' : 'Edit User';
            document.getElementById('formAction').value = action;
            document.getElementById('formUserId').value = id || 0;
            document.getElementById('formFullName').value = name || '';
            document.getElementById('formEmail').value = email || '';
            document.getElementById('formRoleId').value = role || 3;
            document.getElementById('formStatus').value = status || 'Active';
            
            document.getElementById('userModal').style.display = 'block';
        }

        function closeUserModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('userModal')) {
                closeUserModal();
            }
        }
    </script>
</body>
</html>
