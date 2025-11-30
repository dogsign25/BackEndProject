# 로그인 & 회원가입 코드리뷰

## 로그인 및 회원가입 기능 구현 요약

---

### 1. 회원가입 기능 (Signup)

사용자가 이름, 이메일, 비밀번호 등을 입력하여 서비스에 가입하는 기능입니다.

*   **사용된 파일 및 코드 변경:**
    *   `signup.jsp`: 회원가입 정보를 입력받는 HTML 폼을 새로 생성했습니다. 폼은 `signup.do`로 데이터를 전송합니다.
        ```html
        <form action="signup.do" method="post">
            <input type="text" name="email">
            <input type="password" name="password">
            <input type="text" name="name">
            <input type="text" name="phone">
            <input type="date" name="birthdate">
            <button type="submit">가입하기</button>
        </form>
        ```
    *   `MemberController.java`: `doPost()` 메소드 내에 `signup.do` 요청을 받아 처리하는 로직(`memberSignup` 메소드 호출)을 추가했습니다.
        ```java
        // doPost() 메소드 내부
        else if ("signup.do".equals(command)) {
            memberSignup(request, response); // 회원가입 처리 메소드 호출
            response.sendRedirect("login.jsp"); // 성공 후 로그인 페이지로 이동
        }
        ```
    *   `MemberDTO.java`: 사용자의 비밀번호를 담을 `private String password;` 필드와 해당 Getter/Setter 메소드를 추가했습니다.
    *   `MemberDAO.java`: `insertMember()` 메소드가 `MemberDTO`에 담긴 비밀번호를 받아 데이터베이스에 저장하도록 수정했습니다.

*   **동작 방식:**
    1.  사용자가 `signup.jsp`에서 정보를 입력하고 '가입하기' 버튼을 누릅니다.
    2.  폼 데이터는 `signup.do` 주소로 `MemberController`에게 HTTP POST 방식으로 전송됩니다.
    3.  `MemberController`는 전송된 데이터를 `MemberDTO` 객체에 담습니다.
    4.  `MemberDAO`의 `insertMember()` 메소드를 호출하여 데이터베이스 `members` 테이블에 새로운 사용자를 추가(INSERT)합니다.
    5.  회원가입이 성공하면 `login.jsp` 페이지로 이동합니다.

---

### 2. 로그인 기능 (Login)

가입된 사용자가 이메일과 비밀번호로 자신을 인증하는 기능입니다.

*   **사용된 파일 및 코드 변경:**
    *   `login.jsp`: 이메일과 비밀번호를 입력받는 로그인 폼을 새로 생성했습니다. 폼은 `login.do`로 데이터를 전송합니다.
        ```html
        <form action="login.do" method="post">
            <label for="email">이메일:</label><input type="email" id="email" name="email" required>
            <label for="password">비밀번호:</label><input type="password" id="password" name="password" required>
            <button type="submit">로그인</button>
        </form>
        ```
    *   `MemberController.java`: `doPost()` 메소드 내에 `login.do` 요청을 처리하는 로직(`memberLogin` 메소드 호출)을 추가했습니다.
        ```java
        // doPost() 메소드 내부
        else if ("login.do".equals(command)) {
            memberLogin(request, response); // 로그인 처리 메소드 호출
        }
        ```
    *   `MemberDAO.java`: `checkLogin(String email, String password)` 메소드를 추가하여 데이터베이스에 해당 이메일과 비밀번호를 가진 사용자가 있는지 확인합니다.

*   **동작 방식:**
    1.  사용자가 `login.jsp`에서 이메일과 비밀번호를 입력하고 '로그인' 버튼을 누릅니다.
    2.  폼 데이터는 `login.do` 주소로 `MemberController`에게 HTTP POST 방식으로 전송됩니다.
    3.  `MemberController`는 `MemberDAO`의 `checkLogin()`을 호출하여 DB에서 사용자 정보를 조회합니다.
    4.  **로그인 성공 시:**
        *   `HttpSession` (세션)을 생성하고, 여기에 사용자 이름(`userName`)과 이메일(`userEmail`) 정보를 저장합니다. 세션은 브라우저가 켜져 있는 동안 사용자의 로그인 상태를 유지하는 역할을 합니다.
        *   `index.jsp` 메인 페이지로 이동합니다.
    5.  **로그인 실패 시:**
        *   `errorMessage`를 `request` 속성에 담아 다시 `login.jsp`로 포워드하여 오류 메시지를 표시합니다.

---

### 3. 로그아웃 기능 (Logout)

세션에 저장된 사용자 정보를 삭제하여 로그인 상태를 해제하는 기능입니다.

