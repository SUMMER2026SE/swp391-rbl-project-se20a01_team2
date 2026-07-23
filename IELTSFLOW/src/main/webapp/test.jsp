<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    boolean hasDoc = false;
    request.setAttribute("hasDoc", hasDoc);
%>
<c:if test="${hasDoc}">
    RENDERS FALSE AS TRUE!
</c:if>
<c:if test="${!hasDoc}">
    WORKS AS EXPECTED.
</c:if>
