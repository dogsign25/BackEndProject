<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<button class="modal-close-btn" onclick="closeAlbumDetailModal()">&times;</button>

<div class="album-detail-modal-container">
    <c:if test="${not empty album}">
        <!-- 앨범 헤더 -->
        <div class="album-header">
            <img class="album-cover" src="${album.imageUrl}" alt="${album.albumName} Cover" />
            
            <div class="album-info">
                <div class="album-type">Album</div>
                <h1 class="album-title">${album.albumName}</h1>
                <p class="album-artist">${album.artist}</p>
                
                <div class="album-meta">
                    <div class="meta-item">
                        <strong><c:out value="${album.tracks.size()}"/></strong> 곡
                        </div>
                    <div class="meta-item">
                        발매일: <strong><c:out value="${album.releaseDate}"/></strong>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 트랙 리스트 -->
        <div class="tracks-section">
            <div class="tracks-header">
                Tracks
            </div>
            
            <c:forEach var="track" items="${album.tracks}" varStatus="status">
                <div class="track-item" onclick="location.href='<c:url value="/songDetail.do"/>?id=${track.spotifyId}'">
                    <div class="track-number"><c:out value="${status.count}"/></div>
                    
                    <div class="track-info">
                        <div class="track-title"><c:out value="${track.title}"/></div>
                        <div class="track-artist"><c:out value="${track.artist}"/></div>
                    </div>
                    
                    <div class="track-duration"><c:out value="${track.duration}"/></div>
                    
                    <div class="track-play-icon">▶</div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty album}">
        <div style="text-align: center; padding: 50px; font-size: 20px; color: #AAAAAA;">
            <p>앨범 정보를 찾을 수 없습니다.</p>
        </div>
    </c:if>
</div>

<script>
    function closeAlbumDetailModal() {
        window.history.back();
    }
</script>