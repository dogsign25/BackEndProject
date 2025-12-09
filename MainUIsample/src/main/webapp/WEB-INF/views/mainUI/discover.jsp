<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WaterMelon Music Platform - Discover</title>
    <link rel="stylesheet" href="<c:url value="/style.css"/>">
    <style>
        .like-icon {
            width: 20px !important;
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
            <jsp:param name="activePage" value="discover" />
        </jsp:include>
        
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
                                <div style="position: relative; width: 100%;">
                                    <div class="song-card-content" onclick="location.href='songDetail.do?id=${song.spotifyId}'" style="cursor: pointer;">
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
        // Pass likedSpotifyIds from server-side to client-side
        const likedSpotifyIdsClient = new Set(JSON.parse('${likedSpotifyIdsJson}'));

        function likeSong(trackId, element, event) {
            event.stopPropagation(); // Stop parent element's onclick event

            // Convert JSTL boolean to JS boolean
            const isLoggedIn = ('${not empty sessionScope.userName}' === 'true'); 
            
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
                    alert('An error occurred: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred during the request.');
            });
        }
    </script>
</body>
</html>