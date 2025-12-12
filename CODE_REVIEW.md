# Music Web Application 코드 설명서

## 1. Spotify API 연동 서비스

### SpotifyService.java

각 메소드를 인스턴스 메소드로 만들어, Spotify API가 필요한 컨트롤러에서 객체를 생성하여 메소드를 호출

### 1) getAccessToken() 메소드

- **목적**: Spotify API 사용을 위한 액세스 토큰 획득
- **동작 과정**:
    1. CLIENT_ID와 CLIENT_SECRET을 Base64로 인코딩
    2. Spotify 토큰 엔드포인트에 POST 요청
    3. grant_type=client_credentials로 인증
    4. 응답에서 access_token 추출 및 반환

```java
public String getAccessToken() {
    String tokenUrl = "<https://accounts.spotify.com/api/token>";
    String auth = CLIENT_ID + ":" + CLIENT_SECRET;
    String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes());
    // ... 토큰 요청 및 반환
}

```

### 2) getNewReleases() 메소드

- **목적**: 최신 앨범 목록 가져오기
- **동작 과정**:
    1. 받아온 accessToken으로 Spotify API 호출
    2. `/v1/browse/new-releases` 엔드포인트 요청
    3. 응답 JSON을 파싱하여 AlbumDTO 객체 리스트로 변환
    4. 앨범명, 아티스트, 이미지 URL, Spotify ID 추출

### 3) getTrackDetailsByIds() 메소드

- **목적**: 여러 트랙 ID를 한 번에 조회 (배치 요청)
- **동작 과정**:
    1. trackIds 리스트를 쉼표로 연결하여 파라미터 생성
    2. `/v1/tracks?ids={ids}` 엔드포인트 요청 (최대 50개)
    3. 각 트랙 정보를 TrackDTO 객체로 변환
    4. null 트랙은 건너뛰고 유효한 트랙만 리스트에 추가

### 4) searchTracks() 메소드

- **목적**: 키워드로 트랙 검색
- **동작 과정**:
    1. 검색어를 URL 인코딩
    2. `/v1/search?q={query}&type=track&limit=20` 요청
    3. 검색 결과를 TrackDTO 리스트로 변환
    4. 최대 20개의 검색 결과 반환

### 5) getRecommendationsByArtistName() 메소드

- **목적**: 아티스트 이름 기반 추천 곡 검색
- **동작 과정**:
    1. 아티스트 이름으로 검색 쿼리 생성
    2. limit의 5배 또는 최대 50개 결과 요청
    3. 결과를 랜덤으로 섞어서 다양성 확보
    4. 요청한 개수만큼만 반환

---

## 2. 로그인 및 회원가입

### MemberController.java

### login() 메소드

**동작 과정**:

