<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - Admin Dashboard</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
    <div class="page-layout">
                <jsp:include page="/WEB-INF/views/common/sidebar_admin.jsp">
            <jsp:param name="activePage" value="members" />
        </jsp:include>

        <!-- 메인 콘텐츠 -->
        <div class="main-content-wrapper">
            <div class="content-container">
                <!-- 헤더 -->
                <div class="admin-header">
                    <div class="header-title">
                        <h1>회원 관리</h1>
                        <p class="header-subtitle">전체 회원 목록 및 관리</p>
                    </div>
                    <div class="header-actions">
                        <div class="admin-profile">
                            <span class="admin-name">${sessionScope.adminName != null ? sessionScope.adminName : '관리자'}</span>
                            <div class="admin-avatar"></div>
                        </div>
                    </div>
                </div>

                <!-- 성공/에러 메시지 -->
                <c:if test="${not empty sessionScope.msg}">
                    <div class="alert alert-success">
                        ${sessionScope.msg}
                    </div>
                    <c:remove var="msg" scope="session"/>
                </c:if>
                
                <c:if test="${not empty requestScope.errorMsg}">
                    <div class="alert alert-error">
                        ${errorMsg}
                    </div>
                </c:if>

                <!-- 통계 카드 -->
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-total"></div>
                        <div class="stat-info">
                            <div class="stat-value">${stats.total}</div>
                            <div class="stat-label">전체 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-active"></div>
                        <div class="stat-info">
                            <div class="stat-value">${stats.active}</div>
                            <div class="stat-label">활성 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-premium"></div>
                        <div class="stat-info">
                            <div class="stat-value">${stats.premium}</div>
                            <div class="stat-label">프리미엄 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-new"></div>
                        <div class="stat-info">
                            <div class="stat-value">${stats.newMembers}</div>
                            <div class="stat-label">신규 회원 (이번 달)</div>
                        </div>
                    </div>
                </div>

                <!-- 검색 및 필터 -->
                <div class="control-panel">
                    <form action="<c:url value="/admin/memberList.do"/>"" method="get" class="search-filter-group">
                        <div class="search-box">
                            <input type="text" name="search" id="searchInput" 
                                   value="${param.search}" 
                                   placeholder="이름, 이메일, 전화번호로 검색...">
                            <button type="submit" class="search-btn">검색</button>
                        </div>
                        <div class="filter-group">
                            <select name="status" id="statusFilter" onchange="this.form.submit()">
                                <option value="all" ${param.status == 'all' || empty param.status ? 'selected' : ''}>전체 상태</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>활성</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>비활성</option>
                                <option value="suspended" ${param.status == 'suspended' ? 'selected' : ''}>정지</option>
                            </select>
                            <select name="type" id="typeFilter" onchange="this.form.submit()">
                                <option value="all" ${param.type == 'all' || empty param.type ? 'selected' : ''}>전체 유형</option>
                                <option value="free" ${param.type == 'free' ? 'selected' : ''}>무료</option>
                                <option value="premium" ${param.type == 'premium' ? 'selected' : ''}>프리미엄</option>
                                <option value="admin" ${param.type == 'admin' ? 'selected' : ''}>관리자</option>
                            </select>
                            <select name="sort" id="sortFilter" onchange="this.form.submit()">
                                <option value="newest" ${param.sort == 'newest' || empty param.sort ? 'selected' : ''}>최신 가입순</option>
                                <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>오래된 순</option>
                                <option value="name" ${param.sort == 'name' ? 'selected' : ''}>이름순</option>
                            </select>
                        </div>
                    </form>
                    <button class="btn-add-member" onclick="location.href='<c:url value="/admin/memberInsertForm.do"/>'">
                        + 회원 추가
                    </button>
                </div>

                <!-- 회원 목록 테이블 -->
                <div class="member-table-container">
                    <form id="bulkForm" action="memberBulkAction.do" method="post">
                        <table class="member-table">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th>
                                    <th>회원번호</th>
                                    <th>이름</th>
                                    <th>이메일</th>
                                    <th>전화번호</th>
                                    <th>회원유형</th>
                                    <th>상태</th>
                                    <th>가입일</th>
                                    <th>최근접속</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- ========== JSTL로 데이터 출력 (서버 렌더링) ========== -->
                                <c:choose>
                                    <%-- 회원 목록이 비어있을 때 --%>
                                    <c:when test="${empty members}">
                                        <tr>
                                            <td colspan="10" style="text-align: center; padding: 40px; color: rgba(255,255,255,0.6);">
                                                조회된 회원이 없습니다.
                                            </td>
                                        </tr>
                                    </c:when>
                                    
                                    <%-- 회원 목록이 있을 때 반복 출력 --%>
                                    <c:otherwise>
                                        <c:forEach var="member" items="${members}" varStatus="status">
                                            <tr>
                                                <%-- 체크박스 --%>
                                                <td>
                                                    <input type="checkbox" name="memberIds" value="${member.id}" class="member-checkbox">
                                                </td>
                                                
                                                <%-- 회원번호 --%>
                                                <td class="member-id">#${member.id}</td>
                                                
                                                <%-- 이름 --%>
                                                <td class="member-name">${member.name}</td>
                                                
                                                <%-- 이메일 --%>
                                                <td class="member-email">${member.email}</td>
                                                
                                                <%-- 전화번호 (없으면 '-' 표시) --%>
                                                <td>${not empty member.phone ? member.phone : '-'}</td>
                                                
                                                <%-- 회원유형 (배지 스타일) --%>
                                                <td>
                                                    <span class="member-type type-${member.type}">
                                                        <c:choose>
                                                            <c:when test="${member.type == 'free'}">무료</c:when>
                                                            <c:when test="${member.type == 'premium'}">프리미엄</c:when>
                                                            <c:when test="${member.type == 'admin'}">관리자</c:when>
                                                            <c:otherwise>${member.type}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                
                                                <%-- 상태 (배지 스타일) --%>
                                                <td>
                                                    <span class="member-status status-${member.status}">
                                                        <c:choose>
                                                            <c:when test="${member.status == 'active'}">활성</c:when>
                                                            <c:when test="${member.status == 'inactive'}">비활성</c:when>
                                                            <c:when test="${member.status == 'suspended'}">정지</c:when>
                                                            <c:otherwise>${member.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                
                                                <%-- 가입일 (날짜 포맷팅) --%>
                                                <td>
                                                    <fmt:formatDate value="${member.joinDate}" pattern="yyyy-MM-dd"/>
                                                </td>
                                                
                                                <%-- 최근접속 (없으면 '-' 표시) --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty member.lastLogin}">
                                                            <fmt:formatDate value="${member.lastLogin}" pattern="yyyy-MM-dd"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <%-- 관리 버튼 --%>
                                                <td>
                                                    <div class="action-buttons">
                                                        <button type="button" class="action-btn btn-view" 
                                                                onclick="location.href='<c:url value="/admin/memberView.do"/>?id=${member.id}'">
                                                            보기
                                                        </button>
                                                        <button type="button" class="action-btn btn-edit" 
                                                                onclick="location.href='<c:url value="/admin/memberUpdateForm.do"/>?id=${member.id}'">
                                                            수정
                                                        </button>
                                                        <button type="button" class="action-btn btn-delete" 
                                                                onclick="deleteMember(${member.id})">
                                                            삭제
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </form>
                </div>

                <!-- 페이징 (간단 버전) -->
                <div class="pagination">
                    <button class="page-btn" disabled>이전</button>
                    <div class="page-numbers">
                        <div class="page-number active">1</div>
                    </div>
                    <button class="page-btn" disabled>다음</button>
                </div>

                <!-- 선택된 항목 액션 바 -->
                <div class="bulk-action-bar" id="bulkActionBar" style="display: none;">
                    <span class="selected-count" id="selectedCount">0개 선택됨</span>
                    <div class="bulk-actions">
                        <button type="button" class="bulk-btn bulk-btn-activate" onclick="bulkAction('activate')">활성화</button>
                        <button type="button" class="bulk-btn bulk-btn-suspend" onclick="bulkAction('suspend')">정지</button>
                        <button type="button" class="bulk-btn bulk-btn-delete" onclick="bulkAction('delete')">삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // ========== JavaScript는 UI 동작만 처리 (데이터 조작 X) ==========
        
        // 전체 선택/해제
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.member-checkbox');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
            updateBulkActionBar();
        }

        // 체크박스 변경 시 대량 작업 바 업데이트
        document.addEventListener('DOMContentLoaded', function() {
            const checkboxes = document.querySelectorAll('.member-checkbox');
            checkboxes.forEach(cb => {
                cb.addEventListener('change', updateBulkActionBar);
            });
        });

        // 대량 작업 바 표시/숨김
        function updateBulkActionBar() {
            const checkboxes = document.querySelectorAll('.member-checkbox:checked');
            const bar = document.getElementById('bulkActionBar');
            const count = document.getElementById('selectedCount');
            
            if (checkboxes.length > 0) {
                bar.style.display = 'flex';
                count.textContent = checkboxes.length + '개 선택됨';
            } else {
                bar.style.display = 'none';
            }
        }

        // 대량 작업 실행
        function bulkAction(action) {
            const checkboxes = document.querySelectorAll('.member-checkbox:checked');
            
            if (checkboxes.length === 0) {
                alert('선택된 회원이 없습니다.');
                return;
            }
            
            let confirmMsg = '';
            switch(action) {
                case 'activate':
                    confirmMsg = '선택한 ' + checkboxes.length + '명의 회원을 활성화하시겠습니까?';
                    break;
                case 'suspend':
                    confirmMsg = '선택한 ' + checkboxes.length + '명의 회원을 정지하시겠습니까?';
                    break;
                case 'delete':
                    confirmMsg = '선택한 ' + checkboxes.length + '명의 회원을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';
                    break;
            }
            
            if (confirm(confirmMsg)) {
                const form = document.getElementById('bulkForm');
                form.action = 'memberBulkAction.do?action=' + action;
                form.submit();
            }
        }

        // 회원 삭제 (개별)
        function deleteMember(id) {
            if (confirm('정말로 이 회원을 삭제하시겠습니까?')) {
                location.href = 'memberDelete.do?id=' + id;
            }
        }

        // 알림 메시지 자동 숨김 (3초 후)
        window.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.3s ease';
                    setTimeout(() => alert.remove(), 300);
                }, 3000);
            });
        });
    </script>
</body>
</html>