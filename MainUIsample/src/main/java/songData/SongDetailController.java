package songData;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Song Detail Controller
 * Handles /songDetail.do request and displays song information
 */
@WebServlet("/songDetail.do")
public class SongDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;
    private YouTubeService youtubeService;
    private LikedSongDAO likedSongDAO;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        youtubeService = new YouTubeService();
        likedSongDAO = new LikedSongDAO(); // Initialize LikedSongDAO
        System.out.println("[SongDetailController] Initialized successfully.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터로 Spotify Track ID 받기
        String spotifyId = request.getParameter("id");
        
        if (spotifyId == null || spotifyId.trim().isEmpty()) {
            response.sendRedirect("index.do");
            return;
        }

        Set<String> likedSpotifyIds = Collections.emptySet();
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            try {
                likedSpotifyIds = new HashSet<>(likedSongDAO.getLikedSongSpotifyIds(userId));
            } catch (SQLException e) {
                System.err.println("[SongDetailController] Error fetching liked songs: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        try {
            // 액세스 토큰 획득
            String accessToken = spotifyService.getAccessToken();
            
            if (accessToken != null) {
                // Spotify API로 트랙 상세 정보 가져오기
                TrackDTO song = spotifyService.getTrackDetails(accessToken, spotifyId);
                
                if (song != null) {
                    request.setAttribute("song", song);
                    System.out.println("[SongDetailController] Song details loaded: " + song.getTitle());
                } else {
request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
                    return;
                }
            } else {
                System.err.println("[SongDetailController] 액세스 토큰 획득 실패.");
                request.setAttribute("errorMsg", "노래 정보를 불러올 수 없습니다. Spotify API에 연결할 수 없습니다.");
                request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
                return;
            }
            
        } catch (Exception e) {
            System.err.println("[SongDetailController] 예외 발생:");
            e.printStackTrace();
            request.setAttribute("errorMsg", "서버 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
            return;
        }

        // Pass liked song IDs to JSP
        request.setAttribute("likedSpotifyIds", likedSpotifyIds);
        String likedSpotifyIdsJson = "[]";
        if (likedSpotifyIds != null && !likedSpotifyIds.isEmpty()) {
            String joinedIds = likedSpotifyIds.stream()
                                              .map(id -> "\"" + id + "\"")
                                              .collect(Collectors.joining(","));
            likedSpotifyIdsJson = "[" + joinedIds + "]";
        }
        request.setAttribute("likedSpotifyIdsJson", likedSpotifyIdsJson);
        
        // songDetail.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/song/songDetail.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("[SongDetailController] Destroyed.");
    }
}