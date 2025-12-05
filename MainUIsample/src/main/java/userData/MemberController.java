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
    "/login.do", "/signup.do", "/admin/memberInsert.do", "/admin/memberUpdate.do", "/admin/memberBulkAction.do",
    "/memberUpdate.do", "/memberUpdateForm.do"  // 일반 사용자용 경로 추가
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
                    if (!checkAdmin(request, response)) return;
                    memberList(request, response);
                    break;
                    
                case "/admin/memberView.do":
                    if (!checkAdmin(request, response)) return;
                    memberView(request, response);
                    break;
                    
                case "/admin/memberInsertForm.do":
                    if (!checkAdmin(request, response)) return;
                    request.getRequestDispatcher("/WEB-INF/views/admin/memberForm.jsp").forward(request, response);
                    break;
                    
                case "/admin/memberUpdateForm.do":
                    if (!checkAdmin(request, response)) return;
                    memberUpdateForm(request, response);
                    break;
                    
                case "/memberUpdateForm.do":
                    // 일반 사용자용 정보수정 폼
                    if (!checkLogin(request, response)) return;
                    userUpdateForm(request, response);
                    break;
                    
                case "/admin/memberDelete.do":
                    if (!checkAdmin(request, response)) return;
                    memberDelete(request, response);
                    response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
                    break;
                    
                case "/loginForm.do":
                    request.getRequestDispatcher("/WEB-INF/views/mainUI/login.jsp").forward(request, response);
                    break;
                    
                case "/signupForm.do":
                    request.getRequestDispatcher("/WEB-INF/views/mainUI/signup.jsp").forward(request, response);
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
                    if (!checkAdmin(request, response)) return;
                    MemberDTO member = createMemberFromRequest(request);
                    try {
                        memberDAO.insertMember(member);
                        setSessionMessage(request, member.getName() + " 님의 회원 등록이 완료되었습니다.");
                        response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
                    } catch (SQLException e) {
                        e.printStackTrace();
                        String errorMessage = "회원 등록 실패: 데이터베이스 오류가 발생했습니다. (" + e.getMessage() + ")";
                        setSessionMessage(request, errorMessage);
                        response.sendRedirect(request.getContextPath() + "/admin/memberInsertForm.do");
                    }
                    break;
                    
                case "/admin/memberUpdate.do":
                    if (!checkAdmin(request, response)) return;
                    memberUpdate(request, response);
                    response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
                    break;
                    
                case "/memberUpdate.do":
                    // 일반 사용자용 정보수정 처리
                    if (!checkLogin(request, response)) return;
                    userUpdate(request, response);
                    break;
                    
                case "/admin/memberBulkAction.do":
                    if (!checkAdmin(request, response)) return;
                    memberBulkAction(request, response);
                    response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
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
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = uri.substring(contextPath.length());
        
        if (!command.startsWith("/")) {
            command = "/" + command;
        }
        
        System.out.println("[DEBUG] URI: " + uri + " -> Command: " + command);
        return command;
    }
    
    /**
     * 관리자 권한 체크
     */
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userType") == null) {
            response.sendRedirect(request.getContextPath() + "/loginForm.do");
            return false;
        }
        
        String userType = (String) session.getAttribute("userType");
        if (!"admin".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/index.do");
            return false;
        }
        
        return true;
    }
    
    /**
     * 로그인 여부 체크 (일반 사용자용)
     */
    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/loginForm.do");
            return false;
        }
        
        return true;
    }
    
    private void handleException(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("errorMsg", "Error: " + e.getMessage());
        request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
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
        request.getRequestDispatcher("/WEB-INF/views/admin/memberManage.jsp").forward(request, response);
    }
    
    private void memberView(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        MemberDTO member = memberDAO.getMemberById(id);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/WEB-INF/views/admin/memberView.jsp").forward(request, response);
    }
    
    private void memberUpdateForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        MemberDTO member = memberDAO.getMemberById(id);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/WEB-INF/views/admin/memberUpdateForm.jsp").forward(request, response);
    }
    
    /**
     * 일반 사용자용 정보수정 폼
     */
    private void userUpdateForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        
        MemberDTO member = memberDAO.getMemberById(userId);
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/WEB-INF/views/mainUI/memberUpdateForm.jsp").forward(request, response);
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
    
    /**
     * 일반 사용자용 정보수정 처리
     */
    private void userUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        
        MemberDTO member = new MemberDTO();
        member.setId(userId);
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        member.setBirthdate(request.getParameter("birthdate"));
        
        // 일반 사용자는 type과 status를 변경할 수 없음
        MemberDTO currentMember = memberDAO.getMemberById(userId);
        member.setType(currentMember.getType());
        member.setStatus(currentMember.getStatus());
        
        int result = memberDAO.updateMember(member);
        
        if (result > 0) {
            // 세션 정보도 업데이트
            session.setAttribute("userName", member.getName());
            session.setAttribute("userEmail", member.getEmail());
            setSessionMessage(request, "정보가 성공적으로 수정되었습니다.");
        } else {
            setSessionMessage(request, "정보 수정에 실패했습니다.");
        }
        
        response.sendRedirect(request.getContextPath() + "/myPage.do");
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
            
            if ("admin".equals(member.getType())) {
                response.sendRedirect(request.getContextPath() + "/admin/memberList.do");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.do");
            }
        } else {
            System.out.println("[DEBUG] Login failed");
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/mainUI/login.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/loginForm.do");
        } else {
            request.setAttribute("errorMessage", "Signup failed");
            request.getRequestDispatcher("/WEB-INF/views/mainUI/signup.jsp").forward(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/loginForm.do");
    }
    
    private void myPage(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/loginForm.do");
            return;
        }
        
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userEmail != null) {
            MemberDTO member = memberDAO.getMemberByEmail(userEmail);
            request.setAttribute("member", member);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/mainUI/myPage.jsp").forward(request, response);
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