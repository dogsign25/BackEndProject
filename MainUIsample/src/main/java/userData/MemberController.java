package userData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet({
    "/admin/memberList.do", "/admin/memberView.do", "/admin/memberInsertForm.do", "/admin/memberUpdateForm.do",
    "/admin/memberDelete.do", "/loginForm.do", "/signupForm.do", "/logout.do", "/myPage.do",
    "/login.do", "/signup.do", "/admin/memberInsert.do", "/admin/memberUpdate.do", "/admin/memberBulkAction.do"
})
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
        System.out.println("[MemberController] Initialized successfully.");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String command = getCommand(request);
        
        System.out.println("[DEBUG] GET Request - Command: " + command);
        
        try {
            switch (command) {
                case "/admin/memberList.do":
                    // 관리자 체크
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    memberList(request, response);
                    break;
                    
                case "/admin/memberView.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    memberView(request, response);
                    break;
                    
                case "/admin/memberInsertForm.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    request.getRequestDispatcher("/admin/memberForm.jsp").forward(request, response);
                    break;
                    
                case "/admin/memberUpdateForm.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    memberUpdateForm(request, response);
                    break;
                    
                case "/admin/memberDelete.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    memberDelete(request, response);
                    response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
                    break;
                    
                case "/loginForm.do":
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    break;
                    
                case "/signupForm.do":
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    break;
                    
                case "/logout.do":
                    logout(request, response);
                    break;
                    
                case "/myPage.do":
                    myPage(request, response);
                    break;
                    
                default:
                    System.out.println("[DEBUG] Unknown command: " + command);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            handleException(request, response, e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String command = getCommand(request);
        
        System.out.println("[DEBUG] POST Request - Command: " + command);
        
        try {
            switch (command) {
                case "/login.do":
                    login(request, response);
                    break;
                    
                case "/signup.do":
                    signup(request, response);
                    break;
                    
                case "/admin/memberInsert.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    // 🚨 예외 처리 로직 추가
                    MemberDTO member = createMemberFromRequest(request);
                    try {
                        memberDAO.insertMember(member);
                        setSessionMessage(request, member.getName() + " 님의 회원 등록이 완료되었습니다.");
                        response.sendRedirect(request.getContextPath() + "/admin/memberList.do"); // 성공 시 리스트로 이동
                        
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // SQL 오류(예: 'password' null 또는 이메일 중복) 발생 시 
                        String errorMessage = "회원 등록 실패: 데이터베이스 오류가 발생했습니다. (" + e.getMessage() + ")";
                        setSessionMessage(request, errorMessage);
                        response.sendRedirect(request.getContextPath() + "/admin/memberInsertForm.do"); // 실패 시 폼으로 돌아가기
                        
                    }
                    break;
                    
                case "/admin/memberUpdate.do":
                    // myPage에서도 사용 가능하도록 수정
                    memberUpdate(request, response);
                    
                    // 관리자면 memberList로, 일반 사용자면 myPage로
                    HttpSession session = request.getSession();
                    String userType = (String) session.getAttribute("userType");
                    if ("admin".equals(userType)) {
                        response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
                    } else {
                        response.sendRedirect(request.getContextPath() +"myPage.do");
                    }
                    break;
                    
                case "/admin/memberBulkAction.do":
                    if (!checkAdmin(request, response)) {
                        return;
                    }
                    memberBulkAction(request, response);
                    response.sendRedirect(request.getContextPath()+"/admin/memberList.do");
                    break;
                    
                default:
                    System.out.println("[DEBUG] Unknown command: " + command);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            handleException(request, response, e);
        }
    }
    
    // ============ Helper Methods ============
    
    private String getCommand(HttpServletRequest request) {
        String uri = request.getRequestURI();          // 예: /MainUIsample/admin/memberList.do
        String contextPath = request.getContextPath(); // 예: /MainUIsample

        // Context Path를 제거하여 /admin/memberList.do 또는 /login.do 를 추출
        String command = uri.substring(contextPath.length()); 
        
        // Context Path가 없는 경우(예외적인 상황)를 제외하고 '/'로 시작하도록 보장
        if (!command.startsWith("/")) {
            command = "/" + command;
        }
        
        System.out.println("[DEBUG] URI: " + uri + " -> Command: " + command); // -> 이제 "/admin/memberList.do"가 출력됨
        return command;
    }
    /**
     * 관리자 권한 체크
     */
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userType") == null) {
            response.sendRedirect("loginForm.do");
            return false;
        }
        
        String userType = (String) session.getAttribute("userType");
        if (!"admin".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "index.do");
            return false;
        }
        
        return true;
    }
    
    private void handleException(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("errorMsg", "Error: " + e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
    
    // ============ Business Logic Methods ============
    
    private void memberList(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        System.out.println("[DEBUG] memberList() called");
        
        String search = request.getParameter("search");
        String status = getParameterOrDefault(request, "status", "all");
        String type = getParameterOrDefault(request, "type", "all");
        String sort = getParameterOrDefault(request, "sort", "newest");
        
        List<MemberDTO> members = memberDAO.getAllMembers(search, status, type, sort);
        MemberStats stats = memberDAO.getStatistics();
        
        System.out.println("[DEBUG] Members count: " + members.size());
        System.out.println("[DEBUG] Stats: " + stats);
        
        request.setAttribute("members", members);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/admin/memberManage.jsp").forward(request, response);
    }
    
    private void memberView(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        MemberDTO member = memberDAO.getMemberById(id);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/admin/memberView.jsp").forward(request, response);
    }
    
    private void memberUpdateForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        MemberDTO member = memberDAO.getMemberById(id);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/admin/memberUpdateForm.jsp").forward(request, response);
    }
    
    private void memberInsert(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        MemberDTO member = createMemberFromRequest(request);
        int result = memberDAO.insertMember(member);
        
        setSessionMessage(request, result > 0 
            ? "Member added successfully" 
            : "Failed to add member");
    }
    
    private void memberUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        MemberDTO member = createMemberFromRequest(request);
        member.setId(Integer.parseInt(request.getParameter("id")));
        
        int result = memberDAO.updateMember(member);
        
        setSessionMessage(request, result > 0 
            ? "Member updated successfully" 
            : "Failed to update member");
    }
    
    private void memberDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        int result = memberDAO.deleteMember(id);
        
        setSessionMessage(request, result > 0 
            ? "Member deleted successfully" 
            : "Failed to delete member");
    }
    
    private void memberBulkAction(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException {
        
        String action = request.getParameter("action");
        String[] ids = request.getParameterValues("memberIds");
        
        if (ids == null || ids.length == 0) {
            setSessionMessage(request, "No members selected");
            return;
        }
        
        int[] memberIds = Arrays.stream(ids)
                                 .mapToInt(Integer::parseInt)
                                 .toArray();
        
        int result = memberDAO.bulkAction(action, memberIds);
        
        setSessionMessage(request, result > 0 
            ? result + " members processed" 
            : "Bulk action failed");
    }
    
    // ============ Authentication Methods ============
    
    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("[DEBUG] Login attempt - Email: " + email);
        
        MemberDTO member = memberDAO.checkLogin(email, password);
        
        if (member != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userName", member.getName());
            session.setAttribute("userEmail", member.getEmail());
            session.setAttribute("userType", member.getType());
            session.setAttribute("userId", member.getId());
            
            System.out.println("[DEBUG] Login success - Type: " + member.getType());
            
            // 관리자면 대시보드로, 일반 사용자면 index로
            if ("admin".equals(member.getType())) {
                response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.do");
            }
        } else {
            System.out.println("[DEBUG] Login failed");
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void signup(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        
        MemberDTO member = new MemberDTO();
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPassword(request.getParameter("password"));
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        member.setType("free");
        member.setStatus("active");
        
        int result = memberDAO.insertMember(member);
        
        if (result > 0) {
            setSessionMessage(request, "Signup successful! Please login.");
            response.sendRedirect(request.getContextPath() +"loginForm.do");
        } else {
            request.setAttribute("errorMessage", "Signup failed");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() +"/loginForm.do");
    }
    
    private void myPage(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("loginForm.do");
            return;
        }
        
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userEmail != null) {
            MemberDTO member = memberDAO.getMemberByEmail(userEmail);
            request.setAttribute("member", member);
        }
        
        request.getRequestDispatcher("myPage.jsp").forward(request, response);
    }
    
    // ============ Utility Methods ============
    
    private MemberDTO createMemberFromRequest(HttpServletRequest request) {
        MemberDTO member = new MemberDTO();
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        member.setPassword(request.getParameter("password"));
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        
        member.setType(type != null ? type : "free");
        member.setStatus(status != null ? status : "active");
        
        return member;
    }
    
    private String getParameterOrDefault(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return (value == null || value.isEmpty()) ? defaultValue : value;
    }
    
    private void setSessionMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("msg", message);
    }
}