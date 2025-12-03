package songData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject; // Assuming org.json is available for JSON responses

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/likedSongs.do")
public class LikedSongsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LikedSongDAO likedSongDAO;
    private SpotifyService spotifyService; // Assuming this exists or will be implemented

    @Override
    public void init() throws ServletException {
        likedSongDAO = new LikedSongDAO();
        spotifyService = new SpotifyService(); // Initialize SpotifyService
        System.out.println("[LikedSongsController] Initialized successfully.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("loginForm.do"); // 로그인 페이지로 리다이렉트
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String action = request.getParameter("action");

        if ("checkLike".equals(action)) {
            // AJAX 요청: 특정 곡의 좋아요 여부 확인
            String spotifyId = request.getParameter("spotifyId");
            if (spotifyId == null || spotifyId.isEmpty()) {
                sendJsonResponse(response, false, "Spotify ID is required.");
                return;
            }
            try {
                boolean isLiked = likedSongDAO.isSongLiked(userId, spotifyId);
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("success", true);
                jsonResponse.put("isLiked", isLiked);
                sendJsonResponse(response, jsonResponse);
            } catch (SQLException e) {
                e.printStackTrace();
                sendJsonResponse(response, false, "Database error: " + e.getMessage());
            }
        } else {
            // 일반 GET 요청: 좋아요 목록 페이지 표시
            try {
                // 좋아요 누른 곡들의 Spotify ID 목록을 가져옴
                List<String> likedSpotifyIds = likedSongDAO.getLikedSongSpotifyIds(userId);
                
                // 각 Spotify ID에 해당하는 곡의 상세 정보를 가져옴 (SpotifyService 사용)
                List<TrackDTO> likedSongs = spotifyService.getTrackDetailsByIds(likedSpotifyIds);

                request.setAttribute("likedSongs", likedSongs);
                request.getRequestDispatcher("/WEB-INF/views/list/likedSongs.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMsg", "좋아요 목록을 불러오는 데 실패했습니다: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            sendJsonResponse(response, false, "Login required.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        String spotifyId = request.getParameter("spotifyId");

        if (spotifyId == null || spotifyId.isEmpty()) {
            sendJsonResponse(response, false, "Spotify ID is required.");
            return;
        }

        try {
            int result = 0;
            String message = "";
            boolean isLiked = likedSongDAO.isSongLiked(userId, spotifyId);

            if ("add".equals(action)) {
                if (!isLiked) {
                    result = likedSongDAO.addLikedSong(userId, spotifyId);
                    message = (result > 0) ? "Song added to liked songs." : "Failed to add song.";
                } else {
                    message = "Song is already liked.";
                }
            } else if ("remove".equals(action)) {
                if (isLiked) {
                    result = likedSongDAO.removeLikedSong(userId, spotifyId);
                    message = (result > 0) ? "Song removed from liked songs." : "Failed to remove song.";
                } else {
                    message = "Song is not liked.";
                }
            } else {
                sendJsonResponse(response, false, "Invalid action.");
                return;
            }

            sendJsonResponse(response, true, message);

        } catch (SQLException e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Database error: " + e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        sendJsonResponse(response, jsonResponse);
    }

    private void sendJsonResponse(HttpServletResponse response, JSONObject jsonResponse) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse.toString());
            out.flush();
        }
    }
}
