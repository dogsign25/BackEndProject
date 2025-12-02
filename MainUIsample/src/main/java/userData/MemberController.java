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

/**
 * 회원 관리 컨트롤러
 * *.do 패턴으로 모든 회원 관련 요청 처리
 */
@WebServlet({
    "/memberList.do", "/memberView.do", "/memberInsertForm.do", "/memberUpdateForm.do",
    "/memberDelete.do", "/loginForm.do", "/signupForm.do", "/logout.do", "/myPage.do",
    "/login.do", "/signup.do", "/memberInsert.do", "/memberUpdate.do", "/memberBulkAction.do"
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
        String command = getCommand(request);
        
        try {
            switch (command) {
                case "memberList.do":
                    memberList(request, response);
                    break;
                    
                case "memberView.do":
                    memberView(request, response);
                    break;
                    

                    
                case "memberInsertForm.do":
                    request.getRequestDispatcher("/WEB-INF/views/admin/memberForm.jsp").forward(request, response);
                    break;
                    
                case "memberUpdateForm.do":
                    memberUpdateForm(request, response);
                    break;
                    
                case "memberDelete.do":
                    memberDelete(request, response);
                    response.sendRedirect("memberList.do");
                    break;
                    
                // Form display only
                case "loginForm.do":
                    request.getRequestDispatcher("/WEB-INF/views/mainUI/login.jsp").forward(request, response);
                    break;
                    
                case "signupForm.do":
                    request.getRequestDispatcher("/WEB-INF/views/mainUI/signup.jsp").forward(request, response);
                    break;                    
                case "logout.do":
                    logout(request, response);
                    break;
                    
                case "myPage.do":
                    myPage(request, response);
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            handleException(request, response, e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String command = getCommand(request);
        
        try {
            switch (command) {
                // Data processing only
                case "login.do":
                    login(request, response);
                    break;
                    
                case "signup.do":
                    signup(request, response);
                    break;
                    
                case "memberInsert.do":
                    memberInsert(request, response);
                    response.sendRedirect("memberList.do");
                    break;
                    
                case "memberUpdate.do":
                    memberUpdate(request, response);
                    response.sendRedirect("memberList.do");
                    break;
                    
                case "memberBulkAction.do":
                    memberBulkAction(request, response);
                    response.sendRedirect("memberList.do");
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            handleException(request, response, e);
        }
    }
    
    // ============ Helper Methods ============
    
    private String getCommand(HttpServletRequest request) {
        String uri = request.getRequestURI();
        return uri.substring(uri.lastIndexOf("/") + 1);
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
        
        String search = request.getParameter("search");
        String status = getParameterOrDefault(request, "status", "all");
        String type = getParameterOrDefault(request, "type", "all");
        String sort = getParameterOrDefault(request, "sort", "newest");
        
        List<MemberDTO> members = memberDAO.getAllMembers(search, status, type, sort);
        MemberStats stats = memberDAO.getStatistics();
        
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
        
        MemberDTO member = memberDAO.checkLogin(email, password);
        
        if (member != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userName", member.getName());
            session.setAttribute("userEmail", member.getEmail());
            session.setAttribute("userType", member.getType());
            session.setAttribute("userId", member.getId());
            
            response.sendRedirect("index.do");
        } else {
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
            response.sendRedirect("loginForm.do");
        } else {
            request.setAttribute("errorMessage", "Signup failed");
            request.getRequestDispatcher("/WEB-INF/views/mainUI/signup.jsp").forward(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        request.getSession().invalidate();
        response.sendRedirect("loginForm.do");
    }
    
    private void myPage(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
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
        member.setType(request.getParameter("type"));
        member.setStatus(request.getParameter("status"));
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