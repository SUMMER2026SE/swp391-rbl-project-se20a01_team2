/* ============================================================
   IELTS FLOW – profile.js
   Handles: Radar Chart, Countdown, Avatar/Frame Selection,
            Edit Profile, Gamification, Activity Feed
   ============================================================ */

/* ── Radar Chart (Chart.js) ─────────────────────────────── */
function initRadarChart() {
  const canvas = document.getElementById('radarChart');
  if (!canvas) return;

  // Load user data (from localStorage or defaults)
  const userData = getUserData();

  const ctx = canvas.getContext('2d');
  new Chart(ctx, {
    type: 'radar',
    data: {
      labels: ['Listening', 'Reading', 'Writing', 'Speaking'],
      datasets: [
        {
          label: 'Điểm hiện tại',
          data: [
            userData.skills.listening,
            userData.skills.reading,
            userData.skills.writing,
            userData.skills.speaking,
          ],
          backgroundColor: 'rgba(59,130,246,0.2)',
          borderColor: 'rgba(59,130,246,0.9)',
          borderWidth: 2,
          pointBackgroundColor: 'rgba(59,130,246,1)',
          pointBorderColor: '#fff',
          pointBorderWidth: 2,
          pointRadius: 5,
          pointHoverRadius: 7,
        },
        {
          label: 'Mục tiêu',
          data: [
            userData.targetBand,
            userData.targetBand,
            userData.targetBand,
            userData.targetBand,
          ],
          backgroundColor: 'rgba(59,130,246,0.05)',
          borderColor: 'rgba(59,130,246,0.3)',
          borderWidth: 1.5,
          borderDash: [5, 5],
          pointBackgroundColor: 'rgba(59,130,246,0.4)',
          pointBorderColor: 'transparent',
          pointRadius: 3,
        }
      ]
    },
    options: {
      responsive: true,
      animation: { duration: 1500, easing: 'easeOutQuart' },
      scales: {
        r: {
          min: 0,
          max: 9,
          ticks: {
            stepSize: 1.5,
            color: 'rgba(148,163,184,0.6)',
            font: { size: 10 },
            backdropColor: 'transparent',
            callback: (v) => v === 0 ? '' : v.toFixed(1),
          },
          grid: {
            color: 'rgba(255,255,255,0.06)',
            circular: true,
          },
          angleLines: { color: 'rgba(255,255,255,0.06)' },
          pointLabels: {
            color: 'rgba(148,163,184,0.9)',
            font: { size: 12, weight: '600', family: 'Inter' },
          },
        }
      },
      plugins: {
        legend: { display: false },
        tooltip: {
          backgroundColor: 'rgba(17,24,39,0.95)',
          titleColor: '#F1F5F9',
          bodyColor: '#94A3B8',
          borderColor: 'rgba(255,255,255,0.1)',
          borderWidth: 1,
          padding: 12,
          cornerRadius: 12,
          callbacks: {
            label: (ctx) => `  ${ctx.dataset.label}: ${ctx.raw}`,
          }
        }
      }
    }
  });
}

/* ── Countdown Timer ────────────────────────────────────── */
function initCountdown() {
  const daysEl = document.getElementById('countdown-days');
  const dateEl = document.getElementById('exam-date-display');
  const urgencyEl = document.getElementById('countdown-urgency');
  if (!daysEl) return;

  const userData = getUserData();
  const examDate = userData.examDate ? new Date(userData.examDate) : getDefaultExamDate();

  // Update display
  updateCountdownDisplay(examDate, daysEl, dateEl, urgencyEl);

  // Live countdown tick (update every hour)
  setInterval(() => {
    updateCountdownDisplay(examDate, daysEl, dateEl, urgencyEl);
  }, 3600000);
}

function getDefaultExamDate() {
  const d = new Date();
  d.setDate(d.getDate() + 45);
  return d;
}

