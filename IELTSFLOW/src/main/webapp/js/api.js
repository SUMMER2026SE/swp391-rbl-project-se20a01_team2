// API logic for new UI
const MOCK_TODAY_LESSONS = [
    { id: 101, title: 'IELTS Listening - Section 1 Tips', type: 'Video', skill: 'Listening', time: '15 mins', color: 'blue', icon: '🎧' },
    { id: 102, title: 'Academic Vocabulary List 1', type: 'Document', skill: 'Vocabulary', time: '20 mins', color: 'purple', icon: '📚' }
];

const MOCK_LESSONS = [
    { id: 101, title: 'IELTS Listening - Section 1 Tips', type: 'Video', skill: 'Listening', status: 'Unlearned', color: 'blue', icon: '🎧' },
    { id: 102, title: 'Academic Vocabulary List 1', type: 'Document', skill: 'Vocabulary', status: 'Learned', color: 'purple', icon: '📚' },
    { id: 103, title: 'Speaking Part 2: Describe a person', type: 'Video', skill: 'Speaking', status: 'Unlearned', color: 'orange', icon: '🎙️' },
    { id: 104, title: 'Writing Task 1 - Line Graph', type: 'Document', skill: 'Writing', status: 'Unlearned', color: 'green', icon: '✍️' }
];

const MOCK_REDO_EXAMS = [
    { id: 1, title: 'Mock Test 1 - Full Exam', date: 'Oct 12, 2023', score: 6.5, maxScore: 9.0, type: 'Mock Test' },
    { id: 2, title: 'Reading Practice Test A', date: 'Sep 25, 2023', score: 7.0, maxScore: 9.0, type: 'Practice' },
    { id: 3, title: 'Placement Test', date: 'Sep 01, 2023', score: 5.5, maxScore: 9.0, type: 'Placement' }
];

let initializedLearned = localStorage.getItem('learnedLessons');
if (!initializedLearned) {
    const initialLearned = MOCK_LESSONS.filter(l => l.status === 'Learned').map(l => l.id);
    localStorage.setItem('learnedLessons', JSON.stringify(initialLearned));
}

function renderDashboardGrid() {
    const list = document.getElementById('today-lessons-grid');
    if (!list) return;

    let bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
    let learnedList = JSON.parse(localStorage.getItem('learnedLessons') || '[]');

    // Combine MOCK_TODAY_LESSONS with any bookmarked lessons from MOCK_LESSONS
    let displayLessons = [...MOCK_TODAY_LESSONS];
    
    // Add bookmarked lessons that are not already in displayLessons
    bookmarks.forEach(bId => {
        if (!displayLessons.find(l => l.id === bId)) {
            const lesson = MOCK_LESSONS.find(l => l.id === bId);
            if (lesson) displayLessons.push(lesson);
        }
    });

    let html = '';
    displayLessons.forEach((l, idx) => {
        const isLearned = learnedList.includes(l.id);
        const fillWidth = isLearned ? '100%' : '0%';
        const fillStyle = isLearned ? 'background: var(--accent-green)' : '';
        
        const isBookmarked = bookmarks.includes(l.id);
        const bookmarkBadge = isBookmarked ? '<span class="badge badge-red" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;">❤️ Bookmarked</span>' : '';

        html += `
            <div class="lesson-card-3d animate-fade-up" style="animation-delay: ${idx * 0.1}s" onclick="window.location.href='lesson-detail.jsp?id=${l.id}'">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div class="card-icon-wrapper" style="background: rgba(var(--accent-${l.color}-rgb), 0.2); border: 1px solid var(--accent-${l.color});">
                        ${l.icon}
                    </div>
                    <div style="display: flex; gap: 5px; flex-direction: column; align-items: flex-end;">
                        ${isLearned ? '<span class="badge badge-green">✓ Learned</span>' : ''}
                        ${bookmarkBadge}
                    </div>
                </div>
                <span class="badge badge-${l.color}" style="margin-bottom: 10px; margin-top: 10px; display: inline-block;">${l.skill}</span>
                <h3 style="font-size: 1.1rem; margin-bottom: 10px;">${l.title}</h3>
                <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 10px;">⏱️ ${l.time || '15 mins'} to complete</p>
                <div class="progress-track"><div class="progress-fill" style="width: ${fillWidth}; ${fillStyle}"></div></div>
            </div>
        `;
    });
    list.innerHTML = html;
}

