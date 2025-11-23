<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>회원가입</h2>
        <form action="signup.do" method="post">
            <div class="form-group">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="phone">전화번호:</label>
                <input type="text" id="phone" name="phone">
            </div>
            <div class="form-group">
                <label for="birthdate">생년월일:</label>
                <input type="date" id="birthdate" name="birthdate">
            </div>
            <div class="form-group">
                <button type="submit">가입하기</button>
            </div>
        </form>
        <p>이미 계정이 있으신가요? <a href="login.jsp">로그인</a></p>
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
