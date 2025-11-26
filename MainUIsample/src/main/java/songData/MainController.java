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

/**
 * Main Page Controller
 * Handles index.do request and fetches all Spotify data
 */
@WebServlet("/index.do")
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
        List<AlbumDTO> newReleases = Collections.emptyList();
        List<AlbumDTO> trendingSongs = Collections.emptyList();
        List<AlbumDTO> weeklyTopSongs = Collections.emptyList();
        List<AlbumDTO> topAlbums = Collections.emptyList();
        
        try {
            // 액세스 토큰 획득
            String accessToken = service.getAccessToken();
            
            if (accessToken != null) {
                // 1. New Releases 가져오기
                newReleases = service.getNewReleases(accessToken);
                if (newReleases != null && !newReleases.isEmpty()) {
                    System.out.println("[Controller] New Releases: " + newReleases.size() + "개");
                } else {
                    newReleases = Collections.emptyList();
                }
                
                // 2. Trending Songs 가져오기
                trendingSongs = service.getTrendingSongs(accessToken);
                if (trendingSongs != null && !trendingSongs.isEmpty()) {
                    System.out.println("[Controller] Trending Songs: " + trendingSongs.size() + "개");
                } else {
                    trendingSongs = Collections.emptyList();
                }
                
                // 3. Weekly Top Songs 가져오기
                weeklyTopSongs = service.getWeeklyTopSongs(accessToken);
                if (weeklyTopSongs != null && !weeklyTopSongs.isEmpty()) {
                    System.out.println("[Controller] Weekly Top Songs: " + weeklyTopSongs.size() + "개");
                } else {
                    weeklyTopSongs = Collections.emptyList();
                }
                
                // 4. Top Albums 가져오기
                topAlbums = service.getTopAlbums(accessToken);
                if (topAlbums != null && !topAlbums.isEmpty()) {
                    System.out.println("[Controller] Top Albums: " + topAlbums.size() + "개");
                } else {
                    topAlbums = Collections.emptyList();
                }
                
            } else {
                System.err.println("[Controller] 액세스 토큰 획득 실패.");
                request.setAttribute("errorMessage", "음악 데이터를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.");
            }
            
        } catch (Exception e) {
            System.err.println("[Controller] 예외 발생:");
            e.printStackTrace();
            request.setAttribute("errorMessage", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
        
        // JSP에 데이터 전달
        request.setAttribute("newReleases", newReleases);
        request.setAttribute("trendingSongs", trendingSongs);
        request.setAttribute("weeklyTopSongs", weeklyTopSongs);
        request.setAttribute("topAlbums", topAlbums);
        
        System.out.println("[Controller] JSP로 데이터 전달 완료.");
        
        // index.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
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