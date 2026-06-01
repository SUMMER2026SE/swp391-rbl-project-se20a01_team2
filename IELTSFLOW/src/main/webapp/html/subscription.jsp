<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>IELTSFlow - Gói Đăng Ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .pricing-card { transition: transform 0.3s; }
        .pricing-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="text-center mb-5">
        <h1 class="display-4 fw-bold">Chọn Hành Trình IELTS Của Bạn</h1>
        <p class="lead text-muted">Chọn gói đăng ký phù hợp nhất để đạt được band điểm mục tiêu của bạn.</p>
    </div>

    <div class="row g-4 justify-content-center">
        <c:forEach var="pkg" items="${packages}">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm pricing-card border-0 rounded-4">
                    <div class="card-body text-center d-flex flex-column p-4">
                        <h4 class="card-title fw-bold mb-3">${pkg.name}</h4>
                        <h2 class="card-price text-primary mb-4">
                            ${pkg.price} <small class="text-muted fs-5">VND</small>
                        </h2>
                        <ul class="list-unstyled mb-4 flex-grow-1 text-start ps-3">
                            <li class="mb-2"><span class="text-success fw-bold">✓</span> Truy cập trong ${pkg.durationMonths} Tháng</li>
                            <li class="mb-2 text-muted"><span class="text-success fw-bold">✓</span> Đầy đủ Bài thi thử & Luyện tập</li>
                            <li class="mb-2 text-muted"><span class="text-success fw-bold">✓</span> AI Tự động tạo Lộ trình học</li>
                            <li class="mb-2 mt-3 p-2 bg-light rounded text-secondary fst-italic">${pkg.description}</li>
                        </ul>
                        <a href="${pageContext.request.contextPath}/payment?packageId=${pkg.packageId}" class="btn btn-primary w-100 mt-auto rounded-pill py-2 fw-bold">Bắt Đầu Ngay</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty packages}">
            <div class="col-12 text-center">
                <p class="text-muted">Hiện tại chưa có gói đăng ký nào.</p>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
