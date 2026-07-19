<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Testing Hub</title>
            <link rel="stylesheet"
                href="${pageContext.request.contextPath}/css/style.css?v=<%= System.currentTimeMillis() %>">
            <style>
                .test-hub-grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 24px;
                    margin-top: 30px;
                }

                .test-card {
                    background: var(--bg-surface);
                    backdrop-filter: blur(16px);
                    border: 1px solid var(--glass-border);
                    border-radius: 20px;
                    padding: 40px;
                    text-align: center;
                    transition: all 0.3s ease;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    text-decoration: none;
                    color: inherit;
                }

                .test-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08);
                    border-color: var(--accent-blue);
                }

                .test-card.placement {
                    border-top: 4px solid var(--accent-red);
                }

                .test-card.practice {
                    border-top: 4px solid #10b981;
                }

                .test-card.mock {
                    border-top: 4px solid var(--accent-blue);
                }

                .test-icon {
                    font-size: 4rem;
                    margin-bottom: 20px;
                }

                .test-card h2 {
                    font-size: 1.8rem;
                    margin-bottom: 15px;
                }

                .test-card p {
                    color: var(--text-secondary);
                    font-size: 1.1rem;
                    line-height: 1.6;
                    margin-bottom: 25px;
                }

                .btn-test {
                    padding: 12px 30px;
                    border-radius: 8px;
                    font-weight: bold;
                    text-decoration: none;
                    color: white;
                    transition: all 0.2s;
                    margin-top: auto;
                }

                .placement .btn-test {
                    background: linear-gradient(135deg, var(--accent-red), #ff8a65);
                }

                .practice .btn-test {
                    background: linear-gradient(135deg, #10b981, #34d399);
                }

                .mock .btn-test {
                    background: linear-gradient(135deg, var(--accent-blue), #60a5fa);
                }

                @media (max-width: 768px) {
                    .test-hub-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <div class="bg-blob blob-1"></div>
            <div class="bg-blob blob-2"></div>

            <div class="layout-wrapper">
                <!-- Sidebar -->
                <jsp:include page="/jsp/candidate/sidebar.jsp">
                        <jsp:param name="activePage" value="tests" />
                    </jsp:include>

                    <!-- Main Content -->
                    <main class="main-content" id="appMainContent">
                        <div class="welcome-banner animate-fade-up">
                            <div>
                                <h1 style="font-size: 2.5rem; margin-bottom: 10px;">Testing Hub 🎯</h1>
                                <p style="font-size: 1.1rem; color: black;">Select the type of test that fits your
                                    current learning goal.</p>
                            </div>
                        </div>

                        <div class="test-hub-grid animate-fade-up" style="animation-delay: 0.1s;">
                            <!-- Placement Test Card -->
                            <a href="${pageContext.request.contextPath}/candidate/placement-test"
                                class="test-card placement">
                                <div class="test-icon">🚀</div>
                                <h2>Placement Test</h2>
                                <p>Determine your current IELTS proficiency level. Highly recommended for beginners to
                                    receive a personalized learning pathway.</p>
                                <span class="btn-test">Take Placement Test</span>
                            </a>

                            <!-- Practice Test Card -->
                            <a href="${pageContext.request.contextPath}/candidate/mock-test?mode=practice"
                                class="test-card practice">
                                <div class="test-icon">💪</div>
                                <h2>Practice Test</h2>
                                <p>Focus on specific skills (Reading, Listening, Writing, Speaking) and practice at your
                                    own pace with selected exams.</p>
                                <span class="btn-test">Start Practice Test</span>
                            </a>

                            <!-- Mock Test Card -->
                            <a href="${pageContext.request.contextPath}/candidate/mock-test?mode=mocktest"
                                class="test-card mock">
                                <div class="test-icon">📝</div>
                                <h2>Mock Test</h2>
                                <p>Experience a full-length IELTS test simulation. Get used to time pressure, evaluate
                                    your progress, and receive detailed AI feedback.</p>
                                <span class="btn-test">Start Mock Test</span>
                            </a>
                        </div>
                    </main>
            </div>
            <script src="${pageContext.request.contextPath}/js/api.js?v=${System.currentTimeMillis()}"></script>

        </body>

        </html>