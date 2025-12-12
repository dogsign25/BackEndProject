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
        .album-modal-overlay {
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
        
        .album-modal-content {
            background: #1E1E1E;
            border-radius: 20px;
            width: 90%;
            max-width: 900px; /* Adjusted for album content */
            height: 90%;
            max-height: 800px;
            padding: 40px;
            position: relative;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            animation: modalSlideUp 0.3s ease;
            overflow-y: auto; /* Enable scrolling for content */
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
            z-index: 10000;
        }
        
        .modal-close-btn:hover {
            background: #ff3b30;
            transform: rotate(90deg);
        }

        /* Styles from original albumDetail.jsp, adapted for modal content */
        .album-detail-modal-container { /* Renamed from .album-detail-container to avoid conflict */
            max-width: 100%;
            margin: 0 auto;
            padding: 0;
        }
        
        .album-header {
            display: flex;
            gap: 40px;
            margin-bottom: 30px;
            background: #1E1E1E;
            padding: 0; /* No extra padding here, already in modal-content */
            border-radius: 0; /* No extra border-radius here */
        }
        
        .album-cover {
            width: 200px; /* Smaller in modal */
            height: 200px;
            border-radius: 10px;
            object-fit: cover;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }
        
        .album-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 10px;
        }
        
        .album-type {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
            text-transform: uppercase;
        }
        
        .album-title {
            font-size: 38px; /* Smaller in modal */
            font-weight: 800;
            color: white;
        }
        
        .album-artist {
            font-size: 20px; /* Smaller in modal */
            color: rgba(255, 255, 255, 0.8);
        }
        
        .album-meta {
            display: flex;
            gap: 15px;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 5px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .tracks-section {
            background: #1E1E1E;
            border-radius: 0;
            padding: 0;
        }
        
        .tracks-header {
            font-size: 24px; /* Smaller in modal */
            font-weight: 700;
            color: white;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #333;
        }
        
        .track-item {
            display: flex;
            align-items: center;
            padding: 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .track-item:hover {
            background: #282828;
            transform: translateX(5px);
        }
        
        .track-number {
            width: 30px;
            text-align: center;
            font-size: 15px;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 600;
        }
        
        .track-info {
            flex: 1;
            margin-left: 10px;
        }
        
        .track-title {
            font-size: 16px;
            font-weight: 600;
            color: white;
            margin-bottom: 3px;
        }
        
        .track-artist {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.6);
        }
        
        .track-duration {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.6);
            margin-right: 10px;
        }
        
        .track-play-icon {
            width: 30px;
            height: 30px;
            background: #34C759;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            font-size: 14px;
        }
        
        .track-item:hover .track-play-icon {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="album-modal-overlay" onclick="closeModal(event)">
        <div class="album-modal-content" onclick="event.stopPropagation()">
            <button class="modal-close-btn" onclick="window.history.back()">&times;</button>
            
            <jsp:include page="albumDetailModalContent.jsp" />
        </div>
    </div>
    
    <script>
        function closeModal(event) {
            if (event.target.classList.contains('album-modal-overlay')) {
                window.history.back();
            }
        }
    </script>
</body>
</html>
</html>