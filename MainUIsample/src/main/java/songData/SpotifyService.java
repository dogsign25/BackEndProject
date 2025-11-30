package songData;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

public class SpotifyService {
    private static final String CLIENT_ID = "55de3e8154e14951af8483654af23200";
    private static final String CLIENT_SECRET = "914b90ea643f49729ad9141e693ae6fa";
    
    // 액세스 토큰 획득
    public String getAccessToken() {
        String tokenUrl = "https://accounts.spotify.com/api/token"; 
        String auth = CLIENT_ID + ":" + CLIENT_SECRET; 
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes());

        try {
            URL url = new URL(tokenUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true); 
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String param = "grant_type=client_credentials";
            conn.getOutputStream().write(param.getBytes());
            conn.getOutputStream().flush(); 

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] 토큰 요청 실패");
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject jsonResponse = new JSONObject(response.toString());
            String accessToken = jsonResponse.getString("access_token");

            System.out.println("[Spotify API] Access Token 획득 성공.");
            return accessToken; 

        } catch (Exception e) {
            System.err.println("[Spotify API] 토큰 획득 중 Exception 발생:");
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get New Releases (앨범 리스트)
     */
    public List<AlbumDTO> getNewReleases(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        String apiUrl = "https://api.spotify.com/v1/browse/new-releases?limit=4"; 

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] New Releases 요청 실패");
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String albumName = item.getString("name"); 
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                String image = item.getJSONArray("images").getJSONObject(0).getString("url");
                String albumId = item.getString("id");
                
                list.add(new AlbumDTO(albumName, artist, image, albumId));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] New Releases 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Get Top Albums (앨범 리스트)
     */
    public List<AlbumDTO> getTopAlbums(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        String apiUrl = "https://api.spotify.com/v1/search?q=year:2024&type=album&limit=4";

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Top Albums 요청 실패");
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String albumName = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                String image = item.getJSONArray("images").getJSONObject(0).getString("url");
                String albumId = item.getString("id");

                list.add(new AlbumDTO(albumName, artist, image, albumId));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Top Albums 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Get Album Details (앨범 상세 정보 + 트랙 리스트)
     */
    public AlbumDTO getAlbumDetails(String accessToken, String albumId) {
        try {
            String apiUrl = "https://api.spotify.com/v1/albums/" + albumId;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Album Details 요청 실패");
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject album = new JSONObject(response.toString());
            
            String albumName = album.getString("name");
            String artist = album.getJSONArray("artists").getJSONObject(0).getString("name");
            String image = album.getJSONArray("images").getJSONObject(0).getString("url");
            String releaseDate = album.getString("release_date");
            String formattedDate = formatReleaseDate(releaseDate);
            int totalTracks = album.getInt("total_tracks");
            
            AlbumDTO albumDTO = new AlbumDTO(albumName, artist, image, formattedDate, albumId, totalTracks);
            
            // 트랙 리스트 파싱
            List<TrackDTO> tracks = new ArrayList<>();
            JSONArray tracksArray = album.getJSONObject("tracks").getJSONArray("items");
            
            for (int i = 0; i < tracksArray.length(); i++) {
                JSONObject track = tracksArray.getJSONObject(i);
                
                String trackTitle = track.getString("name");
                String trackArtist = track.getJSONArray("artists").getJSONObject(0).getString("name");
                int durationMs = track.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                String trackId = track.getString("id");
                
                TrackDTO trackDTO = new TrackDTO(trackTitle, trackArtist, image, duration, 
                                                  formattedDate, trackId, albumName);
                tracks.add(trackDTO);
            }
            
            albumDTO.setTracks(tracks);
            
            System.out.println("[Spotify API] Album Details 조회 성공: " + albumName + " (" + tracks.size() + " tracks)");
            return albumDTO;

        } catch (Exception e) {
            System.err.println("[Spotify API] Album Details 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Get Trending Songs (트랙 리스트)
     */
    public List<TrackDTO> getTrendingSongs(String accessToken) {
        List<TrackDTO> list = new ArrayList<>();
        
        try {
            String query = URLEncoder.encode("year:2024-2025", "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=10";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Trending Songs 요청 실패");
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONObject tracks = root.getJSONObject("tracks");
            JSONArray items = tracks.getJSONArray("items");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                String image = item.getJSONObject("album").getJSONArray("images").getJSONObject(0).getString("url");
                
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);
                
                String spotifyId = item.getString("id");
                String albumName = item.getJSONObject("album").getString("name");

                list.add(new TrackDTO(title, artist, image, duration, formattedDate, spotifyId, albumName));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Trending Songs 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Get Weekly Top Songs (트랙 리스트)
     */
    public List<TrackDTO> getWeeklyTopSongs(String accessToken) {
        List<TrackDTO> list = new ArrayList<>();
        
        try {
            String query = URLEncoder.encode("genre:pop", "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=4";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Weekly Top Songs 요청 실패");
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONObject tracks = root.getJSONObject("tracks");
            JSONArray items = tracks.getJSONArray("items");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                String image = item.getJSONObject("album").getJSONArray("images").getJSONObject(0).getString("url");
                
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);
                
                String spotifyId = item.getString("id");
                String albumName = item.getJSONObject("album").getString("name");

                list.add(new TrackDTO(title, artist, image, duration, formattedDate, spotifyId, albumName));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Weekly Top Songs 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Get Track Details by Spotify ID
     */
    public TrackDTO getTrackDetails(String accessToken, String trackId) {
        try {
            String apiUrl = "https://api.spotify.com/v1/tracks/" + trackId;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Track Details 요청 실패");
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject track = new JSONObject(response.toString());
            
            String title = track.getString("name");
            String artist = track.getJSONArray("artists").getJSONObject(0).getString("name");
            String image = track.getJSONObject("album").getJSONArray("images").getJSONObject(0).getString("url");
            
            int durationMs = track.getInt("duration_ms");
            String duration = formatDuration(durationMs);
            
            String releaseDate = track.getJSONObject("album").getString("release_date");
            String formattedDate = formatReleaseDate(releaseDate);
            
            String spotifyId = track.getString("id");
            String albumName = track.getJSONObject("album").getString("name");

            System.out.println("[Spotify API] Track Details 조회 성공: " + title);
            return new TrackDTO(title, artist, image, duration, formattedDate, spotifyId, albumName);

        } catch (Exception e) {
            System.err.println("[Spotify API] Track Details 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get Track Details by a list of Spotify IDs (batch request)
     */
    public List<TrackDTO> getTrackDetails(List<String> trackIds, String accessToken) {
        List<TrackDTO> tracks = new ArrayList<>();
        if (trackIds == null || trackIds.isEmpty()) {
            return tracks;
        }

        // Spotify API allows up to 50 track IDs in a single request
        // Join the track IDs with commas
        String idsParam = String.join(",", trackIds);

        try {
            String apiUrl = "https://api.spotify.com/v1/tracks?ids=" + idsParam;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Batch Track Details 요청 실패. Response Code: " + responseCode);
                return tracks;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONArray items = root.getJSONArray("tracks");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                if (item == null || item.keySet().isEmpty()) { // Handle null tracks for invalid IDs
                    continue;
                }

                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                JSONArray images = item.getJSONObject("album").getJSONArray("images");
                String image = "";
                if (images.length() > 0) {
                    image = images.getJSONObject(0).getString("url"); // Get first image
                }
                
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);
                
                String spotifyId = item.getString("id");
                String albumName = item.getJSONObject("album").getString("name");

                tracks.add(new TrackDTO(title, artist, image, duration, formattedDate, spotifyId, albumName));
            }

            System.out.println("[Spotify API] Batch Track Details 조회 성공: " + tracks.size() + " tracks");
        } catch (Exception e) {
            System.err.println("[Spotify API] Batch Track Details 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return tracks;
    }
    
    /**
     * Search Tracks
     */
    public List<TrackDTO> searchTracks(String accessToken, String searchQuery) {
        List<TrackDTO> list = new ArrayList<>();
        
        try {
            String query = URLEncoder.encode(searchQuery, "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=20";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Search Tracks 요청 실패");
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject root = new JSONObject(response.toString());
            JSONObject tracks = root.getJSONObject("tracks");
            JSONArray items = tracks.getJSONArray("items");
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                JSONArray images = item.getJSONObject("album").getJSONArray("images");
                String image = "";
                if (images.length() > 0) {
                    int imageIndex = images.length() > 1 ? 1 : 0; 
                    image = images.getJSONObject(imageIndex).getString("url");
                }
                
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);
                
                String spotifyId = item.getString("id");
                String albumName = item.getJSONObject("album").getString("name");

                list.add(new TrackDTO(title, artist, image, duration, formattedDate, spotifyId, albumName));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Search Tracks 파싱 중 Exception:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    // Helper Methods
    private String formatDuration(int durationMs) {
        int totalSeconds = durationMs / 1000;
        int minutes = totalSeconds / 60;
        int seconds = totalSeconds % 60;
        return String.format("%d:%02d", minutes, seconds);
    }
    
    private String formatReleaseDate(String releaseDate) {
        try {
            String[] parts = releaseDate.split("-");
            if (parts.length == 3) {
                String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
                int month = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);
                String year = parts[0];
                return months[month - 1] + " " + day + ", " + year;
            } else if (parts.length == 2) {
                return parts[1] + ", " + parts[0];
            } else {
                return releaseDate;
            }
        } catch (Exception e) {
            return releaseDate;
        }
    }
}