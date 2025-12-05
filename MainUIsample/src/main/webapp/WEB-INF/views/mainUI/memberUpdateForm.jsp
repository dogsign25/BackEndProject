<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 수정 - WaterMelon</title>
    <link rel="stylesheet" href="<c:url value="/style.css"/>">
</head>
<body>
    <div class="page-layout">
        <jsp:include page="/WEB-INF/views/common/sidebar_user.jsp">
            <jsp:param name="activePage" value="myInfo" />
        </jsp:include>
        
        <div class="main-content-wrapper">
            <div class="content-container" style="padding-top: 40px; max-width: 800px; margin: 0 auto;">
                <h1 style="margin-bottom: 30px; color: #E0E0E0;">내 정보 수정</h1>
                
                <div class="form-container">
                    <form action="<c:url value="/memberUpdate.do"/>" method="post" onsubmit="return validateForm()">
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

                        <div class="form-row">
                            <div class="form-group">
                                <label for="newPassword">새 비밀번호 (변경 시에만 입력)</label>
                                <input type="password" name="newPassword" id="newPassword" placeholder="새 비밀번호 입력">
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">새 비밀번호 확인</label>
                                <input type="password" name="confirmPassword" id="confirmPassword" placeholder="비밀번호 확인">
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
    
    <script>
        function validateForm() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // 비밀번호를 입력한 경우에만 검증
            if (newPassword || confirmPassword) {
                if (newPassword !== confirmPassword) {
                    alert('새 비밀번호가 일치하지 않습니다.');
                    return false;
                }
                
                if (newPassword.length < 4) {
                    alert('비밀번호는 최소 4자 이상이어야 합니다.');
                    return false;
                }
            }
            
            return true;
        }
    </script>
</body>
</html>