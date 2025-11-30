<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 플레이리스트 - WaterMelon</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .content-container {
            padding-top: 40px;
        }
        .playlist-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .playlist-header h1 {
            margin: 0;
            font-size: 32px;
            color: #E0E0E0;
        }
        .create-playlist-btn {
            background: #34C759;
            color: #181818;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s ease;
        }
        .create-playlist-btn:hover {
            background: #2ba84d;
        }
        .playlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 25px;
        }
        .playlist-card {
            background: #1F1F1F;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            transition: transform 0.2s ease;
        }
        .playlist-card:hover {
            transform: translateY(-5px);
        }
        .playlist-card img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .playlist-card h3 {
            font-size: 18px;
            margin: 0 0 5px 0;
            color: #E0E0E0;
        }
        .playlist-card p {
            font-size: 14px;
            color: #AAAAAA;
            margin: 0;
        }
        .no-playlists {
            text-align: center;
            padding: 50px;
            font-size: 20px;
            color: #AAAAAA;
        }
    </style>
</head>
<body>
    <div class="page-layout">
        <%-- Sidebar (assuming it's similar to myPage.jsp) --%>
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
            <a href="myPlaylist.do" class="sidebar-nav-item active">
                <div class="nav-icon"></div>
                <div class="nav-text">My Playlist</div>
            </a>
            <a href="favorites.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Favorites</div>
            </a>
            
            <div class="sidebar-nav-title">General</div>
            <a href="myPage.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">My Info</div>
            </a>
            <a href="logout.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Logout</div>
            </a>
        </div>

        <div class="main-content-wrapper">
            <div class="content-container">
                <div class="playlist-header">
                    <h1>내 플레이리스트</h1>
                    <a href="#" class="create-playlist-btn">새 플레이리스트 만들기</a>
                </div>

                <c:choose>
                    <c:when test="${not empty playlists}">
                        <div class="playlist-grid">
                            <c:forEach var="playlist" items="${playlists}">
                                <a href="playlistDetail.do?playlistId=${playlist.playlist_id}" style="text-decoration: none; color: inherit;">
                                    <div class="playlist-card">
                                        <%-- 플레이리스트 커버 이미지는 현재 PlaylistDTO에 없으므로 임시 이미지 사용 --%>
                                        <img src="https://via.placeholder.com/200x200?text=Playlist" alt="Playlist Cover">
                                        <h3>${playlist.name}</h3>
                                        <p>${playlist.songCount} 곡</p> <%-- PlaylistDTO에 songCount 필드가 있다고 가정 --%>
                                    </div>
                                </a>"playlist-card">
                                    <%-- 플레이리스트 커버 이미지는 현재 PlaylistDTO에 없으므로 임시 이미지 사용 --%>
                                    <img src="https://via.placeholder.com/200x200?text=Playlist" alt="Playlist Cover">
                                    <h3>${playlist.name}</h3>
                                    <p>${playlist.songCount} 곡</p> <%-- PlaylistDTO에 songCount 필드가 있다고 가정 --%>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-playlists">
                            <p>아직 생성된 플레이리스트가 없습니다.</p>
                            <a href="#" class="create-playlist-btn" style="margin-top: 20px;">첫 플레이리스트 만들기</a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
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