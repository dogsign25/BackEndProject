<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정 - WaterMelon Admin</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
    <div class="page-layout">
                <jsp:include page="/WEB-INF/views/common/sidebar_admin.jsp">
            <jsp:param name="activePage" value="members" />
        </jsp:include>

        <div class="main-content-wrapper">
            <div class="content-container">
                <div class="admin-header">
                    <div class="header-title">
                        <h1>회원 정보 수정</h1>
                        <p class="header-subtitle">
                            <span class="highlight">${member.name}</span> 님의 정보를 수정 중입니다.
                        </p>
                    </div>
                    <div class="header-actions">
                         <button class="btn btn-outline" onclick="history.back()">뒤로가기</button>
                    </div>
                </div>

                <div class="member-table-container" style="padding: 30px;">
                    <%--  수정: 폼 액션을 절대 경로로 변경 --%>
                    <form action="<c:url value="/admin/memberUpdate.do"/>" method="post">
                        <input type="hidden" name="id" value="${member.id}">

                        <div class="form-row">
                            <div class="form-group">
                                <label>회원번호 (수정불가)</label>
                                <input type="text" value="${member.id}" disabled style="background: #333; color: #aaa;">
                            </div>
                            <div class="form-group">
                                <label for="name">이름</label>
                                <input type="text" name="name" id="name" value="${member.name}" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">이메일</label>
                                <input type="email" name="email" id="email" value="${member.email}" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">전화번호</label>
                                <input type="text" name="phone" id="phone" value="${member.phone}" placeholder="010-0000-0000">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="birthdate">생년월일</label>
                                <input type="text" name="birthdate" id="birthdate" value="${member.birthdate}" placeholder="YYYY-MM-DD">
                            </div>
                            <div class="form-group">
                                <label for="type">회원 유형</label>
                                <select name="type" id="type">
                                    <option value="free" ${member.type == 'free' ? 'selected' : ''}>무료 (Free)</option>
                                    <option value="premium" ${member.type == 'premium' ? 'selected' : ''}>프리미엄 (Premium)</option>
                                    <option value="admin" ${member.type == 'admin' ? 'selected' : ''}>관리자 (Admin)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                             <div class="form-group">
                                <label for="status">계정 상태</label>
                                <select name="status" id="status">
                                    <option value="active" ${member.status == 'active' ? 'selected' : ''}>활성 (Active)</option>
                                    <option value="inactive" ${member.status == 'inactive' ? 'selected' : ''}>비활성 (Inactive)</option>
                                    <option value="suspended" ${member.status == 'suspended' ? 'selected' : ''}>정지 (Suspended)</option>
                                </select>
                            </div>
                            <div class="form-group"></div>
                        </div>

                        <div class="modal-footer" style="border:none; padding: 20px 0 0 0;">
                            <%--  수정: 취소 버튼을 회원 목록으로 명시적 이동하도록 변경 --%>
                            <button type="button" class="btn-cancel" onclick="location.href='<c:url value="/admin/memberList.do"/>'">취소</button>
                            <button type="submit" class="btn-save">수정 완료</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>