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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[MainController] GET request received for index.do");
        
        List<AlbumDTO> newReleases = Collections.emptyList();
        List<AlbumDTO> weeklyTopSongs = Collections.emptyList();
        List<AlbumDTO> topAlbums = Collections.emptyList();
        
        try {
            // 1. Get Access Token
            String accessToken = spotifyService.getAccessToken();
            
            if (accessToken != null) {
                System.out.println("[MainController] Access token acquired successfully");
                
                // 2. Fetch New Releases
                try {
                    newReleases = spotifyService.getNewReleases(accessToken);
                    System.out.println("[MainController] New Releases: " + 
                                      (newReleases != null ? newReleases.size() : 0) + " albums");
                } catch (Exception e) {
                    System.err.println("[MainController] Error fetching new releases:");
                    e.printStackTrace();
                }
                
                // 3. Fetch Weekly Top Songs
                try {
                    weeklyTopSongs = spotifyService.getWeeklyTopSongs(accessToken);
                    System.out.println("[MainController] Weekly Top Songs: " + 
                                      (weeklyTopSongs != null ? weeklyTopSongs.size() : 0) + " songs");
                } catch (Exception e) {
                    System.err.println("[MainController] Error fetching weekly top songs:");
                    e.printStackTrace();
                }
                
                // 4. Fetch Top Albums
                try {
                    topAlbums = spotifyService.getTopAlbums(accessToken);
                    System.out.println("[MainController] Top Albums: " + 
                                      (topAlbums != null ? topAlbums.size() : 0) + " albums");
                } catch (Exception e) {
                    System.err.println("[MainController] Error fetching top albums:");
                    e.printStackTrace();
                }
                
            } else {
                System.err.println("[MainController] Failed to acquire access token");
                request.setAttribute("errorMessage", "Failed to connect to Spotify API. Please try again later.");
            }
            
        } catch (Exception e) {
            System.err.println("[MainController] Fatal error while processing Spotify data:");
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading music data. Please try again.");
        }
        
        // 5. Set all data to request attributes
        request.setAttribute("newReleases", newReleases != null ? newReleases : Collections.emptyList());
        request.setAttribute("weeklyTopSongs", weeklyTopSongs != null ? weeklyTopSongs : Collections.emptyList());
        request.setAttribute("topAlbums", topAlbums != null ? topAlbums : Collections.emptyList());
        
        System.out.println("[MainController] Forwarding to index.jsp with:");
        System.out.println("  - New Releases: " + (newReleases != null ? newReleases.size() : 0));
        System.out.println("  - Weekly Top Songs: " + (weeklyTopSongs != null ? weeklyTopSongs.size() : 0));
        System.out.println("  - Top Albums: " + (topAlbums != null ? topAlbums.size() : 0));
        
        // 6. Forward to JSP
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