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
        
        // Trigger animation
        setTimeout(() => toast.classList.add('show'), 10);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    // === 2. Fetch User Data & Populate ===
    async function fetchUserData() {
        try {
            const response = await fetch('/IELTSFLOW/api/user/me');
            if (response.status === 401) {
                window.location.href = 'login.html';
                return;
            }
            const data = await response.json();
            
            if (data.success && data.data) {
                populateUserData(data.data);
            } else {
                // Fallback for UI testing if API fails but not 401
                showToast('Không thể tải thông tin người dùng', 'error');
            }
        } catch (error) {
            console.error('Error fetching user data:', error);
            // Fallback for dev environment without backend
            const mockUser = { fullName: 'Nguyễn Văn A', email: 'nguyenvana@gmail.com', roleId: 2 };
            populateUserData(mockUser);
        }
    }

    function getInitials(name) {
        if (!name) return 'U';
        return name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
    }

    function populateUserData(user) {
        const { fullName, email, roleId } = user;
        
        // Remove skeletons
        document.querySelectorAll('.skeleton').forEach(el => {
            el.classList.remove('skeleton');
            // Remove fixed dimensions used for skeleton
            if (el.id.startsWith('sidebar')) {
                el.style.width = 'auto';
                el.style.height = 'auto';
            }
        });

        // Sidebar
        document.getElementById('sidebarName').textContent = fullName;
        document.getElementById('sidebarEmail').textContent = email;
        const roleBadge = document.getElementById('sidebarRole');
        roleBadge.classList.remove('hidden');
        roleBadge.textContent = roleId === 1 ? 'Admin' : 'Học viên';
        
        if (roleId === 1) {
            document.getElementById('adminLink').classList.remove('hidden');
        }

        // Initials
        const initials = getInitials(fullName);
        document.getElementById('sidebarAvatar').textContent = initials;
        document.getElementById('profileInitials').textContent = initials;

        // Profile Form
        document.getElementById('fullName').value = fullName;
        document.getElementById('email').value = email;
        document.getElementById('profileDisplayName').textContent = fullName;

        // Load LocalStorage overrides (Avatar & Phone)
        const savedPhone = localStorage.getItem('user_phone');
        if (savedPhone) document.getElementById('phone').value = savedPhone;

        const savedAvatar = localStorage.getItem('user_avatar');
        if (savedAvatar) {
            const preview = document.getElementById('avatarPreview');
            preview.src = savedAvatar;
            preview.style.display = 'block';
            document.getElementById('profileInitials').style.display = 'none';
            document.getElementById('sidebarAvatar').innerHTML = `<img src="${savedAvatar}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
        }
    }

    fetchUserData();

    // === 3. Mobile Sidebar Toggle ===
    const mobileToggle = document.getElementById('mobileToggle');
    const sidebar = document.getElementById('sidebar');
    
    mobileToggle.addEventListener('click', () => {
        sidebar.classList.toggle('open');
    });

    // Close sidebar when clicking outside on mobile
    document.addEventListener('click', (e) => {
        if (window.innerWidth <= 768 && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
            sidebar.classList.remove('open');
        }
    });

    // === 4. Sidebar Navigation & Scroll Spy ===
    const navItems = document.querySelectorAll('.sidebar-nav-item[data-target]');
    const sections = Array.from(navItems).map(nav => document.getElementById(nav.dataset.target));

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = item.dataset.target;
            const targetSection = document.getElementById(targetId);
            
            window.scrollTo({
                top: targetSection.offsetTop - 20,
                behavior: 'smooth'
            });

            if (window.innerWidth <= 768) {
                sidebar.classList.remove('open');
            }
        });
    });

    const observerOptions = {
        root: null,
        rootMargin: '-50% 0px -50% 0px', // Trigger when section is in middle of viewport
        threshold: 0
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.id;
                navItems.forEach(nav => {
                    if (nav.dataset.target === id) {
                        nav.classList.add('active');
                    } else {
                        nav.classList.remove('active');
                    }
                });
            }
        });
    }, observerOptions);

    sections.forEach(sec => {
        if (sec) observer.observe(sec);
    });

    // === 5. Avatar Upload ===
    const avatarContainer = document.getElementById('profileAvatar');
    const avatarInput = document.getElementById('avatarInput');
    const avatarPreview = document.getElementById('avatarPreview');
    const profileInitials = document.getElementById('profileInitials');
    const sidebarAvatar = document.getElementById('sidebarAvatar');

    avatarContainer.addEventListener('click', () => avatarInput.click());

    avatarInput.addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const base64Str = e.target.result;
                avatarPreview.src = base64Str;
                avatarPreview.style.display = 'block';
                profileInitials.style.display = 'none';
                sidebarAvatar.innerHTML = `<img src="${base64Str}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
                
                // Save to localStorage
                localStorage.setItem('user_avatar', base64Str);
                showToast('Đã cập nhật ảnh đại diện');
            }
            reader.readAsDataURL(file);
        }
    });

    // === 6. Profile Form Save ===
    document.getElementById('profileForm').addEventListener('submit', (e) => {
        e.preventDefault();
        const newName = document.getElementById('fullName').value.trim();
        const newPhone = document.getElementById('phone').value.trim();
        
        if (newName) {
            document.getElementById('profileDisplayName').textContent = newName;
            document.getElementById('sidebarName').textContent = newName;
            
            // Only update initials if there's no custom avatar
            if (document.getElementById('profileInitials').style.display !== 'none') {
                const initials = getInitials(newName);
                document.getElementById('profileInitials').textContent = initials;
                document.getElementById('sidebarAvatar').textContent = initials;
            }
        }
        
        localStorage.setItem('user_phone', newPhone);
        localStorage.setItem('user_fullname', newName); // Local storage as fallback
        
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

        // Regex: 8+ chars, letters and numbers
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
    const bands = ['3.0', '3.5', '4.0', '4.5', '5.0', '5.5', '6.0', '6.5', '7.0', '7.5', '8.0', '8.5', '9.0'];
    const currentSelector = document.getElementById('currentBandSelector');
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
                // Clear previous selection
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

    // Load saved goals
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

    // Initial update
    setTimeout(updateGapIndicator, 100);

    // Save Goal
    document.getElementById('saveGoalBtn').addEventListener('click', () => {
        if (currentBandVal) localStorage.setItem('goal_current_band', currentBandVal.toFixed(1));
        if (targetBandVal) localStorage.setItem('goal_target_band', targetBandVal.toFixed(1));
        
        const dateVal = document.getElementById('examDate').value;
        if (dateVal) localStorage.setItem('goal_exam_date', dateVal);
        
        showToast('Đã lưu mục tiêu IELTS thành công!');
    });

    // === 10. Logout ===
    document.getElementById('logoutBtn').addEventListener('click', (e) => {
        e.preventDefault();
        // Option to clear session if needed
        // localStorage.clear();
        window.location.href = 'login.html';
    });

});
