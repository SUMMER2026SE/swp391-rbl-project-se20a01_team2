/* ============================================================
   IELTS FLOW – survey.js
   3-Step onboarding survey: Band Goal, Exam Month, Current Level
   ============================================================ */

let selectedBand = null;
let selectedMonth = null;
let selectedLevel = null;

/* ── Band Selector ──────────────────────────────────────── */
function selectBand(el, band) {
  document.querySelectorAll('.band-opt').forEach(b => b.classList.remove('selected'));
  el.classList.add('selected');
  selectedBand = band;

  const motivations = {
    '5.0': '🌱 Tốt! Band 5.0 là bước khởi đầu vững chắc. Chúng tôi sẽ xây nền tảng chắc chắn cho bạn!',
    '5.5': '📗 Mục tiêu thực tế! Với lộ trình 3 tháng, band 5.5 hoàn toàn trong tầm tay!',
    '6.0': '📘 Mục tiêu phổ biến nhất! Band 6.0 yêu cầu vốn từ tốt và kỹ năng đọc hiểu nâng cao.',
    '6.5': '⭐ Lựa chọn tuyệt vời! Band 6.5 mở ra nhiều cơ hội du học và làm việc quốc tế!',
    '7.0': '🏆 Mục tiêu của chiến binh! Band 7.0 là dấu mốc quan trọng – chúng tôi sẽ giúp bạn!',
    '7.5': '🚀 Tham vọng cao! Band 7.5 cần kỹ năng Writing và Speaking xuất sắc. Bắt đầu ngay!',
    '8.0': '💎 Đẳng cấp Very Good! Cần sự kiên trì và luyện tập chuyên sâu mỗi ngày.',
    '8.5': '👑 Mục tiêu của elite! Chỉ 10% thí sinh đạt được – bạn có đủ quyết tâm không?',
    '9.0': '🌟 Điểm tuyệt đối! Thách thức cao nhất – nhưng với IELTS Flow, không gì là bất khả!',
  };

  const motivationEl = document.getElementById('band-motivation');
  if (motivationEl) {
    motivationEl.textContent = motivations[band] || '';
    motivationEl.style.display = 'block';
    motivationEl.style.animation = 'slide-in-up 0.3s ease';
  }

  const nextBtn = document.getElementById('next-1');
  if (nextBtn) {
    nextBtn.disabled = false;
    nextBtn.style.opacity = '1';
    nextBtn.style.cursor = 'pointer';
  }
}

/* ── Month Selector ─────────────────────────────────────── */
function renderMonthGrid() {
  const grid = document.getElementById('month-grid');
  if (!grid) return;

  const months = ['Tháng 1','Tháng 2','Tháng 3','Tháng 4','Tháng 5','Tháng 6',
                  'Tháng 7','Tháng 8','Tháng 9','Tháng 10','Tháng 11','Tháng 12'];

  const now = new Date();
  grid.innerHTML = months.map((m, i) => {
    const monthIndex = i; // 0-based
    const year = now.getMonth() >= monthIndex ? now.getFullYear() + 1 : now.getFullYear();
    // If month is in the future this year, show this year
    const isCurrentYear = now.getMonth() < monthIndex && now.getFullYear() === new Date().getFullYear();
    const displayYear = isCurrentYear ? now.getFullYear() : now.getFullYear() + (now.getMonth() >= monthIndex ? 1 : 0);
    const isPast = now.getMonth() > monthIndex && displayYear <= now.getFullYear();

    return `<div class="month-opt${isPast ? ' opacity-50' : ''}" 
                 data-month="${i}" data-year="${displayYear}"
                 onclick="${isPast ? '' : `selectMonth(this, ${i}, ${displayYear})`}"
                 style="${isPast ? 'opacity:0.35; cursor:not-allowed;' : ''}">
              ${m}
              <div class="month-year">${displayYear}</div>
            </div>`;
  }).join('');
}

function selectMonth(el, month, year) {
  document.querySelectorAll('.month-opt').forEach(m => m.classList.remove('selected'));
  el.classList.add('selected');
  selectedMonth = { month, year };

  // Calculate days remaining
  const now = new Date();
  const examDate = new Date(year, month, 15); // Assume 15th of the month
  const daysLeft = Math.ceil((examDate - now) / (1000 * 60 * 60 * 24));

  const countdownEl = document.getElementById('month-countdown');
  if (countdownEl) {
    countdownEl.style.display = 'block';
    countdownEl.innerHTML = `📅 Còn khoảng <strong>${daysLeft} ngày</strong> – ${getTimeMessage(daysLeft)}`;
  }

  const nextBtn = document.getElementById('next-2');
  if (nextBtn) {
    nextBtn.disabled = false;
    nextBtn.style.opacity = '1';
    nextBtn.style.cursor = 'pointer';
  }
}

