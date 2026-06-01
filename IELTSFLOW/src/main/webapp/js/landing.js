document.addEventListener('DOMContentLoaded', () => {
    // 1. Navbar Scroll Effect
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 20) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 2. Mobile Hamburger Toggle
    const hamburger = document.getElementById('hamburger');
    const mobileMenu = document.getElementById('mobile-menu');
    const mobileLinks = document.querySelectorAll('.mobile-link');
    
    if (hamburger && mobileMenu) {
        hamburger.addEventListener('click', () => {
            mobileMenu.classList.toggle('active');
        });

        mobileLinks.forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.remove('active');
            });
        });
    }

    // 3. Smooth Scroll for Anchor Links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            if(targetId === '#') return;
            const targetElement = document.querySelector(targetId);
            if(targetElement) {
                const navHeight = navbar ? navbar.offsetHeight : 0;
                window.scrollTo({
                    top: targetElement.offsetTop - navHeight,
                    behavior: 'smooth'
                });
            }
        });
    });

    // 4. Intersection Observer for Scroll Animations & Counter
    const revealElements = document.querySelectorAll('.scroll-reveal');
    let statsAnimated = false;

    const animateStats = () => {
        const stats = document.querySelectorAll('.stat-value');
        stats.forEach(stat => {
            const target = parseFloat(stat.getAttribute('data-target'));
            const isDecimal = stat.getAttribute('data-decimal') === 'true';
            const suffix = stat.getAttribute('data-suffix') || '';
            const duration = 2000;
            const steps = 60;
            const stepTime = Math.abs(Math.floor(duration / steps));
            
            let current = 0;
            const increment = target / steps;

            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    current = target;
                    clearInterval(timer);
                }
                
                let displayValue = isDecimal ? current.toFixed(1) : Math.floor(current);
                if (target >= 1000 && !isDecimal) {
                    displayValue = Math.floor(current).toLocaleString();
                }
                
                stat.textContent = displayValue + suffix;
            }, stepTime);
        });
    };

    if ('IntersectionObserver' in window) {
        const revealObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    
                    // Trigger stats counter when stats bar is revealed
                    if (entry.target.classList.contains('stats-bar') && !statsAnimated) {
                        statsAnimated = true;
                        animateStats();
                    }
                    
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: "0px 0px -50px 0px"
        });

        revealElements.forEach(el => revealObserver.observe(el));
    } else {
        // Fallback for browsers that don't support IntersectionObserver
        revealElements.forEach(el => el.classList.add('revealed'));
        animateStats();
    }

    // 5. Testimonials Carousel
    const track = document.getElementById('testimonialTrack');
    const slides = document.querySelectorAll('.testimonial-slide');
    const dotsContainer = document.getElementById('carouselDots');
    let currentSlide = 0;
    const slideCount = slides.length;
    let autoPlayInterval;

    if (track && slides.length > 0 && dotsContainer) {
        // Create dots
        slides.forEach((_, index) => {
            const dot = document.createElement('div');
            dot.classList.add('dot');
            if (index === 0) dot.classList.add('active');
            dot.addEventListener('click', () => goToSlide(index));
            dotsContainer.appendChild(dot);
        });

        const dots = document.querySelectorAll('.dot');

        const updateCarousel = () => {
            track.style.transform = `translateX(-${currentSlide * 100}%)`;
            dots.forEach((dot, index) => {
                if (index === currentSlide) {
                    dot.classList.add('active');
                } else {
                    dot.classList.remove('active');
                }
            });
        };

        const goToSlide = (index) => {
            currentSlide = index;
            updateCarousel();
            resetAutoPlay();
        };

        const nextSlide = () => {
            currentSlide = (currentSlide + 1) % slideCount;
            updateCarousel();
        };

        const startAutoPlay = () => {
            autoPlayInterval = setInterval(nextSlide, 5000);
        };

        const resetAutoPlay = () => {
            clearInterval(autoPlayInterval);
            startAutoPlay();
        };

        startAutoPlay();
    }

    // 6. Check Auth Status
    const checkAuthStatus = async () => {
        try {
            const response = await fetch('/IELTSFLOW/api/user/me');
            if (response.ok) {
                const userData = await response.json();
                if (userData && userData.email) {
                    const dashboardHtml = `<a href="pages/dashboard.html" class="btn-cta">Dashboard</a>`;
                    
                    const desktopNav = document.getElementById('desktop-nav-actions');
                    if(desktopNav) desktopNav.innerHTML = dashboardHtml;
                    
                    const mobileNav = document.getElementById('mobile-nav-actions');
                    if(mobileNav) mobileNav.innerHTML = dashboardHtml;
                }
            }
        } catch (error) {
            console.error('Error checking auth status:', error);
        }
    };

    checkAuthStatus();
});