*   **사용된 파일 및 코드 변경:**
    *   `index.jsp`: 'Logout' 링크의 `href` 속성을 `logout.do`로 수정했습니다.
        ```html
        <a href="logout.do" class="btn btn-outline">Logout</a>
        ```
    *   `MemberController.java`: `doGet()` 메소드 내에 `logout.do` 요청을 처리하는 로직(`memberLogout` 메소드 호출)을 추가했습니다.
        ```java
        // doGet() 메소드 내부
        else if ("logout.do".equals(command)) {
            memberLogout(request, response); // 로그아웃 처리 메소드 호출
            response.sendRedirect("login.jsp"); // 로그인 페이지로 이동
        }
        ```
*   **동작 방식:**
    1.  사용자가 'Logout' 링크를 클릭합니다.
    2.  `logout.do` 요청이 `MemberController`로 전달됩니다.
    3.  `MemberController`는 `request.getSession().invalidate()` 코드를 호출하여 현재 사용자의 세션 정보를 완전히 삭제합니다.
    4.  로그인 페이지(`login.jsp`)로 이동합니다.

---

### 4. 로그인 상태에 따른 UI 변경 (index.jsp)

메인 페이지(`index.jsp`)에서 사용자의 로그인 여부에 따라 다른 UI를 보여주도록 수정했습니다.

*   **사용된 파일 및 코드 변경:**
    *   `index.jsp`: JSTL(JSP Standard Tag Library)의 `<c:choose>` 태그와 `sessionScope`를 활용하여 로그인 상태를 확인하는 로직을 추가했습니다.
        ```jsp
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${not empty sessionScope.userName}">
                    <!-- 로그인된 경우: 환영 메시지와 로그아웃 버튼 표시 -->
                    <span style="color:white; margin-right: 15px;">환영합니다, ${sessionScope.userName}님!</span>
                    <a href="logout.do" class="btn btn-outline">Logout</a>
                </c:when>
                <c:otherwise>
                    <!-- 로그인되지 않은 경우: 로그인/회원가입 버튼 표시 -->
                    <a href="login.jsp" class="btn btn-outline">Login</a>
                    <a href="signup.jsp" class="btn btn-fill">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
        ```
*   **동작 방식:**
    *   `index.jsp` 페이지가 로드될 때, 세션(`sessionScope`)에 `userName` 정보가 있는지 확인합니다.
    *   `userName` 정보가 있으면 "환영합니다, [사용자 이름]님!" 메시지와 'Logout' 버튼을 보여줍니다.
    *   `userName` 정보가 없으면 'Login', 'Sign Up' 버튼을 보여줍니다.

---

### 기타 수정 사항

*   `DBConnection.java`: MySQL 데이터베이스의 비밀번호를 `""` (빈 문자열)로 변경했습니다.
*   `web.xml`: `@WebServlet` 어노테이션 기반 서블릿 매핑을 선호하셔서, 이전에 생성했던 `web.xml` 파일은 삭제했습니다.
*   `MainController.java` & `SpotifyService.java`: 코드 내에 포함되어 있던 이모지(`🚨`, `✅`, `❌`, `⚠️`)를 제거하여 잠재적인 인코딩 문제를 방지했습니다.
*   `Servers/Tomcat v10.1 Server at localhost-config/server.xml`: `Multiple Contexts` 오류를 해결하기 위해 중복된 `<Context>` 항목을 제거했습니다.

이 문서가 코드 리뷰에 도움이 되기를 바랍니다.

---

# 플레이리스트 코드 리뷰

## 1. 개요
사용자가 자신만의 플레이리스트를 생성하고, 노래 상세 페이지에서 원하는 노래를 플레이리스트에 추가할 수 있는 기능을 구현했습니다. 이 문서는 해당 기능의 기술적인 구현 사항과 설계 결정에 대한 요약을 제공합니다.

---

## 2. 데이터베이스 변경 사항
기능을 지원하기 위해 `playlists`와 `playlist_songs` 두 개의 새로운 테이블이 추가되었습니다.

**- `Schema Definition`**
```sql
-- 사용자의 플레이리스트 정보를 저장하는 테이블
CREATE TABLE playlists (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 'members' 테이블의 사용자가 삭제될 경우, 해당 사용자의 플레이리스트도 함께 삭제됩니다.
    FOREIGN KEY (user_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 플레이리스트와 노래의 관계를 저장하는 중간 테이블 (다대다 관계)
CREATE TABLE playlist_songs (
    playlist_song_id INT AUTO_INCREMENT PRIMARY KEY,
    playlist_id INT NOT NULL,
    track_spotify_id VARCHAR(255) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 'playlists' 테이블의 플레이리스트가 삭제될 경우, 포함된 노래 목록도 함께 삭제됩니다.
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    -- 한 플레이리스트 안에 동일한 노래가 중복으로 추가되는 것을 방지합니다.
    UNIQUE KEY (playlist_id, track_spotify_id)
);
```

