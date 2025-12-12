<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 상세 정보 - WaterMelon Admin</title>
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
                        <h1>회원 상세 정보</h1>
                        <p class="header-subtitle">회원 ID: #${member.id}</p>
                    </div>
                </div>

                <div class="member-table-container" style="padding: 30px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label>이름</label>
                            <input type="text" value="${member.name}" readonly style="opacity: 0.7;">
                        </div>
                        <div class="form-group">
                            <label>이메일</label>
                            <input type="text" value="${member.email}" readonly style="opacity: 0.7;">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>전화번호</label>
                            <input type="text" value="${member.phone}" readonly style="opacity: 0.7;">
                        </div>
                        <div class="form-group">
                            <label>생년월일</label>
                            <input type="text" value="${member.birthdate}" readonly style="opacity: 0.7;">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>회원 유형</label>
                            <div style="padding: 10px 0;">
                                <span class="member-type type-${member.type}" style="font-size: 14px; padding: 8px 16px;">
                                    ${member.type}
                                </span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>계정 상태</label>
                            <div style="padding: 10px 0;">
                                <span class="member-status status-${member.status}" style="font-size: 14px; padding: 8px 16px;">
                                    ${member.status}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>가입일</label>
                            <input type="text" value="<fmt:formatDate value='${member.joinDate}' pattern='yyyy-MM-dd HH:mm:ss'/>" readonly style="opacity: 0.7;">
                        </div>
                        <div class="form-group">
                            <label>최근 접속일</label>
                            <input type="text" value="<fmt:formatDate value='${member.lastLogin}' pattern='yyyy-MM-dd HH:mm:ss'/>" readonly style="opacity: 0.7;">
                        </div>
                    </div>

                    <div class="modal-footer" style="border-top: 1px solid #333; padding-top: 20px; margin-top: 20px;">
                        <%-- 🚨 수정: 절대 경로로 변경 --%>
                        <button type="button" class="btn-cancel" onclick="location.href='<c:url value="/admin/memberList.do"/>'">목록으로</button>
                        <div style="display: flex; gap: 10px;">
                            <button type="button" class="action-btn btn-delete" style="padding: 12px 20px; font-size: 14px;" onclick="confirmDelete(${member.id})">삭제</button>
                            
                            <%-- 🚨 수정: 절대 경로로 변경 --%>
                            <button type="button" class="btn-save" onclick="location.href='<c:url value="/admin/memberUpdateForm.do"/>?id=${member.id}'">수정하기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id) {
            if(confirm("정말로 이 회원을 삭제하시겠습니까?")) {
                <%-- 🚨 수정: JSTL을 사용하여 절대 경로를 JS 변수에 삽입 --%>
                location.href = "<c:url value="/admin/memberDelete.do"/>?id=" + id;
            }
        }
    </script>
</body>
</html>