function renderLessonLibrary(filterSkill = 'All Skills', filterText = '', filterType = 'All Types') {
    const list = document.getElementById('library-grid');
    if (!list) return;

    let learnedList = JSON.parse(localStorage.getItem('learnedLessons') || '[]');
    let bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');

    let html = '';
    const filteredLessons = MOCK_LESSONS.filter(l => {
        const matchSkill = filterSkill === 'All Skills' || l.skill === filterSkill;
        const matchText = filterText === '' || l.title.toLowerCase().includes(filterText.toLowerCase());
        
        let matchType = true;
        if (filterType === 'Bookmark') {
            matchType = bookmarks.includes(l.id);
        } else if (filterType === 'Learned') {
            matchType = learnedList.includes(l.id);
        } else if (filterType === 'Unlearned') {
            matchType = !learnedList.includes(l.id);
        }

        return matchSkill && matchText && matchType;
    });

    if (filteredLessons.length === 0) {
        list.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 40px; background: rgba(255,255,255,0.05); border-radius: 16px;"><p style="font-size: 1.2rem; color: var(--text-secondary);">No lessons found matching your criteria.</p></div>';
        return;
    }

    filteredLessons.forEach((l, idx) => {
        let learnedList = JSON.parse(localStorage.getItem('learnedLessons') || '[]');
        const isLearned = learnedList.includes(l.id);
        const fillWidth = isLearned ? '100%' : '0%';
        const fillStyle = isLearned ? 'background: var(--accent-green)' : '';
        
        // Check bookmark status
        let bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
        const isBookmarked = bookmarks.includes(l.id);
        const bookmarkBadge = isBookmarked ? '<span class="badge badge-red" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;">❤️ Bookmarked</span>' : '';

        html += `
            <div class="lesson-card-3d animate-fade-up" style="animation-delay: ${idx * 0.1}s" onclick="window.location.href='lesson-detail.jsp?id=${l.id}'">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div class="card-icon-wrapper" style="background: rgba(255,255,255,0.05); font-size: 20px;">
                        ${l.icon}
                    </div>
                    <div>
                        ${isLearned ? '<span class="badge badge-green">✓ Learned</span>' : ''}
                        ${bookmarkBadge}
                    </div>
                </div>
                <span class="badge badge-${l.color}" style="margin-bottom: 10px;">${l.skill}</span>
                <h3 style="font-size: 1.1rem; margin-bottom: 10px;">${l.title}</h3>
                <div class="progress-track"><div class="progress-fill" style="width: ${fillWidth}; ${fillStyle}"></div></div>
            </div>
        `;
    });
    list.innerHTML = html;
}

function searchLessons() {
    const skillFilter = document.getElementById('skill-filter')?.value || 'All Skills';
    const typeFilter = document.getElementById('type-filter')?.value || 'All Types';
    const searchInput = document.getElementById('search-input')?.value || '';
    renderLessonLibrary(skillFilter, searchInput, typeFilter);
}

function loadLessonDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const id = parseInt(urlParams.get('id'));
    if (!id) return;

    const lesson = MOCK_LESSONS.find(l => l.id === id) || MOCK_TODAY_LESSONS.find(l => l.id === id);
    if (!lesson) return;

    const badge = document.getElementById('lesson-badge');
    const title = document.getElementById('lesson-title');
    const bookmarkBtn = document.getElementById('bookmark-btn');

    if (badge) {
        badge.className = `badge badge-${lesson.color}`;
        badge.innerText = lesson.skill;
    }
    if (title) {
        title.innerText = lesson.title;
    }

    if (bookmarkBtn) {
        let bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
        if (bookmarks.includes(id)) {
            bookmarkBtn.innerHTML = '❤️ Bookmarked';
            bookmarkBtn.style.background = 'rgba(239, 68, 68, 0.2)';
        } else {
            bookmarkBtn.innerHTML = '❤️ Bookmark';
            bookmarkBtn.style.background = 'rgba(255, 255, 255, 0.05)';
        }
    }

    const learnBtn = document.getElementById('learn-btn');
    if (learnBtn) {
        let learnedList = JSON.parse(localStorage.getItem('learnedLessons') || '[]');
        if (learnedList.includes(id)) {
            learnBtn.innerHTML = '❌ Unmark as Learned';
            learnBtn.style.background = 'var(--accent-red)';
        } else {
            learnBtn.innerHTML = '✓ Mark as Learned';
            learnBtn.style.background = '';
        }
    }
}

