<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좋아요 누른 곡 - WaterMelon</title>
    <link rel="stylesheet" href="<c:url value="/style.css"/>">
    <style>
        .content-container {
            padding-top: 40px;
        }
        .liked-songs-header {
            margin-bottom: 30px;
            color: #E0E0E0;
        }
        .liked-songs-header h1 {
            font-size: 32px;
            margin: 0;
        }
        .no-liked-songs {
            text-align: center;
            padding: 50px;
            font-size: 20px;
            color: #AAAAAA;
        }
        .song-list-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .song-list-table th, .song-list-table td {
            text-align: left;
            padding: 15px;
            border-bottom: 1px solid #282828;
            color: #E0E0E0;
        }
        .song-list-table th {
            color: #AAAAAA;
            font-weight: 500;
            font-size: 14px;
        }
        .song-list-table tr:hover {
            background-color: #282828;
            cursor: pointer;
        }
        .song-cover {
            width: 50px;
            height: 50px;
            border-radius: 5px;
            object-fit: cover;
            vertical-align: middle;
            margin-right: 15px;
        }
        .song-info {
            display: flex;
            align-items: center;
        }
        .song-title {
            font-weight: 600;
            margin-bottom: 3px;
        }
        .song-artist {
            font-size: 13px;
            color: #AAAAAA;
        }
        .table-action-btn {
            background: none;
            border: none;
            color: #ff3b30; /* Red for delete */
            font-size: 1.2em;
            cursor: pointer;
            transition: color 0.2s ease;
        }
        .table-action-btn:hover {
            color: #e6352b;
        }
    </style>
</head>
<body>
    <div class="page-layout">
        <jsp:include page="/WEB-INF/views/common/sidebar_user.jsp">
            <jsp:param name="activePage" value="likedSongs" />
        </jsp:include>
        
        <div class="main-content-wrapper">
            <div class="content-container">
                <div class="liked-songs-header">
                    <h1>내가 '좋아요' 누른 곡</h1>
                </div>

                <c:choose>
                    <c:when test="${not empty likedSongs}">
                        <table class="song-list-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>곡 정보</th>
                                    <th>앨범</th>
                                    <th>재생 시간</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="song" items="${likedSongs}" varStatus="status">
                                    <tr onclick="location.href='songDetail.do?id=${song.spotifyId}'">
                                        <td>${status.count}</td>
                                        <td>
                                            <div class="song-info">
                                                <img src="${song.imageUrl}" alt="${song.title} Cover" class="song-cover">
                                                <div>
                                                    <div class="song-title">${song.title}</div>
                                                    <div class="song-artist">${song.artist}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${song.albumName}</td>
                                        <td>${song.duration}</td>
                                        <td>
                                            <button class="table-action-btn" onclick="event.stopPropagation(); removeLike('${song.spotifyId}')">
                                                &times;
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="no-liked-songs">
                            <p>아직 '좋아요'를 누른 곡이 없습니다.</p>
                            <a href="discover.do" class="create-playlist-btn" style="margin-top: 20px;">새로운 곡 찾아보기</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        </div>
    </div>

    <script>
        function removeLike(spotifyId) {
            if (confirm('이 곡을 \'좋아요\' 목록에서 삭제하시겠습니까?')) {
                const formData = new URLSearchParams();
                formData.append('action', 'remove');
                formData.append('spotifyId', encodeURIComponent(spotifyId));

                fetch('likedSongs.do', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload(); // Refresh the page to update the list
                    } else {
                        alert('삭제 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error removing like:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>