package songData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({"/likedSongs.do", "/likeSong.do"})
public class LikedSongsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LikedSongDAO likedSongDAO;
    private SpotifyService spotifyService;

    @Override
    public void init() throws ServletException {
        likedSongDAO = new LikedSongDAO();
        spotifyService = new SpotifyService();
        System.out.println("[LikedSongsController] Initialized successfully.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("loginForm.do");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // 기존의 좋아요 목록 페이지 로직
        try {
            List<String> likedSpotifyIds = likedSongDAO.getLikedSongSpotifyIds(userId);
            List<TrackDTO> likedSongs = spotifyService.getTrackDetailsByIds(likedSpotifyIds);

            request.setAttribute("likedSongs", likedSongs);
            request.getRequestDispatcher("/WEB-INF/views/list/likedSongs.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "좋아요 목록을 불러오는 데 실패했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String command = request.getServletPath();
        
        if ("/likeSong.do".equals(command)) {
            handleLikeSong(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown POST command.");
        }
    }

    private void handleLikeSong(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            sendJsonResponse(response, "error", "Login required.", false);
            return;
        }

        try {
            JSONObject jsonRequest = readJsonBody(request);
            String trackId = jsonRequest.optString("trackId", null);
            int userId = (int) session.getAttribute("userId");

            if (trackId == null || trackId.isEmpty()) {
                sendJsonResponse(response, "error", "Track ID is required.", false);
                return;
            }

            boolean isLiked = likedSongDAO.isSongLiked(userId, trackId);
            boolean newLikedState;

            if (isLiked) {
                likedSongDAO.removeLikedSong(userId, trackId);
                newLikedState = false;
            } else {
                likedSongDAO.addLikedSong(userId, trackId);
                newLikedState = true;
            }

            sendJsonResponse(response, "success", "Like status updated.", newLikedState);

        } catch (SQLException e) {
            e.printStackTrace();
            sendJsonResponse(response, "error", "Database error: " + e.getMessage(), false);
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, "error", "Invalid request: " + e.getMessage(), false);
        }
    }

    private JSONObject readJsonBody(HttpServletRequest request) throws IOException {
        try (BufferedReader reader = request.getReader()) {
            String jsonString = reader.lines().collect(Collectors.joining(System.lineSeparator()));
            return new JSONObject(jsonString);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, String status, String message, boolean liked) throws IOException {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("status", status);
        jsonResponse.put("message", message);
        jsonResponse.put("liked", liked);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse.toString());
            out.flush();
        }
    }
}
