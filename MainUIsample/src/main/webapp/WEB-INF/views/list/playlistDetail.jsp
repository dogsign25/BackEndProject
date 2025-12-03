<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${playlist.name} - 플레이리스트 상세 - WaterMelon</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .content-container {
            padding-top: 40px;
        }
        .playlist-detail-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid #333;
        }
        .playlist-cover-large {
            width: 250px;
            height: 250px;
            background: #1F1F1F; /* Placeholder background */
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 24px;
            color: #AAA;
            overflow: hidden; /* To ensure image fits */
        }
        .playlist-cover-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .playlist-info {
            flex-grow: 1;
        }
        .playlist-info h1 {
            font-size: 48px;
            margin: 0 0 10px 0;
            color: #E0E0E0;
        }
        .playlist-info p {
            font-size: 18px;
            color: #AAA;
            margin: 0 0 5px 0;
        }
        .playlist-info .meta-data {
            font-size: 14px;
            color: #777;
        }
        .track-list {
            background: #1F1F1F;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .track-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 5px;
            border-bottom: 1px solid #282828;
            border-radius: 10px;
            color: #E0E0E0;
        }
        .track-item:hover {
        background-color: #282828;
        border-radius: 10px;
        }
        .track-item:last-child {
            border-bottom: none;
        }
        .track-details {
            flex-grow: 1;
        }
        .track-details h4 {
            margin: 0;
            font-size: 18px;
            font-weight: 500;
        }
        .track-details p {
            margin: 0;
            font-size: 14px;
            color: #AAA;
        }
        .track-duration {
            font-size: 14px;
            color: #777;
        }
        .no-tracks {
            text-align: center;
            padding: 50px;
            font-size: 20px;
            color: #AAAAAA;
        }
        .track-item:hover {
            background-color: #34C759; /* A slightly lighter background on hover */
            cursor: pointer;
            transform: translateY(-2px); /* A slight lift effect */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); /* A subtle shadow */
            transition: all 0.2s ease-in-out; /* Smooth transition for all changes */
        }
        .btn-delete-icon {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            border-radius: 50%;
            padding: 5px;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s ease;
        }
        .btn-delete-icon:hover {
            background-color: rgba(255, 68, 68, 0.5); /* Translucent red background on hover */
        }
    </style>
</head>
<body>
    <div class="page-layout">
                <jsp:include page="/WEB-INF/views/common/sidebar_user.jsp">
            <jsp:param name="activePage" value="myPlaylist" />
        </jsp:include>

        <div class="main-content-wrapper">
            <div class="content-container">
                <c:if test="${not empty playlist}">
                    <div class="playlist-detail-header">
                        <div class="playlist-cover-large">
                            <%-- Assuming PlaylistDTO has an imageUrl or cover for the playlist itself --%>
                            <%-- For now, using a placeholder --%>
                            <img src="/assets/images/112.png" alt="Playlist Cover">
                        </div>
                        <div class="playlist-info">
                            <h1>${playlist.name}</h1>
                            <p>총 ${playlist.songCount} 곡</p>
                            <p class="meta-data">생성일: <fmt:formatDate value="${playlist.created_at}" pattern="yyyy.MM.dd"/></p>
                            <%-- Add owner info if available (e.g., from a joined query in DAO) --%>
                            <p class="meta-data">소유자: ${sessionScope.userName}</p> 
                        </div>
                    </div>

                    <div class="track-list">
                        <c:choose>
                            <c:when test="${not empty tracks}">
                                <c:forEach var="track" items="${tracks}">
                                    <div class="track-item">
                                    	<a href="songDetail.do?id=${track.spotifyId}" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1; align-items: center; gap: 15px;">
	                                        <img src="${track.imageUrl}" alt="${track.title} cover">
	                                        <div class="track-details">
	                                            <h4>${track.title}</h4>
	                                            <p>${track.artist}</p>
	                                        </div>
	                                        <div class="track-duration">${track.duration}</div>
                                        </a>
                                        <form action="playlist.do" method="post" style="margin-left: auto;">
                                            <input type="hidden" name="action" value="removeSong">
                                            <input type="hidden" name="playlistId" value="${playlist.playlist_id}">
                                            <input type="hidden" name="trackSpotifyId" value="${track.spotifyId}">
                                            <button type="submit" class="btn-delete-icon">🗑️</button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-tracks">
                                    <p>이 플레이리스트에는 아직 곡이 없습니다.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
                <c:if test="${empty playlist}">
                    <div class="no-tracks">
                        <p>플레이리스트를 찾을 수 없습니다.</p>
                        <a href="myPlaylist.do" class="create-playlist-btn" style="margin-top: 20px;">내 플레이리스트로 돌아가기</a>
                    </div>
                </c:if>
                
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </div>
        </div>
    </div>
</body>
</html>