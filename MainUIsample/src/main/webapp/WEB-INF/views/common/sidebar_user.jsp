<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="sidebar">
    <div class="sidebar-logo">
        <span class="highlight">Water</span>Melon
    </div>
    
    <div class="sidebar-nav-title">Menu</div>
    <a href="index.do" class="sidebar-nav-item ${param.activePage == 'home' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Home</div>
    </a>
    <a href="discover.do" class="sidebar-nav-item ${param.activePage == 'discover' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Discover</div>
    </a>

    
    <div class="sidebar-nav-title">Playlist</div>
    <a href="<c:choose><c:when test="${not empty sessionScope.userId}">myPlaylist.do</c:when><c:otherwise>loginForm.do</c:otherwise></c:choose>" class="sidebar-nav-item ${param.activePage == 'myPlaylist' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">My Playlist</div>
    </a>
    <a href="likedSongs.do" class="sidebar-nav-item ${param.activePage == 'likedSongs' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Liked Songs</div>
    </a>
    
    <!-- 관리자 전용 메뉴 -->
    <c:if test="${not empty sessionScope.userType && sessionScope.userType == 'admin'}">
        <div class="sidebar-nav-title">Admin</div>
        <a href="<c:url value="/admin/memberList.do"/>" class="sidebar-nav-item ${param.activePage == 'manageMembers' ? 'active' : ''}">
            <div class="nav-icon"></div>
            <div class="nav-text">Manage Members</div>
        </a>
    </c:if>
    
    <div class="sidebar-nav-title">General</div>
    <c:if test="${not empty sessionScope.userId}">
        <a href="myPage.do" class="sidebar-nav-item ${param.activePage == 'myInfo' ? 'active' : ''}">
            <div class="nav-icon"></div>
            <div class="nav-text">My Info</div>
        </a>
        <a href="logout.do" class="sidebar-nav-item">
            <div class="nav-icon"></div>
            <div class="nav-text">Logout</div>
        </a>
    </c:if>
</div>