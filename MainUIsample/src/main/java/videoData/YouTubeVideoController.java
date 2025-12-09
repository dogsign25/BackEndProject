package videoData;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import songData.SpotifyService;
import songData.TrackDTO;

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
        
        // UTF-8 인코딩 설정 (중요!)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // 파라미터로 YouTube Video ID, 제목, 아티스트 받기
        String videoId = request.getParameter("videoId");
        String title = request.getParameter("title");
        String artist = request.getParameter("artist");
        
        System.out.println("[YouTubeVideoController] videoId: " + videoId);
        System.out.println("[YouTubeVideoController] title: " + title);
        System.out.println("[YouTubeVideoController] artist: " + artist);
        System.out.println("[YouTubeVideoController] Request encoding: " + request.getCharacterEncoding());
        
        if (videoId == null || videoId.trim().isEmpty()) {
            System.err.println("[YouTubeVideoController] videoId is null or empty");
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
            
            if (accessToken != null) {
                System.out.println("[YouTubeVideoController] Access token obtained successfully");
                
                // 아티스트 정보가 있으면 추천 곡 가져오기
                if (artist != null && !artist.trim().isEmpty() && 
                    !"Unknown Artist".equals(artist) && !"null".equals(artist)) {
                    
                    System.out.println("[YouTubeVideoController] 추천 곡 가져오기 시작: " + artist);
                    
                    // 아티스트 기반 추천 곡 가져오기 (4개)
                    List<TrackDTO> recommendations = spotifyService.getRecommendationsByArtistName(
                        accessToken, artist, 4
                    );
                    
                    if (recommendations != null && !recommendations.isEmpty()) {
                        request.setAttribute("recommendations", recommendations);
                        System.out.println("[YouTubeVideoController] Recommendations loaded: " + recommendations.size());
                    } else {
                        System.out.println("[YouTubeVideoController] No recommendations found");
                    }
                } else {
                    System.err.println("[YouTubeVideoController] 아티스트 정보 없음 또는 유효하지 않음: " + artist);
                }
            } else {
                System.err.println("[YouTubeVideoController] 액세스 토큰 획득 실패");
            }
            
        } catch (Exception e) {
            System.err.println("[YouTubeVideoController] 예외 발생:");
            e.printStackTrace();
            // 추천곡이 없어도 영상은 재생할 수 있으므로 에러 페이지로 가지 않음
        }
        
        // YouTube JSP로 포워딩
        // 주의: 파일명이 YoutubeVideo.jsp이면 아래를 YoutubeVideo.jsp로 변경!
        System.out.println("[YouTubeVideoController] Forwarding to YouTube JSP");
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