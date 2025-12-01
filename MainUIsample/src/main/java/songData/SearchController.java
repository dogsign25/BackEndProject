// songData/SearchController.java (새 파일 생성)

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
 * Search Controller
 * Handles /search.do request and searches Spotify for tracks
 */
@WebServlet("/search.do")
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        System.out.println("[SearchController] Initialized successfully.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String searchQuery = request.getParameter("query");
        List<TrackDTO> searchResults = Collections.emptyList();
        
        System.out.println("[SearchController] Search query received: " + searchQuery);
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            try {
                // 액세스 토큰 획득
                String accessToken = spotifyService.getAccessToken();
                
                if (accessToken != null) {
                    // 트랙 검색 (SpotifyService에 추가한 메서드)
                    searchResults = spotifyService.searchTracks(accessToken, searchQuery);
                    if (searchResults != null && !searchResults.isEmpty()) {
                        System.out.println("[SearchController] Search results: " + searchResults.size() + "개");
                    }
                } else {
                    System.err.println("[SearchController] 액세스 토큰 획득 실패.");
                    request.setAttribute("errorMsg", "검색 기능을 사용할 수 없습니다. Spotify API에 연결할 수 없습니다.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }
                
            } catch (Exception e) {
                System.err.println("[SearchController] 예외 발생:");
                e.printStackTrace();
                request.setAttribute("errorMsg", "검색 중 서버 오류가 발생했습니다: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }
        
        // JSP에 데이터 전달
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchResults", searchResults);
        
        // searchResult.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("searchResult.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("[SearchController] Destroyed.");
    }
}