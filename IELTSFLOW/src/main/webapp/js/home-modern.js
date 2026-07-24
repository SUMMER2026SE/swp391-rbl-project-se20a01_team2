
/* ── AOS Init ────────────────────────────────────────────────── */
AOS.init({
  duration: 700,
  once: true,
  offset: 80,
  easing: 'ease-out-cubic'
});

/* ── Navbar scroll effect ─────────────────────────────────────── */
const navbar = document.getElementById('mainNav');
window.addEventListener('scroll', () => {
  if (window.scrollY > 60) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
});

/* ── Mobile Menu ──────────────────────────────────────────────── */
const mobileMenuToggle = document.getElementById('mobileMenuToggle');
const mobileMenu = document.getElementById('mobileMenu');
let menuOpen = false;

mobileMenuToggle.addEventListener('click', () => {
  menuOpen = !menuOpen;
  mobileMenu.classList.toggle('open', menuOpen);
  mobileMenuToggle.setAttribute('aria-expanded', menuOpen);
  document.body.style.overflow = menuOpen ? 'hidden' : '';
  // Animate hamburger
  const spans = mobileMenuToggle.querySelectorAll('span');
  if (menuOpen) {
    spans[0].style.transform = 'rotate(45deg) translate(5px,5px)';
    spans[1].style.opacity = '0';
    spans[2].style.transform = 'rotate(-45deg) translate(5px,-5px)';
  } else {
    spans[0].style.transform = '';
    spans[1].style.opacity = '';
    spans[2].style.transform = '';
  }
});

/* Close mobile menu on link click */
document.querySelectorAll('.mobile-nav-link, .mobile-nav-actions a').forEach(el => {
  el.addEventListener('click', () => {
    menuOpen = false;
    mobileMenu.classList.remove('open');
    document.body.style.overflow = '';
  });
});

/* ── Back to Top ──────────────────────────────────────────────── */
const backToTop = document.getElementById('backToTop');
window.addEventListener('scroll', () => {
  backToTop.classList.toggle('visible', window.scrollY > 400);
});

/* ── Animated Counters ────────────────────────────────────────── */
function animateCounter(el) {
  const target = parseInt(el.dataset.counter);
  const suffix = el.dataset.suffix || '';
  const duration = 2000;
  const start = performance.now();

  const tick = (now) => {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    const value = Math.floor(eased * target);

    if (target >= 1000000) {
      el.textContent = (value / 1000000).toFixed(1) + 'M' + suffix;
    } else if (target >= 1000) {
      el.textContent = (value / 1000).toFixed(0) + 'K' + suffix;
    } else {
      el.textContent = value + suffix;
    }

    if (progress < 1) requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

const counterObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting && !entry.target.dataset.animated) {
      entry.target.dataset.animated = 'true';
      animateCounter(entry.target);
    }
  });
}, { threshold: 0.5 });

document.querySelectorAll('[data-counter]').forEach(el => counterObserver.observe(el));

/* ── FAQ Toggle ───────────────────────────────────────────────── */
function toggleFaq(id) {
  const item = document.getElementById(id);
  const btn = item.querySelector('.faq-question');
  const isOpen = item.classList.contains('open');

  // Close all
  document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
  document.querySelectorAll('.faq-question').forEach(b => b.setAttribute('aria-expanded', 'false'));

  if (!isOpen) {
    item.classList.add('open');
    btn.setAttribute('aria-expanded', 'true');
  }
}

