<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WaterMelon Music Platform</title>
    <link rel="stylesheet" href="<c:url value="/style.css"/>">
    <style>
        .like-icon {
            width: 20px !important; /*아이콘 크기 조정 안돼서 직접 넣었음*/
            height: 20px !important;
            object-fit: contain !important;
            transition: transform 0.2s ease-in-out; /* Add transition for smooth effect */
        }
        .like-icon:hover {
            transform: scale(1.1); /* Slightly enlarge on hover */
        }
    </style>
</head>
<body>
    <div class="page-layout">
        <jsp:include page="/WEB-INF/views/common/sidebar_user.jsp">
            <jsp:param name="activePage" value="home" />
        </jsp:include>
        
        <div class="main-content-wrapper">
            
            <div class="content-container">
                <div class="hero-section">
                    
                    <img class="hero-image" src="./assets/images/MainBackground.png" alt="Hero Background" />
                    <div class="header-overlay">
                        <div class="nav-bar">
                            <form action="search.do" method="get" class="search-container">
                                <div class="search-icon" onclick="this.closest('form').submit();"><img src="<c:url value="/assets/icons/search_icon.png"/>" alt="Search"></div>
                                <input type="text" 
                                       name="query" 
                                       placeholder="Search For Musics, Artists, ..." 
                                       class="search-input" 
                                       required />
                            </form>
                            <div class="desktop-nav-links">
                                <a href="#" class="nav-link">About Us</a>
                                <a href="#" class="nav-link">Contact</a>
                                <a href="#" class="nav-link">Premium</a>
                            </div>
                            <div class="auth-buttons">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.userName}">
                                        <span style="color:white; margin-right: 15px;">환영합니다, ${sessionScope.userName}님!</span>
                                        <c:if test="${sessionScope.userType == 'admin'}">
                                            <a href="<c:url value="/admin/memberList.do"/>" class="btn btn-fill">Admin</a>
                                        </c:if>
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
                            <a href="#" onclick="promptAndCreatePlaylist(); return false;" class="action-btn-blue">Create Playlist</a>
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
                            <div class="song-card-item">
                                <div style="position: relative; width: 100%;">
                                    <div class="song-card-content" onclick="location.href='songDetail.do?id=${song.spotifyId}'">
                                        <img class="song-card-image" src="${song.imageUrl}" alt="${song.title} Album Cover" />
                                        <div class="song-card-info">
                                            <div class="song-title">${song.title}</div>
                                            <div class="song-artist">${song.artist}</div>
                                        </div>
                                    </div>
                                    <div class="like-icon-wrapper">
                                        <c:set var="isLiked" value="${likedSpotifyIds.contains(song.spotifyId)}"/>
                                        <img src="<c:url value="${isLiked ? '/assets/icons/liked_icon.png' : '/assets/icons/like_icon.png'}"/>" 
                                             alt="Like" 
                                             class="like-icon ${isLiked ? 'liked' : ''}" 
                                             onclick="likeSong('${song.spotifyId}', this, event)">
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
                            <div class="song-card-item">
                                <div style="position: relative; width: 100%;">
                                    <div class="song-card-content" onclick="location.href='albumDetail.do?id=${album.spotifyAlbumId}'">
                                        <img class="song-card-image" src="${album.imageUrl}" alt="${album.albumName} Album Cover" />
                                        <div class="song-card-info">
                                            <div class="song-title">${album.albumName}</div>
                                            <div class="song-artist">${album.artist}</div>
                                        </div>
                                    </div>
                                    <%-- 앨범 좋아요는 기능 미구현. 아이콘만 UI 일관성을 위해 추가 --%>
                                    <div class="like-icon-wrapper">
                                        <img src="<c:url value='/assets/icons/like_icon.png'/>" alt="Like" class="like-icon" style="opacity: 0.2; cursor: not-allowed;">
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
                            <div class="song-card-item">
                                <div style="position: relative; width: 100%;">
                                    <div class="song-card-content" onclick="location.href='albumDetail.do?id=${album.spotifyAlbumId}'">
                                        <img class="song-card-image" src="${album.imageUrl}" alt="${album.albumName} Album Cover" />
                                        <div class="song-card-info">
                                            <div class="song-title">${album.albumName}</div>
                                            <div class="song-artist">${album.artist}</div>
                                        </div>
                                    </div>
                                    <%-- 앨범 좋아요는 기능 미구현. 아이콘만 UI 일관성을 위해 추가 --%>
                                    <div class="like-icon-wrapper">
                                        <img src="<c:url value='/assets/icons/like_icon.png'/>" alt="Like" class="like-icon" style="opacity: 0.2; cursor: not-allowed;">
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
                        <div class="row-col-like"></div>
                    </div>
                    
                    <c:forEach var="song" items="${trendingSongs}" varStatus="status">
                        <div class="table-row">
                            <div class="row-col-hash" onclick="location.href='songDetail.do?id=${song.spotifyId}'">#${status.index + 1}</div>
                            <div class="row-col-track-artist" onclick="location.href='songDetail.do?id=${song.spotifyId}'">
                                <img class="track-album-cover" src="${song.imageUrl}" alt="${song.title} Album Cover" />
                                <div class="track-info-text">
                                    <div class="track-title-text">${song.title}</div>
                                    <div class="track-artist-text">${song.artist}</div>
                                </div>
                            </div>
                            <div class="row-col-date" onclick="location.href='songDetail.do?id=${song.spotifyId}'">${song.releaseDate}</div>
                            <div class="row-col-album" onclick="location.href='songDetail.do?id=${song.spotifyId}'">${song.albumName}</div>
                            <div class="row-col-time" onclick="location.href='songDetail.do?id=${song.spotifyId}'">
                                <div class="play-icon-container"><div class="play-icon"></div></div>
                                <div style="width: 34px;">${song.duration}</div>
                            </div>
                            <div class="row-col-like">
                                <c:set var="isLiked" value="${likedSpotifyIds.contains(song.spotifyId)}"/>
                                <img src="<c:url value="${isLiked ? '/assets/icons/liked_icon.png' : '/assets/icons/like_icon.png'}"/>" 
                                     alt="Like" 
                                     class="like-icon ${isLiked ? 'liked' : ''}" 
                                     onclick="likeSong('${song.spotifyId}', this, event)">
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        </div>
    </div>
    <script>
        function promptAndCreatePlaylist() {
            const playlistName = prompt("새 플레이리스트의 이름을 입력하세요:", "My New Playlist");
            if (playlistName && playlistName.trim() !== "") {
                document.getElementById("playlistNameInput").value = playlistName.trim();
                document.getElementById("createPlaylistForm").submit();
            }
        }

        // Pass likedSpotifyIds from server-side to client-side
        const likedSpotifyIdsClient = new Set(JSON.parse('${likedSpotifyIdsJson}'));

        function likeSong(trackId, element, event) {
            event.stopPropagation(); // 부모 요소의 onclick 이벤트를 막습니다.

            const isLoggedIn = ('${not empty sessionSession.userName}' === 'true'); // Convert JSTL boolean to JS boolean
            
            if (!isLoggedIn) {
                if (confirm("'좋아요' 기능은 로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?")) {
                    window.location.href = '<c:url value="/loginForm.do"/>';
                }
                return;
            }

            fetch('<c:url value="/likeSong.do"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ trackId: trackId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    if (data.liked) {
                        element.src = '<c:url value="/assets/icons/liked_icon.png"/>';
                        element.classList.add('liked');
                        likedSpotifyIdsClient.add(trackId); // Update client-side set
                    } else {
                        element.src = '<c:url value="/assets/icons/like_icon.png"/>';
                        element.classList.remove('liked');
                        likedSpotifyIdsClient.delete(trackId); // Update client-side set
                    }
                    console.log('Like status updated:', data.liked);
                } else {
                    alert('오류가 발생했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('요청 중 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>