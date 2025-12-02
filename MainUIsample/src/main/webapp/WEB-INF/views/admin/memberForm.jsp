<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 추가 - WaterMelon Admin</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
    <div class="page-layout">
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>
            <div class="sidebar-nav-title">관리자 메뉴</div>
            <a href="<c:url value="/admin/dashboard.do"/>" class="sidebar-nav-item">
                <div class="nav-icon"></div><div class="nav-text">대시보드</div>
            </a>
            <a href="<c:url value="/admin/memberList.do"/>" class="sidebar-nav-item active">
                <div class="nav-icon"></div><div class="nav-text">회원 관리</div>
            </a>
            <a href="<c:url value="/logout.do"/>" class="sidebar-nav-item">
                <div class="nav-icon"></div><div class="nav-text">로그아웃</div>
            </a>
        </div>

        <div class="main-content-wrapper">
            <div class="content-container">
                <div class="admin-header">
                    <div class="header-title">
                        <h1>회원 추가</h1>
                        <p class="header-subtitle">신규 회원을 시스템에 등록합니다.</p>
                    </div>
                    <div class="header-actions">
                         <button class="btn btn-outline" onclick="history.back()">뒤로가기</button>
                    </div>
                </div>

                <div class="member-table-container" style="padding: 30px;">
                    <form action="<c:url value="/admin/memberInsert.do"/>" method="post">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="name">이름</label>
                                <input type="text" name="name" id="name" required placeholder="이름을 입력하세요">
                            </div>
                            <div class="form-group">
                                <label for="email">이메일</label>
                                <input type="email" name="email" id="email" required placeholder="example@email.com">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="password">비밀번호</label>
                                <input type="password" name="password" id="password" required placeholder="비밀번호 입력">
                            </div>
                            <div class="form-group">
                                <label for="phone">전화번호</label>
                                <input type="text" name="phone" id="phone" placeholder="010-0000-0000">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="birthdate">생년월일</label>
                                <input type="date" name="birthdate" id="birthdate">
                            </div>
                            <div class="form-group">
                                <label for="type">회원 유형</label>
                                <select name="type" id="type">
                                    <option value="free">무료 (Free)</option>
                                    <option value="premium">프리미엄 (Premium)</option>
                                    <option value="admin">관리자 (Admin)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                             <div class="form-group">
                                <label for="status">계정 상태</label>
                                <select name="status" id="status">
                                    <option value="active">활성 (Active)</option>
                                    <option value="inactive">비활성 (Inactive)</option>
                                    <option value="suspended">정지 (Suspended)</option>
                                </select>
                            </div>
                        </div>

                        <div class="modal-footer" style="border:none; padding: 20px 0 0 0;">
                            <button type="button" class="btn-cancel" onclick="location.href='<c:url value="/admin/memberList.do"/>'">취소</button>
                            <button type="submit" class="btn-save">등록하기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>