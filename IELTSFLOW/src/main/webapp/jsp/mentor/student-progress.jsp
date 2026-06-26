<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiến độ học viên - IELTSFlow Mentor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .filter-tabs { display: flex; gap: 10px; margin-bottom: 20px; }
        .filter-tab {
            padding: 8px 16px; border-radius: 20px; border: 1px solid var(--glass-border);
            background: var(--bg-surface); color: var(--text-secondary); text-decoration: none;
            font-weight: 600; transition: all 0.2s;
        }
        .filter-tab:hover { background: rgba(99,102,241,0.05); color: var(--accent-blue); }
        .filter-tab.active { background: rgba(99,102,241,0.1); color: var(--accent-blue); border-color: var(--accent-blue); }
        
        .student-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 16px; border-radius: 12px; transition: background 0.2s;
            text-decoration: none; color: inherit; border: 1px solid transparent;
        }
        .student-item:hover { background: rgba(0,0,0,0.02); }
        .student-item.active { background: rgba(99,102,241,0.05); border-color: var(--accent-blue); }
    </style>
</head>
<body>
    <div class="bg-blob blob-1"></div>
    <div class="bg-blob blob-3"></div>

<div class="layout-wrapper">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="active" value="students" />
    </jsp:include>

    <main class="main-content">
        <header class="main-header animate-fade-up" style="margin-bottom: 30px;">
            <h1 class="page-title">Tiến độ học viên</h1>
            <p class="page-subtitle">Theo dõi quá trình làm bài và chấm điểm</p>
        </header>

        <div class="row">
            <!-- Cột trái: Danh sách học viên -->
            <div class="col-md-4 mb-4">
                <div class="glass-panel animate-fade-up" style="animation-delay: 0.1s; height: 100%;">
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/mentor/students?filter=my" class="filter-tab ${currentFilter == 'my' ? 'active' : ''}">Học viên của tôi</a>
                        <a href="${pageContext.request.contextPath}/mentor/students?filter=all" class="filter-tab ${currentFilter == 'all' ? 'active' : ''}">Tất cả</a>
                    </div>
                    
                    <div class="student-list mt-3">
                        <c:choose>
                            <c:when test="${empty students}">
                                <div class="text-center text-muted py-4">Không tìm thấy học viên nào.</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="stu" items="${students}">
                                    <a href="${pageContext.request.contextPath}/mentor/students?filter=${currentFilter}&studentId=${stu.userId}" 
                                       class="student-item ${selectedStudentId == stu.userId ? 'active' : ''} mb-2">
                                        <div class="d-flex align-items-center">
                                            <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--accent-blue); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; margin-right: 12px;">
                                                ${stu.fullName.substring(0,1)}
                                            </div>
                                            <div>
                                                <div class="fw-bold">${stu.fullName}</div>
                                                <div class="text-muted" style="font-size: 0.8rem;">${stu.email}</div>
                                            </div>
                                        </div>
                                        <i class="fa-solid fa-chevron-right text-muted"></i>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Lịch sử làm bài -->
            <div class="col-md-8 mb-4">
                <div class="glass-panel animate-fade-up" style="animation-delay: 0.2s; height: 100%;">
                    <c:choose>
                        <c:when test="${empty selectedStudentId}">
                            <div class="text-center text-muted py-5 mt-5">
                                <i class="fa-solid fa-user-graduate mb-3" style="font-size: 3rem; color: #cbd5e1;"></i>
                                <h5>Chọn một học viên để xem chi tiết</h5>
                            </div>
                        </c:when>
                        <c:when test="${empty studentSubmissions}">
                            <div class="text-center text-muted py-5 mt-5">
                                Học viên này chưa có bài thi nào.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <h5 class="fw-bold mb-4">Lịch sử bài thi</h5>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Bài thi</th>
                                            <th>Ngày nộp</th>
                                            <th>Overall</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="sub" items="${studentSubmissions}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold">${sub.examTitle}</div>
                                                    <div class="text-muted" style="font-size: 0.8rem;">${sub.examType}</div>
                                                </td>
                                                <td><fmt:formatDate value="${sub.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td><span class="badge bg-primary rounded-pill">${sub.overallBand != null ? sub.overallBand : '-'}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sub.status == 'Completed'}"><span class="text-success"><i class="fa-solid fa-check-circle"></i> Đã nộp</span></c:when>
                                                        <c:otherwise><span class="text-warning"><i class="fa-solid fa-clock"></i> Đang làm</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${sub.status == 'Completed'}">
                                                        <a href="${pageContext.request.contextPath}/mentor/submissions/${sub.submissionId}" class="btn btn-sm btn-outline-primary rounded-pill">
                                                            <i class="fa-solid fa-eye"></i> Chi tiết
                                                        </a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </main>
</div>

</body>
</html>
