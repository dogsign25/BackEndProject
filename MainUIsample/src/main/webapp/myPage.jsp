<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%--
    JSP에서 사용되는 가상의 'member' 객체 필드 (예시):
    member.id, member.name, member.email, 
    member.type ('free' 또는 'premium'), 
    member.joinDate, member.lastLogin
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
        
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>

            <div class="sidebar-nav-title">Menu</div>
            <a href="index.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Home</div>
            </a>
            <a href="discover.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Discover</div>
            </a>
            <a href="library.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Library</div>
            </a>
            
            <div class="sidebar-nav-title">Playlist</div>
            <a href="myPlaylist.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">My Playlist</div>
            </a>
            <a href="favorites.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Favorites</div>
            </a>
            
            <div class="sidebar-nav-title">General</div>
            <a href="myPage.do" class="sidebar-nav-item active">
                <div class="nav-icon"></div>
                <div class="nav-text">My Info</div>
            </a>
            <a href="logout.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">로그아웃</div>
            </a>
        </div>
        
        <div class="main-content-wrapper">
            <div class="content-container">
                
                <div class="admin-header">
                    <div class="header-title">
                        <h1>마이페이지</h1>
                        <p class="header-subtitle"><span class="highlight">Water</span>Melon 계정 관리</p>
                    </div>
                </div>

                <c:if test="${not empty member}">
                    <div class="profile-card">
                        <div class="profile-header">
                            <div class="user-avatar">
                                <%-- 이름이 있을 경우 첫 글자 표시, 없을 경우 기본값 'M' --%>
                                <c:choose>
                                    <c:when test="${not empty member.name}">
                                        <c:out value="${fn:substring(member.name, 0, 1)}"/> 
                                    </c:when>
                                    <c:otherwise>M</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="user-info-text">
                                <h2><c:out value="${member.name}"/> 님</h2>
                                <p><c:out value="${member.email}"/></p>
                            </div>
                        </div>
                        
                        <div class="info-grid">
                            
                            <div class="info-group">
                                <label>아이디</label>
                                <p><c:out value="${member.id}"/></p>
                            </div>
                            
                            <div class="info-group">
                                <label>회원 등급</label>
                                <p>
                                    <c:choose>
                                        <c:when test="${member.type == 'premium'}">
                                            <span class="member-type type-premium">프리미엄</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="member-type type-free">무료</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            
                            <div class="info-group">
                                <label>가입일</label>
                                <p><fmt:formatDate value="${member.joinDate}" pattern="yyyy-MM-dd"/></p>
                            </div>
                            
                            <div class="info-group">
                                <label>최근 접속일</label>
                                <p><fmt:formatDate value="${member.lastLogin}" pattern="yyyy-MM-dd HH:mm"/></p>
                            </div>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="memberUpdateForm.do?id=<c:out value='${member.id}'/>" class="btn-update">정보 수정</a>
                            <a href="logout.do" class="btn-logout">로그아웃</a>
                        </div>
                    </div>

                    <div class="section-title-wrap">
                        <div class="section-title" style="font-size: 24px;">
                            결제 및 <span class="highlight">이용 정보</span>
                        </div>
                    </div>
                    
                    <div class="form-container">
                        <div class="form-row">
                            <div class="form-group">
                                <label>현재 이용권</label>
                                <input type="text" value="${member.type == 'premium' ? '프리미엄 무제한 이용권' : '무료 이용권 (광고 포함)'}" readonly />
                            </div>
                            <div class="form-group">
                                <label>다음 결제일</label>
                                <input type="text" value="${member.type == 'premium' ? '2026-01-01' : '해당 없음'}" readonly />
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>누적 청취 시간 (분)</label>
                                <input type="text" value="12,450분" readonly />
                            </div>
                            <div class="form-group">
                                <label>등록된 플레이리스트 수</label>
                                <input type="text" value="12개" readonly />
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
                        <a href="login.do" class="btn-update" style="display: inline-block; margin-top: 30px;">로그인 페이지로 이동</a>
                    </div>
                </c:if>
                
                <footer class="footer">
                    <div class="footer-copyright" style="text-align: center; padding: 20px 0;">
                        &copy; 2025 <span class="highlight">Water</span>Melon. All rights reserved.
                    </div>
                </footer>
                
            </div>
        </div>
    </div>
</body>
</html>