function toggleBookmark() {
    const urlParams = new URLSearchParams(window.location.search);
    let id = parseInt(urlParams.get('id'));
    if (!id) id = 101; // fallback for testing directly

    let bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
    const btn = document.getElementById('bookmark-btn');
    
    if (bookmarks.includes(id)) {
        // Remove bookmark
        bookmarks = bookmarks.filter(b => b !== id);
        if (btn) {
            btn.innerHTML = '❤️ Bookmark';
            btn.style.background = 'rgba(255, 255, 255, 0.05)';
        }
        alert('Đã xoá khỏi danh sách Bookmark!');
    } else {
        // Add bookmark
        bookmarks.push(id);
        if (btn) {
            btn.innerHTML = '❤️ Bookmarked';
            btn.style.background = 'rgba(239, 68, 68, 0.2)';
        }
        alert('Đã thêm vào danh sách Bookmark thành công!');
    }
    localStorage.setItem('bookmarks', JSON.stringify(bookmarks));
}

function toggleLearned() {
    const urlParams = new URLSearchParams(window.location.search);
    let id = parseInt(urlParams.get('id'));
    if (!id) id = 101; // fallback

    let learnedList = JSON.parse(localStorage.getItem('learnedLessons') || '[]');
    const btn = document.getElementById('learn-btn');
    
    if (learnedList.includes(id)) {
        // Unmark
        learnedList = learnedList.filter(l => l !== id);
        if (btn) {
            btn.innerHTML = '✓ Mark as Learned';
            btn.style.background = ''; // default primary
        }
        alert('Unmarked as learned!');
    } else {
        // Mark
        learnedList.push(id);
        if (btn) {
            btn.innerHTML = '❌ Unmark as Learned';
            btn.style.background = 'var(--accent-red)';
        }
        alert('Marked as learned! Your progress is updated.');
    }
    localStorage.setItem('learnedLessons', JSON.stringify(learnedList));
}

function renderRedoHistory() {
    const list = document.getElementById('history-list');
    if (!list) return;

    let html = '';
    MOCK_REDO_EXAMS.forEach((e, idx) => {
        const percentage = (e.score / e.maxScore) * 100;
        let scoreColor = e.score >= 7.0 ? 'var(--accent-green)' : (e.score >= 6.0 ? 'var(--accent-blue)' : 'var(--accent-orange)');
        
        html += `
            <div class="history-card animate-fade-up" style="animation-delay: ${idx * 0.1}s">
                <div style="flex: 1;">
                    <span class="badge badge-purple" style="margin-bottom: 8px;">${e.type}</span>
                    <h3 style="font-size: 1.2rem; margin-bottom: 5px;">${e.title}</h3>
                    <p style="font-size: 0.85rem; color: var(--text-secondary);">Taken on: ${e.date}</p>
                </div>
                <div style="width: 200px; margin-right: 30px; text-align: center;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span style="font-size: 0.85rem; color: var(--text-secondary);">Previous Score</span>
                        <strong style="color: ${scoreColor};">${e.score} / ${e.maxScore}</strong>
                    </div>
                    <div class="progress-track" style="height: 6px;">
                        <div class="progress-fill" style="width: ${percentage}%; background: ${scoreColor};"></div>
                    </div>
                </div>
                <button class="btn btn-primary" onclick="alert('Starting retake...')">Retake Now</button>
            </div>
        `;
    });
    list.innerHTML = html;
}

document.addEventListener('DOMContentLoaded', () => {
    renderDashboardGrid();
    renderLessonLibrary();
    renderRedoHistory();
    loadLessonDetail();
});
