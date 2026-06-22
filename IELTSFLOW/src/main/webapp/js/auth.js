document.addEventListener('DOMContentLoaded', () => {
    // --- UI Interactions ---
    const loginFormArea = document.getElementById('loginFormArea');
    const registerFormArea = document.getElementById('registerFormArea');
    const tabLogin = document.getElementById('tabLogin');
    const tabRegister = document.getElementById('tabRegister');
    const formWrapper = document.querySelector('.auth-form-wrapper');

    function switchTab(tab) {
        formWrapper.style.opacity = '0';
        formWrapper.style.transform = 'translateY(10px) scale(0.98)';
        
        setTimeout(() => {
            if (tab === 'login') {
                loginFormArea.classList.add('active');
                registerFormArea.classList.remove('active');
                tabLogin.classList.add('active');
                tabRegister.classList.remove('active');
            } else {
                loginFormArea.classList.remove('active');
                registerFormArea.classList.add('active');
                tabLogin.classList.remove('active');
                tabRegister.classList.add('active');
            }
            formWrapper.style.opacity = '1';
            formWrapper.style.transform = 'translateY(0) scale(1)';
        }, 200);
    }

    if(tabLogin) tabLogin.addEventListener('click', () => switchTab('login'));
    if(tabRegister) tabRegister.addEventListener('click', () => switchTab('register'));

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'register') switchTab('register');

    // Toggle Password Visibility
    document.querySelectorAll('.toggle-password').forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                this.innerHTML = '&#128064;';
            } else {
                input.type = 'password';
                this.innerHTML = '&#128065;';
            }
        });
    });

    // Password Strength Meter
    const regPassword = document.getElementById('regPassword');
    if (regPassword) {
        regPassword.addEventListener('input', function() {
            const val = this.value;
            let strength = 0;
            if (val.length >= 8) strength += 1;
            if (val.match(/[a-z]/) && val.match(/[A-Z]/)) strength += 1;
            if (val.match(/\d/)) strength += 1;
            if (val.match(/[^a-zA-Z\d]/)) strength += 1;

            for (let i = 1; i <= 4; i++) {
                const seg = document.getElementById('seg' + i);
                if (seg) {
                    seg.className = 'strength-seg';
                    if (i <= strength) {
                        if (strength <= 2) seg.classList.add('weak');
                        else if (strength === 3) seg.classList.add('medium');
                        else seg.classList.add('strong');
                    }
                }
            }

            const textObj = document.getElementById('strengthText');
            if (textObj) {
                if (val.length === 0) { textObj.textContent = 'Độ mạnh mật khẩu'; textObj.style.color = '#94a3b8'; }
                else if (strength <= 2) { textObj.textContent = 'Yếu'; textObj.style.color = '#ef4444'; }
                else if (strength === 3) { textObj.textContent = 'Trung bình'; textObj.style.color = '#f59e0b'; }
                else { textObj.textContent = 'Mạnh'; textObj.style.color = '#10b981'; }
            }
        });
    }

    // Google Sign-In Initialization
    window.onGoogleLibraryLoad = () => {
        if (window.google && window.google.accounts) {
            google.accounts.id.initialize({
                client_id: window.GOOGLE_CLIENT_ID,
                callback: handleGoogleCredentialResponse,
                auto_select: false,
                cancel_on_tap_outside: true,
                context: "signin",
                ux_mode: "popup"
            });

            // Render Google Button in Login Form
            const loginBtn = document.getElementById('googleLoginBtn');
            if (loginBtn) {
                google.accounts.id.renderButton(
                    loginBtn,
                    { theme: 'outline', size: 'large', type: 'standard', text: 'signin_with', shape: 'rectangular', width: 380 }
                );
            }

            // Render Google Button in Register Form
            const regBtn = document.getElementById('googleRegisterBtn');
            if (regBtn) {
                google.accounts.id.renderButton(
                    regBtn,
                    { theme: 'outline', size: 'large', type: 'standard', text: 'signup_with', shape: 'rectangular', width: 380 }
                );
            }
        }
    };
});

window.handleGoogleCredentialResponse = function(response) {
    if (response.credential) {
        // Create a hidden form to submit the token to GoogleAuthServlet using SSR
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = (window.CONTEXT_PATH || '') + '/auth/google';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'idToken';
        input.value = response.credential;

        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
};