package userData;

import java.sql.*;
import java.util.*;

public class MemberDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
    
    // 전체 회원 조회 (검색, 필터링, 정렬 포함)
    public List<MemberDTO> getAllMembers(String search, String status, String type, String sort) throws SQLException {
        List<MemberDTO> members = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT id, name, email, phone, birthdate, type, status, " +
            "join_date, last_login, updated_at FROM members WHERE 1=1"
        );
        
        // 검색 조건
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        
        // 상태 필터
        if (status != null && !status.equals("all")) {
            sql.append(" AND status = ?");
        }
        
        // 유형 필터
        if (type != null && !type.equals("all")) {
            sql.append(" AND type = ?");
        }
        
        // 정렬
        if (sort != null) {
            switch(sort) {
                case "newest":
                    sql.append(" ORDER BY join_date DESC");
                    break;
                case "oldest":
                    sql.append(" ORDER BY join_date ASC");
                    break;
                case "name":
                    sql.append(" ORDER BY name ASC");
                    break;
                default:
                    sql.append(" ORDER BY id DESC");
            }
        } else {
            sql.append(" ORDER BY id DESC");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            // 검색어 바인딩
            if (search != null && !search.trim().isEmpty()) {
                String searchParam = "%" + search + "%";
                pstmt.setString(paramIndex++, searchParam);
                pstmt.setString(paramIndex++, searchParam);
                pstmt.setString(paramIndex++, searchParam);
            }
            
            // 상태 바인딩
            if (status != null && !status.equals("all")) {
                pstmt.setString(paramIndex++, status);
            }
            
            // 유형 바인딩
            if (type != null && !type.equals("all")) {
                pstmt.setString(paramIndex++, type);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                MemberDTO member = new MemberDTO();
                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                member.setBirthdate(rs.getString("birthdate"));
                member.setType(rs.getString("type"));
                member.setStatus(rs.getString("status"));
                member.setJoinDate(rs.getTimestamp("join_date"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setUpdatedAt(rs.getString("updated_at"));
                members.add(member);
            }
        }
        
        return members;
    }
    
    // 특정 회원 조회
    public MemberDTO getMemberById(int memberId) throws SQLException {
        String sql = "SELECT id, name, email, phone, birthdate, type, status, " +
                    "join_date, last_login, updated_at FROM members WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MemberDTO member = new MemberDTO();
                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                member.setBirthdate(rs.getString("birthdate"));
                member.setType(rs.getString("type"));
                member.setStatus(rs.getString("status"));
                member.setJoinDate(rs.getTimestamp("join_date"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setUpdatedAt(rs.getString("updated_at"));
                return member;
            }
        }
        
        return null;
    }
    
    // 회원 추가
    public int insertMember(MemberDTO member) throws SQLException {
        String sql = "INSERT INTO members (name, email, password, phone, birthdate, type, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPassword()); // 실제로는 암호화된 비밀번호
            pstmt.setString(4, member.getPhone());
            pstmt.setString(5, member.getBirthdate());
            pstmt.setString(6, member.getType() != null ? member.getType() : "free");
            pstmt.setString(7, member.getStatus() != null ? member.getStatus() : "active");
            
            return pstmt.executeUpdate();
        }
    }
    
    // 회원 수정
    public int updateMember(MemberDTO member) throws SQLException {
        String sql = "UPDATE members SET name=?, email=?, phone=?, birthdate=?, " +
                    "type=?, status=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPhone());
            pstmt.setString(4, member.getBirthdate());
            pstmt.setString(5, member.getType());
            pstmt.setString(6, member.getStatus());
            pstmt.setInt(7, member.getId());
            
            return pstmt.executeUpdate();
        }
    }
    
    // 회원 삭제
    public int deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM members WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate();
        }
    }
    
    // 대량 작업 (활성화/정지/삭제)
    public int bulkAction(String actionType, int[] memberIds) throws SQLException {
        if (memberIds == null || memberIds.length == 0) {
            return 0;
        }
        
        String sql = "";
        switch(actionType) {
            case "activate":
                sql = "UPDATE members SET status = 'active' WHERE id IN (";
                break;
            case "suspend":
                sql = "UPDATE members SET status = 'suspended' WHERE id IN (";
                break;
            case "delete":
                sql = "DELETE FROM members WHERE id IN (";
                break;
            default:
                throw new IllegalArgumentException("지원하지 않는 작업입니다: " + actionType);
        }
        
        // IN 절 구성
        StringBuilder sqlBuilder = new StringBuilder(sql);
        for (int i = 0; i < memberIds.length; i++) {
            sqlBuilder.append("?");
            if (i < memberIds.length - 1) {
                sqlBuilder.append(",");
            }
        }
        sqlBuilder.append(")");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            
            for (int i = 0; i < memberIds.length; i++) {
                pstmt.setInt(i + 1, memberIds[i]);
            }
            
            return pstmt.executeUpdate();
        }
    }
    
    // 회원 통계 조회
    public MemberStats getStatistics() throws SQLException {
        String sql = "SELECT " +
                    "(SELECT COUNT(*) FROM members) as total, " +
                    "(SELECT COUNT(*) FROM members WHERE status = 'active') as active, " +
                    "(SELECT COUNT(*) FROM members WHERE type = 'premium') as premium, " +
                    "(SELECT COUNT(*) FROM members WHERE YEAR(join_date) = YEAR(CURDATE()) " +
                    "AND MONTH(join_date) = MONTH(CURDATE())) as new_members";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                MemberStats stats = new MemberStats();
                stats.setTotal(rs.getInt("total"));
                stats.setActive(rs.getInt("active"));
                stats.setPremium(rs.getInt("premium"));
                stats.setNewMembers(rs.getInt("new_members"));
                return stats;
            }
        }
        
        return null;
    }
    
    // 이메일 중복 체크
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM members WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }

    public MemberDTO getMemberByEmail(String email) throws SQLException {
        String sql = "SELECT id, name, email, phone, birthdate, type, status, " +
                    "join_date, last_login, updated_at FROM members WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MemberDTO member = new MemberDTO();
                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                member.setBirthdate(rs.getString("birthdate"));
                member.setType(rs.getString("type"));
                member.setStatus(rs.getString("status"));
                member.setJoinDate(rs.getTimestamp("join_date"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setUpdatedAt(rs.getString("updated_at"));
                return member;
            }
        }
        
        return null;
    }

    // 로그인 체크
    public MemberDTO checkLogin(String email, String password) throws SQLException {
        String sql = "SELECT * FROM members WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MemberDTO member = new MemberDTO();
                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setPhone(rs.getString("phone"));
                member.setBirthdate(rs.getString("birthdate"));
                member.setType(rs.getString("type"));
                member.setStatus(rs.getString("status"));
                member.setJoinDate(rs.getTimestamp("join_date"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                return member;
            }
        }
        
        return null;
    }
    /**
     * 회원 수정 (비밀번호 포함)
     */
    public int updateMemberWithPassword(MemberDTO member) throws SQLException {
        String sql = "UPDATE members SET name=?, email=?, phone=?, birthdate=?, " +
                    "type=?, status=?, password=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPhone());
            pstmt.setString(4, member.getBirthdate());
            pstmt.setString(5, member.getType());
            pstmt.setString(6, member.getStatus());
            pstmt.setString(7, member.getPassword());
            pstmt.setInt(8, member.getId());
            
            return pstmt.executeUpdate();
        }
    }

}

