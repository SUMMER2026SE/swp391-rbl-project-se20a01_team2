// account.js v6 - Server-side goal storage + full band range

document.addEventListener('DOMContentLoaded', () => {

    // === 1. Toast ===
    const toastContainer = document.getElementById('toastContainer');
    function showToast(message, type = 'success', duration = 3500) {
        if (!toastContainer) return;
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        const color = type === 'success' ? 'var(--color-success-500)' : 'var(--color-danger-500)';
        toast.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="' + color + '" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle></svg>' +
                          '<span class="text-sm fw-medium">' + message + '</span>';
        toastContainer.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 10);
        setTimeout(() => { toast.classList.remove('show'); setTimeout(() => toast.remove(), 300); }, duration);
    }

    // === 2. Mobile Sidebar ===
    const mobileToggle = document.getElementById('mobileToggle');
    const sidebar = document.getElementById('sidebar');
    if (mobileToggle && sidebar) {
        mobileToggle.addEventListener('click', () => sidebar.classList.toggle('open'));
        document.addEventListener('click', (e) => {
            if (window.innerWidth <= 768 && !sidebar.contains(e.target) && !mobileToggle.contains(e.target))
                sidebar.classList.remove('open');
        });
    }

    // === 3. Sidebar Links (Tab logic removed since we use separate pages) ===
    const navItems = document.querySelectorAll('.sidebar-nav-item');
    if (window.innerWidth <= 768 && sidebar) {
        navItems.forEach(item => {
            item.addEventListener('click', () => {
                sidebar.classList.remove('open');
            });
        });
    }

    // === 4. Avatar ===
    const avatarContainer = document.getElementById('profileAvatar');
    const avatarInput = document.getElementById('avatarInput');
    const avatarPreview = document.getElementById('avatarPreview');
    const profileInitials = document.getElementById('profileInitials');
    const sidebarAvatar = document.getElementById('sidebarAvatar');

    if (avatarContainer && avatarInput) {
        avatarContainer.addEventListener('click', () => avatarInput.click());
        avatarInput.addEventListener('change', async function() {
            const file = this.files[0];
            if (file) {
                // Show temporary preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    const base64Str = e.target.result;
                    if (avatarPreview) {
                        avatarPreview.src = base64Str;
                        avatarPreview.style.display = 'block';
                    }
                    if (profileInitials) profileInitials.style.display = 'none';
                    if (sidebarAvatar) sidebarAvatar.innerHTML = `<img src="${base64Str}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
                }
                reader.readAsDataURL(file);

                const saveBtn = document.querySelector('#profileForm button[type="submit"]');
                const originalSaveText = saveBtn ? saveBtn.innerHTML : '';
                if (saveBtn) {
                    saveBtn.disabled = true;
                    saveBtn.innerHTML = '&#8987; Đang tải ảnh...';
                }

                // Upload to server
                const formData = new FormData();
                formData.append('type', 'profile_pic');
                formData.append('file', file);

                try {
                    const response = await fetch(window.contextPath + '/api/upload', {
                        method: 'POST',
                        body: formData
                    });
                    
                    const result = await response.json();
                    
                    if (response.ok) {
                        const profilePicInput = document.getElementById('profilePicInput');
                        if (profilePicInput) {
                            profilePicInput.value = result.url;
                        }
                        showToast('Đã tải ảnh lên thành công. Vui lòng nhấn Lưu thay đổi.');
                    } else {
                        showToast(result.error || 'Tải ảnh lên thất bại', 'error');
                    }
                } catch (error) {
                    console.error(error);
                    showToast('Lỗi kết nối khi tải ảnh lên', 'error');
                } finally {
                    if (saveBtn) {
                        saveBtn.disabled = false;
                        saveBtn.innerHTML = originalSaveText;
                    }
                }
            }
        });
    }

    // Profile Form is handled natively via POST

    // === 7. Password Toggle & Strength ===
    const toggleBtns = document.querySelectorAll('.toggle-password');
    toggleBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (!input) return;
            const isHidden = input.type === 'password';
            input.type = isHidden ? 'text' : 'password';
            this.innerHTML = isHidden
                ? '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>'
                : '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
        });
    });

    // === 6. Password Strength ===
    const newPwInput = document.getElementById('newPassword');
    const strLabel = document.getElementById('str-label');
    const segs = ['str-1','str-2','str-3','str-4'].map(id => document.getElementById(id));
    if (newPwInput && strLabel) {
        newPwInput.addEventListener('input', function() {
            const v = this.value; let score = 0;
            if (v.length >= 8) score++;
            if (/[A-Z]/.test(v) && /[a-z]/.test(v)) score++;
            if (/[0-9]/.test(v)) score++;
            if (/[^A-Za-z0-9]/.test(v)) score++;
            segs.forEach(s => { if (s) s.className = 'strength-seg'; });
            if (!v.length) { strLabel.textContent = 'Độ mạnh mật khẩu'; strLabel.style.color = 'var(--color-text-muted)'; return; }
            if (score <= 1) { if (segs[0]) segs[0].classList.add('weak'); strLabel.textContent = 'Yếu'; strLabel.style.color = 'var(--color-danger-500)'; }
            else if (score <= 3) { segs.slice(0, score).forEach(s => { if(s) s.classList.add('medium'); }); strLabel.textContent = 'Trung bình'; strLabel.style.color = 'var(--color-warning-500)'; }
            else { segs.forEach(s => { if(s) s.classList.add('strong'); }); strLabel.textContent = 'Mạnh'; strLabel.style.color = 'var(--color-success-500)'; }
        });
    }

    // === 7. Password Form is now handled via standard POST to ChangePasswordServlet ===

    // === 8. IELTS Goal - Target band only ===
    const targetSelector  = document.getElementById('targetBandSelector');

    if (targetSelector) {
        // Tất cả band IELTS hợp lệ từ 4.0 đến 9.0 (bước 0.5)
        const bands = ['4.0','4.5','5.0','5.5','6.0','6.5','7.0','7.5','8.0','8.5','9.0'];

        let targetBandVal  = null;

        // Màu sắc theo band level
        function getBandColor(band) {
            const b = parseFloat(band);
            if (b <= 3.5) return { bg: '#fef2f2', border: '#fca5a5', text: '#dc2626', selBg: '#dc2626' };
            if (b <= 5.0) return { bg: '#fffbeb', border: '#fcd34d', text: '#d97706', selBg: '#d97706' };
            if (b <= 6.5) return { bg: '#f0fdf4', border: '#86efac', text: '#16a34a', selBg: '#16a34a' };
            return { bg: '#eff6ff', border: '#93c5fd', text: '#2563eb', selBg: '#2563eb' };
        }

        function renderBands(container, type) {
            if (!container) return;
            container.innerHTML = '';
            bands.forEach(band => {
                const c = getBandColor(band);
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.dataset.value = band;
                btn.textContent = band;
                btn.style.cssText = 'width:54px;height:42px;border-radius:8px;border:1.5px solid ' + c.border +
                    ';background:' + c.bg + ';color:' + c.text + ';font-weight:700;font-size:13px;' +
                    'cursor:pointer;transition:all 0.15s;flex-shrink:0;';
                btn.addEventListener('mouseenter', () => { if (!btn.classList.contains('selected')) btn.style.transform = 'scale(1.08)'; });
                btn.addEventListener('mouseleave', () => { if (!btn.classList.contains('selected')) btn.style.transform = 'scale(1)'; });
                btn.addEventListener('click', () => {
                    container.querySelectorAll('button').forEach(b => {
                        const bc = getBandColor(b.dataset.value);
                        b.classList.remove('selected');
                        b.style.background = bc.bg; b.style.color = bc.text; b.style.transform = 'scale(1)';
                        b.style.boxShadow = 'none';
                    });
                    btn.classList.add('selected');
                    btn.style.background = c.selBg; btn.style.color = 'white'; btn.style.transform = 'scale(1.1)';
                    btn.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
                    targetBandVal = parseFloat(band);
                });
                container.appendChild(btn);
            });
        }

        function selectBand(container, value) {
            if (!container || !value) return;
            const btn = container.querySelector('button[data-value="' + value + '"]');
            if (btn) {
                btn.click(); // trigger the click event to apply styles
            }
        }

        renderBands(targetSelector, 'target');

        // Load data từ server (injected bởi JSP)
        const goalData = window.GOAL_DATA || {};
        if (goalData.targetBand) {
            const v = parseFloat(goalData.targetBand).toFixed(1);
            targetBandVal = parseFloat(v);
            selectBand(targetSelector, v);
        }

        // Lưu lên server
        const saveGoalBtn = document.getElementById('saveGoalBtn');
        if (saveGoalBtn) {
            saveGoalBtn.addEventListener('click', async () => {
                if (!targetBandVal) {
                    showToast('Vui lòng chọn band điểm mục tiêu', 'error');
                    return;
                }

                saveGoalBtn.disabled = true;
                saveGoalBtn.textContent = 'Đang lưu...';

                const params = new URLSearchParams();
                params.append('targetBand', targetBandVal.toFixed(1));

                try {
                    const res = await fetch(window.contextPath + '/api/goal', { method: 'POST', body: params });
                    const data = await res.json();
                    if (data.success) {
                        showToast('Đã lưu mục tiêu IELTS lên server thành công!');
                        const badge = document.getElementById('goalSavedBadge');
                        if (badge) { badge.style.display = 'block'; setTimeout(() => badge.style.display = 'none', 3000); }
                    } else {
                        showToast('Lưu thất bại: ' + (data.error || 'Lỗi không xác định'), 'error');
                    }
                } catch (err) {
                    showToast('Lỗi kết nối server', 'error');
                } finally {
                    saveGoalBtn.disabled = false;
                    saveGoalBtn.innerHTML = '&#128190; Lưu mục tiêu';
                }
            });
        }
    }
});