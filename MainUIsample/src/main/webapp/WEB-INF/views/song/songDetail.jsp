<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>노래 상세 - ${song.title}</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .song-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.85);
            backdrop-filter: blur(10px);
            z-index: 9999;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-y: auto;
            padding: 40px 0;
        }
        
        .song-modal-content {
            background: #1E1E1E;
            border-radius: 20px;
            width: 90%;
            max-width: 800px;
            padding: 40px;
            position: relative;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            animation: modalSlideUp 0.3s ease;
            margin: auto;
        }
        
        @keyframes modalSlideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 24px;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 10;
        }
        
        .modal-close-btn:hover {
            background: #ff3b30;
            transform: rotate(90deg);
        }
        
        .song-detail-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
            align-items: center;
        }
        
        .song-album-art {
            width: 300px;
            height: 300px;
            border-radius: 15px;
            object-fit: cover;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            animation: albumRotate 20s linear infinite paused;
        }
        
        .song-album-art.playing {
            animation-play-state: running;
        }
        
        @keyframes albumRotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .song-info-section {
            text-align: center;
            width: 100%;
        }
        
        .song-detail-title {
            font-size: 28px;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
        }
        
        .song-detail-artist {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 20px;
        }
        
        .song-metadata {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 15px;
        }
        
        .metadata-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
        }
        
        .metadata-label {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.5);
        }
        
        .metadata-value {
            font-size: 16px;
            font-weight: 600;
            color: #34C759;
        }
        
        .spotify-embed {
            width: 100%;
            height: 80px;
            border-radius: 12px;
            margin-top: 20px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            justify-content: center;
        }
        
        .action-button {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-add-playlist {
            background: #0E9EEF;
            color: white;
        }
        
        .btn-add-playlist:hover {
            background: #0c89d1;
            transform: translateY(-2px);
        }
        
        .btn-toggle-like.liked {
            background: #ff3b30;
            color: white;
        }
        
        .btn-toggle-like:not(.liked) {
            background: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
        }
        
        .btn-toggle-like:not(.liked):hover {
            background: rgba(255, 255, 255, 0.2);
        }

        /* Playlist Modal */
        .playlist-modal-container {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.7);
            justify-content: center;
            align-items: center;
        }
        
        .playlist-modal-content {
            background-color: #282828;
            padding: 20px;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            text-align: center;
        }
        
        .playlist-modal-content h3 {
            color: white;
            margin-top: 0;
        }
        
        .playlist-modal-list {
            list-style: none;
            padding: 0;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .playlist-modal-list li {
            background: #333;
            color: white;
            padding: 15px;
            margin-top: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .playlist-modal-list li:hover {
            background: #34C759;
        }
        
        .playlist-modal-close {
            margin-top: 15px;
            padding: 10px 20px;
            background: #555;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        
        /* 추천 곡 섹션 */
        .recommendations-section {
            width: 100%;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #333;
        }
        
        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: white;
            margin-bottom: 20px;
        }
        
        .recommendations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
        }
        
        .recommendation-card {
            background: #252525;
            border-radius: 10px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .recommendation-card:hover {
            background: #2a2a2a;
            transform: translateY(-5px);
        }
        
        .recommendation-image {
            width: 100%;
            aspect-ratio: 1;
            border-radius: 8px;
            object-fit: cover;
            margin-bottom: 10px;
        }
        
        .recommendation-title {
            font-size: 14px;
            font-weight: 600;
            color: white;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .recommendation-artist {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        /* YouTube 영상 섹션 */
        .youtube-section {
            width: 100%;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #333;
        }
        
        .youtube-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
        }
        
        .youtube-card {
            background: #252525;
            border-radius: 10px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .youtube-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
        }
        
        .youtube-thumbnail {
            width: 100%;
            aspect-ratio: 16/9;
            object-fit: cover;
            position: relative;
        }
        
        .youtube-info {
            padding: 12px;
        }
        
        .youtube-title {
            font-size: 13px;
            font-weight: 600;
            color: white;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        
        .youtube-channel {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.5);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <div class="song-modal-overlay" onclick="closeModal(event)">
        <div class="song-modal-content" onclick="event.stopPropagation()">
            <button class="modal-close-btn" onclick="window.history.back()">&times;</button>
            
            <div class="song-detail-container">
                <img id="albumArt" class="song-album-art" src="${song.imageUrl}" alt="${song.title} Album Art" />
                
                <div class="song-info-section">
                    <h1 class="song-detail-title">${song.title}</h1>
                    <p class="song-detail-artist">${song.artist}</p>
                    
                    <div class="song-metadata">
                        <c:if test="${not empty song.duration}">
                            <div class="metadata-item">
                                <span class="metadata-label">재생시간</span>
                                <span class="metadata-value">${song.duration}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty song.releaseDate}">
                            <div class="metadata-item">
                                <span class="metadata-label">발매일</span>
                                <span class="metadata-value">${song.releaseDate}</span>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Spotify 웹 플레이어 임베드 -->
                <c:if test="${not empty song.spotifyId}">
                    <iframe 
                        class="spotify-embed"
                        src="https://open.spotify.com/embed/track/${song.spotifyId}?utm_source=generator&theme=0" 
                        frameBorder="0" 
                        allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" 
                        loading="lazy">
                    </iframe>
                </c:if>
                
                <div class="action-buttons">
                    <button class="action-button btn-add-playlist" onclick="openPlaylistModal()">플레이리스트에 추가</button>
                    <button id="toggleLikeButton" class="action-button btn-toggle-like" onclick="toggleLike()">좋아요 ♥</button>
                </div>
                
                <!-- 비슷한 장르 추천 곡 섹션 -->
                <c:if test="${not empty recommendations}">
                    <div class="recommendations-section">
                        <h2 class="section-title">비슷한 <span style="color: #34C759;">곡 추천</span></h2>
                        <div class="recommendations-grid">
                            <c:forEach var="track" items="${recommendations}">
                                <div class="recommendation-card" onclick="location.href='songDetail.do?id=${track.spotifyId}'">
                                    <img src="${track.imageUrl}" alt="${track.title}" class="recommendation-image">
                                    <div class="recommendation-title">${track.title}</div>
                                    <div class="recommendation-artist">${track.artist}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <!-- YouTube 라이브/커버 영상 섹션 -->
                <c:if test="${not empty youtubeVideos}">
                    <div class="youtube-section">
                        <h2 class="section-title">라이브 & <span style="color: #ff0000;">커버 영상</span></h2>
                        <div class="youtube-grid">
                            <c:forEach var="video" items="${youtubeVideos}">
                                <div class="youtube-card" onclick="openYouTubeVideo('${video.videoId}', '${video.title}', '${video.channelTitle}')">
                                    <img src="${video.thumbnailUrl}" alt="${video.title}" class="youtube-thumbnail">
                                    <div class="youtube-info">
                                        <div class="youtube-title">${video.title}</div>
                                        <div class="youtube-channel">${video.channelTitle}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Playlist Selection Modal -->
    <div id="playlistModal" class="playlist-modal-container">
        <div class="playlist-modal-content">
            <h3>내 플레이리스트</h3>
            <ul id="playlistModalList" class="playlist-modal-list">
            </ul>
            <button class="playlist-modal-close" onclick="closePlaylistModal()">닫기</button>
        </div>
    </div>
    
    <script>
        const trackSpotifyId = "${song.spotifyId}";

        function closeModal(event) {
            if (event.target.classList.contains('song-modal-overlay')) {
                window.history.back();
            }
        }
        
        function openPlaylistModal() {
            fetch("playlist.do")
                .then(response => {
                    if (!response.ok) {
                        throw new Error("플레이리스트를 불러오는 데 실패했습니다. 다시 로그인해주세요.");
                    }
                    return response.json();
                })
                .then(playlists => {
                    const playlistList = document.getElementById("playlistModalList");
                    playlistList.innerHTML = "";
                    
                    if (playlists.length === 0) {
                        playlistList.innerHTML = '<li>플레이리스트가 없습니다. 먼저 플레이리스트를 만들어주세요.</li>';
                    } else {
                        playlists.forEach(playlist => {
                            const li = document.createElement("li");
                            li.textContent = playlist.name;
                            li.onclick = () => addSongToSpecificPlaylist(playlist.id);
                            playlistList.appendChild(li);
                        });
                    }
                    document.getElementById("playlistModal").style.display = "flex";
                })
                .catch(error => {
                    alert(error.message);
                });
        }

        function closePlaylistModal() {
            document.getElementById("playlistModal").style.display = "none";
        }

        function addSongToSpecificPlaylist(playlistId) {
            const params = new URLSearchParams();
            params.append('action', 'addSong');
            params.append('playlistId', playlistId);
            params.append('trackSpotifyId', trackSpotifyId);

            fetch("playlist.do", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    closePlaylistModal();
                }
            })
            .catch(error => {
                console.error("Error adding song:", error);
                alert("오류가 발생했습니다.");
            });
        }

        const albumArt = document.getElementById('albumArt');
        const iframe = document.querySelector('.spotify-embed');
        
        if (iframe) {
            iframe.addEventListener('load', function() {
                albumArt.classList.add('playing');
            });
        }

        const toggleLikeButton = document.getElementById('toggleLikeButton');
        const userId = "${sessionScope.userId}";

        async function checkLikeStatus() {
            if (!userId || userId === "0") {
                return;
            }

            try {
                const encodedSpotifyId = encodeURIComponent(trackSpotifyId);
                const response = await fetch("likedSongs.do?action=checkLike&spotifyId=" + encodedSpotifyId, {
                    method: 'GET'
                });
                const data = await response.json();
                if (data.success) {
                    updateLikeButton(data.isLiked);
                } else {
                    console.error("Failed to check like status:", data.message);
                }
            } catch (error) {
                console.error("Error checking like status:", error);
            }
        }

        function updateLikeButton(isLiked) {
            if (isLiked) {
                toggleLikeButton.classList.add('liked');
                toggleLikeButton.innerHTML = '좋아요 ♥';
            } else {
                toggleLikeButton.classList.remove('liked');
                toggleLikeButton.innerHTML = '좋아요 ♡';
            }
        }

        async function toggleLike() {
            if (!userId || userId === "0") {
                alert("로그인이 필요합니다.");
                window.location.href = "loginForm.do";
                return;
            }

            const currentIsLiked = toggleLikeButton.classList.contains('liked');
            const action = currentIsLiked ? 'remove' : 'add';

            try {
                const encodedSpotifyId = encodeURIComponent(trackSpotifyId);
                const response = await fetch('likedSongs.do', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: "action=" + action + "&spotifyId=" + encodedSpotifyId
                });
                const data = await response.json();

                if (data.success) {
                    updateLikeButton(!currentIsLiked);
                    alert(data.message);
                } else {
                    alert("좋아요 처리 실패: " + data.message);
                }
            } catch (error) {
                console.error("Error toggling like:", error);
                alert("좋아요 처리 중 오류가 발생했습니다.");
            }
        }

        document.addEventListener('DOMContentLoaded', checkLikeStatus);
        
        function openYouTubeVideo(videoId, title, artist) {
            // 특수문자 인코딩
            const encodedTitle = encodeURIComponent(title);
            const encodedArtist = encodeURIComponent(artist);
            const encodedVideoId = encodeURIComponent(videoId);
            
            // youtubeVideo.do로 이동
            window.location.href = `youtubeVideo.do?videoId=${encodedVideoId}&title=${encodedTitle}&artist=${encodedArtist}`;
        }
    </script>
</body>
</html>