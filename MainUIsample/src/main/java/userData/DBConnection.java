package userData;

import java.sql.*;

public class DBConnection {
	public static Connection getConnection() {
		Connection conn=null;
		try {
//			1단계 : 커넥터 로딩
			Class.forName("com.mysql.cj.jdbc.Driver");
//			2단계 : DB서버 커넥션
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/musicapp", "root", "dongyang");

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	public static void close(Connection con, PreparedStatement pstmt) {
		//4단계-select쿼리 이외의 쿼리작업시
		try {
			con.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}


	}

	public static void close(Connection con, PreparedStatement pstmt, ResultSet rs) {
		//4단계-select쿼리 작업시
		try {
			con.close();
			pstmt.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}