function updateCountdownDisplay(examDate, daysEl, dateEl, urgencyEl) {
  const now = new Date();
  const diff = examDate - now;
  const daysLeft = Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));

  if (daysEl) {
    daysEl.textContent = daysLeft;
    // Color based on urgency
    if (daysLeft <= 7) daysEl.style.filter = 'hue-rotate(270deg)'; // Red-ish
    else if (daysLeft <= 30) daysEl.style.filter = 'hue-rotate(30deg)'; // Orange
  }

  if (dateEl) {
    const options = { day: 'numeric', month: 'long', year: 'numeric' };
    dateEl.textContent = examDate.toLocaleDateString('vi-VN', options);
  }

  if (urgencyEl) {
    if (daysLeft <= 7) {
      urgencyEl.textContent = '🚨 Kỳ thi sắp đến! Ôn luyện tối đa!';
      urgencyEl.style.background = 'rgba(239,68,68,0.1)';
      urgencyEl.style.borderColor = 'rgba(239,68,68,0.3)';
      urgencyEl.style.color = 'var(--clr-danger-400)';
    } else if (daysLeft <= 30) {
      urgencyEl.textContent = '⚡ Nước rút! Tập trung mỗi ngày!';
      urgencyEl.style.background = 'rgba(245,158,11,0.1)';
      urgencyEl.style.borderColor = 'rgba(245,158,11,0.3)';
      urgencyEl.style.color = 'var(--clr-gold-400)';
    } else if (daysLeft <= 60) {
      urgencyEl.textContent = '🔥 Tập trung tối đa!';
    } else {
      urgencyEl.textContent = '🌱 Học từng bước vững chắc!';
      urgencyEl.style.background = 'rgba(16,185,129,0.1)';
      urgencyEl.style.borderColor = 'rgba(16,185,129,0.2)';
      urgencyEl.style.color = 'var(--clr-success-400)';
    }
  }
}

function setExamDate() {
  const dateStr = prompt('Nhập ngày thi của bạn (YYYY-MM-DD):\nVí dụ: 2026-08-15');
  if (!dateStr) return;
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) { showToast('Định dạng ngày không hợp lệ!', 'error'); return; }

  const userData = getUserData();
  userData.examDate = dateStr;
  saveUserData(userData);

  initCountdown();
  showToast('Đã cập nhật ngày thi! 📅', 'success');
}

/* ── Avatar Frame Selection ─────────────────────────────── */
let selectedFrame = { id: 'target7', label: 'Target 7.0', gradient: 'linear-gradient(135deg,#2563EB,#7C3AED)' };

function selectFrame(el, frameId, frameName, gradient) {
  document.querySelectorAll('.frame-option').forEach(f => f.classList.remove('selected'));
  el.classList.add('selected');
  selectedFrame = { id: frameId, label: frameName, gradient };
}

function handleAvatarUpload(event) {
  const file = event.target.files[0];
  if (!file) return;
  if (file.size > 5 * 1024 * 1024) { showToast('Ảnh không được lớn hơn 5MB!', 'error'); return; }

  const reader = new FileReader();
  reader.onload = (e) => {
    const userData = getUserData();
    userData.avatarUrl = e.target.result;
    saveUserData(userData);
    showToast('Ảnh đã được tải lên! Nhấn "Lưu thay đổi" để áp dụng.', 'success');
  };
  reader.readAsDataURL(file);
}

function saveAvatar() {
  const userData = getUserData();
  userData.frame = selectedFrame;
  saveUserData(userData);

  // Update main avatar frame
  applyAvatarFrame(selectedFrame);
  toggleAvatarModal();
  showToast(`Avatar đã được cập nhật với khung "${selectedFrame.label}"! 🎨`, 'success');
}

function applyAvatarFrame(frame) {
  const frameEl = document.getElementById('avatar-frame-el');
  const labelEl = document.getElementById('avatar-frame-label');

  if (frameEl) {
    if (frame.id === 'none') {
      frameEl.style.background = 'rgba(255,255,255,0.1)';
    } else if (frame.gradient) {
      frameEl.style.background = frame.gradient;
    }
  }

  if (labelEl) {
    labelEl.textContent = frame.id === 'none' ? '' : frame.label;
    labelEl.style.display = frame.id === 'none' ? 'none' : 'block';
  }

  // Update nav avatar
  const navAvatar = document.getElementById('nav-avatar');
  if (navAvatar) {
    navAvatar.style.borderColor = frame.id === 'none' ? 'var(--clr-primary-500)' : 'transparent';
  }
}

/* ── Modal Controls ─────────────────────────────────────── */
function toggleAvatarModal() {
  const modal = document.getElementById('avatar-modal');
  if (!modal) return;
  modal.classList.toggle('hidden');
}

function openEditProfile() {
  const modal = document.getElementById('edit-profile-modal');
  if (!modal) return;

  const userData = getUserData();
  const nameEl = document.getElementById('edit-name');
  const emailEl = document.getElementById('edit-email');
  const examDateEl = document.getElementById('edit-exam-date');
  const targetBandEl = document.getElementById('edit-target-band');

  if (nameEl) nameEl.value = userData.name || 'Nguyễn Minh Anh';
  if (emailEl) emailEl.value = userData.email || 'minhanh@example.com';
  if (examDateEl && userData.examDate) examDateEl.value = userData.examDate;
  if (targetBandEl) targetBandEl.value = userData.targetBand || '7.0';

  modal.classList.remove('hidden');
}

