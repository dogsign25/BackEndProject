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
 * Album Detail Controller
 * 앨범 클릭 시 앨범의 트랙 리스트를 보여줌
 */
@WebServlet("/albumDetail.do")
public class AlbumDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SpotifyService spotifyService;

    @Override
    public void init() throws ServletException {
        spotifyService = new SpotifyService();
        System.out.println("[AlbumDetailController] Initialized successfully.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터로 Spotify Album ID 받기
        String albumId = request.getParameter("id");
        
        if (albumId == null || albumId.trim().isEmpty()) {
            response.sendRedirect("index.do");
            return;
        }
        
        try {
            // 액세스 토큰 획득
            String accessToken = spotifyService.getAccessToken();
            
            if (accessToken != null) {
                // 앨범 상세 정보 가져오기 (트랙 리스트 포함)
                AlbumDTO album = spotifyService.getAlbumDetails(accessToken, albumId);
                
                if (album != null) {
                    request.setAttribute("album", album);
                    System.out.println("[AlbumDetailController] Album details loaded: " + album.getAlbumName());
                    System.out.println("[AlbumDetailController] Total tracks: " + (album.getTracks() != null ? album.getTracks().size() : 0));
                } else {
                    request.setAttribute("errorMsg", "앨범 정보를 찾을 수 없습니다.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }
            } else {
                System.err.println("[AlbumDetailController] 액세스 토큰 획득 실패.");
                request.setAttribute("errorMsg", "앨범 정보를 불러올 수 없습니다. Spotify API에 연결할 수 없습니다.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
        } catch (Exception e) {
            System.err.println("[AlbumDetailController] 예외 발생:");
            e.printStackTrace();
            request.setAttribute("errorMsg", "서버 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // albumDetail.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("albumDetail.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("[AlbumDetailController] Destroyed.");
    }
}