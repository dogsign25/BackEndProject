// MainController.java (또는 IndexController.java)

package songData; // 실제 패키지명으로 변경해주세요.
// 예시: package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// SpotifyService와 AlbumDTO가 있는 패키지를 import 해야 합니다.
import songData.SpotifyService; 
import songData.AlbumDTO;

@WebServlet("/index.do")
public class MainController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. SpotifyService 인스턴스 생성
        SpotifyService service = new SpotifyService();
        List<AlbumDTO> newReleases = null;
        
        try {
            // 2. 액세스 토큰 획득
            String accessToken = service.getAccessToken();
            
            if (accessToken != null) {
                // 3. 토큰을 사용하여 신규 앨범 목록 획득
                newReleases = service.getNewReleases(accessToken);
            } else {
                System.err.println("[Controller] 액세스 토큰 획득에 실패하여 New Releases를 가져올 수 없습니다.");
            }
            
                    } catch (Exception e) {
                        System.err.println("[Controller] 데이터 처리 중 치명적인 오류 발생:");
                        e.printStackTrace();
                        // 오류가 발생해도 newReleases는 null 또는 빈 리스트로 유지되어 JSP 오류를 방지합니다.
                        request.setAttribute("errorMessage", "음악 데이터를 불러오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.");
                    }
        // 4. JSP에 데이터 전달
        // 'newReleases'라는 이름은 index.jsp의 c:forEach var="album" items="${newReleases}"와 일치해야 합니다.
        if (newReleases != null) {
            request.setAttribute("newReleases", newReleases);
            System.out.println("[Controller] JSP로 " + newReleases.size() + "개의 앨범 데이터 전달.");
        } else {
            // newReleases가 null이면, JSP에서 빈 리스트로 처리됩니다.
            request.setAttribute("newReleases", java.util.Collections.emptyList());
            System.out.println(" [Controller] JSP로 빈 리스트를 전달합니다 (API 호출 실패).");
        }
        
        // 5. index.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }

}