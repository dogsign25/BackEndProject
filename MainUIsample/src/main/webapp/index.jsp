<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WaterMelon Music Platform</title>
    <link rel="stylesheet" href="./style.css">
</head>
<body>
    <div class="page-layout">
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>
            <div class="sidebar-nav-title">Menu</div>
            <a href="index.do" class="sidebar-nav-item active">
                <div class="nav-icon"></div>
                <div class="nav-text">Home</div>
            </a>
            <a href="discover.do" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Discover</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Library</div>
            </a>
            <div class="sidebar-nav-title">Playlist</div>
            <a href="<c:choose><c:when test="${not empty sessionScope.userId}">myPlaylist.do</c:when><c:otherwise>login.jsp</c:otherwise></c:choose>" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">My Playlist</div>
            </a>
            <a href="#" class="sidebar-nav-item">
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
                <div class="hero-section">
                    
                    <img class="hero-image" src="./src/MainBackground.png" alt="Hero Background" />
                    <div class="header-overlay">
                        <div class="nav-bar">
                            <div class="search-container">
                                <div class="search-icon"><div></div></div>
                                <div><div class="search-placeholder">Search For Musics, Artists, ...</div></div>
                            </div>
                            <div class="desktop-nav-links">
                                <a href="#" class="nav-link">About Us</a>
                                <a href="#" class="nav-link">Contact</a>
                                <a href="#" class="nav-link">Premium</a>
                            </div>
                            <div class="auth-buttons">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.userName}">
                                        <span style="color:white; margin-right: 15px;">환영합니다, ${sessionScope.userName}님!</span>
                                        <a href="logout.do" class="btn btn-outline">Logout</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="loginForm.do" class="btn btn-outline">Login</a>
                                        <a href="signupForm.do" class="btn btn-fill">Sign Up</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div> 
                    
                    <div class="hero-text-block">
                        <div class="hero-title">
                            All the <span class="highlight">Best Songs</span><br/>in One Place
                        </div>
                        <div class="hero-description">
                            On our website, you can access an amazing collection of popular and new songs.
                            Stream your favorite tracks in high quality and enjoy without interruptions.
                            Whatever your taste in music, we have it all for you!
                        </div>
                        <div class="hero-actions">
                            <a href="discover.do" class="action-btn-green">Discover Now</a>
                            <a href="javascript:void(0);" onclick="promptAndCreatePlaylist();" class="action-btn-blue">Create Playlist</a>
                        </div>
                    </div>
                </div>
                
                <!-- Hidden Form for Playlist Creation -->
                <form id="createPlaylistForm" action="playlist.do" method="post" style="display:none;">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" id="playlistNameInput" name="playlistName">
                </form>

                <!-- Weekly Top Songs 섹션 -->
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            Weekly Top <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <c:forEach var="song" items="${weeklyTopSongs}">
                            <div class="song-card-item" onclick="location.href='songDetail.do?id=${song.spotifyId}'">
                                <div class="song-card-content">
                                    <img class="song-card-image" src="${song.imageUrl}" alt="${song.title} Album Cover" />
                                    <div class="song-card-info">
                                        <div class="song-title">${song.title}</div>
                                        <div class="song-artist">${song.artist}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="view-all-card">
                            <div class="view-all-circle"><div><div></div></div></div>
                            <div class="song-title">View All</div>
                        </div>
                    </div>
                </div>
                
                <!-- New Release Songs 섹션 -->
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            New Release <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <c:forEach var="album" items="${newReleases}">
                            <div class="song-card-item" onclick="location.href='albumDetail.do?id=${album.spotifyAlbumId}'">
                                <div class="song-card-content">
                                    <img class="song-card-image" src="${album.imageUrl}" alt="${album.albumName} Album Cover" />
                                    <div class="song-card-info">
                                        <div class="song-title">${album.albumName}</div>
                                        <div class="song-artist">${album.artist}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="view-all-card">
                            <div class="view-all-circle"><div><div></div></div></div>
                            <div class="song-title">View All</div>
                        </div>
                    </div>
                </div>
                
                <!-- Top Albums 섹션 -->
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            Top <span class="highlight">Albums</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <c:forEach var="album" items="${topAlbums}">
                            <div class="song-card-item" onclick="location.href='albumDetail.do?id=${album.spotifyAlbumId}'">
                                <div class="song-card-content">
                                    <img class="song-card-image" src="${album.imageUrl}" alt="${album.albumName} Album Cover" />
                                    <div class="song-card-info">
                                        <div class="song-title">${album.albumName}</div>
                                        <div class="song-artist">${album.artist}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="view-all-card">
                            <div class="view-all-circle"><div><div></div></div></div>
                            <div class="song-title">View All</div>
                        </div>
                    </div>
                </div>
                
                <div class="cta-banner">
                    <div class="cta-text-group">
                        <div class="cta-title">Join Our Platform</div>
                        <div class="cta-subtitle">Stream unlimited music and discover new artists today.</div>
                    </div>
                    <div class="cta-button-wrapper">
                        <a href="signupForm.do" class="cta-button">Sign Up Now</a>
                    </div>
                </div>
                
                <!-- Trending Songs 테이블 (Spotify API 데이터로 채움) -->
                <div class="trending-table-container">
                    <div class="section-title">
                        Trending <span class="highlight">Songs</span>
                    </div>
                    
                    <div class="table-header">
                        <div class="row-col-hash">#</div>
                        <div class="row-col-track-artist">Track / Artist</div>
                        <div class="row-col-date row-col-date-header">Release Date</div>
                        <div class="row-col-album row-col-album-header">Album</div>
                        <div class="row-col-time">Time</div>
                    </div>
                    
                    <c:forEach var="song" items="${trendingSongs}" varStatus="status">
                    <!-- onclick으로 인해 songDetail.do로 이동-->
                        <div class="table-row" onclick="location.href='songDetail.do?id=${song.spotifyId}'" style="cursor: pointer;">
                            <div class="row-col-hash">#${status.index + 1}</div>
                            <div class="row-col-track-artist">
                                <img class="track-album-cover" src="${song.imageUrl}" alt="${song.title} Album Cover" />
                                <div class="track-info-text">
                                    <div class="track-title-text">${song.title}</div>
                                    <div class="track-artist-text">${song.artist}</div>
                                </div>
                            </div>
                            <div class="row-col-date">${song.releaseDate}</div>
                            <div class="row-col-album">${song.albumName}</div>
                            <div class="row-col-time">
                                <div class="play-icon-container"><div class="play-icon"></div></div>
                                <div style="width: 34px;">${song.duration}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Footer -->
            <footer class="footer">
                <div class="footer-container">
                    <div class="footer-col">
                        <div class="footer-heading">Company</div>
                        <a href="#" class="footer-link">About Us</a>
                        <a href="#" class="footer-link">Careers</a>
                        <a href="#" class="footer-link">Press</a>
                        <a href="#" class="footer-link">Advertise</a>
                    </div>
                    <div class="footer-col">
                        <div class="footer-heading">Features</div>
                        <a href="#" class="footer-link">Charts</a>
                        <a href="#" class="footer-link">Premium</a>
                    </div>
                    <div class="footer-col">
                        <div class="footer-heading">Support</div>
                        <a href="#" class="footer-link">Help Center</a>
                        <a href="#" class="footer-link">Contact Us</a>
                        <a href="#" class="footer-link">Privacy Policy</a>
                        <a href="#" class="footer-link">Terms of Service</a>
                    </div>
                    <div class="footer-col">
                        <div class="footer-heading">Downloads</div>
                        <a href="#" class="footer-link">iOS App</a>
                        <a href="#" class="footer-link">Android App</a>
                        <a href="#" class="footer-link">Desktop App</a>
                    </div>
                </div>
                <div class="footer-copyright">
                    &copy; 2025 MusicSite. All rights reserved.
                </div>
            </footer>
        </div>
    </div>
    <script>
        function promptAndCreatePlaylist() {
            // Check if user is logged in
            <c:if test="${empty sessionScope.userId}">
                alert("로그인이 필요합니다.");
                window.location.href = "login.jsp";
                return;
            </c:if>

            const playlistName = prompt("새 플레이리스트의 이름을 입력하세요:", "My New Playlist");
            if (playlistName && playlistName.trim() !== "") {
                document.getElementById("playlistNameInput").value = playlistName.trim();
                document.getElementById("createPlaylistForm").submit();
            }
        }
    </script>
</body>
</html>
   