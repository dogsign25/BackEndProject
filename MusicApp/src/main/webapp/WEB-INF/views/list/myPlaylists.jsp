<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 플레이리스트 - WaterMelon</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .content-container {
            padding-top: 40px;
        }
        .playlist-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .playlist-header h1 {
            margin: 0;
            font-size: 32px;
            color: #E0E0E0;
        }
        .create-playlist-btn {
            background: #34C759;
            color: #181818;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s ease;
            display: inline-block;
        }
        .create-playlist-btn:hover {
            background: #2ba84d;
        }
        .playlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 25px;
            width: 100%;
        }
        .playlist-card {
            background: #1F1F1F;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            justify-content: flex-start;
            position: relative; /* For positioning the options menu */
        }
        .playlist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.4);
        }
        .playlist-card-options {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-size: 24px;
            color: #fff;
            z-index: 2;
            padding: 5px;
            border-radius: 50%;
            transition: background-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease; /* Added box-shadow to transition */
        }
        .playlist-card-options:hover {
            background-color: rgba(255, 255, 255, 0.2); /* Translucent white background */
            transform: scale(0.95); /* Slightly scale down for sinking effect */
            box-shadow: inset 0 0 5px rgba(0,0,0,0.5); /* Inner shadow for depth */
        }
        .playlist-delete-form {
            display: none; /* Initially hidden */
            position: absolute;
            top: 40px;
            right: 10px;
            z-index: 3;
        }
        .btn-delete {
            background-color: #e53935;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-delete:hover {
            background-color: #c62828;
        }
        .playlist-card-image-wrapper {
            width: 100%;
            padding-bottom: 100%;
            position: relative;
            margin-bottom: 10px;
            border-radius: 8px;
            overflow: hidden;
            background: #2A2A2A;
        }
        .playlist-card img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .playlist-card h3 {
            font-size: 18px;
            margin: 10px 0 5px 0;
            color: #E0E0E0;
            word-break: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .playlist-card p {
            font-size: 14px;
            color: #AAAAAA;
            margin: 0;
        }
        .no-playlists {
            text-align: center;
            padding: 50px;
            font-size: 20px;
            color: #AAAAAA;
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
                <div class="playlist-header">
                    <h1>내 플레이리스트</h1>
                    <a href="javascript:void(0);" onclick="promptAndCreatePlaylist();" class="create-playlist-btn">새 플레이리스트 만들기</a>
                </div>

                <c:choose>
                    <c:when test="${not empty playlists}">
                        <div class="playlist-grid">
                            <c:forEach var="playlist" items="${playlists}">
                                <div class="playlist-card">
                                    <div class="playlist-card-options" data-playlist-id="${playlist.playlist_id}">&#8942;</div>
                                    <form action="playlist.do" method="post" class="playlist-delete-form" id="delete-form-${playlist.playlist_id}">
                                        <input type="hidden" name="action" value="deletePlaylist">
                                        <input type="hidden" name="playlistId" value="${playlist.playlist_id}">
                                        <button type="submit" class="btn-delete" onclick="return confirm('정말로 이 플레이리스트를 삭제하시겠습니까?');">삭제</button>
                                    </form>
                                    <a href="playlistDetail.do?playlistId=${playlist.playlist_id}" class="playlist-card-link">
                                        <div class="playlist-card-image-wrapper">
                                            <img src="./assets/icons/playlist.png" alt="Playlist Cover">
                                        </div>
                                        <h3>${playlist.name}</h3>
                                        <p>${playlist.songCount} 곡</p>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-playlists">
                            <p>아직 생성된 플레이리스트가 없습니다.</p>
                            <a href="#" class="create-playlist-btn" style="margin-top: 20px;" onclick="promptAndCreatePlaylist();">첫 플레이리스트 만들기</a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </div>
        </div>
    </div>
    <form id="createPlaylistForm" action="<c:url value="/playlist.do"/>" method="post" style="display:none;">
        <input type="hidden" name="action" value="create">
        <input type="hidden" id="playlistNameInput" name="playlistName">
    </form>

    <script>
        function promptAndCreatePlaylist() {
            const playlistName = prompt("새 플레이리스트의 이름을 입력하세요:", "My New Playlist");
            if (playlistName && playlistName.trim() !== "") {
                document.getElementById("playlistNameInput").value = playlistName.trim();
                document.getElementById("createPlaylistForm").submit();
            }
        }

        document.addEventListener('click', function(e) {
            // Check if the clicked element is an options button
            if (e.target.classList.contains('playlist-card-options')) {
                const playlistId = e.target.dataset.playlistId;
                const form = document.getElementById('delete-form-' + playlistId);
                
                // Toggle display of the corresponding form
                if (form) {
                    const isVisible = form.style.display === 'block';
                    // Hide all other forms first
                    document.querySelectorAll('.playlist-delete-form').forEach(f => f.style.display = 'none');
                    // Toggle the current form
                    form.style.display = isVisible ? 'none' : 'block';
                }
            } else {
                // If clicking anywhere else on the page, hide all delete forms
                let isDeleteButton = e.target.classList.contains('btn-delete');
                let isOptionsMenu = e.target.classList.contains('playlist-card-options');
                if (!isDeleteButton && !isOptionsMenu) {
                    document.querySelectorAll('.playlist-delete-form').forEach(f => f.style.display = 'none');
                }
            }
        });
    </script>
</body>
</html>