function closeEditProfile() {
  document.getElementById('edit-profile-modal')?.classList.add('hidden');
}

function saveProfile() {
  const name = document.getElementById('edit-name')?.value?.trim();
  const email = document.getElementById('edit-email')?.value?.trim();
  const examDate = document.getElementById('edit-exam-date')?.value;
  const targetBand = document.getElementById('edit-target-band')?.value;

  if (!name) { showToast('Vui lòng nhập tên!', 'error'); return; }

  const userData = getUserData();
  userData.name = name;
  userData.email = email;
  userData.examDate = examDate;
  userData.targetBand = parseFloat(targetBand) || 7.0;
  saveUserData(userData);

  // Update UI
  const nameEl = document.getElementById('user-name');
  if (nameEl) nameEl.textContent = name;
  const emailEl = document.getElementById('user-email');
  if (emailEl) emailEl.textContent = email;
  const navAvatarText = document.getElementById('nav-avatar-text');
  if (navAvatarText) {
    const initials = name.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();
    navAvatarText.textContent = initials;
  }
  const mainAvatar = document.getElementById('avatar-main');
  if (mainAvatar) {
    const initials = name.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();
    mainAvatar.textContent = initials;
  }

  // Reinit countdown with new date
  if (examDate) initCountdown();

  closeEditProfile();
  showToast('Hồ sơ đã được cập nhật thành công! ✅', 'success');
}

/* ── Logout ─────────────────────────────────────────────── */
function confirmLogout() {
  if (confirm('Bạn có chắc muốn đăng xuất?\nTiến trình học của bạn đã được lưu!')) {
    showToast('Đang đăng xuất...', 'info', 1500);
    setTimeout(() => window.location.href = '/IELTSFLOW/jsp/auth.jsp', 1500);
  }
}

/* ── User Data (localStorage) ───────────────────────────── */
function getUserData() {
  const defaults = {
    name: 'Nguyễn Minh Anh',
    email: 'minhanh@example.com',
    targetBand: 7.0,
    currentBand: 6.0,
    examDate: (() => {
      const d = new Date();
      d.setDate(d.getDate() + 45);
      return d.toISOString().split('T')[0];
    })(),
    skills: {
      listening: 7.0,
      reading: 6.5,
      writing: 5.5,
      speaking: 6.0,
    },
    frame: { id: 'target7', label: 'Target 7.0', gradient: 'linear-gradient(135deg,#2563EB,#7C3AED)' },
    avatarUrl: null,
    streak: 28,
  };

  try {
    const saved = JSON.parse(localStorage.getItem('ieltsUserData') || '{}');
    return { ...defaults, ...saved, skills: { ...defaults.skills, ...(saved.skills || {}) } };
  } catch {
    return defaults;
  }
}

function saveUserData(data) {
  localStorage.setItem('ieltsUserData', JSON.stringify(data));
}

/* ── Progress Bar Animations ────────────────────────────── */
function animateProgressBars() {
  const bars = document.querySelectorAll('.band-bar-fill');
  bars.forEach(bar => {
    const targetWidth = bar.style.width;
    bar.style.width = '0%';
    setTimeout(() => {
      bar.style.transition = 'width 1.2s cubic-bezier(0.16,1,0.3,1)';
      bar.style.width = targetWidth;
    }, 100);
  });
}

/* ── Toast ──────────────────────────────────────────────── */
function showToast(message, type = 'info', duration = 4000) {
  const container = document.getElementById('toast-container');
  if (!container) return;
  const icons = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
  const titles = { success: 'Thành công!', error: 'Có lỗi xảy ra', info: 'Thông tin', warning: 'Cảnh báo' };
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `
    <span style="font-size:1.25rem; flex-shrink:0;">${icons[type]}</span>
    <div style="flex:1;">
      <div style="font-size:0.875rem; font-weight:600; color:var(--clr-text-primary); margin-bottom:2px;">${titles[type]}</div>
      <div style="font-size:0.8125rem; color:var(--clr-text-secondary); line-height:1.5;">${message}</div>
    </div>
    <button onclick="this.closest('.toast').remove()" style="color:var(--clr-text-muted); font-size:1rem; background:none; border:none; cursor:pointer; flex-shrink:0; padding:0 0 0 0.5rem;">✕</button>
  `;
  container.appendChild(toast);
  setTimeout(() => {
    toast.style.animation = 'toast-out 0.4s ease forwards';
    setTimeout(() => toast.remove(), 400);
  }, duration);
}