1. 클라이언트로부터 email과 password를 파라미터로 받아옴
2. MemberDAO.checkLogin()을 통해 데이터베이스에서 회원 정보 조회
3. 조회 결과 처리:
    - **조회 성공 시**:
        - Session에 회원 정보 저장 (userName, userEmail, userType, userId)
        - userType이 "admin"이면 관리자 페이지로 리다이렉트
        - 일반 회원이면 메인 페이지([index.do](http://index.do/))로 리다이렉트
    - **조회 실패 시**:
        - errorMessage를 request에 설정
        - 로그인 폼 페이지로 다시 포워딩

```java
private void login(HttpServletRequest request, HttpServletResponse response) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    MemberDTO member = memberDAO.checkLogin(email, password);

    if (member != null) {
        HttpSession session = request.getSession();
        session.setAttribute("userName", member.getName());
        session.setAttribute("userEmail", member.getEmail());
        session.setAttribute("userType", member.getType());
        session.setAttribute("userId", member.getId());

        if ("admin".equals(member.getType())) {
            response.sendRedirect("admin/memberList.do");
        } else {
            response.sendRedirect("index.do");
        }
    } else {
        request.setAttribute("errorMessage", "Invalid email or password");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}

```

### MemberDAO.java

### checkLogin() 메소드

**동작 과정**:

1. SQL 쿼리: `SELECT * FROM members WHERE email = ? AND password = ?`
2. PreparedStatement로 email과 password 바인딩
3. ResultSet에서 회원 정보 추출:
    - id, name, email, phone, birthdate
    - type (free/premium/admin), status (active/inactive/suspended)
    - joinDate, lastLogin
4. 결과가 있으면 MemberDTO 객체 반환, 없으면 null 반환

---

### signup() 메소드

**동작 과정**:

1. 클라이언트로부터 회원가입 데이터 받아옴
    - name, email, password, phone, birthdate
2. MemberDTO 객체 생성 및 기본값 설정
    - type: "free" (무료 회원)
    - status: "active" (활성 상태)
3. MemberDAO.insertMember()로 데이터베이스에 삽입
4. 결과 처리:
    - **성공 시**: 세션 메시지 설정 후 로그인 폼으로 리다이렉트
    - **실패 시**: 에러 메시지와 함께 회원가입 폼으로 다시 포워딩

### insertMember() 메소드

**동작 과정**:

1. SQL 쿼리: `INSERT INTO members (name, email, password, phone, birthdate, type, status) VALUES (?, ?, ?, ?, ?, ?, ?)`
2. PreparedStatement로 각 필드 바인딩
3. executeUpdate() 실행
4. 영향받은 행 개수 반환 (성공 시 1, 실패 시 0)

---

## 3. 플레이리스트 관리

### PlaylistController.java

### createPlaylist() 메소드

**동작 과정**:

1. 세션에서 userId 가져오기
2. 파라미터에서 playlistName 받아오기
3. 유효성 검사: 이름이 null이거나 비어있으면 에러 처리
4. PlaylistDAO.createPlaylist() 호출
5. 성공 시 myPlaylist.do로 리다이렉트

### addSongToPlaylist() 메소드

**동작 과정**:

1. 파라미터에서 playlistId와 trackSpotifyId 받아오기
2. trackSpotifyId 유효성 검사
3. PlaylistDAO.addSongToPlaylist() 호출
4. JSON 형태로 응답 반환:
    - 성공: `{"success":true, "message":"곡이 플레이리스트에 추가되었습니다."}`
    - 실패: `{"success":false, "message":"오류 메시지"}`

### playlistDetail 처리

**동작 과정**:

1. 파라미터에서 playlistId 받아오기
2. PlaylistDAO.getPlaylistById()로 플레이리스트 정보 조회
3. 권한 검사: user_id와 현재 로그인 사용자 비교
4. PlaylistDAO.getTrackSpotifyIdsByPlaylistId()로 트랙 ID 목록 조회
5. SpotifyService.getTrackDetailsByIds()로 트랙 상세 정보 조회
6. request에 playlist와 tracks 설정 후 JSP로 포워딩

### PlaylistDAO.java

### getPlaylistsByUserId() 메소드

**동작 과정**:

1. SQL 쿼리: 플레이리스트 정보 + 곡 개수를 LEFT JOIN으로 조회

```sql
SELECT p.playlist_id, p.user_id, p.name, p.created_at,
       COUNT(ps.track_spotify_id) AS song_count
FROM playlists p
LEFT JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
WHERE p.user_id = ?
GROUP BY p.playlist_id
ORDER BY p.created_at DESC

```

1. ResultSet을 PlaylistDTO 리스트로 변환
2. 각 플레이리스트의 곡 개수(songCount)도 함께 설정

### addSongToPlaylist() 메소드

**동작 과정**:

1. SQL: `INSERT INTO playlist_songs (playlist_id, track_spotify_id) VALUES (?, ?)`
2. 중복 체크: UNIQUE 제약조건으로 동일 곡 중복 방지
3. SQLException 1062 코드(MySQL 중복 에러) 처리
4. 성공하면 true, 실패하면 false 반환

---

## 4. 좋아요 기능

### LikedSongsController.java

### doGet() - 좋아요 목록 조회

**동작 과정**:

1. 세션에서 userId 확인 (없으면 로그인 페이지로 리다이렉트)
2. action 파라미터 확인:
    - **"checkLike"**: 특정 곡의 좋아요 여부 AJAX 확인
        - LikedSongDAO.isSongLiked() 호출
        - JSON 응답: `{"success":true, "isLiked":true/false}`
    - **일반 요청**: 좋아요 목록 페이지 표시
        - LikedSongDAO.getLikedSongSpotifyIds()로 ID 목록 조회
        - SpotifyService.getTrackDetailsByIds()로 상세 정보 조회
        - likedSongs.jsp로 포워딩

### doPost() - 좋아요 추가/삭제

**동작 과정**:

1. 세션에서 userId와 파라미터에서 action, spotifyId 받기
2. 현재 좋아요 상태 확인: LikedSongDAO.isSongLiked()
3. action에 따른 처리:
    - **"add"**: 좋아요 추가
        - 이미 좋아요 상태가 아니면 addLikedSong() 호출
    - **"remove"**: 좋아요 취소
        - 좋아요 상태이면 removeLikedSong() 호출
4. JSON 응답 반환

### LikedSongDAO.java

### isSongLiked() 메소드

**동작 과정**:

1. SQL: `SELECT COUNT(*) FROM liked_songs WHERE user_id = ? AND track_spotify_id = ?`
2. COUNT 결과가 0보다 크면 true, 아니면 false 반환

### getLikedSongSpotifyIds() 메소드

**동작 과정**:

1. SQL: `SELECT track_spotify_id FROM liked_songs WHERE user_id = ?`
2. ResultSet을 순회하며 String 리스트에 Spotify ID 추가
3. 리스트 반환

---

## 5. YouTube 연동

### YouTubeService.java

### searchVideos() 메소드

**동작 과정**:

1. 검색어 구성: `"{artist} {title} (live OR cover OR performance)"`
2. URL 인코딩 후 YouTube Data API v3 호출

```
GET <https://www.googleapis.com/youtube/v3/search>
  ?part=snippet
  &q={encodedQuery}
  &type=video
  &maxResults={maxResults}
  &key={API_KEY}

```

1. JSON 응답에서 items 배열 파싱
2. 각 항목에서 추출:
    - videoId: 영상 고유 ID
    - title: 영상 제목
    - thumbnailUrl: 썸네일 이미지 URL
    - channelTitle: 채널 이름
    - publishedAt: 게시 날짜
3. YouTubeVideo 객체 리스트 생성 및 반환

### YouTubeVideoController.java

### doGet() 메소드

**동작 과정**:

1. UTF-8 인코딩 설정 (중요!)
2. 파라미터 받기: videoId, title, artist
3. videoId 유효성 검사
4. request에 영상 정보 설정
5. Spotify 액세스 토큰 획득
6. 아티스트 정보가 유효하면:
    - SpotifyService.getRecommendationsByArtistName() 호출
    - 추천 곡 4개 조회 후 request에 설정
7. youtubeVideo.jsp로 포워딩

---

## 6. 검색 기능

### SearchController.java

### doGet() 메소드

**동작 과정**:

1. UTF-8 인코딩 설정
2. query 파라미터에서 검색어 받기
3. 검색어가 유효하면:
    - SpotifyService.getAccessToken() 호출
    - SpotifyService.searchTracks() 호출
    - 최대 20개 결과 조회
4. request에 searchQuery와 searchResults 설정
5. searchResult.jsp로 포워딩
6. 검색어가 없으면 빈 리스트로 JSP 포워딩

---

## 7. 앨범 상세 정보

### AlbumDetailController.java

### doGet() 메소드

**동작 과전**:

1. 파라미터에서 albumId(Spotify Album ID) 받기
2. albumId 유효성 검사
3. SpotifyService.getAccessToken() 호출
4. SpotifyService.getAlbumDetails(accessToken, albumId) 호출
    - 앨범 기본 정보 조회
    - 앨범에 포함된 트랙 리스트 조회
5. AJAX 요청 여부 확인:
    - ajax=true: 모달용 JSP fragment로 포워딩
    - 일반 요청: 전체 페이지 JSP로 포워딩
6. 에러 발생 시 error.jsp로 포워딩

---

## 8. 곡 상세 정보

### SongDetailController.java

### doGet() 메소드

**동작 과정**:

1. 파라미터에서 spotifyId(Spotify Track ID) 받기
2. SpotifyService.getAccessToken() 호출
3. **3가지 정보 병렬 조회**:
    
    **A. 곡 상세 정보**
    
    - SpotifyService.getTrackDetails(accessToken, spotifyId)
    - 곡 제목, 아티스트, 이미지, 재생시간, 발매일, 앨범명
    
    **B. 추천 곡 (4개)**
    
    - SpotifyService.getRecommendationsByArtistName(accessToken, artist, 4)
    - 동일 아티스트의 다른 곡들
    
    **C. YouTube 라이브/커버 영상 (4개)**
    
    - YouTubeService.searchVideos(artist, title, 4)
    - 해당 곡의 라이브나 커버 영상
4. 모든 정보를 request에 설정
5. songDetail.jsp로 포워딩

---

## 9. 인증 필터

### AuthenticationFilter.java

### doFilter() 메소드

**동작 과정**:

1. HttpServletRequest로 캐스팅
2. requestURI에서 contextPath 제거
3. **필터링 제외 대상 체크**:
    - 정적 자원: /assets/, /webjars/, /favicon.ico
    - publicUrls: [loginForm.do](http://loginform.do/), [login.do](http://login.do/), [signupForm.do](http://signupform.do/), [signup.do](http://signup.do/), [index.do](http://index.do/), [discover.do](http://discover.do/), [search.do](http://search.do/), [albumDetail.do](http://albumdetail.do/)
4. 세션 확인:
    - 세션이 없거나 userId가 없으면 loginForm.do로 리다이렉트
    - 있으면 다음 필터 또는 서블릿으로 요청 전달
5. **보안 강화**: 로그인 필요한 모든 페이지 보호

---

## 10. 데이터베이스 연결

### DBConnection.java

### getConnection() 메소드

**동작 과정**:

1. MySQL JDBC 드라이버 로딩: `Class.forName("com.mysql.cj.jdbc.Driver")`
2. DriverManager.getConnection() 호출
    - URL: `jdbc:mysql://localhost:3306/MusicApp`
    - 사용자명: root
    - 비밀번호: 1234
3. Connection 객체 반환

### close() 메소드

**2가지 오버로드 버전**:

1. `close(Connection, PreparedStatement)`: SELECT 이외 쿼리용
2. `close(Connection, PreparedStatement, ResultSet)`: SELECT 쿼리용

**동작**: 각 리소스를 순서대로 닫아서 메모리 누수 방지

---

## 11. 주요 DTO 클래스

### TrackDTO

- **필드**: title, artist, imageUrl, duration, releaseDate, spotifyId, albumName
- **용도**: 개별 트랙(곡) 정보 저장
- **생성자**: 4개 파라미터, 7개 파라미터(전체) 버전 제공

### AlbumDTO

- **필드**: albumName, artist, imageUrl, releaseDate, spotifyAlbumId, totalTracks, tracks(List<TrackDTO>)
- **용도**: 앨범 정보 및 포함된 트랙 리스트 저장
- **생성자**: 3개, 4개, 6개 파라미터 버전 제공

### PlaylistDTO

- **필드**: playlist_id, user_id, name, created_at, tracks, songCount
- **용도**: 사용자 플레이리스트 정보 저장
- **특징**: songCount로 곡 개수를 미리 조회하여 성능 최적화

### MemberDTO

- **필드**: id, name, email, phone, birthdate, type, status, joinDate, lastLogin, updatedAt, password
- **용도**: 회원 정보 저장
- **type**: free(무료), premium(프리미엄), admin(관리자)
- **status**: active(활성), inactive(비활성), suspended(정지)

### YouTubeVideo

- **필드**: videoId, title, thumbnailUrl, channelTitle, publishedAt
- **용도**: YouTube 영상 정보 저장
- **특징**: 생성자로만 생성 가능 (불변 객체 패턴)

---

## 12. 주요 설계 패턴 및 특징

### 1. MVC 패턴

- **Model**: DTO, DAO 클래스
- **View**: JSP 파일
- **Controller**: Servlet 클래스

### 2. DAO 패턴

- 데이터베이스 접근 로직을 DAO 클래스에 집중
- 비즈니스 로직과 데이터 접근 로직 분리

### 3. Service 패턴

- SpotifyService, YouTubeService: 외부 API 연동 로직 캡슐화
- Controller에서 복잡한 API 호출 로직 제거

### 4. 세션 기반 인증

- 로그인 정보를 HttpSession에 저장
- Filter를 통한 전역 인증 체크

### 5. RESTful한 URL 설계

- .do 패턴 사용
- 명확한 액션별 엔드포인트 구분

### 6. 에러 처리

- try-catch를 통한 예외 처리
- 사용자 친화적 에러 메시지 제공
- 에러 발생 시 error.jsp로 통합 처리

### 7. 리소스 관리

- try-with-resources 문법 사용
- Connection, PreparedStatement, ResultSet 자동 종료
- 메모리 누수 방지