function getTimeMessage(days) {
  if (days < 30) return '⚡ Thời gian ngắn! Tập trung tối đa ngay bây giờ!';
  if (days < 60) return '🔥 Còn ít thời gian! Luyện tập mỗi ngày là chìa khóa!';
  if (days < 90) return '💪 Đủ thời gian nếu luyện tập đều đặn mỗi ngày!';
  if (days < 180) return '🌱 Thời gian lý tưởng! Học từng bước một, tiến bộ vững chắc!';
  return '✨ Bạn có đủ thời gian để chinh phục IELTS một cách bài bản!';
}

/* ── Level Selector ─────────────────────────────────────── */
function selectLevel(el, level) {
  document.querySelectorAll('.level-opt').forEach(l => l.classList.remove('selected'));
  el.classList.add('selected');
  selectedLevel = level;

  const finishBtn = document.getElementById('finish-survey');
  if (finishBtn) {
    finishBtn.disabled = false;
    finishBtn.style.opacity = '1';
    finishBtn.style.cursor = 'pointer';
  }
}

/* ── Step Navigation ────────────────────────────────────── */
function nextStep(step) {
  const current = step - 1;
  // Hide current
  document.getElementById(`step-${current}`).classList.remove('active');
  // Show next
  document.getElementById(`step-${step}`).classList.add('active');
  // Update dots
  const prevDot = document.getElementById(`step-dot-${current}`);
  if (prevDot) {
    prevDot.classList.remove('active');
    prevDot.classList.add('done');
    prevDot.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>`;
  }
  const line = document.getElementById(`line-${current}`);
  if (line) line.classList.add('done');

  const nextDot = document.getElementById(`step-dot-${step}`);
  if (nextDot) nextDot.classList.add('active');
}

function prevStep(step) {
  const current = step + 1;
  document.getElementById(`step-${current}`).classList.remove('active');
  document.getElementById(`step-${step}`).classList.add('active');

  const nextDot = document.getElementById(`step-dot-${current}`);
  if (nextDot) { nextDot.classList.remove('active'); }

  const currentDot = document.getElementById(`step-dot-${step}`);
  if (currentDot) {
    currentDot.classList.remove('done');
    currentDot.classList.add('active');
    currentDot.innerHTML = step;
  }
  const line = document.getElementById(`line-${step}`);
  if (line) line.classList.remove('done');
}

/* ── Complete Survey ────────────────────────────────────── */
function completeSurvey() {
  if (!selectedBand || !selectedMonth || !selectedLevel) {
    showToast('Vui lòng hoàn thành tất cả các bước!', 'error');
    return;
  }

  // Save survey data
  const surveyData = { targetBand: selectedBand, examMonth: selectedMonth, currentLevel: selectedLevel };
  localStorage.setItem('ieltsSurvey', JSON.stringify(surveyData));

  const finishBtn = document.getElementById('finish-survey');
  if (finishBtn) { finishBtn.disabled = true; finishBtn.style.opacity = '0.7'; }

  showToast(`🎉 Tuyệt vời! Mục tiêu ${selectedBand} đã được ghi nhận. Đang tạo lộ trình cá nhân hóa...`, 'success');
  setTimeout(() => window.location.href = '/IELTSFLOW/jsp/account.jsp', 2000);
}

/* ── Toast ──────────────────────────────────────────────── */
function showToast(message, type = 'info', duration = 4000) {
  const container = document.getElementById('toast-container');
  if (!container) return;
  const icons = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `
    <span style="font-size:1.25rem; flex-shrink:0;">${icons[type]}</span>
    <div style="flex:1; font-size:0.875rem; color:var(--clr-text-primary); line-height:1.5;">${message}</div>
    <button onclick="this.closest('.toast').remove()" style="color:var(--clr-text-muted); font-size:1rem; background:none; border:none; cursor:pointer;">✕</button>
  `;
  container.appendChild(toast);
  setTimeout(() => { toast.style.animation = 'toast-out 0.4s ease forwards'; setTimeout(() => toast.remove(), 400); }, duration);
}

/* ── Init ───────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  renderMonthGrid();
});
