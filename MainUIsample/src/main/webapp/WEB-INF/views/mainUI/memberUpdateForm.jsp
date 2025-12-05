<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 수정 - WaterMelon</title>
    <link rel="stylesheet" href="<c:url value="/style.css"/>">
    <style>
        .content-container {
            padding-top: 40px;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-container {
            background: #1F1F1F;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.8);
        }
        .form-group input {
            background: #282828;
            border: 1px solid #333;
            color: white;
            padding: 12px;
            border-radius: 5px;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        .form-group input[readonly] {
            background: #1a1a1a;
            color: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
        }
        .form-group input:focus:not([readonly]) {
            outline: none;
            border-color: #34C759;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        .btn-update, .btn-cancel {
            padding: 12px 25px;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-block;
        }
        .btn-update {
            background: #34C759;
            color: #181818;
        }
        .btn-update:hover {
            background: #2ba84d;
            color: white;
        }
        .btn-cancel {
            background: #555;
            color: white;
        }
        .btn-cancel:hover {
            background: #666;
        }
        h1 {
            margin-bottom: 30px;
            color: #E0E0E0;
        }
    </style>
</head>
<body>
    <div class="page-layout">
        <jsp:include page="/WEB-INF/views/common/sidebar_user.jsp">
            <jsp:param name="activePage" value="myInfo" />
        </jsp:include>
        
        <div class="main-content-wrapper">
            <div class="content-container">
                <h1>내 정보 수정</h1>
                
                <div class="form-container">
                    <form action="<c:url value="/memberUpdate.do"/>" method="post">
                        <input type="hidden" name="id" value="${member.id}">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="name">이름</label>
                                <input type="text" name="name" id="name" value="${member.name}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">이메일 (변경 불가)</label>
                                <input type="email" name="email" id="email" value="${member.email}" readonly>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">전화번호</label>
                                <input type="text" name="phone" id="phone" value="${member.phone}" placeholder="010-1234-5678">
                            </div>
                            <div class="form-group">
                                <label for="birthdate">생년월일</label>
                                <input type="date" name="birthdate" id="birthdate" value="${member.birthdate}">
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="<c:url value="/myPage.do"/>" class="btn-cancel">취소</a>
                            <button type="submit" class="btn-update">저장</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        </div>
    </div>
</body>
</html>