// ── State ─────────────────────────────
let authChart = null;

// ── Bootstrap ─────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    if (typeof statsData !== 'undefined') {
        renderChart(statsData);
        renderProviders(statsData);
    }
});

// ── Chart ─────────────────────────────
function renderChart(stats) {
  const ctx = document.getElementById('authChart');
  if (!ctx) return;
  if (authChart) authChart.destroy();

  authChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['Google', 'Email'],
      datasets: [{
        data: [stats.googleUsers, stats.localUsers],
        backgroundColor: ['#ea4335', '#3b82f6'],
        borderWidth: 0,
        hoverOffset: 4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '75%',
      plugins: {
        legend: { display: false },
        tooltip: {
          backgroundColor: 'rgba(17, 24, 39, 0.9)',
          titleFont: { family: 'Inter', size: 13 },
          bodyFont: { family: 'Inter', size: 14, weight: 'bold' },
          padding: 12,
          cornerRadius: 8,
          displayColors: true,
          callbacks: {
            label: function(context) {
              let label = context.label || '';
              if (label) label += ': ';
              if (context.parsed !== null) label += context.parsed + ' users';
              return label;
            }
          }
        }
      }
    }
  });
}

// ── Providers ─────────────────────────
function renderProviders(stats) {
  const t = stats.totalUsers || 1;
  const gp = Math.round((stats.googleUsers / t) * 100);
  const lp = Math.round((stats.localUsers / t) * 100);

  document.getElementById('google-count').textContent = stats.googleUsers + ' users';
  document.getElementById('local-count').textContent  = stats.localUsers + ' users';
  
  document.getElementById('google-bar').style.width = gp + '%';
  document.getElementById('local-bar').style.width  = lp + '%';
  
  document.getElementById('google-pct').textContent = gp + '%';
  document.getElementById('local-pct').textContent  = lp + '%';

  // Status breakdown
  const html = `
    <div style="display:flex;justify-content:space-between;font-size:.875rem">
      <span style="display:flex;align-items:center;gap:.5rem">
        <span style="width:8px;height:8px;border-radius:50%;background:var(--success)"></span> Active
      </span>
      <span style="font-weight:600">${stats.activeUsers}</span>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:.875rem;margin-top:.5rem">
      <span style="display:flex;align-items:center;gap:.5rem">
        <span style="width:8px;height:8px;border-radius:50%;background:var(--danger)"></span> Banned
      </span>
      <span style="font-weight:600">${stats.bannedUsers}</span>
    </div>
  `;
  document.getElementById('status-breakdown').innerHTML = html;
}

// ── Filtering ─────────────────────────
function filterTable() {
  const q = document.getElementById('search-input').value.toLowerCase();
  const s = document.getElementById('status-filter').value;
  const p = document.getElementById('provider-filter').value;

  const rows = document.querySelectorAll('#user-table-body tr');
  let visibleCount = 0;

  rows.forEach(row => {
      if (row.children.length === 1) return; // Skip empty message row

      const name = row.getAttribute('data-name') || '';
      const email = row.getAttribute('data-email') || '';
      const status = row.getAttribute('data-status') || '';
      const provider = row.getAttribute('data-provider') || '';

      const matchQ = !q || name.includes(q) || email.includes(q);
      const matchS = !s || status === s;
      const matchP = !p || provider === p;

      if (matchQ && matchS && matchP) {
          row.style.display = '';
          visibleCount++;
      } else {
          row.style.display = 'none';
      }
  });

  document.getElementById('user-count-label').textContent = `${visibleCount} người dùng thỏa mãn`;
}

// ── Ban/Unban API ─────────────────────
async function banUser(userId, action, name) {
  if (!confirm(`Bạn chắc chắn muốn ${action === 'ban' ? 'khóa' : 'mở khóa'} tài khoản của ${name}?`)) return;
  try {
    const r = await fetch(window.contextPath + '/api/admin/users/ban', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId, action })
    });
    const d = await r.json();
    if (d.success) {
      showToast(d.message);
      setTimeout(() => location.reload(), 1000);
    } else {
      showToast(d.message, 'error');
    }
  } catch(e) {
    showToast('Lỗi mạng', 'error');
  }
}

// ── Section Switcher ──────────────────
function showSection(name, el) {
  document.querySelectorAll('[id^="section-"]').forEach(s => s.style.display = 'none');
  document.getElementById('section-' + name).style.display = '';
  document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
  el.classList.add('active');
  const titles = { dashboard: ['Dashboard','Tổng quan hệ thống IELTS Flow'], users: ['Quản lý User','Xem và quản lý tất cả tài khoản'] };
  const [t, s] = titles[name] || [name, ''];
  document.getElementById('page-title').textContent = t;
  document.getElementById('page-sub').textContent   = s;
}

// ── Logout ────────────────────────────
async function confirmLogout() {
  if (!confirm('Bạn có chắc muốn đăng xuất?')) return;
  try {
    await fetch(window.contextPath + '/api/auth/logout', { method: 'POST' });
  } catch(e){}
  location.href = window.contextPath + '/jsp/auth.jsp';
}

// ── Toasts ────────────────────────────
function showToast(msg, type='success') {
  const c = document.getElementById('toast-container');
  const t = document.createElement('div');
  t.className = `toast toast-${type}`;
  
  const icon = type === 'success' 
    ? `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`
    : `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;

  t.innerHTML = `${icon} <span>${msg}</span>`;
  c.appendChild(t);
  setTimeout(() => t.classList.add('show'), 10);
  setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 300); }, 3000);
}
