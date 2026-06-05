// Admin API logic

let allUsers = [];

async function fetchUsers() {
    try {
        const response = await fetch('../../api/admin/users');
        if (response.ok) {
            allUsers = await response.json();
            renderUsers(allUsers);
        } else {
            console.error('Failed to fetch users');
        }
    } catch (error) {
        console.error('Error fetching users:', error);
    }
}

function renderUsers(users) {
    const tbody = document.getElementById('users-tbody');
    if (!tbody) return;

    let html = '';
    users.forEach(user => {
        let roleName = 'Candidate';
        if (user.roleId === 1) roleName = 'Admin';
        else if (user.roleId === 2) roleName = 'Mentor';

        let statusColor = 'var(--accent-green)';
        if (user.status !== 'Active') statusColor = 'var(--accent-red)';

        let isLocked = user.status === 'Inactive';
        let lockBtnText = isLocked ? 'Unlock' : 'Lock';
        let lockBtnColor = isLocked ? 'var(--accent-green)' : 'var(--accent-red)';
        let lockNewStatus = isLocked ? 'Active' : 'Inactive';

        html += `
            <tr>
                <td>#${user.userId}</td>
                <td>${user.fullName}</td>
                <td>${user.email}</td>
                <td><span style="color: ${statusColor}; font-weight: 600;">${user.status || 'Active'}</span></td>
                <td>${roleName}</td>
                <td>
                    <button class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem;" onclick="editUser(${user.userId})">Edit</button>
                    <button class="btn btn-glass" style="padding: 5px 10px; font-size: 0.8rem; color: ${lockBtnColor}; border-color: rgba(255, 255, 255, 0.2);" onclick="toggleLock(${user.userId}, '${user.fullName.replace(/'/g, "\\'")}', '${user.email.replace(/'/g, "\\'")}', '${lockNewStatus}')">${lockBtnText}</button>
                </td>
            </tr>
        `;
    });

    if (users.length === 0) {
        html = '<tr><td colspan="6" style="text-align: center;">No users found.</td></tr>';
    }

    tbody.innerHTML = html;
}

async function editUser(id) {
    const user = allUsers.find(u => u.userId === id);
    if (!user) return;

    const newFullName = prompt("Edit Full Name:", user.fullName);
    if (newFullName === null) return; // Cancelled

    let newEmail = prompt("Edit Email:", user.email);
    if (newEmail === null) return; // Cancelled

    const emailPattern = /^.+@.+\.com$/i;
    while (!emailPattern.test(newEmail)) {
        alert("Email không hợp lệ. Vui lòng nhập lại theo định dạng kiểu như abc@gmail.com");
        newEmail = prompt("Edit Email:", newEmail);
        if (newEmail === null) return; // Cancelled
    }

    let newStatus = prompt("Edit Status (Active, Inactive):", user.status);
    if (newStatus === null) return;
    
    while (!['Active', 'Inactive'].includes(newStatus)) {
        alert("Status không hợp lệ. Vui lòng nhập lại (Active, Inactive).");
        newStatus = prompt("Edit Status:", newStatus);
        if (newStatus === null) return;
    }

    try {
        const response = await fetch(`../../api/admin/users/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                fullName: newFullName,
                email: newEmail,
                status: newStatus
            })
        });

        if (response.ok) {
            alert('User updated successfully!');
            fetchUsers();
        } else {
            const err = await response.json();
            alert('Failed to update user: ' + (err.error || response.statusText));
        }
    } catch (error) {
        alert('Error updating user: ' + error.message);
    }
}

async function toggleLock(id, currentFullName, currentEmail, newStatus) {
    const actionText = newStatus === 'Active' ? 'unlock' : 'lock';
    if (!confirm(`Are you sure you want to ${actionText} this user?`)) {
        return;
    }

    try {
        const response = await fetch(`../../api/admin/users/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                fullName: currentFullName,
                email: currentEmail,
                status: newStatus
            })
        });

        if (response.ok) {
            alert(`User ${actionText}ed successfully!`);
            fetchUsers();
        } else {
            const err = await response.json();
            alert(`Failed to ${actionText} user: ` + (err.error || response.statusText));
        }
    } catch (error) {
        alert(`Error ${actionText}ing user: ` + error.message);
    }
}

function searchUsers() {
    const searchInput = document.getElementById('search-input')?.value.toLowerCase() || '';
    const roleFilter = document.getElementById('role-filter')?.value || 'all';

    let filtered = allUsers;

    if (roleFilter !== 'all') {
        filtered = filtered.filter(u => u.roleId == roleFilter);
    }

    if (searchInput) {
        filtered = filtered.filter(u => 
            (u.fullName && u.fullName.toLowerCase().includes(searchInput)) || 
            (u.email && u.email.toLowerCase().includes(searchInput))
        );
    }

    renderUsers(filtered);
}

async function addNewUser() {
    const fullName = prompt("Enter full name:");
    if (!fullName) return;

    let email = prompt("Enter email:");
    if (email === null) return;

    const emailPattern = /^.+@.+\.com$/i;
    while (!emailPattern.test(email)) {
        alert("Email không hợp lệ. Vui lòng nhập lại theo định dạng kiểu như abc@gmail.com");
        email = prompt("Enter email:", email);
        if (email === null) return;
    }

    const role = prompt("Enter role ID (1: Admin, 2: Mentor, 3: Candidate)", "3");
    if (!role) return;

    let status = prompt("Enter status (Active, Inactive):", "Active");
    if (status === null) return;
    
    while (!['Active', 'Inactive'].includes(status)) {
        alert("Status không hợp lệ. Vui lòng nhập lại (Active, Inactive).");
        status = prompt("Enter status:", status);
        if (status === null) return;
    }

    const user = {
        fullName: fullName,
        email: email,
        roleId: parseInt(role),
        status: status
    };

    try {
        const response = await fetch('../../api/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(user)
        });

        if (response.ok) {
            alert('User added successfully!');
            fetchUsers(); // refresh the list
        } else {
            const err = await response.json();
            alert('Failed to add user: ' + (err.error || response.statusText));
        }
    } catch (error) {
        alert('Error adding user: ' + error.message);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    fetchUsers();
});
