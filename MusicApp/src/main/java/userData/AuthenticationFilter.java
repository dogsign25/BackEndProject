package userData;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("*.do")
public class AuthenticationFilter implements Filter {

    // 로그인 없이 접근 가능한 URL 목록
    // 필터에서 제외할 경로들을 여기에 추가
    private static final List<String> publicUrls = Arrays.asList(
            "/loginForm.do",    // 로그인 폼 페이지
            "/login.do",        // 로그인 처리
            "/signupForm.do",   // 회원가입 폼 페이지
            "/signup.do",       // 회원가입 처리
            "/index.do",        // 메인 페이지
            "/discover.do",     // 탐색 페이지
            "/search.do",       // 검색 페이지
            "/albumDetail.do",  // 앨범 상세 페이지
            "/error.jsp",       // 에러 페이지
            "/style.css"        // CSS 파일
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화 시 필요한 작업 (현재는 없음)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // 세션이 없으면 새로 생성하지 않음

        String requestURI = httpRequest.getRequestURI();
        // 컨텍스트 경로 제거 (예: /MainUIsample/index.do -> /index.do)
        String contextPath = httpRequest.getContextPath();
        if (contextPath != null && !contextPath.isEmpty()) {
            requestURI = requestURI.substring(contextPath.length());
        }

        // 정적 자원 (CSS, JS, 이미지 등) 경로는 필터링 제외
        if (requestURI.startsWith("/assets/") || requestURI.startsWith("/webjars/") || requestURI.equals("/favicon.ico")) {
            chain.doFilter(request, response);
            return;
        }

        // publicUrls 목록에 있는 경로는 필터링 제외
        if (publicUrls.contains(requestURI)) {
            chain.doFilter(request, response);
            return;
        }

        // 세션이 없거나 userId가 없는 경우 (로그인되지 않은 경우)
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("AuthenticationFilter: Unauthenticated access to " + requestURI + ". Redirecting to login.");
            httpResponse.sendRedirect(contextPath + "/loginForm.do"); // 로그인 폼으로 리다이렉트
            return;
        }

        // 로그인된 사용자이거나 publicUrls에 해당하는 경우, 다음 필터 또는 서블릿으로 요청 전달
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 필터 종료 시 필요한 작업 (현재는 없음)
    }
}
