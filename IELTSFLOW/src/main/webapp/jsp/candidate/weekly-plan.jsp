<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Weekly Plan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-blob blob-2"></div>
    <div class="bg-blob blob-3"></div>
    
    <div class="layout-wrapper">
        <aside class="sidebar">
            <div class="brand">IELTSFLOW</div>
            <div class="user-profile">
                <div class="avatar">${not empty sessionScope.fullName ? sessionScope.fullName.substring(0, 1) : 'HV'}</div>
                <div>
                    <h4 style="font-size: 1rem;">${not empty sessionScope.fullName ? sessionScope.fullName : 'Học Viên'}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Target: 7.0</p>
                </div>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="nav-link">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/candidate/weekly-plan" class="nav-link active">📅 Weekly Plan</a>
                <a href="${pageContext.request.contextPath}/candidate/lessons" class="nav-link">📚 Library</a>
                <a href="${pageContext.request.contextPath}/candidate/redo-exercises" class="nav-link">🔄 History & Redo</a>
                <a href="${pageContext.request.contextPath}/candidate/notifications" class="nav-link">🔔 Thông báo</a>
                <a href="${pageContext.request.contextPath}/candidate/tickets" class="nav-link">🎫 Ticket hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">⚙️ Cài đặt tài khoản</a>
            </nav>
            <div style="margin-top: auto;">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: var(--accent-red);">🚪 Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div class="animate-fade-up" style="margin-bottom: 40px;">
                <h1 style="font-size: 2.5rem; margin-bottom: 15px;">Your Pathway 🚀</h1>
                <div style="display: flex; gap: 20px;">
                    <div style="padding: 10px 20px; background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); border-radius: 10px;">
                        <span style="color: var(--text-secondary); font-size: 0.85rem;">Target Band</span>
                        <div style="color: var(--accent-green); font-size: 1.5rem; font-weight: 700;">7.0</div>
                    </div>
                    <div style="padding: 10px 20px; background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.3); border-radius: 10px;">
                        <span style="color: var(--text-secondary); font-size: 0.85rem;">Current Band</span>
                        <div style="color: var(--accent-blue); font-size: 1.5rem; font-weight: 700;">6.0</div>
                    </div>
                </div>
            </div>

            <div class="timeline animate-fade-up" style="animation-delay: 0.2s;">
                <!-- Week 1 -->
                <div class="timeline-node">
                    <div class="timeline-dot active"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px);">
                        <span class="badge badge-blue">Week 1 (Current)</span>
                        <h2 style="margin: 10px 0;">Foundation & Vocabulary</h2>
                        <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 20px;">
                            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                                <input type="checkbox" checked style="width: 20px; height: 20px; accent-color: var(--accent-green);">
                                <span style="color: black; text-decoration: line-through;">Read Vocab List 1-5</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                                <input type="checkbox" style="width: 20px; height: 20px; accent-color: var(--accent-green);">
                                <span>Complete Listening Mock Test 1</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                                <input type="checkbox" style="width: 20px; height: 20px; accent-color: var(--accent-green);">
                                <span>Write 1 Task 1 Essay</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Week 2 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.6;">
                        <span class="badge badge-purple">Week 2</span>
                        <h2 style="margin: 10px 0;">Listening & Reading Skills</h2>
                        <ul style="margin-left: 20px; margin-top: 15px; color: var(--text-secondary);">
                            <li>Reading Practice Test A</li>
                            <li>Watch Speaking Part 1 video</li>
                        </ul>
                    </div>
                </div>
                
                <!-- Week 3 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.4;">
                        <span class="badge badge-orange">Week 3</span>
                        <h2 style="margin: 10px 0;">Intensive Writing</h2>
                        <ul style="margin-left: 20px; margin-top: 15px; color: var(--text-secondary);">
                            <li>Submit 2 Writing Essays for Review</li>
                            <li>Listening Section 3 drills</li>
                        </ul>
                    </div>
                </div>

                <!-- Week 4 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.4;">
                        <span class="badge badge-purple">Week 4</span>
                        <h2 style="margin: 10px 0;">Speaking & Pronunciation</h2>
                        <ul style="margin-left: 20px; margin-top: 15px; color: var(--text-secondary);">
                            <li>Mock Speaking Interview with AI</li>
                            <li>Review pronunciation rules</li>
                        </ul>
                    </div>
                </div>

                <!-- Week 5 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.3;">
                        <span class="badge badge-blue">Week 5</span>
                        <h2 style="margin: 10px 0;">Advanced Grammar</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Upcoming AI-generated plan for Advanced Grammar patterns.</p>
                    </div>
                </div>

                <!-- Week 6 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.3;">
                        <span class="badge badge-green">Week 6</span>
                        <h2 style="margin: 10px 0;">Mid-Term Mock Test</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Comprehensive test across all 4 skills.</p>
                    </div>
                </div>

                <!-- Week 7 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.3;">
                        <span class="badge badge-orange">Week 7</span>
                        <h2 style="margin: 10px 0;">Reading Comprehension II</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Tackling True/False/Not Given questions.</p>
                    </div>
                </div>

                <!-- Week 8 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.3;">
                        <span class="badge badge-purple">Week 8</span>
                        <h2 style="margin: 10px 0;">Writing Task 2 Focus</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Structuring opinion and discussion essays.</p>
                    </div>
                </div>

                <!-- Week 9 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.25;">
                        <span class="badge badge-blue">Week 9</span>
                        <h2 style="margin: 10px 0;">Listening Note-taking</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Focus on Section 4 long lectures.</p>
                    </div>
                </div>

                <!-- Week 10 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.25;">
                        <span class="badge badge-green">Week 10</span>
                        <h2 style="margin: 10px 0;">Speaking Part 2 & 3</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Fluency and expanding answers.</p>
                    </div>
                </div>

                <!-- Week 11 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.25;">
                        <span class="badge badge-orange">Week 11</span>
                        <h2 style="margin: 10px 0;">Final Review & Weakness Fixing</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Targeting your most frequent mistakes.</p>
                    </div>
                </div>

                <!-- Week 12 -->
                <div class="timeline-node">
                    <div class="timeline-dot"></div>
                    <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: 0.25;">
                        <span class="badge badge-purple">Week 12</span>
                        <h2 style="margin: 10px 0;">Final Mock Test</h2>
                        <p style="margin-top: 15px; color: var(--text-secondary);">Full simulated IELTS exam.</p>
                    </div>
                </div>

                <!-- End of 3-month phase (Re-test Prompt) -->
                <div class="timeline-node">
                    <div class="timeline-dot" style="border-color: var(--accent-red); box-shadow: 0 0 15px rgba(239, 68, 68, 0.5);"></div>
                    <div class="glass-panel" style="padding: 30px; transform: translateY(-5px); border-color: rgba(239, 68, 68, 0.3); background: rgba(239, 68, 68, 0.05);">
                        <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px;">
                            <div>
                                <span class="badge" style="background: rgba(239, 68, 68, 0.2); color: #f87171;">Phase Completed (3 Months)</span>
                                <h2 style="margin: 15px 0 10px; color: var(--accent-red); font-size: 1.8rem;">Time for a Re-test! 🎯</h2>
                                <p style="color: black; font-size: 1rem; line-height: 1.6;">You've reached the end of the 12-week study phase. To continue your journey and let our AI build the next personalized pathway, a re-evaluation is required.</p>
                            </div>
                            <button class="btn btn-primary" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4); white-space: nowrap; padding: 15px 30px; font-size: 1.1rem; border-radius: 12px; cursor: pointer;">
                                Take Re-test Now →
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</body>
</html>
