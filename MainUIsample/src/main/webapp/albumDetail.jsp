<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${album.albumName} - WaterMelon</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .album-detail-container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .album-header {
            display: flex;
            gap: 40px;
            margin-bottom: 50px;
            background: #1E1E1E;
            padding: 40px;
            border-radius: 20px;
        }
        
        .album-cover {
            width: 300px;
            height: 300px;
            border-radius: 15px;
            object-fit: cover;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }
        
        .album-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 15px;
        }
        
        .album-type {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.7);
            text-transform: uppercase;
        }
        
        .album-title {
            font-size: 48px;
            font-weight: 800;
            color: white;
        }
        
        .album-artist {
            font-size: 24px;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .album-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 10px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .tracks-section {
            background: #1E1E1E;
            border-radius: 20px;
            padding: 30px;
        }
        
        .tracks-header {
            font-size: 28px;
            font-weight: 700;
            color: white;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #333;
        }
        
        .track-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .track-item:hover {
            background: #282828;
            transform: translateX(5px);
        }
        
        .track-number {
            width: 40px;
            text-align: center;
            font-size: 16px;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 600;
        }
        
        .track-info {
            flex: 1;
            margin-left: 15px;
        }
        
        .track-title {
            font-size: 18px;
            font-weight: 600;
            color: white;
            margin-bottom: 5px;
        }
        
        .track-artist {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.6);
        }
        
        .track-duration {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.6);
            margin-right: 15px;
        }
        
        .track-play-icon {
            width: 40px;
            height: 40px;
            background: #34C759;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .track-item:hover .track-play-icon {
            opacity: 1;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: #282828;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }
        
        .back-button:hover {
            background: #34C759;
            transform: translateX(-5px);
        }
    </style>
</head>
<body style="background: #181818; color: white;">
    <div class="album-detail-container">
        <a href="javascript:history.back()" class="back-button">
            ← 뒤로 가기
        </a>
        
        
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
                            <strong>${album.totalTracks}</strong> 곡
                        </div>
                        <div class="meta-item">
                            발매일: <strong>${album.releaseDate}</strong>
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
                    <div class="track-item" onclick="location.href='songDetail.do?id=${track.spotifyId}'">
                        <div class="track-number">${status.index + 1}</div>
                        
                        <div class="track-info">
                            <div class="track-title">${track.title}</div>
                            <div class="track-artist">${track.artist}</div>
                        </div>
                        
                        <div class="track-duration">${track.duration}</div>
                        
                        <div class="track-play-icon">▶</div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
</html>