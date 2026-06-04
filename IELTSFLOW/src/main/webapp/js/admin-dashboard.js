    // ── State ─────────────────────────────
    let allUsers  = [];
    let allStats  = {};
    let authChart = null;

    // ── Bootstrap ─────────────────────────
    document.addEventListener('DOMContentLoaded', async () => {
      await loadData();
    });

    // ── Load Data ─────────────────────────
    async function loadData() {
      try {
        const r = await fetch('/IELTSFLOW/api/admin/users');
        const d = await r.json();
        if (!d.success) { showToast('Không thể tải dữ liệu: ' + d.message, 'error'); return; }
        allUsers = d.users;
        allStats = d.stats;
        renderStats(d.stats);
        renderChart(d.stats, d.users);
        renderProviders(d.stats, d.users);
        renderUsers(d.users);
        document.getElementById('nav-total-badge').textContent = d.stats.totalUsers;
        document.getElementById('user-count-label').textContent = `${d.stats.totalUsers} người dùng trong hệ thống`;
      } catch(e) {
        showToast('Lỗi kết nối server', 'error');
      }
    }

    // ── Render Stats ──────────────────────
    function renderStats(stats) {
      animateCount('stat-total',  stats.totalUsers);
      animateCount('stat-active', stats.activeUsers);
      animateCount('stat-today',  stats.newToday);
      animateCount('stat-google', stats.googleUsers);
      animateCount('stat-banned', stats.bannedUsers);
    }

    function animateCount(id, target) {
      const el = document.getElementById(id);
      let cur = 0;
      const step = Math.ceil(target / 30);
      const timer = setInterval(() => {
        cur = Math.min(cur + step, target);
        el.textContent = cur.toLocaleString('vi-VN');
        if (cur >= target) clearInterval(timer);
      }, 30);
    }

    // ── Render Chart ──────────────────────
    function renderChart(stats, users) {
      const active   = Number(stats.activeUsers)  || 0;
      const inactive = (Number(stats.totalUsers) - active - Number(stats.bannedUsers)) || 0;
      const banned   = Number(stats.bannedUsers)  || 0;
      const ctx = document.getElementById('authChart').getContext('2d');
      if (authChart) authChart.destroy();
      authChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: ['Active', 'Inactive', 'Bị khoá'],
          datasets: [{
            data: [active, inactive, banned],
            backgroundColor: ['rgba(16,185,129,0.8)', 'rgba(245,158,11,0.8)', 'rgba(239,68,68,0.8)'],
            borderColor: ['#10b981','#f59e0b','#ef4444'],
            borderWidth: 2, borderRadius: 6, spacing: 4,
          }]
        },
        options: {
          cutout: '70%',
          responsive: true, maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: { color: '#94a3b8', font: { family:'Inter', size:12 }, padding: 16, boxWidth: 12, borderRadius: 4 }
            },
            tooltip: {
              backgroundColor: '#111827', titleColor: '#f1f5f9', bodyColor: '#94a3b8',
              borderColor: 'rgba(255,255,255,0.08)', borderWidth: 1,
              padding: 12, cornerRadius: 10,
            }
          },
          animation: { animateScale: true, duration: 1000 }
        }
      });
    }

    // ── Render Providers ─────────────────
    function renderProviders(stats, users) {
      const total   = Number(stats.totalUsers) || 1;
      const google  = Number(stats.googleUsers) || 0;
      const local   = total - google;
      const gPct    = Math.round(google / total * 100);
      const lPct    = 100 - gPct;
      document.getElementById('google-count').textContent = google + ' users';
      document.getElementById('local-count').textContent  = local  + ' users';
      setTimeout(() => {
        document.getElementById('google-bar').style.width = gPct + '%';
        document.getElementById('local-bar').style.width  = lPct + '%';
      }, 300);
      document.getElementById('google-pct').textContent = gPct + '%';
      document.getElementById('local-pct').textContent  = lPct + '%';

      // Status breakdown
      const active   = Number(stats.activeUsers);
      const banned   = Number(stats.bannedUsers);
      const inactive = total - active - banned;
      const statusWrap = document.getElementById('status-breakdown');
      statusWrap.innerHTML = [
        { label: 'Active',   count: active,   color: '#34d399' },
        { label: 'Inactive', count: inactive, color: '#fbbf24' },
        { label: 'Bị khoá', count: banned,   color: '#f87171' },
      ].map(s => `
        <div style="display:flex;align-items:center;justify-content:space-between;gap:.5rem">
          <span style="display:flex;align-items:center;gap:.5rem;font-size:.8125rem">
            <span style="width:8px;height:8px;border-radius:50%;background:${s.color};flex-shrink:0;display:inline-block"></span>
            ${s.label}
          </span>
          <span style="font-weight:700;font-size:.875rem;color:${s.color}">${s.count}</span>
        </div>`).join('');
    }

    // ── Render User Table ─────────────────
    function renderUsers(users) {
      const tbody = document.getElementById('user-table-body');
      if (!users.length) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:2rem;color:var(--text3)">Không có dữ liệu</td></tr>';
        return;
      }
      tbody.innerHTML = users.map(u => {
        const initials = (u.fullName || '?').split(' ').map(w=>w[0]).slice(-2).join('').toUpperCase();
        const statusClass = (u.status||'').toLowerCase();
        const roleLabel   = u.roleId === 1 ? '<span class="badge admin">Admin</span>' : '<span class="badge candidate">Candidate</span>';
        const providerBadge = u.authProvider === 'Google'
          ? '<span class="badge google">🔗 Google</span>'
          : '<span class="badge local">📧 Email</span>';
        const date = u.createdAt ? new Date(u.createdAt).toLocaleDateString('vi-VN') : '—';
        const actionBtn = u.status === 'Banned'
          ? `<button class="action-btn action-unban" onclick="banUser(${u.userId},'unban','${(u.fullName||'').replace(/'/g,"\\'")}')">✅ Mở khoá</button>`
          : u.roleId !== 1
            ? `<button class="action-btn action-ban" onclick="banUser(${u.userId},'ban','${(u.fullName||'').replace(/'/g,"\\'")}')">🔒 Khoá</button>`
            : '<span style="font-size:.75rem;color:var(--text3)">—</span>';
        return `
          <tr data-name="${(u.fullName||'').toLowerCase()}" data-email="${(u.email||'').toLowerCase()}"
              data-status="${u.status||''}" data-provider="${u.authProvider||''}">
            <td>
              <div class="user-cell">
                <div class="user-av">${initials}</div>
                <div>
                  <div class="user-name-text">${u.fullName || '(Chưa đặt tên)'}</div>
                  <div class="user-email">${u.email || ''}</div>
                </div>
              </div>
            </td>
            <td>${roleLabel}</td>
            <td>${providerBadge}</td>
            <td><span class="badge ${statusClass}"><span class="badge-dot"></span>${u.status||'—'}</span></td>
            <td style="color:var(--text3)">${date}</td>
            <td>${actionBtn}</td>
          </tr>`;
      }).join('');
    }

    // ── Filter Table ──────────────────────
    function filterTable() {
      const q        = document.getElementById('search-input').value.toLowerCase();
      const status   = document.getElementById('status-filter').value;
      const provider = document.getElementById('provider-filter').value;
      document.querySelectorAll('#user-table-body tr[data-name]').forEach(row => {
        const name  = row.dataset.name || '';
        const email = row.dataset.email || '';
        const matchQ = name.includes(q) || email.includes(q);
        const matchS = !status   || row.dataset.status   === status;
        const matchP = !provider || row.dataset.provider === provider;
        row.style.display = (matchQ && matchS && matchP) ? '' : 'none';
      });
    }

    // ── Ban / Unban ───────────────────────
    async function banUser(userId, action, name) {
      const msg = action === 'ban'
        ? `Khóa tài khoản "${name}"?`
        : `Mở khóa tài khoản "${name}"?`;
      if (!confirm(msg)) return;
      try {
        const r = await fetch('/IELTSFLOW/api/admin/users', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ userId, action })
        });
        const d = await r.json();
        showToast(d.message, d.success ? 'success' : 'error');
        if (d.success) await loadData();
      } catch(e) {
        showToast('Lỗi kết nối', 'error');
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
        await fetch('/IELTSFLOW/api/auth/logout', { method: 'POST' });
      } catch(e) { /* ignore network error, still redirect */ }
      location.href = '/IELTSFLOW/jsp/auth.jsp';
    }

    // ── Toast ─────────────────────────────
    function showToast(message, type = 'info') {
      const icons  = { success:'✅', error:'❌', info:'ℹ️', warning:'⚠️' };
      const colors = { success:'#34d399', error:'#f87171', info:'#60a5fa', warning:'#fbbf24' };
      const el = document.createElement('div');
      el.className = 'toast';
      el.style.borderLeft = `3px solid ${colors[type]}`;
      el.innerHTML = `
        <span style="font-size:1.1rem">${icons[type]}</span>
        <div style="flex:1;font-size:.875rem">${message}</div>
        <button onclick="this.closest('.toast').remove()" style="background:none;border:none;cursor:pointer;color:var(--text3)">✕</button>`;
      document.getElementById('toast-container').appendChild(el);
      setTimeout(() => { el.style.animation='toast-out .4s forwards'; setTimeout(()=>el.remove(),400); }, 3500);
    }
  