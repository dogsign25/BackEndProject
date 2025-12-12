<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- 사이드바 -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span class="highlight">Water</span>Melon
    </div>
    
    <div class="sidebar-nav-title">관리자 메뉴</div>
   
   <a href="<c:url value="/index.do"/>" class="sidebar-nav-item ${param.activePage == 'home' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Home</div>
    </a>
   
    <a href="<c:url value="/admin/memberList.do"/>" class="sidebar-nav-item ${param.activePage == 'members' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Manage Members</div>
    </a>
   
    
    <div class="sidebar-nav-title">Stat</div>
    <a href="<c:url value="/statistics.do"/>" class="sidebar-nav-item ${param.activePage == 'stats' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Usage Statistics</div>
    </a>
    <a href="<c:url value="/payment.do"/>" class="sidebar-nav-item ${param.activePage == 'payment' ? 'active' : ''}">
        <div class="nav-icon"></div>
        <div class="nav-text">Payment Management</div>
    </a>
    
    <a href="<c:url value="/logout.do"/>" class="sidebar-nav-item">
        <div class="nav-icon"></div>
        <div class="nav-text">Logout</div>
    </a>
</div>