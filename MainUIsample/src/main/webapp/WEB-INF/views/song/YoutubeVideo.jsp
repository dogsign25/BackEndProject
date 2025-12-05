<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - YouTube Video</title>
    <link rel="stylesheet" href="./style.css">
    <style>
        .video-modal-overlay {
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
        
        .video-modal-content {
            background: #1E1E1E;
            border-radius: 20px;
            width: 90%;
            max-width: 1000px;
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
        
        .video-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        .video-player {
            width: 100%;
            aspect-ratio: 16/9;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }
        
        .video-player iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .video-info-section {
            text-align: center;
            width: 100%;
            padding: 20px 0;
        }
        
        .video-title {
            font-size: 28px;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
        }
        
        .video-artist {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 10px;
        }
        
        .youtube-badge {
            display: inline-block;
            padding: 8px 16px;
            background: #ff0000;
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-top: 10px;
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
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
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
    </style>
</head>
<body>
    <div class="video-modal-overlay" onclick="closeModal(event)">
        <div class="video-modal-content" onclick="event.stopPropagation()">
            <button class="modal-close-btn" onclick="window.history.back()">&times;</button>
            
            <div class="video-container">
                <!-- YouTube 플레이어 -->
                <div class="video-player">
                    <iframe 
                        src="https://www.youtube.com/embed/${videoId}?autoplay=1" 
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                        allowfullscreen>
                    </iframe>
                </div>
                
                <div class="video-info-section">
                    <h1 class="video-title">${title}</h1>
                    <p class="video-artist">${artist}</p>
                    <span class="youtube-badge">YouTube Video</span>
                </div>
                
                <!-- 비슷한 아티스트의 곡 추천 -->
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
            </div>
        </div>
    </div>
    
    <script>
        function closeModal(event) {
            if (event.target.classList.contains('video-modal-overlay')) {
                window.history.back();
            }
        }
    </script>
</body>
</html>