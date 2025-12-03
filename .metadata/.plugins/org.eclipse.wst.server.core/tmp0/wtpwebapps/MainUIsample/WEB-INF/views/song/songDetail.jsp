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
        }
        
        .song-modal-content {
            background: #1E1E1E;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            padding: 40px;
            position: relative;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            animation: modalSlideUp 0.3s ease;
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
        
        .player-controls {
            width: 100%;
            margin-top: 20px;
        }
        
        .play-pause-btn {
            width: 70px;
            height: 70px;
            background: #34C759;
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        
        .play-pause-btn:hover {
            background: #2ba84d;
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(52, 199, 89, 0.4);
        }
        
        .progress-bar-container {
            width: 100%;
            height: 6px;
            background: #333;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 10px;
        }
        
        .progress-bar {
            height: 100%;
            background: #34C759;
            width: 0%;
            transition: width 0.1s linear;
        }
        
        .time-display {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
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
        
        .btn-add-favorite {
            background: #ff3b30;
            color: white;
        }
        
        .btn-add-favorite:hover {
            background: #e6352b;
            transform: translateY(-2px);
        }
        /* New style for liked songs button */
        .btn-toggle-like.liked {
            background: #ff3b30; /* Red for liked */
            color: white;
        }
        .btn-toggle-like:not(.liked) {
            background: rgba(255, 255, 255, 0.1); /* Lighter background when not liked */
            color: rgba(255, 255, 255, 0.7);
        }
        .btn-toggle-like:not(.liked):hover {
            background: rgba(255, 255, 255, 0.2);
        }

        /* Playlist Modal Styles */
        .playlist-modal-container {
            display: none; /* Hidden by default */
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
            </div>
        </div>
    </div>

    <!-- Playlist Selection Modal -->
    <div id="playlistModal" class="playlist-modal-container">
        <div class="playlist-modal-content">
            <h3>내 플레이리스트</h3>
            <ul id="playlistModalList" class="playlist-modal-list">
                <!-- Playlists will be dynamically inserted here -->
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
                    playlistList.innerHTML = ""; // Clear previous list
                    
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

        // 앨범 아트 회전 애니메이션 (재생 중일 때)
        const albumArt = document.getElementById('albumArt');
        const iframe = document.querySelector('.spotify-embed');
        
        if (iframe) {
            iframe.addEventListener('load', function() {
                albumArt.classList.add('playing');
            });
        }

        // --- New Like Functionality ---
        const toggleLikeButton = document.getElementById('toggleLikeButton');
        const userId = "${sessionScope.userId}"; // Assuming userId is available in session

        // Function to check initial like status
        async function checkLikeStatus() {
            if (!userId || userId === "0") { // userId is 0 if not logged in
                // If not logged in, disable like button or hide it. For now, just don't check.
                // toggleLikeButton.disabled = true;
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

        // Function to update the button's appearance
        function updateLikeButton(isLiked) {
            if (isLiked) {
                toggleLikeButton.classList.add('liked');
                toggleLikeButton.innerHTML = '좋아요 ♥'; // Filled heart or similar
            } else {
                toggleLikeButton.classList.remove('liked');
                toggleLikeButton.innerHTML = '좋아요 ♡'; // Empty heart
            }
        }

        // Function to toggle like status
        async function toggleLike() {
            if (!userId || userId === "0") {
                alert("로그인이 필요합니다.");
                window.location.href = "loginForm.do"; // Redirect to login page
                return;
            }

            const currentIsLiked = toggleLikeButton.classList.contains('liked');
            const action = currentIsLiked ? 'remove' : 'add';

            try {
                const encodedSpotifyId = encodeURIComponent(trackSpotifyId); // Moved outside
                const response = await fetch('likedSongs.do', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: "action=" + action + "&spotifyId=" + encodedSpotifyId
                });
                const data = await response.json();

                if (data.success) {
                    updateLikeButton(!currentIsLiked); // Toggle button state
                    alert(data.message);
                } else {
                    alert("좋아요 처리 실패: " + data.message);
                }
            } catch (error) {
                console.error("Error toggling like:", error);
                alert("좋아요 처리 중 오류가 발생했습니다.");
            }
        }

        // Initial check on page load
        document.addEventListener('DOMContentLoaded', checkLikeStatus);
    </script>
</body>
</html>