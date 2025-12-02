package songData;

import java.io.IOException;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import userData.PlaylistDAO;

@WebServlet({"/playlist.do", "/myPlaylist.do", "/playlistDetail.do"})
public class PlaylistController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("loginForm.do");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        PlaylistDAO playlistDAO = new PlaylistDAO();
        SpotifyService spotifyService = new SpotifyService(); // SpotifyService instance
        
        String command = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);

        if ("myPlaylist.do".equals(command)) {
            List<PlaylistDTO> playlists = playlistDAO.getPlaylistsByUserId(userId);
            request.setAttribute("playlists", playlists);
            request.getRequestDispatcher("/WEB-INF/views/list/myPlaylists.jsp").forward(request, response);
        } else if ("playlistDetail.do".equals(command)) {
            try {
                int playlistId = Integer.parseInt(request.getParameter("playlistId"));
                PlaylistDTO playlist = playlistDAO.getPlaylistById(playlistId);

                if (playlist == null || playlist.getUser_id() != userId) {
                    response.sendRedirect("myPlaylist.do"); // Redirect if not found or not owner
                    return;
                }

                // Get Spotify track IDs from DAO
                List<String> trackSpotifyIds = playlistDAO.getTrackSpotifyIdsByPlaylistId(playlistId);
                List<TrackDTO> tracks = new java.util.ArrayList<>();

                if (!trackSpotifyIds.isEmpty()) {
                    String accessToken = spotifyService.getAccessToken(); // Ensure accessToken is available
                    if (accessToken != null) {
                        tracks = spotifyService.getTrackDetails(trackSpotifyIds, accessToken);
                    } else {
                        System.err.println("[PlaylistController] Access token for Spotify not available.");
                    }
                }
                
                request.setAttribute("playlist", playlist);
                request.setAttribute("tracks", tracks);
                request.getRequestDispatcher("/WEB-INF/views/list/playlistDetail.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("myPlaylist.do"); // Redirect if playlistId is invalid
            } catch (Exception e) {
                System.err.println("Error in playlistDetail.do: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMsg", "플레이리스트 상세 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/mainUI/error.jsp").forward(request, response);
            }
        }
        else if ("playlist.do".equals(command)) {
            // Original JSON API endpoint behavior for /playlist.do
            List<PlaylistDTO> playlists = playlistDAO.getPlaylistsByUserId(userId); // Fetch playlists for JSON as well
            JSONArray jsonPlaylists = new JSONArray();
            for (PlaylistDTO p : playlists) {
                JSONObject jsonPlaylist = new JSONObject();
                jsonPlaylist.put("id", p.getPlaylist_id());
                jsonPlaylist.put("name", p.getName());
                jsonPlaylists.put(jsonPlaylist);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonPlaylists.toString());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // Should not happen with correct mappings
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPlaylist(request, response);
        } else if ("addSong".equals(action)) {
            addSongToPlaylist(request, response);
        } else {
            response.sendRedirect("index.do");
        }
    }

    private void createPlaylist(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("loginForm.do");
            return;
        }

        String playlistName = request.getParameter("playlistName");
        if (playlistName == null || playlistName.trim().isEmpty()) {
            response.sendRedirect("index.do?error=playlistNameInvalid");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        
        PlaylistDAO playlistDAO = new PlaylistDAO();
        boolean success = playlistDAO.createPlaylist(playlistName.trim(), userId);

        if (success) {
            response.sendRedirect("myPage.do?playlistCreated=true");
        } else {
            response.sendRedirect("index.do?error=playlistCreationFailed");
        }
    }

    private void addSongToPlaylist(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false, \"message\":\"로그인이 필요합니다.\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int playlistId = Integer.parseInt(request.getParameter("playlistId"));
            String trackSpotifyId = request.getParameter("trackSpotifyId");

            if (trackSpotifyId == null || trackSpotifyId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false, \"message\":\"Track ID가 유효하지 않습니다.\"}");
                return;
            }

            PlaylistDAO playlistDAO = new PlaylistDAO();
            boolean success = playlistDAO.addSongToPlaylist(playlistId, trackSpotifyId);

            if (success) {
                response.getWriter().write("{\"success\":true, \"message\":\"곡이 플레이리스트에 추가되었습니다.\"}");
            } else {
                // This could be due to the song already being in the playlist, or a DB error.
                response.getWriter().write("{\"success\":false, \"message\":\"곡을 추가하지 못했습니다. 이미 추가되었거나 오류가 발생했습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false, \"message\":\"Playlist ID가 유효하지 않습니다.\"}");
        }
    }
}