**- `Code Review`**
- **Data Integrity**: `FOREIGN KEY` 제약 조건에 `ON DELETE CASCADE`를 적용하여 데이터의 일관성을 유지했습니다. 예를 들어, 사용자가 탈퇴하면 해당 사용자의 모든 플레이리스트가 자동으로 삭제됩니다.
- **Preventing Duplicates**: `playlist_songs` 테이블에 `UNIQUE KEY`를 설정하여 한 플레이리스트에 같은 곡이 여러 번 추가되는 것을 방지했습니다. 이는 데이터의 정합성을 높이고 예상치 못한 동작을 줄여줍니다.

---

## 3. 백엔드 변경 사항 (`/src/main/java`)

### 3.1. DTO (Data Transfer Object)
- **`songData/PlaylistDTO.java`**: `playlists` 테이블의 데이터를 객체로 표현하기 위해 `PlaylistDTO`를 추가했습니다. 이는 계층 간 데이터 전송의 표준적인 방법을 따릅니다.
  - **`songCount` 필드 추가**: 플레이리스트에 포함된 곡의 개수를 저장하기 위해 `private int songCount;` 필드와 해당 getter/setter를 추가했습니다. 이 필드는 데이터베이스 컬럼이 아닌, 조회 시점에 계산되어 `PlaylistDTO` 객체에 담기는 정보를 위한 것입니다.

### 3.2. DAO (Data Access Object)
- **`userData/PlaylistDAO.java`**: 플레이리스트 관련 데이터베이스 작업을 전담하는 `PlaylistDAO`를 구현했습니다.
- **`Code Review`**:
  - **Connection Management**: `DBConnection`을 사용하고 모든 SQL 작업에 `try-with-resources` 구문을 적용하여, 사용이 끝난 `Connection`과 `PreparedStatement`가 자동으로 해제되도록 구현했습니다. 이는 리소스 누수를 방지하는 필수적인 패턴입니다.
  - **Error Handling**: `addSongToPlaylist` 메소드에서 `SQLException`의 `getErrorCode()`를 확인하여, 노래 중복 추가 시 발생하는 예외(MySQL의 1062 코드)를 명시적으로 처리했습니다. 이는 일반적인 DB 오류와 비즈니스 로직 상의 예외(중복)를 구분하여 더 나은 피드백을 제공합니다.
  - **`songCount` 계산 로직 추가**: `getPlaylistsByUserId` 메서드의 SQL 쿼리를 `LEFT JOIN`과 `COUNT(ps.track_spotify_id)`를 활용하여 각 플레이리스트의 곡 수를 함께 가져오도록 수정했습니다. 이는 `PlaylistDTO`의 `songCount` 필드를 채웁니다.
  - **`getPlaylistById` 메서드 추가**: 특정 `playlist_id`로 단일 플레이리스트 정보를 조회하는 메서드를 추가했습니다. 이 메서드 또한 `songCount`를 계산하여 반환합니다.
  - **`getTrackSpotifyIdsByPlaylistId` 메서드 명확화**: 기존 `getTrackIdsByPlaylistId` 메서드의 이름을 `getTrackSpotifyIdsByPlaylistId`로 변경하여, 반환되는 ID가 Spotify ID임을 명확히 했습니다.

### 3.3. Controller (Servlet)
- **`songData/MainController.java`**:
  - **`TrackDTO` 타입 확인**: "TrackDTO cannot be resolved" 오류 발생 시, 빌드 경로 문제를 외부적으로 해결하고 `MainController` 내 `TrackDTO` 참조가 올바르게 작동함을 확인했습니다. (코드 수정은 없었음)
- **`userData/MemberController.java`**:
  - **매핑 충돌 해결**: `MemberController`의 `@WebServlet("*.do")` 매핑을 `MainController`와 중복되지 않도록 명시적인 URL 패턴 목록으로 변경했습니다. 이는 라우팅 충돌을 방지하고 각 서블릿이 의도된 요청만 처리하도록 보장합니다.
  - **`discover.do` 처리 제거**: `MainController`가 `discover.do`를 담당하게 되면서, `MemberController`의 `doGet` 메소드에서 `case "discover.do":` 블록을 제거했습니다.
- **`songData/PlaylistController.java`**:
  - **`@WebServlet` 매핑 확장**: `@WebServlet` 어노테이션에 `"/myPlaylist.do"` 및 `"/playlistDetail.do"` 패턴을 추가하여, 플레이리스트 목록 및 상세 페이지 요청을 처리할 수 있도록 했습니다.
  - **`doGet` 메서드 로직 개선**:
    - `myPlaylist.do` 요청 시: 로그인 확인 후 `PlaylistDAO`를 통해 사용자 플레이리스트 목록을 가져와 `myPlaylists.jsp`로 포워딩합니다.
    - `playlistDetail.do` 요청 시: `playlistId`를 받아 `PlaylistDAO`를 통해 플레이리스트 상세 정보와 `PlaylistDAO.getTrackSpotifyIdsByPlaylistId`를 통해 Spotify 트랙 ID 목록을 가져옵니다. 이후 `SpotifyService.getTrackDetails(List<String>, String)`를 사용하여 트랙의 상세 정보를 가져온 후 `playlistDetail.jsp`로 포워딩합니다.
    - `playlist.do`는 기존처럼 JSON API 엔드포인트로 유지됩니다.
    - 로그인되지 않은 사용자가 플레이리스트 관련 페이지에 접근 시 `login.jsp`로 리다이렉트되도록 처리했습니다.