/* ── AI Goal Generator ────────────────────────────────────────── */
const roadmaps = {
  '5.0': '📅 Lộ trình 8 tuần: Tập trung Listening & Reading cơ bản. 2h/ngày. AI Writing 3x/tuần để nắm cấu trúc câu.',
  '5.5': '📅 Lộ trình 8 tuần: Vocabulary building 20 từ/ngày. Grammar correction AI. 2 Mock Tests/tháng.',
  '6.0': '📅 Lộ trình 10 tuần: Academic vocabulary, complex grammar. Writing Task 2 hàng ngày với AI feedback. Speaking 3x/tuần.',
  '6.5': '📅 Lộ trình 10 tuần: Nâng cao cohesion & coherence trong Writing. Speaking fluency và pronunciation. Reading skimming techniques.',
  '7.0': '📅 Lộ trình 12 tuần: Advanced academic writing, complex sentences. Speaking naturally với idioms. Reading time management.',
  '7.5': '📅 Lộ trình 12 tuần: Native-level vocabulary, sophisticated grammar. Speaking with Band 7+ lexical variety. Thi thử 1x/tuần.',
  '8.0': '📅 Lộ trình 16 tuần: Expert-level writing style. Speaking với minimal errors. Mastery of all question types.',
  '8.5': '📅 Lộ trình 16 tuần: Near-native proficiency. Perfect task achievement in Writing. Naturally fluent Speaking.'
};

function generateRoadmap() {
  const select = document.getElementById('targetBand');
  const val = select.value;
  if (!val) {
    select.style.borderColor = 'rgba(239,68,68,0.5)';
    setTimeout(() => select.style.borderColor = '', 2000);
    return;
  }
  const btn = document.getElementById('generate-roadmap-btn');
  btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
  btn.disabled = true;

  setTimeout(() => {
    document.getElementById('selectedBand').textContent = val;
    document.getElementById('roadmapContent').innerHTML =
      roadmaps[val] +
      '<br><br>✅ <strong>Recommended daily goals:</strong>' +
      '<br>• Morning: Vocabulary (30 min)' +
      '<br>• Afternoon: Practice (60 min)' +
      '<br>• Evening: AI Writing/Speaking (30 min)' +
      '<br><br><a href="${pageContext.request.contextPath}/placement-test" style="color:#60A5FA;font-weight:600;">→ Start with Free Placement Test</a>';
    document.getElementById('roadmapResult').style.display = 'block';
    btn.innerHTML = '<i class="fas fa-check"></i> Roadmap Generated!';
    btn.disabled = false;
    setTimeout(() => {
      btn.innerHTML = '<i class="fas fa-wand-magic-sparkles"></i> Generate AI Roadmap';
    }, 3000);
  }, 1500);
}

/* ── AI Chat Demo ─────────────────────────────────────────────── */
const aiResponses = {
  'default': '🤖 Câu hỏi rất hay! Tôi đang xử lý và sẽ trả lời ngay. Thử hỏi cụ thể hơn về Writing, Speaking, Reading hoặc Listening nhé!',
  'writing': '✍️ Để cải thiện Writing Task 2: (1) Sử dụng Complex sentences (2) Vary vocabulary - tránh lặp từ (3) Clear topic sentences (4) Coherent paragraphs với linking devices. Hãy luyện với AI Writing của IELTSFlow!',
  'speaking': '🎙️ Cho IELTS Speaking: (1) Dùng cụm từ mở đầu như "Well, to be honest..." (2) Elaborate câu trả lời, đừng nói ngắn (3) Sử dụng fillers tự nhiên (4) Speak at natural pace. Luyện với AI Speaking Coach!',
  'vocabulary': '📚 Band 7+ vocabulary examples: "ubiquitous" thay "everywhere", "substantial" thay "big", "detrimental" thay "harmful", "mitigate" thay "reduce". Học 10-15 từ mới/ngày!'
};

