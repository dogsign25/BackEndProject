<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">Setting</div>
            </a>
            <a href="#" class="sidebar-nav-item">
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
                                <a href="#" class="btn btn-outline">Login</a>
                                <a href="#" class="btn btn-fill">Sign Up</a>
                            </div>
                        </div>
                    </div> 
                    
                    <div class="hero-text-block">
                        <div class="hero-title">
                            All the <span class="highlight">Best Songs</span><br/>in One Place
                        </div>
                        <div class="hero-description">
                            On our website, you can access an amazing collection of popular and new songs. Stream your favorite tracks in high quality and enjoy without interruptions. Whatever your taste in music, we have it all for you!
                        </div>
                        <div class="hero-actions">
                            <a href="#" class="action-btn-green">Discover Now</a>
                            <a href="#" class="action-btn-blue">Create Playlist</a>
                        </div>
                    </div>
                </div>
                <div class="song-section">
                    <div class="section-title-wrap">
                        <div class="section-title">
                            Weekly Top <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/WhateverItTakes.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Whatever It Takes</div>
                                    <div class="song-artist">Imagine Dragons</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/SkyFall.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Skyfall</div>
                                    <div class="song-artist">Adele</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/SuperMan.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Superman</div>
                                    <div class="song-artist">Eminiem</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/Softcore.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Softcore</div>
                                    <div class="song-artist">The Neighberhood</div>
                                </div>
                            </div>
                        </div>
                        
                        
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
                            New Release <span class="highlight">Songs</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/Time.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Time</div>
                                    <div class="song-artist">Luciano</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/112.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">112</div>
                                    <div class="song-artist">jazz</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/WeDontCare.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">We Don't Care</div>
                                    <div class="song-artist">Kyanu & Dj Gullum</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/WhoIam.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Who I Am</div>
                                    <div class="song-artist">Alan Walker & Elias</div>
                                </div>
                            </div>
                        </div>
                        
                        
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
                            Top <span class="highlight">Music Video</span>
                        </div>
                    </div>
                    <div class="song-card-list">
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/Gossip.png" alt="Music Video Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Greatest Hits</div>
                                    <div class="song-artist">Top Artists</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/ShapeOfYou.png" alt="Music Video Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Shape Of You</div>
                                    <div class="song-artist">Ed Sheeran</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/SomeoneLikeYou.png" alt="Music Video Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Someone Like You</div>
                                    <div class="song-artist">Adele</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/ChillSongs.png" alt="Music Video Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Chill Vibes</div>
                                    <div class="song-artist">Lo-Fi Artist</div>
                                </div>
                            </div>
                        </div>
                        
                        
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
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/Adele21.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Adele 21</div>
                                    <div class="song-artist">Adele</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/Scorpion.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Electric Dreams</div>
                                    <div class="song-artist">Synth Wave</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/HarrysHouse.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Classic Jams</div>
                                    <div class="song-artist">Old School</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/BornToDie.png" alt="Album Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Born To Die</div>
                                    <div class="song-artist">Lana Del Rey</div>
                                </div>
                            </div>
                        </div>
                        
                        
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
                            <span class="highlight">Mood</span> Playlist
                        </div>
                    </div>
                    <div class="song-card-list">
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/SadSongs.png" alt="Playlist Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Study Focus</div>
                                    <div class="song-artist">Chillhop Music</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/ChillSongs.png" alt="Playlist Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Workout Beat</div>
                                    <div class="song-artist">High Energy Pop</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/WorkoutSongs.png" alt="Playlist Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Rainy Days</div>
                                    <div class="song-artist">Soft Jazz</div>
                                </div>
                            </div>
                        </div>
                        <div class="song-card-item">
                            <div class="song-card-content">
                                <img class="song-card-image" src="./src/LoveSongs.png" alt="Playlist Cover" />
                                <div class="song-card-info">
                                    <div class="song-title">Road Trip Mix</div>
                                    <div class="song-artist">Indie Rock</div>
                                </div>
                            </div>
                        </div>
                        
                        
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
                        <a href="#" class="cta-button">Sign Up Now</a>
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
                        <div class="row-col-date">Oct 26, 2023</div>
                        <div class="row-col-album">nightmares</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">2:45</div>
                        </div>
                    </div>
                    
                    <div class="table-row">
                        <div class="row-col-hash">#3</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/TheLoneliest.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">The Lonliest</div>
                                <div class="track-artist-text">MÃ¥neskin</div>
                            </div>
                        </div>
                        <div class="row-col-date">Dec 30, 2023</div>
                        <div class="row-col-album">The Lonliest</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">2:11</div>
                        </div>
                    </div>
                    
                    <div class="table-row">
                        <div class="row-col-hash">#4</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/LovinOnMe.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">Lovin On Me</div>
                                <div class="track-artist-text">Jack Harlow</div>
                            </div>
                        </div>
                        <div class="row-col-date">Dec 30, 2023</div>
                        <div class="row-col-album">Lovin On me</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">2:18</div>
                        </div>
                    </div>
                    
                    <div class="table-row">
                        <div class="row-col-hash">#5</div>
                        <div class="row-col-track-artist">
                            <img class="track-album-cover" src="./src/Water.png" alt="Album Cover" />
                            <div class="track-info-text">
                                <div class="track-title-text">Californication</div>
                                <div class="track-artist-text">Red Hot Chili Peppers</div>
                            </div>
                        </div>
                        <div class="row-col-date">Dec 21, 2023</div>
                        <div class="row-col-album">Californication</div>
                        <div class="row-col-time">
                            <div class="play-icon-container"><div class="play-icon"></div></div>
                            <div style="width: 34px;">3:51</div>
                        </div>
                    </div>
                    
                    <div class="view-all-table-btn">
                        <div class="view-all-table-btn-wrapper">
                            <a href="#" class="inner-wrapper">
                                <div class="icon-text-group">
                                    <div class="view-all-icon-block">
                                        <div class="view-all-icon-block-inner"></div>
                                    </div>
                                    <div class="view-all-text">View All</div>
                                </div>
                            </a>
                        </div>
                    </div>
                    
                </div>
                </div>
            
            <footer class="footer">
                <div class="footer-container">
                    
                    <div class="footer-col">
                        <div class="footer-logo-title">
                            <span class="highlight">Water</span>Melon
                        </div>
                        <div class="footer-description">
                            The best platform for discovering and streaming your favorite music effortlessly.
                        </div>
                        <div class="social-icons">
                            <div class="social-icon"></div> <div class="social-icon"></div> <div class="social-icon"></div> </div>
                    </div>

                    <div class="footer-col">
                        <div class="footer-heading">Quick Links</div>
                        <a href="#" class="footer-link">Home</a>
                        <a href="#" class="footer-link">Discover</a>
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
                    Â© 2025 MusicSite. All rights reserved.
                </div>
            </footer>
            </div>
    </div>
</body>
</html>