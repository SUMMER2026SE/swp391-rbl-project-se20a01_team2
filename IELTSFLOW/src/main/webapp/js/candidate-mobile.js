/**
 * candidate-mobile.js
 * Injects mobile topbar + hamburger menu for candidate pages.
 * Works in conjunction with style.css mobile responsive architecture.
 * Include this script in every candidate page that uses .sidebar + .main-content layout.
 */
(function () {
    'use strict';

    function injectMobileTopbar() {
        // Only inject if not already present
        if (document.querySelector('.mobile-topbar')) return;

        const sidebar = document.querySelector('.sidebar');
        if (!sidebar) return;

        // Create mobile topbar
        const topbar = document.createElement('div');
        topbar.className = 'mobile-topbar';
        topbar.id = 'mobileTopbar';
        topbar.innerHTML = `
            <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Mở menu">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <line x1="3" y1="12" x2="21" y2="12"></line>
                    <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>
            <div class="mobile-brand">
                <strong>IELTSFLOW</strong>
            </div>
        `;

        // Create overlay
        const overlay = document.createElement('div');
        overlay.className = 'sidebar-overlay';
        overlay.id = 'sidebarOverlay';

        // Insert topbar as first child of body
        document.body.insertBefore(overlay, document.body.firstChild);
        document.body.insertBefore(topbar, document.body.firstChild);

        // Wire up toggle
        const menuBtn = document.getElementById('mobileMenuBtn');
        if (menuBtn) {
            menuBtn.addEventListener('click', function () {
                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
            });
        }

        // Close sidebar when clicking overlay
        overlay.addEventListener('click', function () {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
        });

        // Close sidebar when a nav link is clicked (for single-page navigation)
        const navLinks = sidebar.querySelectorAll('.nav-link');
        navLinks.forEach(function (link) {
            link.addEventListener('click', function () {
                if (window.innerWidth <= 768) {
                    sidebar.classList.remove('active');
                    overlay.classList.remove('active');
                }
            });
        });
    }

    // Run on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectMobileTopbar);
    } else {
        injectMobileTopbar();
    }
})();
