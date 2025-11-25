<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Music Platform with All Sections</title>
    
    <link rel="stylesheet" href="./style.css">
</head>
<body>

    <div class="page-layout">
        
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>

            <div class="sidebar-nav-title">Menu</div>
            <a href="#" class="sidebar-nav-item active">
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
                    <c:if test="${not empty errorMessage}">
                        <p style="color:red; text-align:center; margin-top: 10px;">${errorMessage}</p>
                    </c:if>
                    
                    <img class="hero-image" src="./src/MainBackground.png" alt="Hero Background" />

                    <div class="header-overlay">
                        <div class="nav-bar">
                            <div class="search-container">
                                <div class="search-icon">
                                    <div></div>
                                </div>
                                <div>
                                    <div class="search-placeholder">Search For Musics, Artists, ...</div>
                                </div>
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
                            <a href="#" class="action-btn-green">Discover Now</a>
                            <a href="#" class="action-btn-blue">Create Playlist</a>
                        </div>
                    </div>
                </div>
                
               <!-- Weekly Top Songs 섹션 -->
<div class="song-section">
    <div class="section-title-wrap">
        <div class="section-title">
            Weekly Top <span class="highlight">Songs</span>
        </div>
    </div>
    <div class="song-card-list">
        <!-- JSTL로 Spotify 데이터 표시 -->
                <c:forEach var="song" items="${weeklyTopSongs}">
                    <div class="song-card-item">
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
                            <div class="view-all-circle">
                                <div><div></div></div>
                            </div>
                            <div class="song-title">View All</div>
                        </div>
            
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            New Release <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <c:forEach var="album" items="${newReleases}">
                            <div class="song-card-item">
                                <div class="song-card-content">
                                    <img class="song-card-image" src="${album.imageUrl}" alt="${album.title} Album Cover" />
                                    <div class="song-card-info">
                                        <div class="song-title">${album.title}</div>
                                        <div class="song-artist">${album.artist}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="view-all-card">
                            <div class="view-all-circle">
                                <div><div></div></div>
                            </div>
                            <div class="song-title">View All</div>
                        </div>
                    </div>
                </div>
                
                
               <div class="song-section">
    <div class="section-title-wrap">
        <div class="section-title">
            Top <span class="highlight">Albums</span>
        </div>
    </div>
    <div class="song-card-list">
        <!-- JSTL로 Spotify 데이터 표시 -->
                <c:forEach var="album" items="${topAlbums}">
                    <div class="song-card-item">
                        <div class="song-card-content">
                            <img class="song-card-image" src="${album.imageUrl}" alt="${album.title} Album Cover" />
                            <div class="song-card-info">
                                <div class="song-title">${album.title}</div>
                                <div class="song-artist">${album.artist}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                        <div class="view-all-card">
                            <div class="view-all-circle">
                                <div><div></div></div>
                            </div>
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
                
                <div class="trending-table-container">
                    <div class="section-title">
                        Trending <span class="highlight">Songs</span>
                    </div>
                    
                    <div class="table-header">
                        <div class="row-col-hash">#</div>
                        <div class="row-col-track-artist">Track / Artist</div>
                        <div class="row-col-date row-col-date-header">Relase Date</div>
                        <div class="row-col-album row-col-album-header">album</div>
                        <div class="row-col-time">Time</div>
                    </div>
                    
                    <div class="table-row">
                        <div class="row-col-hash">#1</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/Softcore.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">Softcore</div>
                                <div class="track-artist-text">The neighberhood</div>
                            </div>
                        </div>
                        <div class="row-col-date">Nov 4, 2023</div>
                        <div class="row-col-album">Hard to Imagine the Neighbourhood Ever Changing</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">3:26</div>
                        </div>
                    </div>
                    
                    <div class="table-row">
                        <div class="row-col-hash">#2</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/SkyfallBeats.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">Skyfall Beats</div>
                                <div class="track-artist-text">nightmares</div>
                            </div>
                        </div>
                        <div class="row-col-date">Nov 4, 2023</div>
                        <div class="row-col-album">Skyfall Beats</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">3:26</div>
                        </div>
                    </div>

                    <div class="table-row">
                        <div class="row-col-hash">#3</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/PopSongs.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">Pop Songs 2024</div>
                                <div class="track-artist-text">Various Artists</div>
                            </div>
                        </div>
                        <div class="row-col-date">Dec 1, 2023</div>
                        <div class="row-col-album">Best of 2024</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">3:26</div>
                        </div>
                    </div>
                    
                </div>
            </div>
            
            <footer class="footer">
                <div class="footer-columns">
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
</body>
</html>