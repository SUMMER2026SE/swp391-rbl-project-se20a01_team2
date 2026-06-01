<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Khảo sát học tập – IELTS Flow | Cá nhân hóa lộ trình</title>
  <meta name="description" content="Cài đặt mục tiêu IELTS và cá nhân hóa lộ trình học tập của bạn trên IELTS Flow.">
  <link rel="stylesheet" href="../css/auth.css">
  <style>
    .survey-page {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem 1rem;
    }
    .survey-card {
      width: 100%;
      max-width: 560px;
      padding: 3rem 2.5rem;
    }
    /* Steps */
    .step-indicator {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0;
      margin-bottom: 3rem;
    }
    .step-dot {
      width: 36px; height: 36px;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.8125rem;
      font-weight: 700;
      border: 2px solid var(--clr-border);
      background: var(--clr-bg-glass);
      color: var(--clr-text-muted);
      transition: all 0.4s var(--ease-out);
      position: relative;
      z-index: 1;
    }
    .step-dot.active {
      border-color: var(--clr-primary-500);
      background: rgba(59,130,246,0.15);
      color: var(--clr-primary-400);
      box-shadow: 0 0 0 4px rgba(59,130,246,0.15);
    }
    .step-dot.done {
      border-color: var(--clr-success-500);
      background: var(--clr-success-500);
      color: #fff;
    }
    .step-line {
      flex: 1;
      height: 2px;
      background: var(--clr-border);
      max-width: 60px;
      transition: background 0.4s;
    }
    .step-line.done { background: var(--clr-success-500); }

    /* Step Content */
    .step-content { display: none; animation: slide-in-up 0.4s var(--ease-out); }
    .step-content.active { display: block; }

    /* Band Selector */
    .band-options {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 0.625rem;
      margin: 1.5rem 0;
    }
    .band-opt {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 0.875rem 0.5rem;
      border: 2px solid var(--clr-border);
      border-radius: 0.875rem;
      cursor: pointer;
      transition: all 0.25s var(--ease-out);
      background: var(--clr-bg-glass);
    }
    .band-opt:hover {
      border-color: rgba(59,130,246,0.4);
      background: rgba(59,130,246,0.06);
      transform: translateY(-2px);
    }
    .band-opt.selected {
      border-color: var(--clr-primary-500);
      background: rgba(59,130,246,0.12);
      box-shadow: 0 0 0 3px rgba(59,130,246,0.2);
    }
    .band-opt .band-num {
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--clr-primary-400);
      line-height: 1;
    }
    .band-opt.selected .band-num {
      background: var(--grad-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    .band-opt .band-level {
      font-size: 9px;
      color: var(--clr-text-muted);
      margin-top: 4px;
      text-align: center;
    }

    /* Month Selector */
    .month-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 0.625rem;
      margin: 1.5rem 0;
    }
    .month-opt {
      padding: 0.75rem;
      border: 2px solid var(--clr-border);
      border-radius: 0.75rem;
      cursor: pointer;
      text-align: center;
      font-size: 0.875rem;
      font-weight: 600;
      transition: all 0.25s var(--ease-out);
      background: var(--clr-bg-glass);
      color: var(--clr-text-secondary);
    }
    .month-opt:hover { border-color: rgba(59,130,246,0.4); color: var(--clr-text-primary); transform: translateY(-1px); }
    .month-opt.selected {
      border-color: var(--clr-primary-500);
      background: rgba(59,130,246,0.12);
      color: var(--clr-primary-400);
      box-shadow: 0 0 0 3px rgba(59,130,246,0.2);
    }
    .month-opt .month-year { font-size: 10px; color: var(--clr-text-muted); font-weight: 400; }

    /* Step 3: Current Level */
    .level-options {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
      margin: 1.5rem 0;
    }
    .level-opt {
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 1rem 1.25rem;
      border: 2px solid var(--clr-border);
      border-radius: 0.875rem;
      cursor: pointer;
      transition: all 0.25s var(--ease-out);
      background: var(--clr-bg-glass);
    }
    .level-opt:hover { border-color: rgba(59,130,246,0.4); transform: translateX(4px); }
    .level-opt.selected {
      border-color: var(--clr-primary-500);
      background: rgba(59,130,246,0.08);
    }
    .level-emoji { font-size: 1.5rem; flex-shrink: 0; }
    .level-text-wrap { flex: 1; }
    .level-title { font-size: 0.9375rem; font-weight: 600; }
    .level-sub { font-size: 0.75rem; color: var(--clr-text-secondary); }
    .level-check { width: 20px; height: 20px; border-radius: 50%; border: 2px solid var(--clr-border); flex-shrink: 0; display: flex; align-items: center; justify-content: center; transition: all 0.2s; }
    .level-opt.selected .level-check { background: var(--clr-primary-500); border-color: var(--clr-primary-500); }
    .level-opt.selected .level-check::after {
      content: '';
      width: 6px; height: 6px;
      background: #fff;
      border-radius: 50%;
    }

    /* Survey nav */
    .survey-nav { display: flex; gap: 0.75rem; justify-content: space-between; margin-top: 2rem; }
  </style>
</head>
<body>
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>
  <div class="orb orb-3"></div>

  <div class="survey-page">
    <div class="glass-card survey-card">

      <!-- Step Indicator -->
      <div class="step-indicator">
        <div class="step-dot active" id="step-dot-1">1</div>
        <div class="step-line" id="line-1"></div>
        <div class="step-dot" id="step-dot-2">2</div>
        <div class="step-line" id="line-2"></div>
        <div class="step-dot" id="step-dot-3">3</div>
      </div>

      <!-- STEP 1: Target Band -->
      <div class="step-content active" id="step-1">
        <div style="text-align:center; margin-bottom:1.5rem;">
          <span style="font-size:2.5rem;">🎯</span>
          <h2 class="text-2xl fw-extrabold" style="margin-top:0.75rem; margin-bottom:0.5rem;">Mục tiêu band điểm?</h2>
          <p class="text-secondary text-sm">Chọn band điểm IELTS bạn muốn đạt được</p>
        </div>

        <div class="band-options">
          <div class="band-opt" data-band="5.0" onclick="selectBand(this, '5.0')">
            <span class="band-num">5.0</span>
            <span class="band-level">Modest</span>
          </div>
          <div class="band-opt" data-band="5.5" onclick="selectBand(this, '5.5')">
            <span class="band-num">5.5</span>
            <span class="band-level">Modest</span>
          </div>
          <div class="band-opt" data-band="6.0" onclick="selectBand(this, '6.0')">
            <span class="band-num">6.0</span>
            <span class="band-level">Competent</span>
          </div>
          <div class="band-opt" data-band="6.5" onclick="selectBand(this, '6.5')">
            <span class="band-num">6.5</span>
            <span class="band-level">Competent</span>
          </div>
          <div class="band-opt" data-band="7.0" onclick="selectBand(this, '7.0')">
            <span class="band-num">7.0</span>
            <span class="band-level">Good</span>
          </div>
          <div class="band-opt" data-band="7.5" onclick="selectBand(this, '7.5')">
            <span class="band-num">7.5</span>
            <span class="band-level">Good</span>
          </div>
          <div class="band-opt" data-band="8.0" onclick="selectBand(this, '8.0')">
            <span class="band-num">8.0</span>
            <span class="band-level">Very Good</span>
          </div>
          <div class="band-opt" data-band="8.5" onclick="selectBand(this, '8.5')">
            <span class="band-num">8.5</span>
            <span class="band-level">Expert</span>
          </div>
          <div class="band-opt" data-band="9.0" onclick="selectBand(this, '9.0')">
            <span class="band-num">9.0</span>
            <span class="band-level">Expert</span>
          </div>
        </div>

        <!-- Motivation text based on selection -->
        <div id="band-motivation" style="min-height:2.5rem; text-align:center; font-size:0.875rem; color:var(--clr-text-secondary); transition:all 0.3s; padding:0.75rem; border-radius:0.75rem; display:none; background:rgba(59,130,246,0.06); border:1px solid rgba(59,130,246,0.1);">
        </div>

        <div class="survey-nav">
          <div></div>
          <button class="btn btn-primary btn-lg" id="next-1" onclick="nextStep(2)" disabled style="opacity:0.5; cursor:not-allowed;">
            Tiếp theo
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- STEP 2: Exam Date -->
      <div class="step-content" id="step-2">
        <div style="text-align:center; margin-bottom:1.5rem;">
          <span style="font-size:2.5rem;">📅</span>
          <h2 class="text-2xl fw-extrabold" style="margin-top:0.75rem; margin-bottom:0.5rem;">Dự định thi tháng mấy?</h2>
          <p class="text-secondary text-sm">Giúp chúng tôi tạo lộ trình học phù hợp thời gian của bạn</p>
        </div>

        <div class="month-grid" id="month-grid">
          <!-- Populated by JS -->
        </div>

        <div id="month-countdown" style="display:none; text-align:center; padding:0.875rem; background:rgba(59,130,246,0.06); border:1px solid rgba(59,130,246,0.15); border-radius:0.875rem; font-size:0.875rem; color:var(--clr-primary-400); font-weight:600;"></div>

        <div class="survey-nav">
          <button class="btn btn-ghost btn-lg" onclick="prevStep(1)">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M19 12H5M12 19l-7-7 7-7"/>
            </svg>
            Trước
          </button>
          <button class="btn btn-primary btn-lg" id="next-2" onclick="nextStep(3)" disabled style="opacity:0.5; cursor:not-allowed;">
            Tiếp theo
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- STEP 3: Current Level -->
      <div class="step-content" id="step-3">
        <div style="text-align:center; margin-bottom:1.5rem;">
          <span style="font-size:2.5rem;">📊</span>
          <h2 class="text-2xl fw-extrabold" style="margin-top:0.75rem; margin-bottom:0.5rem;">Trình độ hiện tại?</h2>
          <p class="text-secondary text-sm">Để cá nhân hóa bài tập và lộ trình học tập</p>
        </div>

        <div class="level-options">
          <div class="level-opt" onclick="selectLevel(this, 'beginner')">
            <span class="level-emoji">🌱</span>
            <div class="level-text-wrap">
              <div class="level-title">Mới bắt đầu</div>
              <div class="level-sub">Chưa có kinh nghiệm IELTS hoặc Band < 4.0</div>
            </div>
            <div class="level-check"></div>
          </div>
          <div class="level-opt" onclick="selectLevel(this, 'elementary')">
            <span class="level-emoji">📗</span>
            <div class="level-text-wrap">
              <div class="level-title">Cơ bản</div>
              <div class="level-sub">Đã học tiếng Anh nhưng chưa thi IELTS – Band 4.0–5.0</div>
            </div>
            <div class="level-check"></div>
          </div>
          <div class="level-opt" onclick="selectLevel(this, 'intermediate')">
            <span class="level-emoji">📘</span>
            <div class="level-text-wrap">
              <div class="level-title">Trung cấp</div>
              <div class="level-sub">Đã thi và đạt Band 5.0–6.5 trước đây</div>
            </div>
            <div class="level-check"></div>
          </div>
          <div class="level-opt" onclick="selectLevel(this, 'advanced')">
            <span class="level-emoji">🏆</span>
            <div class="level-text-wrap">
              <div class="level-title">Nâng cao</div>
              <div class="level-sub">Band 6.5+ và muốn đạt điểm cao hơn</div>
            </div>
            <div class="level-check"></div>
          </div>
        </div>

        <div class="survey-nav">
          <button class="btn btn-ghost btn-lg" onclick="prevStep(2)">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M19 12H5M12 19l-7-7 7-7"/>
            </svg>
            Trước
          </button>
          <button class="btn btn-success btn-lg" id="finish-survey" onclick="completeSurvey()" disabled style="opacity:0.5; cursor:not-allowed;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
            Bắt đầu hành trình!
          </button>
        </div>
      </div>

    </div>
  </div>

  <div id="toast-container" style="position:fixed;bottom:1.5rem;right:1.5rem;z-index:500;display:flex;flex-direction:column;gap:.75rem;"></div>
  <script src="../js/survey.js"></script>
</body>
</html>
