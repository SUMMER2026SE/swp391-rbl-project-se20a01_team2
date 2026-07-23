<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:forEach var="entry" items="${stats}">
    <div class="skill-card">
        <h3>${entry.key}</h3>
        <p>Submissions graded: ${entry.value.submissionCount}</p>
        <p>Average band: <fmt:formatNumber value="${entry.value.avgBand}" maxFractionDigits="2"/></p>
        <p>Total mistakes logged: ${entry.value.totalMistakes}</p>
        <canvas id="chart-${entry.key}"></canvas>
        <script>
            // pass entry.value.mistakesByCategory as JSON to Chart.js here
        </script>
    </div>
</c:forEach>