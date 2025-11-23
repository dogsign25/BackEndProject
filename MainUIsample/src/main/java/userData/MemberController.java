package userData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

/**
 * 회원 관리 컨트롤러
 * *.do 패턴으로 모든 회원 관련 요청 처리
 */
@WebServlet("*.do")
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    /**
     * Servlet 초기화
     * 서블릿이 처음 로드될 때 한 번만 실행
     */
    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
        System.out.println("MemberController initialized.");
    }
    
    /**
     * GET 방식 요청 처리
     * 주로 조회(SELECT) 작업에 사용
     * - 회원 목록 조회
     * - 회원 상세 조회
     * - 폼 화면 표시
     * - 회원 삭제 (RESTful하게는 DELETE지만 간단하게 GET 사용)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // URL에서 명령어 추출
        // 예: /MainUIsample/memberList.do → memberList.do
        String uri = request.getRequestURI();
        String command = uri.substring(uri.lastIndexOf("/") + 1);
        
        System.out.println("GET 요청: " + command); // 디버깅용
        
        String viewPage = null; // 이동할 JSP 페이지
        
        try {
            // 명령어에 따라 분기 처리
            if ("memberList.do".equals(command)) {
                // 회원 목록 조회
                viewPage = memberList(request, response);
                // JSP로 포워드 (데이터 전달)
                request.getRequestDispatcher(viewPage).forward(request, response);
                
            } else if ("memberView.do".equals(command)) {
                // 회원 상세 조회
                viewPage = memberView(request, response);
                request.getRequestDispatcher(viewPage).forward(request, response);
                
            } else if ("memberInsertForm.do".equals(command)) {
                // 회원 추가 폼 (데이터 조회 없이 바로 JSP 표시)
                viewPage = "memberForm.jsp";
                request.getRequestDispatcher(viewPage).forward(request, response);
                
            } else if ("memberUpdateForm.do".equals(command)) {
                // 회원 수정 폼 (기존 데이터 조회 후 JSP 표시)
                viewPage = memberUpdateForm(request, response);
                request.getRequestDispatcher(viewPage).forward(request, response);
                
            } else if ("memberDelete.do".equals(command)) {
                // 회원 삭제 후 목록으로 리다이렉트
                memberDelete(request, response);
                response.sendRedirect("memberList.do");
            } else if ("login.do".equals(command)) {
                viewPage = "login.jsp";
                request.getRequestDispatcher(viewPage).forward(request, response);
            } else if ("signupForm.do".equals(command)) {
                viewPage = "signup.jsp";
                request.getRequestDispatcher(viewPage).forward(request, response);
            } else if ("logout.do".equals(command)) {
                // 로그아웃 처리
                memberLogout(request, response);
                response.sendRedirect("login.do");
            }
            else if ("myPage.do".equals(command)) {
                // 마이페이지 조회
            	viewPage = memberMyPage(request, response);
            	request.getRequestDispatcher(viewPage).forward(request, response);
            }
            
        } catch (Exception e) {
            // 예외 발생 시 에러 페이지로 이동
            e.printStackTrace();
            System.err.println("에러 발생: " + e.getMessage());
            request.setAttribute("errorMsg", "처리 중 오류가 발생했습니다: " + e.getMessage());
            
            // error.jsp가 있으면 그쪽으로, 없으면 memberManage.jsp로
            try {
                request.getRequestDispatcher("error.jsp").forward(request, response);
            } catch (Exception ex) {
                request.getRequestDispatcher("memberManage.jsp").forward(request, response);
            }
        }
    }
    
    /**
     * POST 방식 요청 처리
     * 주로 데이터 변경(INSERT, UPDATE, DELETE) 작업에 사용
     * - 회원 추가
     * - 회원 수정
     * - 대량 작업
     */
    private String memberMyPage(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String userName = (String) session.getAttribute("userName");
        
        if (userEmail != null) {
            // MemberDAO에 이메일로 회원 정보를 조회하는 메서드가 있다고 가정
            MemberDTO member = memberDAO.getMemberByEmail(userEmail);
            
            if (member == null) {
                 // DB에서 조회 실패 시 myPage.jsp 테스트를 위한 임시 가상 객체 생성
                member = new MemberDTO();
                member.setId(1);
                member.setName(userName != null ? userName : "테스트사용자"); 
                member.setEmail(userEmail);
                member.setPhone("010-1234-5678");
                member.setBirthdate("1995-01-01"); 
                member.setType("premium"); 
                member.setStatus("active");
                member.setJoinDate(new Date(System.currentTimeMillis() - 86400000L * 30)); 
                member.setLastLogin(new Date()); 
            }
            
            request.setAttribute("member", member);
            
        } else {
            // 세션 정보가 없는 경우: member 객체를 request에 담지 않음. 
            // myPage.jsp에서 ${empty member}로 처리되어 로그인 유도 화면 표시됨.
        }
        
        return "myPage.jsp";
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 한글 인코딩 설정 (POST는 body에 데이터가 있어서 필수!)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // URL에서 명령어 추출
        String uri = request.getRequestURI();
        String command = uri.substring(uri.lastIndexOf("/") + 1);
        
        System.out.println("POST 요청: " + command); // 디버깅용
        
        try {
            if ("memberInsert.do".equals(command)) {
                // 회원 추가 처리 후 목록으로 리다이렉트
                memberInsert(request, response);
                response.sendRedirect("memberList.do");
                
            } else if ("memberUpdate.do".equals(command)) {
                // 회원 수정 처리 후 목록으로 리다이렉트
                memberUpdate(request, response);
                response.sendRedirect("memberList.do");
                
            } else if ("memberBulkAction.do".equals(command)) {
                // 대량 작업 처리 후 목록으로 리다이렉트
                memberBulkAction(request, response);
                response.sendRedirect("memberList.do");
            } else if ("login.do".equals(command)) {
                // 로그인 처리
                memberLogin(request, response);

            } else if ("signup.do".equals(command)) {
                // 회원가입 처리
                memberSignup(request, response);
                response.sendRedirect("login.do");
            }
            
        } catch (Exception e) {
            // 예외 발생 시 세션에 에러 메시지 저장 후 목록으로 리다이렉트
            e.printStackTrace();
            System.err.println("에러 발생: " + e.getMessage());
            request.getSession().setAttribute("msg", "처리 중 오류가 발생했습니다: " + e.getMessage());
            response.sendRedirect("memberList.do");
        }
    }
    
    // ==================== 각 기능별 메소드 ====================

    /**
     * 로그아웃 처리
     */
    private void memberLogout(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().invalidate();
    }

    /**
     * 회원가입 처리
     */
    private void memberSignup(HttpServletRequest request, HttpServletResponse response) throws SQLException {
        MemberDTO member = new MemberDTO();
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPassword(request.getParameter("password")); // 암호화 필요
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        member.setType("free");
        member.setStatus("active");
        
        memberDAO.insertMember(member);
    }
    
    /**
     * 로그인 처리
     */
    private void memberLogin(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        MemberDTO member = memberDAO.checkLogin(email, password);
        
        if (member != null) {
            // 로그인 성공
            request.getSession().setAttribute("userName", member.getName());
            request.getSession().setAttribute("userEmail", member.getEmail());
            
            // last_login 업데이트 (추가 기능)
            // memberDAO.updateLastLogin(member.getId()); 
            
            response.sendRedirect("index.jsp");
        } else {
            // 로그인 실패
            request.setAttribute("errorMessage", "이메일 또는 비밀번호가 올바르지 않습니다.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    /**
     * 회원 목록 조회
     * @param request  검색/필터 파라미터 포함
     * @param response 응답 객체
     * @return JSP 페이지 경로
     */
    private String memberList(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        System.out.println("memberList 메소드 실행");
        
        // 파라미터 받기 (검색어, 필터, 정렬)
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        String sort = request.getParameter("sort");
        
        System.out.println("파라미터 - search: " + search + ", status: " + status + 
                          ", type: " + type + ", sort: " + sort);
        
        // 기본값 설정 (파라미터가 없을 경우)
        if (status == null || status.isEmpty()) status = "all";
        if (type == null || type.isEmpty()) type = "all";
        if (sort == null || sort.isEmpty()) sort = "newest";
        
        // DAO를 통해 DB에서 데이터 조회
        List<MemberDTO> members = memberDAO.getAllMembers(search, status, type, sort);
        MemberStats stats = memberDAO.getStatistics();
        
        System.out.println("조회된 회원 수: " + (members != null ? members.size() : 0));
        System.out.println("통계 정보: " + stats);
        
        // request에 데이터 저장 (JSP에서 ${members}로 접근 가능)
        request.setAttribute("members", members);
        request.setAttribute("stats", stats);
        
        // JSP 페이지 경로 반환
        return "memberManage.jsp";
    }
    
    /**
     * 회원 상세 조회
     * @param request  id 파라미터 포함
     * @param response 응답 객체
     * @return JSP 페이지 경로
     */
    private String memberView(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        // URL 파라미터에서 회원 ID 받기
        // 예: memberView.do?id=5
        int id = Integer.parseInt(request.getParameter("id"));
        
        // DAO를 통해 특정 회원 조회
        MemberDTO member = memberDAO.getMemberById(id);
        
        // request에 데이터 저장
        request.setAttribute("member", member);
        
        return "memberView.jsp";
    }
    
    /**
     * 회원 수정 폼 표시
     * 기존 데이터를 조회해서 폼에 채워넣기 위함
     */
    private String memberUpdateForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        MemberDTO member = memberDAO.getMemberById(id);
        
        // request에 기존 회원 데이터 저장
        // JSP에서 ${member.name} 등으로 접근하여 폼에 표시
        request.setAttribute("member", member);
        
        return "memberUpdateForm.jsp";
    }
    
    /**
     * 회원 추가 처리
     * 폼에서 입력한 데이터를 받아서 DB에 INSERT
     */
    private void memberInsert(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        // Member 객체 생성
        MemberDTO member = new MemberDTO();
        
        // 폼에서 전송된 파라미터 받아서 객체에 저장
        // <input name="name"> → request.getParameter("name")
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        member.setType(request.getParameter("type"));
        member.setStatus(request.getParameter("status"));
        
        // DAO를 통해 DB에 INSERT
        int result = memberDAO.insertMember(member);
        
        // 결과 메시지를 세션에 저장
        // 세션에 저장하면 리다이렉트 후에도 메시지 유지됨
        if (result > 0) {
            request.getSession().setAttribute("msg", "회원이 추가되었습니다.");
        } else {
            request.getSession().setAttribute("msg", "회원 추가에 실패했습니다.");
        }
    }
    
    /**
     * 회원 수정 처리
     * 폼에서 수정한 데이터를 받아서 DB에 UPDATE
     */
    private void memberUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        MemberDTO member = new MemberDTO();
        
        // hidden input으로 전송된 id와 수정된 데이터 받기
        member.setId(Integer.parseInt(request.getParameter("id")));
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        member.setType(request.getParameter("type"));
        member.setStatus(request.getParameter("status"));
        
        // DAO를 통해 DB에 UPDATE
        int result = memberDAO.updateMember(member);
        
        if (result > 0) {
            request.getSession().setAttribute("msg", "회원 정보가 수정되었습니다.");
        } else {
            request.getSession().setAttribute("msg", "회원 수정에 실패했습니다.");
        }
    }
    
    /**
     * 회원 삭제 처리
     * URL 파라미터로 받은 id로 DB에서 DELETE
     */
    private void memberDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        // 삭제할 회원 ID
        int id = Integer.parseInt(request.getParameter("id"));
        
        // DAO를 통해 DB에서 DELETE
        int result = memberDAO.deleteMember(id);
        
        if (result > 0) {
            request.getSession().setAttribute("msg", "회원이 삭제되었습니다.");
        } else {
            request.getSession().setAttribute("msg", "회원 삭제에 실패했습니다.");
        }
    }
    
    /**
     * 대량 작업 처리
     * 여러 회원을 선택해서 일괄 처리 (활성화/정지/삭제)
     */
    private void memberBulkAction(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        // 작업 유형 (activate, suspend, delete)
        String action = request.getParameter("action");
        
        // 체크박스로 선택된 회원 ID들
        // <input type="checkbox" name="memberIds" value="1">
        // <input type="checkbox" name="memberIds" value="2">
        // → ["1", "2"]
        String[] ids = request.getParameterValues("memberIds");
        
        // 선택된 회원이 없으면 종료
        if (ids == null || ids.length == 0) {
            request.getSession().setAttribute("msg", "선택된 회원이 없습니다.");
            return;
        }
        
        // String 배열을 int 배열로 변환
        int[] memberIds = new int[ids.length];
        for (int i = 0; i < ids.length; i++) {
            memberIds[i] = Integer.parseInt(ids[i]);
        }
        
        // DAO를 통해 대량 작업 실행
        int result = memberDAO.bulkAction(action, memberIds);
        
        if (result > 0) {
            request.getSession().setAttribute("msg", result + "명의 회원이 처리되었습니다.");
        } else {
            request.getSession().setAttribute("msg", "작업에 실패했습니다.");
        }
    }
    
    /**
     * Servlet 종료 시 실행
     * 리소스 정리 작업
     */
    @Override
    public void destroy() {
        System.out.println("MemberController destroyed.");
    }
}