### 3.4. SpotifyService (API 연동)
- **`songData/SpotifyService.java`**:
  - **`getTrackDetails` 오버로드**: `List<String>` 형태의 트랙 ID 목록을 받아 여러 트랙의 상세 정보를 한 번에 가져오는 `public List<TrackDTO> getTrackDetails(List<String> trackIds, String accessToken)` 메서드를 추가했습니다. 이는 Spotify API의 `v1/tracks?ids=` 엔드포인트를 활용하여 단일 배치 요청으로 처리하며, 효율성을 높이고 타입 불일치 오류를 해결합니다.

---

## 4. 프론트엔드 변경 사항 (`/src/main/webapp`)

### 4.1. `index.jsp` (메인 페이지)
- **사이드바 "My Playlist" 링크 수정**: 사이드바의 "My Playlist" 링크(`href="#"`)를 JSTL `<c:choose>` 태그를 사용하여 로그인 상태에 따라 조건부로 연결되도록 변경했습니다. 로그인 시 `myPlaylist.do`로, 로그인하지 않은 경우 `login.jsp`로 리다이렉트됩니다.

### 4.2. `myPlaylists.jsp` (내 플레이리스트 목록 페이지)
- **페이지 생성**: 사용자 플레이리스트 목록을 표시하는 새로운 JSP 페이지를 생성했습니다. 이 페이지는 `PlaylistController`에서 전달받은 `playlists` 객체를 반복하여 각 플레이리스트의 커버 이미지(임시), 이름, 곡 수를 표시합니다.
- **`playlistDetail.do` 연결**: 각 플레이리스트 카드(`playlist-card`)를 `playlistDetail.do?playlistId=${playlist.playlist_id}`로 연결되는 클릭 가능한 링크로 만들었습니다. 이를 통해 사용자가 특정 플레이리스트를 클릭하여 상세 페이지로 이동할 수 있습니다.

### 4.3. `playlistDetail.jsp` (플레이리스트 상세 페이지)
- **페이지 생성**: 특정 플레이리스트의 상세 정보(이름, 곡 수, 생성일)와 해당 플레이리스트에 포함된 곡 목록을 표시하는 새로운 JSP 페이지를 생성했습니다.
- **곡 정보 표시**: `PlaylistController`에서 전달받은 `tracks` 객체(`List<TrackDTO>`)를 반복하여 각 곡의 앨범 이미지, 제목, 아티스트, 재생 시간 등을 표시합니다.
- **`songDetail.do` 연결**: 각 곡 아이템(`track-item`)을 `songDetail.do?id=${track.spotifyId}`로 연결되는 클릭 가능한 링크로 만들었습니다. 이를 통해 사용자가 플레이리스트 내의 특정 곡을 클릭하여 해당 곡의 상세 정보 모달을 열 수 있습니다.

### 4.4. `songDetail.jsp` (곡 정보 상세 모달)
- **`playlistDetail.jsp`와의 연동**: `playlistDetail.jsp`에서 곡을 클릭하면 `songDetail.do?id=<spotifyId>`로 이동하도록 연결되었습니다. `SongDetailController`는 이 요청을 받아 `songDetail.jsp`를 렌더링하며, 이는 모달 형태로 곡 정보를 보여줍니다. `closeModal` 시 `window.history.back()`을 호출하여 이전 페이지로 돌아가는 동작은 유지됩니다.

---

## 5. 결론
이번 개선을 통해 사용자들은 자신만의 플레이리스트를 생성, 관리하고, 플레이리스트 내 곡 상세 정보까지 탐색할 수 있게 되었습니다. 서블릿 매핑 충돌 문제를 해결하여 시스템의 안정성을 높였으며, DTO, DAO, Controller, JSP 계층 전반에 걸쳐 기능을 확장하고 상호 연동성을 확보했습니다. 특히 Spotify API의 배치 요청 처리를 통해 여러 곡의 정보를 효율적으로 가져올 수 있도록 개선했습니다.

향후 플레이리스트 관리 기능(수정, 삭제) 및 곡 추가/삭제 UI/UX 개선을 통해 사용자 편의성을 더욱 높일 수 있을 것입니다.