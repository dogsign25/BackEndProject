### 좋아요 기능 구현 및 통합 변경점 요약

**날짜:** 2025년 12월 8일

**개요:**
사용자가 노래에 '좋아요'를 표시하고 취소할 수 있는 기능을 구현하고, 이를 `index.jsp`, `discover.jsp`, `songDetail.jsp` 페이지에 통합했습니다. 초기 '좋아요' 상태 표시, 아이콘 변경 및 호버 효과를 포함하며, 기존 `songDetail.jsp`의 '좋아요' 기능과 충돌하지 않도록 통합했습니다. 외부 라이브러리(Gson) 추가 없이 순수 Java 및 JavaScript로 구현되었습니다.

---

#### **변경 파일 및 내용:**

1.  **`MainUIsample/src/main/java/songData/MainController.java`**
    *   `LikedSongDAO` 인스턴스를 추가하고 `init()` 메서드에서 초기화했습니다.
    *   `doGet()` 메서드에서 로그인한 사용자의 '좋아요' 곡 ID 목록(`likedSpotifyIds`)을 가져왔습니다.
    *   `likedSpotifyIds` `Set`을 수동으로 JSON 문자열(`likedSpotifyIdsJson`)로 변환하여 `HttpServletRequest` 속성으로 추가했습니다.
    *   이전에 포함되었던 `Gson` 라이브러리 `import` 문 및 관련 인스턴스를 제거했습니다.

2.  **`MainUIsample/src/main/java/songData/LikedSongsController.java`**
    *   `@WebServlet` 어노테이션에 `/likeSong.do` 경로를 추가하여 '좋아요' 토글 요청을 처리할 수 있도록 했습니다.
    *   기존 `doPost()` 메서드를 `handleLikeSong()` 로직으로 대체했습니다.
    *   `handleLikeSong()`은 `/likeSong.do`로 들어오는 JSON `POST` 요청을 처리하며, 현재 '좋아요' 상태에 따라 `LikedSongDAO.addLikedSong()` 또는 `LikedSongDAO.removeLikedSong()`을 호출하여 상태를 토글합니다.
    *   작업 성공/실패 및 새로운 '좋아요' 상태를 나타내는 JSON 응답을 반환합니다.
    *   JSON 요청 본문을 읽기 위한 헬퍼 메서드 `readJsonBody()`를 추가했습니다.

3.  **`MainUIsample/src/main/java/songData/SongDetailController.java`**
    *   `LikedSongDAO` 인스턴스를 추가하고 `init()` 메서드에서 초기화했습니다.
    *   `doGet()` 메서드에서 로그인한 사용자의 '좋아요' 곡 ID 목록(`likedSpotifyIds`)을 가져왔습니다.
    *   `likedSpotifyIds` `Set`을 수동으로 JSON 문자열(`likedSpotifyIdsJson`)로 변환하여 `HttpServletRequest` 속성으로 추가했습니다.

4.  **`MainUIsample/src/main/webapp/WEB-INF/views/mainUI/index.jsp`**
    *   **HTML 구조 변경**: `.song-card-item` 내부의 `.song-card-content`와 `.like-icon-wrapper`를 `position: relative; width: 100%;` 스타일이 적용된 새 `div`로 감싸 아이콘의 위치 기준을 명확히 했습니다.
    *   이전 '좋아요' 아이콘(버튼 또는 플레이스홀더)을 `<img>` 태그로 교체했습니다.
    *   `<img>` 태그의 `src` 및 `class`는 `likedSpotifyIds`를 기반으로 동적으로 설정되어 초기 '좋아요' 상태를 반영합니다.
    *   `<head>` 안에 인라인 `<style>` 블록을 추가하여 `.like-icon`의 크기(`width: 20px !important; height: 20px !important; object-fit: contain !important;`)와 호버 효과(`transition`, `transform: scale(1.1);`)를 강제로 적용했습니다.
    *   `likeSong` JavaScript 함수를 `JSON.parse('${likedSpotifyIdsJson}')`를 사용하여 `likedSpotifyIdsClient`를 초기화하고, '좋아요' 상태에 따라 `<img>` `src` 속성을 동적으로 변경하도록 업데이트했습니다.

5.  **`MainUIsample/src/main/webapp/WEB-INF/views/mainUI/discover.jsp`**
    *   `index.jsp`와 동일하게 HTML 구조 변경 및 `<img>` 태그 아이콘 교체가 적용되었습니다.
    *   `index.jsp`와 동일하게 인라인 `<style>` 블록이 추가되어 아이콘 크기 및 호버 효과를 제어합니다.
    *   `index.jsp`와 동일하게 `likeSong` JavaScript 함수가 업데이트되었습니다.

6.  **`MainUIsample/src/main/webapp/WEB-INF/views/song/songDetail.jsp`**
    *   `<head>` 안에 인라인 `<style>` 블록을 추가하여 `.like-icon`의 크기(`width: 20px !important; height: 20px !important; object-fit: contain !important;`)와 호버 효과(`transition`, `transform: scale(1.1);`)를 강제로 적용했습니다.
    *   기존 '좋아요' `<button id="toggleLikeButton" ...>`을 `<div>`로 감싸진 `<img>` 태그 아이콘으로 교체했습니다. 이 `<img>` 태그는 `likedSpotifyIds`를 기반으로 `src` 및 `class`가 동적으로 설정되며, 통합된 `likeSong()` 함수를 호출합니다.
    *   기존의 '좋아요' 관련 JavaScript 코드(예: `checkLikeStatus`, `updateLikeButton`, `toggleLike` 함수 및 `DOMContentLoaded` 이벤트 리스너)를 모두 삭제하고, 재생 목록 및 앨범 아트 관련 로직을 보존하면서 새로운 통합 `likeSong` 함수와 `likedSpotifyIdsClient` 초기화 코드를 포함하는 `<script>` 블록으로 교체했습니다.

7.  **`MainUIsample/src/main/webapp/style.css`**
    *   이전에 추가되었으나 현재는 사용되지 않는 `.like-icon`, `.like-icon-wrapper`, `.row-col-like` 관련 CSS 규칙들을 모두 제거하여 스타일시트를 정리했습니다.