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
 * YouTube Video Controller
 * Handles /youtubeVideo.do request and displays YouTube video with recommendations
 */
@WebServlet("/youtubeVideo.do")
public class YouTubeVideoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        System.out.println("[YouTubeVideoController] Initialized successfully.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터로 YouTube Video ID, 제목, 아티스트 받기
        String videoId = request.getParameter("videoId");
        String title = request.getParameter("title");
        String artist = request.getParameter("artist");
        
        if (videoId == null || videoId.trim().isEmpty()) {
            response.sendRedirect("index.do");
            return;
        }
        
        // YouTube 영상 정보 전달
        request.setAttribute("videoId", videoId);
        request.setAttribute("title", title != null ? title : "YouTube Video");
        request.setAttribute("artist", artist != null ? artist : "Unknown Artist");
        
        try {
            // Spotify 액세스 토큰 획득
            String accessToken = spotifyService.getAccessToken();
            
            if (accessToken != null && artist != null && !artist.trim().isEmpty()) {
                // 아티스트 기반 추천 곡 가져오기 (4개)
                List<TrackDTO> recommendations = spotifyService.getRecommendationsByArtistName(
                    accessToken, artist, 4
                );
                request.setAttribute("recommendations", recommendations);
                System.out.println("[YouTubeVideoController] Recommendations loaded: " + recommendations.size());
            } else {
                System.err.println("[YouTubeVideoController] 액세스 토큰 획득 실패 또는 아티스트 정보 없음.");
            }
            
        } catch (Exception e) {
            System.err.println("[YouTubeVideoController] 예외 발생:");
            e.printStackTrace();
            // 추천곡이 없어도 영상은 재생할 수 있으므로 에러 페이지로 가지 않음
        }
        
        // youtubeVideo.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/song/youtubeVideo.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("[YouTubeVideoController] Destroyed.");
    }
}