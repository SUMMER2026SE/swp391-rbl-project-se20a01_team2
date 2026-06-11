document.addEventListener('DOMContentLoaded', () => {
    // 1. Scroll Animations (Intersection Observer)
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach((entry, index) => {
            if (entry.isIntersecting) {
                // Staggered delay based on index for elements appearing together
                setTimeout(() => {
                    entry.target.classList.add('is-visible');
                }, index * 100);
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    const animatedElements = document.querySelectorAll('.animate-on-scroll');
    animatedElements.forEach(el => observer.observe(el));

    // 2. Mobile Sidebar Toggle
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const sidebar = document.getElementById('adminSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');

    if(hamburgerBtn && sidebar && mobileOverlay) {
        function toggleMenu() {
            sidebar.classList.toggle('open');
            mobileOverlay.classList.toggle('active');
        }

        hamburgerBtn.addEventListener('click', toggleMenu);
        mobileOverlay.addEventListener('click', toggleMenu);
    }
});
