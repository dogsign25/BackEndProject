<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - Admin Dashboard</title>
    <link rel="stylesheet" href="./style.css">
</head>
<body>
    <div class="page-layout">
        <!-- 사이드바 -->
        <div class="sidebar">
            <div class="sidebar-logo">
                <span class="highlight">Water</span>Melon
            </div>

            <div class="sidebar-nav-title">관리자 메뉴</div>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">대시보드</div>
            </a>
            <a href="#" class="sidebar-nav-item active">
                <div class="nav-icon"></div>
                <div class="nav-text">회원 관리</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">음악 관리</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">플레이리스트</div>
            </a>
            
            <div class="sidebar-nav-title">통계</div>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">이용 통계</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">결제 관리</div>
            </a>
            
            <div class="sidebar-nav-title">설정</div>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">시스템 설정</div>
            </a>
            <a href="#" class="sidebar-nav-item">
                <div class="nav-icon"></div>
                <div class="nav-text">로그아웃</div>
            </a>
        </div>

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
                            <span class="admin-name">관리자</span>
                            <div class="admin-avatar"></div>
                        </div>
                    </div>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-total"></div>
                        <div class="stat-info">
                            <div class="stat-value" id="totalMembers">1,234</div>
                            <div class="stat-label">전체 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-active"></div>
                        <div class="stat-info">
                            <div class="stat-value" id="activeMembers">987</div>
                            <div class="stat-label">활성 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-premium"></div>
                        <div class="stat-info">
                            <div class="stat-value" id="premiumMembers">456</div>
                            <div class="stat-label">프리미엄 회원</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon stat-icon-new"></div>
                        <div class="stat-info">
                            <div class="stat-value" id="newMembers">78</div>
                            <div class="stat-label">신규 회원 (이번 달)</div>
                        </div>
                    </div>
                </div>

                <!-- 검색 및 필터 -->
                <div class="control-panel">
                    <div class="search-filter-group">
                        <div class="search-box">
                            <input type="text" id="searchInput" placeholder="이름, 이메일, 전화번호로 검색...">
                            <button class="search-btn" onclick="searchMembers()">검색</button>
                        </div>
                        <div class="filter-group">
                            <select id="statusFilter" onchange="filterMembers()">
                                <option value="all">전체 상태</option>
                                <option value="active">활성</option>
                                <option value="inactive">비활성</option>
                                <option value="suspended">정지</option>
                            </select>
                            <select id="typeFilter" onchange="filterMembers()">
                                <option value="all">전체 유형</option>
                                <option value="free">무료</option>
                                <option value="premium">프리미엄</option>
                            </select>
                            <select id="sortFilter" onchange="sortMembers()">
                                <option value="newest">최신 가입순</option>
                                <option value="oldest">오래된 순</option>
                                <option value="name">이름순</option>
                            </select>
                        </div>
                    </div>
                    <button class="btn-add-member" onclick="openAddMemberModal()">
                        + 회원 추가
                    </button>
                </div>

                <!-- 회원 목록 테이블 -->
                <div class="member-table-container">
                    <table class="member-table">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"></th>
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
                        <tbody id="memberTableBody">
                            <!-- 데이터는 JavaScript로 동적 생성 -->
                        </tbody>
                    </table>
                </div>

                <!-- 페이징 -->
                <div class="pagination">
                    <button class="page-btn" onclick="changePage('prev')">이전</button>
                    <div class="page-numbers" id="pageNumbers">
                        <!-- JavaScript로 동적 생성 -->
                    </div>
                    <button class="page-btn" onclick="changePage('next')">다음</button>
                </div>

                <!-- 선택된 항목 액션 바 -->
                <div class="bulk-action-bar" id="bulkActionBar" style="display: none;">
                    <span class="selected-count" id="selectedCount">0개 선택됨</span>
                    <div class="bulk-actions">
                        <button class="bulk-btn bulk-btn-activate" onclick="bulkAction('activate')">활성화</button>
                        <button class="bulk-btn bulk-btn-suspend" onclick="bulkAction('suspend')">정지</button>
                        <button class="bulk-btn bulk-btn-delete" onclick="bulkAction('delete')">삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 회원 상세/수정 모달 -->
    <div id="memberModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">회원 정보</h2>
                <span class="modal-close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="memberForm">
                    <input type="hidden" id="memberId">
                    <div class="form-row">
                        <div class="form-group">
                            <label>이름 *</label>
                            <input type="text" id="memberName" required>
                        </div>
                        <div class="form-group">
                            <label>이메일 *</label>
                            <input type="email" id="memberEmail" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>전화번호</label>
                            <input type="tel" id="memberPhone">
                        </div>
                        <div class="form-group">
                            <label>생년월일</label>
                            <input type="date" id="memberBirthdate">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>회원유형</label>
                            <select id="memberType">
                                <option value="free">무료</option>
                                <option value="premium">프리미엄</option>
                                <option value="admin">관리자</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>상태</label>
                            <select id="memberStatus">
                                <option value="active">활성</option>
                                <option value="inactive">비활성</option>
                                <option value="suspended">정지</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeModal()">취소</button>
                <button class="btn-save" onclick="saveMember()">저장</button>
            </div>
        </div>
    </div>

    <script src="./admin-script.js"></script>
</body>
</html>