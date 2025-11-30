<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WaterMelon Music Platform - Discover</title> <link rel="stylesheet" href="./style.css">
</head>
<body>
    <div class="page-layout">
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>
            <div class="sidebar-nav-title">Menu</div>
            <a href="index.do" class="sidebar-nav-item"> <div class="nav-icon"></div>
                <div class="nav-text">Home</div>
            </a>
            <a href="discover.do" class="sidebar-nav-item active"> <div class="nav-icon"></div>
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
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            Weekly Top <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
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
                            <div class="view-all-circle"><div><div></div></div></div>
                            <div class="song-title">View All</div>
                        </div>
                    </div>
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
                
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            Top <span class="highlight">Albums</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <c:forEach var="album" items="${topAlbums}">
                            <div class="song-card-item">
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
                        <div class="table-row">
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
</body>
</html>