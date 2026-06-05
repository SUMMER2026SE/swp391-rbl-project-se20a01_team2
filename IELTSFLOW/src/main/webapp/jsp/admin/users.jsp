<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Management</title>
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .admin-table th { padding: 15px 20px; color: var(--text-secondary); font-weight: 500; font-size: 0.9rem; text-transform: uppercase; border-bottom: 1px solid var(--glass-border); }
        .admin-table td { padding: 15px 20px; background: rgba(255,255,255,0.02); }
        .admin-table tr td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .admin-table tr td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        .admin-table tr:hover td { background: rgba(255,255,255,0.05); }
    </style>
</head>
<body>
    <div class="bg-blob blob-1" style="background: var(--accent-red); opacity: 0.1;"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar">
            <div class="brand" style="background: linear-gradient(135deg, #ef4444, #f59e0b); -webkit-background-clip: text;">IELTSFLOW Admin</div>
            <div class="user-profile">
                <div class="avatar" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">AD</div>
                <div><h4 style="font-size: 1rem;">Administrator</h4></div>
            </div>
            <nav class="nav-menu">
                <a href="#" class="nav-link active">👥 User Management</a>
                <a href="#" class="nav-link">⚙️ System Settings</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="#" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1 class="animate-fade-up">User Management</h1>
                <button class="btn btn-primary animate-fade-up" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);" onclick="addNewUser()">+ Add New User</button>
            </div>
            
            <div class="search-pill animate-fade-up" style="animation-delay: 0.1s;">
                <input type="text" id="search-input" placeholder="Search users by email or name...">
                <select id="role-filter" onchange="searchUsers()">
                    <option value="all">All Roles</option>
                    <option value="1">Admin</option>
                    <option value="2">Mentor</option>
                    <option value="3">Candidate</option>
                </select>
                <button class="btn btn-glass" style="border-radius: 25px;" onclick="searchUsers()">Search</button>
            </div>

            <div class="animate-fade-up" style="animation-delay: 0.2s;">
                <table class="admin-table">
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
                    <tbody id="users-tbody">
                        <!-- Data will be loaded by API -->
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script src="../../js/admin.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
