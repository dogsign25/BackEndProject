<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<button class="modal-close-btn" onclick="closeSongDetailModal()">&times;</button>

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
        <button id="likeBtn" class="action-button btn-like <c:if test="${isLiked}">liked</c:if>" onclick="toggleLike('${song.spotifyId}', event)">좋아요 ♥</button>
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
    // Note: trackSpotifyId is now passed directly to toggleLike function, or retrieved from the DOM as needed.
    // This script block should ideally be moved to the main page script or loaded dynamically.
    // For now, it's here assuming it will be loaded with the modal content.

    function toggleLike(trackSpotifyId, event) {
        // Prevent event bubbling if button is part of a larger clickable area
        if (event) event.stopPropagation();

        <c:if test="${empty sessionScope.userId}">
            alert("로그인이 필요합니다.");
            window.location.href = "loginForm.do";
            return;
        </c:if>

        const likeBtn = document.getElementById('likeBtn');
        const isLiked = likeBtn.classList.contains('liked');
        const action = isLiked ? 'unlike' : 'like';

        const params = new URLSearchParams();
        params.append('action', action);
        params.append('trackId', trackSpotifyId);

        fetch('like.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('요청을 처리하지 못했습니다.');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                likeBtn.classList.toggle('liked');
            } else {
                alert(data.message || '오류가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('Error toggling like:', error);
            alert('오류가 발생했습니다.');
        });
    }

    function openPlaylistModal() {
        <c:if test="${empty sessionScope.userId}">
            alert("로그인이 필요합니다.");
            window.location.href = "loginForm.do";
            return;
        </c:if>

        const currentTrackSpotifyId = document.querySelector('.spotify-embed').src.split('/').pop().split('?')[0];

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
                        li.onclick = () => addSongToSpecificPlaylist(playlist.id, currentTrackSpotifyId);
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

    function addSongToSpecificPlaylist(playlistId, trackSpotifyId) {
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

    // 앨범 아트 회전 애니메이션 (재생 중일 때) - 필요시 여기에 남겨두거나, 메인 페이지 스크립트로 이동
    // const albumArt = document.getElementById('albumArt');
    // const iframe = document.querySelector('.spotify-embed');
    
    // if (iframe) {
    //     iframe.addEventListener('load', function() {
    //         albumArt.classList.add('playing');
    //     });
    // }
</script>
