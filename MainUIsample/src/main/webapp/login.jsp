<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>로그인</h2>
        <form action="login.do" method="post">
            <div class="form-group">
                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="submit">로그인</button>
            </div>
        </form>
        <p>계정이 없으신가요? <a href="signup.jsp">회원가입</a></p>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <p style="color:red;"><%= errorMessage %></p>
        <%
            }
        %>
    </div>
</body>
</html>
