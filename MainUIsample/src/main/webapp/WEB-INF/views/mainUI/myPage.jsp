<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%--
    JSP에서 사용되는 'member' 객체 필드:
    member.id, member.name, member.email, member.type, 
    member.joinDate, member.lastLogin
    
    MemberController의 memberView.do를 통해 ${member} 객체가 request에 저장되어야 함.
    이 페이지의 경로가 myPage.do라고 가정하고, myPage.do 처리 시
    MemberController에서 ${member} 객체를 조회하여 request에 저장하는 로직이 필요합니다.
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - WaterMelon</title>
    
    <link rel="stylesheet" href="./style.css">
    
    <style>
        /* ================================== */
        /* 마이페이지 전용 스타일 */
        /* ================================== */
        /* 💡 수정 사항 1: 메인 콘텐츠 영역 상단 여백 추가 (전체적으로 아래로 내리기) */
        .content-container {
            padding-top: 40px;
        }

        .profile-card {
            background: #1F1F1F;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #333;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #34C759; /* Green highlight color */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: 700;
            color: #181818;
        }
        .user-info-text h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }
        .user-info-text p {
            margin: 5px 0 0 0;
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        .info-group {
            background: #181818;
            padding: 15px;
            border-radius: 8px;
        }
        .info-group label {
            display: block;
            font-size: 12px;
            color: #34C759;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .info-group p {
            margin: 0;
            font-size: 16px;
            font-weight: 400;
        }

        /* 폼 요소 및 버튼 (admin 페이지 스타일 재활용) */
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
        .form-group label {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.8);
        }
        .form-group input[readonly] {
            background: #282828;
            border: 1px solid #333;
            color: rgba(255, 255, 255, 0.7);
            padding: 10px;
            border-radius: 5px;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        
        /* 버튼 스타일 */
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        .btn-update, .btn-logout {
            padding: 12px 25px;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
        }
        .btn-update {
            background: #34C759; /* Highlight color */
            color: #181818;
        }
        .btn-update:hover {
            background: #2ba84d;
            color: white;
            box-shadow: 0 4px 12px rgba(52, 199, 89, 0.4);
        }
        .btn-logout {
            background: #ff3b30;
            color: white;
        }
        .btn-logout:hover {
            background: #e6352b;
        }

        /* 회원 등급 뱃지 */
        .member-type {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .type-free { background: rgba(100, 100, 100, 0.3); color: #aaa; }
        .type-premium { background: rgba(255, 215, 0, 0.2); color: #ffd700; }
        
        .action-btn-blue {
            background: #007aff;
            color: white;
            border-radius: 4px;
            text-align: center;
            font-weight: 500;
        }
        .action-btn-green {
            background: #34C759;
            color: #181818;
            border-radius: 4px;
            text-align: center;
            font-weight: 500;
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
                
                <h1 style="margin-bottom: 20px;">마이페이지</h1>
                
                <c:if test="${not empty sessionScope.msg}">
                    <div style="background: #2ba84d; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                        ${sessionScope.msg}
                    </div>
                    <% session.removeAttribute("msg"); %>
                </c:if>

                <c:if test="${not empty member}">
                    
                    <%-- 1. 프로필 카드: 이름, 등급, 이메일, 가입일, 최종 로그인 정보 --%>
                    <div class="profile-card">
                        <div class="profile-header">
                            <div class="user-avatar">${fn:toUpperCase(fn:substring(member.name, 0, 1))}</div>
                            <div class="user-info-text">
                                <h2>${member.name}</h2>
                                <p>
                                    <span class="member-type type-${member.type}">
                                        <c:choose>
                                            <c:when test="${member.type == 'premium'}">Premium 회원</c:when>
                                            <c:when test="${member.type == 'admin'}">관리자</c:when>
                                            <c:otherwise>Free 회원</c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>
                            </div>
                            <div style="margin-left: auto;">
                                <a href="logout.do" class="btn-logout">로그아웃</a>
                            </div>
                        </div>
                        
                        <div class="info-grid">
                            <div class="info-group">
                                <label>이메일 (ID)</label>
                                <p>${member.email}</p>
                            </div>
                            <div class="info-group">
                                <label>회원 상태</label>
                                <p>
                                    <c:choose>
                                        <c:when test="${member.status == 'active'}">활성</c:when>
                                        <c:when test="${member.status == 'suspended'}">정지</c:when>
                                        <c:otherwise>비활성</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="info-group">
                                <label>가입일</label>
                                <p><fmt:formatDate value="${member.joinDate}" pattern="yyyy년 MM월 dd일"/></p>
                            </div>
                            <div class="info-group">
                                <label>최종 접속일</label>
                                <p><fmt:formatDate value="${member.lastLogin}" pattern="yyyy년 MM월 dd일 HH:mm"/></p>
                            </div>
                        </div>
                    </div>
                    
                    <%-- 2. 회원 정보 수정 폼 --%>
                    <h2 style="margin-bottom: 20px;">정보 수정</h2>
                    <div class="form-container">
                        <form action="admin/memberUpdateForm.do" method="get">
                            <input type="hidden" name="id" value="${member.id}">
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="name">이름</label>
                                    <input type="text" id="name" name="name" value="${member.name}" required />
                                </div>
                                <div class="form-group">
                                    <label for="email">이메일 (수정 불가)</label>
                                    <input type="email" id="email" name="email" value="${member.email}" readonly />
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="phone">연락처</label>
                                    <input type="text" id="phone" name="phone" value="${member.phone}" placeholder="010-1234-5678" />
                                </div>
                                <div class="form-group">
                                    <label for="birthdate">생년월일</label>
                                    <input type="date" id="birthdate" name="birthdate" value="${member.birthdate}" />
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button type="submit" class="btn-update">정보 수정</button>
                            </div>
                        </form>
                    </div>

                    <%-- 3. 서비스 정보 및 통계 --%>
                    <h2 style="margin-bottom: 20px;">서비스 이용 정보</h2>
                    <div class="form-container">
                        <div class="form-row">
                            <div class="form-group">
                                <label>회원 등급</label>
                                <input type="text" value="${member.type == 'premium' ? '프리미엄' : '일반 (Free)'}" readonly />
                            </div>
                            <div class="form-group">
                                <label>프리미엄 만료일</label>
                                <%-- member.type이 'premium'일 경우 가상의 만료일 표시 --%>
                                <input type="text" value="${member.type == 'premium' ? '2026-01-01' : '해당 없음'}" readonly />
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>누적 청취 시간 (분)</label>
                                <input type="text" value="12,450분" readonly /> <%-- 임의의 통계 데이터 --%>
                            </div>
                            <div class="form-group">
                                <label>등록된 플레이리스트 수</label>
                                <input type="text" value="12개" readonly /> <%-- 임의의 통계 데이터 --%>
                            </div>
                        </div>
                        
                        <div class="action-buttons" style="margin-top: 10px;">
                            <a href="paymentHistory.do" class="action-btn-blue" style="padding: 10px 20px;">결제 내역 확인</a>
                            <a href="premium.do" class="action-btn-green" style="padding: 10px 20px;">이용권 변경</a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty member}">
                    <div class="profile-card" style="text-align: center; padding: 50px;">
                        <h2 style="color: #ff3b30;">로그인이 필요합니다.</h2>
                        <p style="margin-top: 20px;">마이페이지 정보를 보려면 로그인해 주세요.</p>
                        <a href="loginForm.do" class="btn-update" style="display: inline-block; margin-top: 30px;">로그인 페이지로 이동</a>
                    </div>
                </c:if>
                
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                
            </div>
        </div>
    </div>
</body>
</html>