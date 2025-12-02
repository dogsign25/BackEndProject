<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색 결과 - ${searchQuery}</title>
    <link rel="stylesheet" href="./style.css">
</head>
<body>
    <div class="page-layout">
        <div class="sidebar">
            </div>
        
        <div class="main-content-wrapper">
            <div class="content-container">
                
                <h2 class="section-title" style="margin-top: 50px;">
                    '${searchQuery}'에 대한 <span class="highlight">검색 결과</span>
                </h2>
                

                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <div class="song-card-list">
                            <c:forEach var="track" items="${searchResults}">
                                <div class="song-card-item" onclick="location.href='songDetail.do?id=${track.spotifyId}'" style="cursor: pointer;">
                                    <div class="song-card-content">
                                        <img class="song-card-image" src="${track.imageUrl}" alt="${track.title} Album Cover" />
                                        <div class="song-card-info">
                                            <div class="song-title">${track.title}</div>
                                            <div class="song-artist">${track.artist}</div>
                                            <div class="song-artist" style="font-size: 10px; opacity: 0.7;">
                                                (${track.duration}) | ${track.releaseDate}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align:center; margin-top: 20px; color: grey; font-size: 16px;">
                            검색 결과가 없습니다. 다른 키워드로 검색해보세요.
                        </p>
                    </c:otherwise>
                </c:choose>

            </div>
            </div>
    </div>
</body>
</html>