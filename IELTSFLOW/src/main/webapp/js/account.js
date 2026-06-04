// Refactored account.js for Tabbed Interface instead of Scroll Spy

document.addEventListener('DOMContentLoaded', () => {
    // === 1. Toast Notification System ===
    const toastContainer = document.getElementById('toastContainer');
    
    function showToast(message, type = 'success', duration = 3000) {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        
        const icon = type === 'success' 
            ? `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-success-500)" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`
            : `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-danger-500)" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
            
        toast.innerHTML = `
            ${icon}
            <span class="text-sm fw-medium">${message}</span>
        `;
        
        toastContainer.appendChild(toast);
        
        setTimeout(() => toast.classList.add('show'), 10);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    // === 3. Mobile Sidebar Toggle ===
    const mobileToggle = document.getElementById('mobileToggle');
    const sidebar = document.getElementById('sidebar');
    
    mobileToggle.addEventListener('click', () => {
        sidebar.classList.toggle('open');
    });

    document.addEventListener('click', (e) => {
        if (window.innerWidth <= 768 && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
            sidebar.classList.remove('open');
        }
    });

    // === 4. Sidebar Navigation & Tabs ===
    const navItems = document.querySelectorAll('.sidebar-nav-item[data-target]');
    const sections = Array.from(navItems).map(nav => document.getElementById(nav.dataset.target));

    // Hide all sections except the first one initially
    sections.forEach((sec, index) => {
        if(sec) {
            sec.style.display = index === 0 ? 'block' : 'none';
        }
    });

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = item.dataset.target;
            
            // Remove active from all nav items
            navItems.forEach(nav => nav.classList.remove('active'));
            item.classList.add('active');
            
            // Hide all sections, show target section
            sections.forEach(sec => {
                if(sec) sec.style.display = 'none';
            });
            const targetSection = document.getElementById(targetId);
            if(targetSection) {
                targetSection.style.display = 'block';
            }

            if (window.innerWidth <= 768) {
                sidebar.classList.remove('open');
            }
        });
    });

    // === 5. Avatar Upload ===
    const avatarContainer = document.getElementById('profileAvatar');
    const avatarInput = document.getElementById('avatarInput');
    const avatarPreview = document.getElementById('avatarPreview');
    const profileInitials = document.getElementById('profileInitials');
    const sidebarAvatar = document.getElementById('sidebarAvatar');

    if (avatarContainer && avatarInput) {
        avatarContainer.addEventListener('click', () => avatarInput.click());

        avatarInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const base64Str = e.target.result;
                    if (avatarPreview) {
                        avatarPreview.src = base64Str;
                        avatarPreview.style.display = 'block';
                    }
                    if (profileInitials) profileInitials.style.display = 'none';
                    if (sidebarAvatar) sidebarAvatar.innerHTML = `<img src="${base64Str}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
                    localStorage.setItem('user_avatar', base64Str);
                    showToast('Đã cập nhật ảnh đại diện');
                }
                reader.readAsDataURL(file);
            }
        });
    }

    // Load saved avatar
    const savedAvatar = localStorage.getItem('user_avatar');
    if (savedAvatar) {
        if (avatarPreview) {
            avatarPreview.src = savedAvatar;
            avatarPreview.style.display = 'block';
        }
        if (profileInitials) profileInitials.style.display = 'none';
        if (sidebarAvatar) sidebarAvatar.innerHTML = `<img src="${savedAvatar}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
    }

    // === 6. Profile Form Save ===
    document.getElementById('profileForm').addEventListener('submit', (e) => {
        e.preventDefault();
        const newName = document.getElementById('fullName').value.trim();
        const newPhone = document.getElementById('phone').value.trim();
        
        if (newName) {
            document.getElementById('profileDisplayName').textContent = newName;
            document.getElementById('sidebarName').textContent = newName;
            if (document.getElementById('profileInitials').style.display !== 'none') {
                const initials = getInitials(newName);
                document.getElementById('profileInitials').textContent = initials;
                document.getElementById('sidebarAvatar').textContent = initials;
            }
        }
        
        localStorage.setItem('user_phone', newPhone);
        localStorage.setItem('user_fullname', newName);
        showToast('Đã lưu thông tin cá nhân');
    });

    // === 7. Password Toggle & Strength ===
    const toggleBtns = document.querySelectorAll('.toggle-password');
    toggleBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                this.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>`;
            } else {
                input.type = 'password';
                this.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>`;
            }
        });
    });

    const newPasswordInput = document.getElementById('newPassword');
    const segments = [
        document.getElementById('str-1'),
        document.getElementById('str-2'),
        document.getElementById('str-3'),
        document.getElementById('str-4')
    ];
    const strLabel = document.getElementById('str-label');

    newPasswordInput.addEventListener('input', function() {
        const val = this.value;
        let score = 0;
        
        if (val.length >= 8) score++;
        if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        segments.forEach(seg => seg.className = 'strength-seg');
        
        if (val.length === 0) {
            strLabel.textContent = 'Độ mạnh mật khẩu';
            strLabel.style.color = 'var(--color-text-muted)';
            return;
        }

        if (score <= 1) {
            segments[0].classList.add('weak');
            strLabel.textContent = 'Yếu';
            strLabel.style.color = 'var(--color-danger-500)';
        } else if (score === 2 || score === 3) {
            segments[0].classList.add('medium');
            segments[1].classList.add('medium');
            if(score === 3) segments[2].classList.add('medium');
            strLabel.textContent = 'Trung bình';
            strLabel.style.color = 'var(--color-warning-500)';
        } else if (score >= 4) {
            segments.forEach(s => s.classList.add('strong'));
            strLabel.textContent = 'Mạnh';
            strLabel.style.color = 'var(--color-success-500)';
        }
    });

    // === 8. Password Form Save ===
    document.getElementById('passwordForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const currentPw = document.getElementById('currentPassword').value;
        const newPw = newPasswordInput.value;
        const confirmPw = document.getElementById('confirmPassword').value;
        const matchError = document.getElementById('passwordMatchError');

        if (newPw !== confirmPw) {
            matchError.classList.remove('hidden');
            document.getElementById('confirmPassword').classList.add('error');
            return;
        }
        
        matchError.classList.add('hidden');
        document.getElementById('confirmPassword').classList.remove('error');

        const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$/;
        if (!pwRegex.test(newPw)) {
            showToast('Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ và số', 'error');
            return;
        }

        try {
            const response = await fetch('/IELTSFLOW/api/user/change-password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ currentPassword: currentPw, newPassword: newPw })
            });

            if (response.ok) {
                showToast('Đổi mật khẩu thành công!');
                document.getElementById('passwordForm').reset();
                segments.forEach(seg => seg.className = 'strength-seg');
                strLabel.textContent = 'Độ mạnh mật khẩu';
            } else {
                showToast('Đổi mật khẩu thất bại (API có thể chưa được cấu hình)', 'error');
            }
        } catch (error) {
            console.error(error);
            showToast('Chức năng đổi mật khẩu hiện không khả dụng', 'error');
        }
    });

    // === 9. IELTS Goal Settings ===
    const currentSelector = document.getElementById('currentBandSelector');
    if (currentSelector) {
        const bands = ['3.0', '3.5', '4.0', '4.5', '5.0', '5.5', '6.0', '6.5', '7.0', '7.5', '8.0', '8.5', '9.0'];
        const targetSelector = document.getElementById('targetBandSelector');
        let currentBandVal = 0;
        let targetBandVal = 0;

        function renderBands(container, type) {
            bands.forEach(band => {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'band-option';
                btn.textContent = band;
                btn.dataset.value = band;
                
                btn.addEventListener('click', () => {
                    container.querySelectorAll('.band-option').forEach(b => b.classList.remove('selected'));
                    btn.classList.add('selected');
                    
                    if (type === 'current') currentBandVal = parseFloat(band);
                    else targetBandVal = parseFloat(band);
                    
                    updateGapIndicator();
                });
                
                container.appendChild(btn);
            });
        }

        renderBands(currentSelector, 'current');
        renderBands(targetSelector, 'target');

        const gapMessage = document.getElementById('gapMessage');
        const gapBarCurrent = document.getElementById('gapBarCurrent');
        const gapBarTarget = document.getElementById('gapBarTarget');

        function updateGapIndicator() {
            if (!currentBandVal && !targetBandVal) return;

            const maxBand = 9.0;
            
            if (currentBandVal) {
                const currentPct = (currentBandVal / maxBand) * 100;
                gapBarCurrent.style.width = `${currentPct}%`;
            }
            
            if (targetBandVal) {
                const targetPct = (targetBandVal / maxBand) * 100;
                gapBarTarget.style.left = `${targetPct}%`;
            }

            if (currentBandVal && targetBandVal) {
                const gap = (targetBandVal - currentBandVal).toFixed(1);
                if (gap > 0) {
                    gapMessage.textContent = `Bạn cần cải thiện +${gap} band — Bạn làm được! 💪`;
                    gapMessage.style.color = 'var(--color-primary-700)';
                } else {
                    gapMessage.textContent = 'Bạn đã đạt mục tiêu! 🎉';
                    gapMessage.style.color = 'var(--color-success-600)';
                }
            }
        }

        const savedCurrent = localStorage.getItem('goal_current_band');
        const savedTarget = localStorage.getItem('goal_target_band');
        const savedDate = localStorage.getItem('goal_exam_date');

        if (savedCurrent) {
            currentBandVal = parseFloat(savedCurrent);
            const btn = currentSelector.querySelector(`.band-option[data-value="${savedCurrent}"]`);
            if (btn) btn.classList.add('selected');
        }
        
        if (savedTarget) {
            targetBandVal = parseFloat(savedTarget);
            const btn = targetSelector.querySelector(`.band-option[data-value="${savedTarget}"]`);
            if (btn) btn.classList.add('selected');
        }

        if (savedDate) {
            document.getElementById('examDate').value = savedDate;
        }

        setTimeout(updateGapIndicator, 100);

        document.getElementById('saveGoalBtn').addEventListener('click', () => {
            if (currentBandVal) localStorage.setItem('goal_current_band', currentBandVal.toFixed(1));
            if (targetBandVal) localStorage.setItem('goal_target_band', targetBandVal.toFixed(1));
            
            const dateVal = document.getElementById('examDate').value;
            if (dateVal) localStorage.setItem('goal_exam_date', dateVal);
            
            showToast('Đã lưu mục tiêu IELTS thành công!');
        });
    }

    // === 10. Logout ===
    document.getElementById('logoutBtn').addEventListener('click', async (e) => {
        e.preventDefault();
        try { await fetch('/IELTSFLOW/api/auth/logout', { method: 'POST' }); } catch(err) {}
        window.location.href = '/IELTSFLOW/jsp/auth.jsp';
    });
});