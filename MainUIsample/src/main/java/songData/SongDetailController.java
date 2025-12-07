package songData;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Song Detail Controller
 * Handles /songDetail.do request and displays song information
 */
@WebServlet("/songDetail.do")
public class SongDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;
    private YouTubeService youtubeService;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        youtubeService = new YouTubeService();
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
        
        try {
            // 액세스 토큰 획득
            String accessToken = spotifyService.getAccessToken();
            
            if (accessToken != null) {
                // 1. Spotify API로 트랙 상세 정보 가져오기
                TrackDTO song = spotifyService.getTrackDetails(accessToken, spotifyId);
                
                if (song != null) {
                    request.setAttribute("song", song);
                    System.out.println("[SongDetailController] Song details loaded: " + song.getTitle());
                    
                    // 2. 아티스트 기반 추천 곡 가져오기 (4개)
                    List<TrackDTO> recommendations = spotifyService.getRecommendationsByArtistName(
                        accessToken, song.getArtist(), 4
                    );
                    request.setAttribute("recommendations", recommendations);
                    System.out.println("[SongDetailController] Recommendations loaded: " + recommendations.size());
                    
                    // 3. YouTube에서 라이브/커버 영상 검색 (4개)
                    List<YouTubeService.YouTubeVideo> youtubeVideos = youtubeService.searchVideos(
                        song.getArtist(), song.getTitle(), 4
                    );
                 // 디버깅: YouTube 비디오 정보 출력
                    if (youtubeVideos != null && !youtubeVideos.isEmpty()) {
                        System.out.println("[SongDetailController] YouTube videos loaded: " + youtubeVideos.size());
                        for (YouTubeService.YouTubeVideo video : youtubeVideos) {
                            System.out.println("  - Video ID: " + video.getVideoId());
                            System.out.println("    Title: " + video.getTitle());
                            System.out.println("    Channel: " + video.getChannelTitle());
                        }
                    } else {
                        System.out.println("[SongDetailController] No YouTube videos found");
                    }
                    request.setAttribute("youtubeVideos", youtubeVideos);
                    System.out.println("[SongDetailController] YouTube videos loaded: " + youtubeVideos.size());
                    
                } else {
                    request.setAttribute("errorMsg", "노래 정보를 찾을 수 없습니다.");
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