/* ── Close modal on overlay click ──────────────────────── */
document.addEventListener('click', (e) => {
  const avatarModal = document.getElementById('avatar-modal');
  const editModal = document.getElementById('edit-profile-modal');
  if (avatarModal && e.target === avatarModal) toggleAvatarModal();
  if (editModal && e.target === editModal) closeEditProfile();
});

/* ── Keyboard shortcuts ─────────────────────────────────── */
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    document.getElementById('avatar-modal')?.classList.add('hidden');
    document.getElementById('edit-profile-modal')?.classList.add('hidden');
  }
});

/* ── Init ───────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', async () => {
  // ── Bước 1: Lấy thông tin thật từ Session (backend) ──────────────
  try {
    const resp = await fetch('/IELTSFLOW/api/user/me');
    if (resp.status === 401) {
      // Chưa đăng nhập → Redirect về trang đăng nhập
      window.location.href = '/IELTSFLOW/jsp/auth.jsp?redirect_error=Vui+lòng+đăng+nhập+để+tiếp+tục';
      return;
    }
    const result = await resp.json();
    if (result.success && result.data) {
      const serverUser = result.data;
      if (serverUser.roleId === 1) {
        window.location.href = 'admin/dashboard.jsp';
        return;
      }
      // Lưu vào localStorage và cập nhật UI ngay lập tức
      const localData = JSON.parse(localStorage.getItem('ieltsUserData') || '{}');
      localData.name  = serverUser.fullName || localData.name || 'Người dùng';
      localData.email = serverUser.email    || localData.email || '';
      localStorage.setItem('ieltsUserData', JSON.stringify(localData));

      // Cập nhật các element hiển thị tên thật
      const nameEls = document.querySelectorAll('#user-name, #nav-name');
      nameEls.forEach(el => { if (el) el.textContent = localData.name; });

      const emailEls = document.querySelectorAll('#user-email');
      emailEls.forEach(el => { if (el) el.textContent = localData.email; });

      // Initials Avatar
      const initials = localData.name.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();
      ['avatar-main', 'nav-avatar-text'].forEach(id => {
        const el = document.getElementById(id);
        if (el && el.tagName !== 'IMG') el.textContent = initials;
      });

      // Badge vai trò (nếu có element)
      const roleEl = document.getElementById('user-role-badge');
      if (roleEl) {
        roleEl.textContent = serverUser.roleId === 1 ? 'Admin' : 'Học viên';
      }
      
      // Hiển thị nút truy cập Admin Dashboard nếu là Admin
      const adminBtn = document.getElementById('admin-dashboard-btn');
      if (adminBtn) {
        if (serverUser.roleId === 1) {
          adminBtn.style.display = 'inline-flex';
        } else {
          adminBtn.style.display = 'none';
        }
      }
    }
  } catch (e) {
    console.warn('Không thể lấy thông tin user từ server, dùng dữ liệu local:', e);
  }

  // ── Bước 2: Lấy userData từ localStorage (chứa exam date, skills...) ─
  const userData = getUserData();

  // Apply saved frame
  if (userData.frame) {
    applyAvatarFrame(userData.frame);
    selectedFrame = userData.frame;
    document.querySelectorAll('.frame-option').forEach(el => {
      if (el.classList.contains(`frame-opt-${userData.frame.id}`)) {
        el.classList.add('selected');
      }
    });
  }

  // Apply avatar if saved
  if (userData.avatarUrl) {
    const mainAvatar = document.getElementById('avatar-main');
    if (mainAvatar) {
      const img = document.createElement('img');
      img.src = userData.avatarUrl;
      img.style.cssText = 'width:100%;height:100%;object-fit:cover;border-radius:50%;';
      mainAvatar.replaceWith(img);
    }
  }

  // Init components
  initRadarChart();
  initCountdown();
  animateProgressBars();

  // Welcome toast on first visit
  if (!sessionStorage.getItem('dashboardVisited')) {
    sessionStorage.setItem('dashboardVisited', '1');
    const firstName = (userData.name || 'bạn').split(' ').pop();
    const daysLeft  = Math.ceil((new Date(userData.examDate) - new Date()) / 86400000);
    setTimeout(() => {
      showToast(`Chào mừng ${firstName}! Còn ${daysLeft > 0 ? daysLeft + ' ngày' : 'ít hơn 1 ngày'} đến kỳ thi. Chiến thôi! 💪`, 'info', 5000);
    }, 800);
  }
});

