<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Weekly Plan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
    <div class="bg-blob blob-2"></div>
    <div class="bg-blob blob-3"></div>
    
    <div class="layout-wrapper">
        <jsp:include page="/jsp/candidate/sidebar.jsp">
            <jsp:param name="activePage" value="weekly-plan" />
        </jsp:include>

        <main class="main-content">
            <c:choose>
                <c:when test="${needsTarget}">
                    <div class="animate-fade-up" style="margin-bottom: 40px; text-align: center; margin-top: 50px;">
                        <h1 style="font-size: 2.5rem; margin-bottom: 15px;">Thiết lập Mục tiêu 🎯</h1>
                        <p style="color: black; margin-bottom: 20px;">Bạn cần thiết lập mục tiêu Band điểm trước khi hệ thống có thể tạo lộ trình học.</p>
                        <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-primary" style="padding: 10px 20px; border-radius: 8px;">Đến trang Dashboard để thiết lập</a>
                    </div>
                </c:when>

                <c:when test="${hasNoPlacementTest}">
                    <div class="animate-fade-up" style="margin-bottom: 40px; text-align: center; margin-top: 50px;">
                        <h1 style="font-size: 2.5rem; margin-bottom: 15px;">Bài thi đầu vào 📝</h1>
                        <p style="color: black; margin-bottom: 20px;">Bạn chưa làm bài kiểm tra đầu vào, hoặc kết quả đã quá hạn.<br>Vui lòng làm bài kiểm tra để hệ thống cá nhân hóa lộ trình cho bạn.</p>
                        <a href="${pageContext.request.contextPath}/candidate/placement-test" class="btn btn-primary" style="padding: 10px 20px; border-radius: 8px;">Làm bài Placement Test</a>
                    </div>
                </c:when>

                <c:when test="${canGeneratePathway}">
                    <div class="animate-fade-up" style="margin-bottom: 40px; text-align: center; margin-top: 50px;">
                        <h1 style="font-size: 2.5rem; margin-bottom: 15px;">Sẵn sàng tạo Lộ trình 🚀</h1>
                        <p style="color: black; margin-bottom: 20px;">Hệ thống đã nhận diện được kết quả bài test gần nhất và mục tiêu của bạn.<br>Hãy nhấn nút bên dưới để AI bắt đầu phân tích và tạo lộ trình học 12 tuần.</p>
                        <c:choose>
                            <c:when test="${isGenerating}">
                                <div style="display: flex; flex-direction: column; align-items: center; gap: 15px;">
                                    <div class="spinner" style="width: 40px; height: 40px; border: 4px solid rgba(16, 185, 129, 0.3); border-top-color: var(--accent-green); border-radius: 50%; animation: spin 1s linear infinite;"></div>
                                    <p style="color: var(--accent-green); font-weight: bold;">Hệ thống đang sử dụng AI để phân tích và lập lộ trình.<br>Vui lòng đợi trong giây lát...</p>
                                </div>
                                <script>
                                    // Tự động kiểm tra trạng thái mỗi 5 giây
                                    setInterval(function() {
                                        fetch('${pageContext.request.contextPath}/candidate/weekly-plan?action=check-status')
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.status === 'ready') {
                                                    window.location.reload();
                                                }
                                            })
                                            .catch(err => console.error(err));
                                    }, 5000);
                                </script>
                                <style>
                                    @keyframes spin { 100% { transform: rotate(360deg); } }
                                </style>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/candidate/weekly-plan" method="post">
                                    <input type="hidden" name="action" value="generate">
                                    <input type="hidden" name="submissionId" value="${submissionId}">
                                    <input type="hidden" name="targetBand" value="${targetBand}">
                                    <button type="submit" class="btn btn-primary" style="padding: 15px 30px; font-size: 1.2rem; border-radius: 8px; background: linear-gradient(135deg, var(--accent-green), var(--accent-blue));">
                                        Nhận Lộ Trình Của Tôi ✨
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:if test="${targetBandMismatched}">
                        <div class="animate-fade-up" style="margin-bottom: 30px; padding: 25px; background: rgba(245, 158, 11, 0.1); border: 2px solid rgba(245, 158, 11, 0.5); border-radius: 12px;">
                            <h2 style="color: #d97706; margin-top: 0; margin-bottom: 10px; font-size: 1.5rem;">⚠️ Mục tiêu của bạn đã thay đổi!</h2>
                            <p style="color: black; margin-bottom: 20px; font-size: 1.05rem;">
                                Mục tiêu IELTS của bạn đã thay đổi (từ <strong>${oldTargetBand}</strong> lên <strong>${targetBand}</strong>). Lộ trình hiện tại dưới đây không còn phù hợp (Không khuyến nghị sử dụng tiếp).
                            </p>
                            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                                <form action="${pageContext.request.contextPath}/candidate/weekly-plan" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="generate">
                                    <input type="hidden" name="submissionId" value="${submissionId}">
                                    <input type="hidden" name="targetBand" value="${targetBand}">
                                    <input type="hidden" name="useOldTest" value="true">
                                    <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, #d97706, #f59e0b); border: none; padding: 12px 25px; border-radius: 8px;">
                                        Tạo lại lộ trình với kết quả Test cũ
                                    </button>
                                </form>
                                <a href="${pageContext.request.contextPath}/candidate/placement-test" class="btn btn-outline" style="padding: 12px 25px; border-radius: 8px; border: 1px solid #d97706; color: #d97706; text-decoration: none;">
                                    Làm lại bài Test đầu vào
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <div class="animate-fade-up" style="margin-bottom: 40px;">
                        <h1 style="font-size: 2.5rem; margin-bottom: 15px;">Your Pathway 🚀</h1>
                        <div style="display: flex; gap: 20px;">
                            <div style="padding: 10px 20px; background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); border-radius: 10px;">
                                <span style="color: var(--text-secondary); font-size: 0.85rem;">Target Band</span>
                                <div style="color: var(--accent-green); font-size: 1.5rem; font-weight: 700;">${pathway.targetBand}</div>
                            </div>
                            <div style="padding: 10px 20px; background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.3); border-radius: 10px;">
                                <span style="color: var(--text-secondary); font-size: 0.85rem;">Created At</span>
                                <div style="color: var(--accent-blue); font-size: 1.2rem; font-weight: 700;">
                                    ${pathway.createdAt.toLocalDate()}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="timeline animate-fade-up" style="animation-delay: 0.2s;" id="weekly-plans-container">
                        <!-- Plans will be rendered here by JS -->
                    </div>

                    <c:if test="${isPathwayExpired}">
                        <div class="timeline-node animate-fade-up" style="animation-delay: 0.5s;">
                            <div class="timeline-dot" style="border-color: var(--accent-red); box-shadow: 0 0 15px rgba(239, 68, 68, 0.5);"></div>
                            <div class="glass-panel" style="padding: 30px; transform: translateY(-5px); border-color: rgba(239, 68, 68, 0.3); background: rgba(239, 68, 68, 0.05);">
                                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px;">
                                    <div>
                                        <span class="badge" style="background: rgba(239, 68, 68, 0.2); color: #f87171;">Phase Đã hoàn thành (3 Months)</span>
                                        <h2 style="margin: 15px 0 10px; color: var(--accent-red); font-size: 1.8rem;">Time for a Re-test! 🎯</h2>
                                        <p style="color: black; font-size: 1rem; line-height: 1.6;">You've reached the end of the 12-week study phase. To continue your journey and let our AI build the next personalized pathway, a re-evaluation is required.</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/candidate/placement-test" class="btn btn-primary" style="background: linear-gradient(135deg, var(--accent-red), var(--accent-orange)); box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4); white-space: nowrap; padding: 15px 30px; font-size: 1.1rem; border-radius: 12px; cursor: pointer; text-decoration: none;">
                                        Take Re-test Now →
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <script>
                        const plansData = [
                            <c:forEach items="${weeklyPlans}" var="plan" varStatus="loop">
                                ${plan.planContent}${!loop.last ? ',' : ''}
                            </c:forEach>
                        ];
                        
                        const container = document.getElementById('weekly-plans-container');
                        let html = '';
                        
                        const badges = ['badge-blue', 'badge-purple', 'badge-orange', 'badge-green'];
                        
                        plansData.forEach((plan, index) => {
                            const badgeClass = badges[index % badges.length];
                            // Determine opacity based on current week (Mocking current week as Week 1)
                            const isCurrent = index === 0;
                            const opacity = isCurrent ? 1 : 0.6 - (index * 0.03);
                            
                            let activitiesHtml = '';
                            if (plan.activities && Array.isArray(plan.activities)) {
                                plan.activities.forEach(act => {
                                    activitiesHtml += `
                                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                                            <input type="checkbox" \${isCurrent ? '' : 'disabled'} style="width: 20px; height: 20px; accent-color: var(--accent-green);">
                                            <span style="color: black;">\${act}</span>
                                        </label>
                                    `;
                                });
                            }
                            
                            html += `
                            <div class="timeline-node">
                                <div class="timeline-dot \${isCurrent ? 'active' : ''}"></div>
                                <div class="glass-panel" style="padding: 20px; transform: translateY(-5px); opacity: \${opacity};">
                                    <span class="badge \${badgeClass}">Week \${plan.weekNumber} \${isCurrent ? '(Current)' : ''}</span>
                                    <h2 style="margin: 10px 0;">\${plan.skillsFocus}</h2>
                                    <p style="color: var(--accent-blue); font-weight: 500;">Mục tiêu: \${plan.objectives}</p>
                                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 20px;">
                                        \${activitiesHtml}
                                    </div>
                                </div>
                            </div>
                            `;
                        });
                        
                        container.innerHTML = html;
                    </script>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/js/candidate-mobile.js"></script>
    <!-- AI Chatbox Widget -->
    <jsp:include page="/jsp/components/chat-widget.jsp" />
    
</body>
</html>



