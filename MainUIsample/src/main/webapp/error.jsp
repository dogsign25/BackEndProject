<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error</title>
<link rel="stylesheet" href="style.css">
<style>
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        flex-direction: column;
        text-align: center;
    }
    .error-container {
        padding: 40px;
        border-radius: 10px;
        background-color: #1e1e1e;
        color: white;
    }
    .error-code {
        font-size: 5rem;
        font-weight: bold;
        color: #FF3B30;
    }
    .error-message {
        font-size: 1.5rem;
        margin-top: 10px;
        margin-bottom: 20px;
    }
    .home-link {
        color: #34c759;
        text-decoration: none;
        font-size: 1.2rem;
    }
</style>
</head>
<body>
    <div class="error-container">
        <c:set var="statusCode" value="${pageContext.errorData.statusCode != 0 ? pageContext.errorData.statusCode : 500}" />
        <c:set var="errorMessage">
            <c:choose>
                <c:when test="${not empty requestScope.errorMsg}">
                    ${requestScope.errorMsg}
                </c:when>
                <c:when test="${not empty pageContext.exception}">
                    ${pageContext.exception.message}
                </c:when>
                <c:when test="${statusCode == 404}">
                    The page you requested could not be found.
                </c:when>
                <c:otherwise>
                    An unexpected error occurred.
                </c:otherwise>
            </c:choose>
        </c:set>

        <div class="error-code">${statusCode}</div>
        <div class="error-message">${errorMessage}</div>
        <a href="${pageContext.request.contextPath}/index.do" class="home-link">Go to Homepage</a>
    </div>
</body>
</html>
