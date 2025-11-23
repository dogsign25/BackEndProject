# 로그인 및 회원가입 기능 구현 요약

이 문서에서는 Gemini 에이전트가 `BackEndProject`에 로그인 및 회원가입 기능을 구현하고 관련 UI를 연동한 내역을 정리합니다.

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
