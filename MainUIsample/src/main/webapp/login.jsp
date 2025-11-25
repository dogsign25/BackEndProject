<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet" href="./style.css">
<style>
    /* ========================================= */
    /* 핵심 수정: flex: 1 추가 (남은 공간 모두 차지) */
    /* ========================================= */
    .main-content-area {
        flex: 1;  /* 이 속성이 있어야 사이드바 옆 남은 공간을 꽉 채웁니다 */
        display: flex;
        justify-content: center; /* 가로 중앙 정렬 */
        align-items: center;     /* 세로 중앙 정렬 */
        height: 100vh;           /* 화면 전체 높이 */
        padding: 0;
        box-sizing: border-box;
        background-color: #181818; /* 배경색 지정 (혹시 투명일 경우 대비) */
    }

    .auth-card {
        background: #1F1F1F; 
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        width: 100%;
        max-width: 450px; /* 폼 최대 너비 */
        margin: 0; /* 마진 초기화 */
    }
    
    /* 반응형: 화면이 좁아져서 사이드바가 사라지거나 줄어들 때 */
    @media screen and (max-width: 992px) {
        .main-content-area {
            padding: 20px;
            height: auto;
            min-height: 100vh;
        }
    }

    /* 기타 스타일 (기존 유지) */
    .auth-card h2 {
        color: white;
        border-bottom: 2px solid #34C759;
        padding-bottom: 10px;
        margin-bottom: 30px;
        font-size: 26px;
        text-align: center;
    }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #AAAAAA; }
    .form-group input {
        width: 100%; padding: 12px; border: 1px solid #333;
        border-radius: 5px; background: #2A2A2A; color: white;
        box-sizing: border-box; font-size: 16px;
    }
    .highlight-button {
        width: 100%; padding: 12px; border: none; border-radius: 5px;
        background: #34C759; color: white; font-size: 17px; font-weight: 700;
        cursor: pointer; transition: background 0.2s ease;
    }
    .highlight-button:hover { background: #30A84E; }
    .auth-card p { text-align: center; margin-top: 20px; }
    .highlight-link { color: #34C759; text-decoration: none; font-weight: 600; }
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
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Discover</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Library</div>
            </a>
            
            <div class="sidebar-nav-title">Playlist</div>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">My Playlist</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Favorites</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Create New</div>
            </a>
        </div>
        
        <div class="main-content-area">
            
            <div class="auth-card">
                <h2><span class="highlight">로그인</span></h2>
                <form action="login.do" method="post">
                    <div class="form-group">
                        <label for="email">이메일:</label>
                        <input type="email" id="email" name="email" placeholder="이메일 주소를 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label for="password">비밀번호:</label>
                        <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                    </div>
                    <div class="form-group" style="margin-top: 30px;">
                        <button type="submit" class="highlight-button">로그인</button>
                    </div>
                </form>
                
                <p>계정이 없으신가요? <a href="signupForm.do" class="highlight-link">회원가입</a></p>
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <p style="color:#FF3B30;"><%= errorMessage %></p>
                <%
                    }
                %>
            </div>
            
        </div>
    </div>
</body>
</html>