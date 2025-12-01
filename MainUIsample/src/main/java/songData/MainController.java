package songData;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import songData.TrackDTO;

/**
 * Main Page Controller
 * Handles index.do and discover.do requests
 */
@WebServlet({"/index.do", "/discover.do"})
public class MainController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
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
        
        try {
            String accessToken = service.getAccessToken();
            
            if (accessToken != null) {
                // 1. New Releases (앨범)
                newReleases = service.getNewReleases(accessToken);
                if (newReleases != null && !newReleases.isEmpty()) {
                    System.out.println("[Controller] New Releases: " + newReleases.size() + "개");
                } else {
                    newReleases = Collections.emptyList();
                }
                
                // 2. Trending Songs (트랙)
                trendingSongs = service.getTrendingSongs(accessToken);
                if (trendingSongs != null && !trendingSongs.isEmpty()) {
                    System.out.println("[Controller] Trending Songs: " + trendingSongs.size() + "개");
                } else {
                    trendingSongs = Collections.emptyList();
                }
                
                // 3. Weekly Top Songs (트랙)
                weeklyTopSongs = service.getWeeklyTopSongs(accessToken);
                if (weeklyTopSongs != null && !weeklyTopSongs.isEmpty()) {
                    System.out.println("[Controller] Weekly Top Songs: " + weeklyTopSongs.size() + "개");
                } else {
                    weeklyTopSongs = Collections.emptyList();
                }
                
                // 4. Top Albums (앨범)
                topAlbums = service.getTopAlbums(accessToken);
                if (topAlbums != null && !topAlbums.isEmpty()) {
                    System.out.println("[Controller] Top Albums: " + topAlbums.size() + "개");
                } else {
                    topAlbums = Collections.emptyList();
                }
                
            } else {
                System.err.println("[Controller] 액세스 토큰 획득 실패.");
                request.setAttribute("errorMsg", "음악 데이터를 불러올 수 없습니다. Spotify API에 연결할 수 없습니다.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
        } catch (Exception e) {
            System.err.println("[Controller] 예외 발생:");
            e.printStackTrace();
            request.setAttribute("errorMsg", "서버 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // JSP에 데이터 전달
        request.setAttribute("newReleases", newReleases);
        request.setAttribute("trendingSongs", trendingSongs);
        request.setAttribute("weeklyTopSongs", weeklyTopSongs);
        request.setAttribute("topAlbums", topAlbums);
        
        // 요청 경로에 따라 포워딩할 JSP 결정
        String uri = request.getRequestURI();
        String command = uri.substring(uri.lastIndexOf("/") + 1);
        
        String viewPage = "index.jsp";
        if ("discover.do".equals(command)) {
            viewPage = "discover.jsp"; 
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