function sendChat() {
  const input = document.getElementById('chatInput');
  const msg = input.value.trim();
  if (!msg) return;

  const chatBody = document.getElementById('chatBody');

  // Add user message
  chatBody.innerHTML += `
    <div class="chat-msg user-msg">
      <div class="chat-bubble user-bubble">${escapeHtml(msg)}</div>
    </div>
    <div class="chat-msg" id="typingIndicator">
      <div class="typing-indicator">
        <span class="typing-dot"></span>
        <span class="typing-dot"></span>
        <span class="typing-dot"></span>
      </div>
    </div>`;

  chatBody.scrollTop = chatBody.scrollHeight;
  input.value = '';

  // AI response
  setTimeout(() => {
    const indicator = document.getElementById('typingIndicator');
    if (indicator) indicator.remove();

    let response = aiResponses.default;
    const lowerMsg = msg.toLowerCase();
    if (lowerMsg.includes('writing') || lowerMsg.includes('task')) response = aiResponses.writing;
    else if (lowerMsg.includes('speaking') || lowerMsg.includes('speak')) response = aiResponses.speaking;
    else if (lowerMsg.includes('vocab') || lowerMsg.includes('word') || lowerMsg.includes('band 7')) response = aiResponses.vocabulary;

    chatBody.innerHTML += `
      <div class="chat-msg">
        <div class="chat-bubble ai-bubble">${response}</div>
      </div>`;
    chatBody.scrollTop = chatBody.scrollHeight;
  }, 1500);
}

function askQuestion(question) {
  document.getElementById('chatInput').value = question;
  sendChat();
  document.getElementById('ai-mentor-section').scrollIntoView({ behavior: 'smooth' });
}

document.getElementById('chatInput').addEventListener('keydown', (e) => {
  if (e.key === 'Enter') sendChat();
});

function escapeHtml(text) {
  const div = document.createElement('div');
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}

/* ── Newsletter ───────────────────────────────────────────────── */
function subscribeNewsletter() {
  const email = document.getElementById('newsletterEmail').value.trim();
  const btn = document.getElementById('newsletter-subscribe-btn');
  if (!email || !email.includes('@')) {
    document.getElementById('newsletterEmail').style.borderColor = 'rgba(239,68,68,0.5)';
    setTimeout(() => document.getElementById('newsletterEmail').style.borderColor = '', 2000);
    return;
  }
  btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
  btn.disabled = true;
  setTimeout(() => {
    btn.innerHTML = '<i class="fas fa-check"></i> Subscribed!';
    btn.style.background = 'var(--grad-success)';
    document.getElementById('newsletterEmail').value = '';
    setTimeout(() => {
      btn.innerHTML = '<i class="fas fa-paper-plane"></i> Subscribe';
      btn.style.background = '';
      btn.disabled = false;
    }, 3000);
  }, 1200);
}

/* ── Swiper Init ──────────────────────────────────────────────── */
new Swiper('.mock-tests-swiper', {
  slidesPerView: 1,
  spaceBetween: 20,
  pagination: { el: '.mock-tests-swiper .swiper-pagination', clickable: true },
  breakpoints: {
    640:  { slidesPerView: 2 },
    1024: { slidesPerView: 3 }
  }
});

new Swiper('#testiSwiper', {
  slidesPerView: 1,
  spaceBetween: 20,
  autoplay: { delay: 5000, disableOnInteraction: false, pauseOnMouseEnter: true },
  pagination: { el: '#testiPagination', clickable: true },
  breakpoints: {
    768: { slidesPerView: 2 },
    1100: { slidesPerView: 3 }
  }
});

/* ── Dark mode toggle (decorative) ────────────────────────────── */
const darkModeToggle = document.getElementById('darkModeToggle');
darkModeToggle.addEventListener('click', () => {
  const icon = darkModeToggle.querySelector('i');
  icon.classList.toggle('fa-moon');
  icon.classList.toggle('fa-sun');
});

/* ── Navbar active link ──────────────────────────────────────── */
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-link');

const sectionObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      navLinks.forEach(l => l.classList.remove('active'));
      const matching = document.querySelector(`.nav-link[href*="${entry.target.id}"]`);
      if (matching) matching.classList.add('active');
    }
  });
}, { threshold: 0.4 });

sections.forEach(s => sectionObserver.observe(s));
