<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chấm điểm thủ công - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="bg-blob blob-1" style="background: var(--accent-orange); opacity: 0.1;"></div>
    <div class="bg-blob blob-3" style="background: var(--accent-blue); opacity: 0.1;"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="students" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <a href="${pageContext.request.contextPath}/mentor/students" class="btn btn-sm btn-outline-secondary rounded-pill mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="page-title" style="font-size: 2rem; margin: 0;">Review Bài Thi Của Học Viên</h1>
            </div>
        </header>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success animate-fade-up">${param.success}</div>
        </c:if>

        <div class="glass-panel animate-fade-up mb-4 p-4">
            <h5 class="fw-bold mb-3">Thông tin bài thi #${submission.submissionId}</h5>
            <p><strong>Loại:</strong> ${submission.examTitle} (${submission.examType})</p>
            <p><strong>Overall Band:</strong> ${submission.overallBand}</p>
        </div>

        <c:forEach var="detail" items="${details}" varStatus="status">
            <div class="glass-panel animate-fade-up mb-4 p-4" style="animation-delay: ${status.index * 0.1}s;">
                <h5 class="fw-bold mb-3">Câu ${status.index + 1}: ${detail.skill}</h5>
                <div class="mb-3">
                    <strong>Đề bài:</strong><br>
                    ${detail.questionContent}
                </div>
                
                <div class="mb-3 p-3 bg-light rounded">
                    <strong>Bài làm của học viên:</strong><br>
                    <c:choose>
                        <c:when test="${not empty detail.speakingUrl}">
                            <audio controls class="mt-2 w-100">
                                <source src="${detail.speakingUrl}" type="audio/wav">
                            </audio>
                            <c:if test="${not empty detail.candidateTranscript}">
                                <p class="mt-2 text-muted"><em>Transcript: ${detail.candidateTranscript}</em></p>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            ${detail.candidateAnswer}
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="p-3 rounded border border-info" style="background: #f0f9ff;">
                            <h6 class="fw-bold text-info"><i class="fa-solid fa-robot"></i> AI Feedback</h6>
                            <p><strong>Điểm AI:</strong> ${detail.score}</p>
                            <div style="white-space: pre-wrap; font-size: 0.9em;">${detail.aiFeedbackJson}</div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="p-3 rounded border border-warning" style="background: #fffbeb;">
                            <h6 class="fw-bold text-warning"><i class="fa-solid fa-user-tie"></i> Mentor Override</h6>
                            <form action="${pageContext.request.contextPath}/mentor/submissions" method="POST">
                                <input type="hidden" name="action" value="override">
                                <input type="hidden" name="detailId" value="${detail.detailId}">
                                <input type="hidden" name="submissionId" value="${submission.submissionId}">
                                
                                <div class="mb-2">
                                    <label class="form-label fw-bold">Điểm Mentor chấm (0 - 9.0)</label>
                                    <input type="number" step="0.5" min="0" max="9" name="mentorScore" class="form-control" value="${detail.mentorScore != null ? detail.mentorScore : detail.score}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Nhận xét của Mentor</label>
                                    <textarea name="mentorFeedback" class="form-control" rows="4" placeholder="Nhập nhận xét của bạn để đè lên nhận xét của AI...">${detail.mentorFeedback}</textarea>
                                </div>
                                <button type="submit" class="btn btn-warning fw-bold"><i class="fa-solid fa-save"></i> Lưu Đánh Giá</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

    </main>
</div>

</body>
</html>
