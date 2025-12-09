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
import songData.TrackDTO;

/**
 * Main Page Controller
 * Handles index.do and discover.do requests
 */
@WebServlet({"/index.do", "/discover.do"})
public class MainController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;
    private LikedSongDAO likedSongDAO;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        likedSongDAO = new LikedSongDAO();
        System.out.println("[MainController] Initialized successfully.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        SpotifyService service = new SpotifyService();
        
        // Album 리스트
        List<AlbumDTO> newReleases = Collections.emptyList();
        List<AlbumDTO> topAlbums = Collections.emptyList();
        
        // Track 리스트
        List<TrackDTO> trendingSongs = Collections.emptyList();
        List<TrackDTO> weeklyTopSongs = Collections.emptyList();
        
        Set<String> likedSpotifyIds = Collections.emptySet();

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            try {
                List<String> userLikedIdsList = likedSongDAO.getLikedSongSpotifyIds(userId);
                likedSpotifyIds = new HashSet<>(userLikedIdsList);
            } catch (SQLException e) {
                System.err.println("[MainController] Error fetching liked songs for user " + userId + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        try {
            String accessToken = service.getAccessToken();
            
            if (accessToken != null) {
                newReleases = service.getNewReleases(accessToken);
                trendingSongs = service.getTrendingSongs(accessToken);
                weeklyTopSongs = service.getWeeklyTopSongs(accessToken);
                topAlbums = service.getTopAlbums(accessToken);
            } else {
                System.err.println("[Controller] 액세스 토큰 획득 실패.");
                request.setAttribute("errorMsg", "음악 데이터를 불러올 수 없습니다. Spotify API에 연결할 수 없습니다.");
                request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
                return;
            }
            
        } catch (Exception e) {
            System.err.println("[Controller] 예외 발생:");
            e.printStackTrace();
            request.setAttribute("errorMsg", "An unexpected error occurred.");
            request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
            return;
        }
        
        // JSP에 데이터 전달
        request.setAttribute("newReleases", newReleases != null ? newReleases : Collections.emptyList());
        request.setAttribute("trendingSongs", trendingSongs != null ? trendingSongs : Collections.emptyList());
        request.setAttribute("weeklyTopSongs", weeklyTopSongs != null ? weeklyTopSongs : Collections.emptyList());
        request.setAttribute("topAlbums", topAlbums != null ? topAlbums : Collections.emptyList());
        request.setAttribute("likedSpotifyIds", likedSpotifyIds);

        // Manually create JSON string for liked song IDs
        String likedSpotifyIdsJson = "[]";
        if (likedSpotifyIds != null && !likedSpotifyIds.isEmpty()) {
            String joinedIds = likedSpotifyIds.stream()
                                              .map(id -> "\"" + id + "\"")
                                              .collect(Collectors.joining(","));
            likedSpotifyIdsJson = "[" + joinedIds + "]";
        }
        request.setAttribute("likedSpotifyIdsJson", likedSpotifyIdsJson);
        
        // 요청 경로에 따라 포워딩할 JSP 결정
        String uri = request.getRequestURI();
        String command = uri.substring(uri.lastIndexOf("/") + 1);
        
        String viewPage = "/WEB-INF/views/mainUI/index.jsp";
        if ("discover.do".equals(command)) {
            viewPage = "/WEB-INF/views/mainUI/discover.jsp"; 
        }
        
        System.out.println("[Controller] " + viewPage + "로 데이터 전달 완료.");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage);
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("[MainController] Destroyed.");
    }
}