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
            System.out.println("[Spotify API] Token Request Response Code: " + responseCode);

            if (responseCode != 200) {
                System.err.println("[Spotify API] 토큰 요청 실패:");
                BufferedReader errorBr = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
                String errorLine;
                StringBuilder errorResponse = new StringBuilder();
                while ((errorLine = errorBr.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorBr.close();
                System.err.println(errorResponse.toString());
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

    // 신곡 데이터 가져오기 (New Releases)
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
                System.err.println("[Spotify API] New Releases 요청 실패. 응답 코드: " + responseCode);
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            String jsonString = response.toString();
            System.out.println("[Spotify API] New Releases JSON: " + 
                               jsonString.substring(0, Math.min(jsonString.length(), 500)) + "...");
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");
            
            if (items.length() == 0) {
                System.out.println("[Spotify API] 0개의 신규 앨범 검색됨.");
            }

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name"); 
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                JSONArray images = item.getJSONArray("images");
                String image = "";
                if (images.length() > 0) {
                    // images 배열의 첫 번째 요소(index 0)에 가장 큰 이미지가 위치합니다.
                    image = images.getJSONObject(0).getString("url");
                }
                list.add(new AlbumDTO(title, artist, image));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] New Releases 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }

    // Trending Songs 가져오기 (Search API 사용)
    public List<AlbumDTO> getTrendingSongs(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        
        try {
            // 인기 키워드로 검색 (trending, popular 등)
            String query = URLEncoder.encode("year:2024-2025", "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=10";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Trending Songs 요청 실패. 응답 코드: " + responseCode);
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            String jsonString = response.toString();
            System.out.println("[Spotify API] Trending Songs JSON: " + 
                               jsonString.substring(0, Math.min(jsonString.length(), 500)) + "...");
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject tracks = root.getJSONObject("tracks");
            JSONArray items = tracks.getJSONArray("items");
            
            if (items.length() == 0) {
                System.out.println("[Spotify API] 0개의 트렌딩 곡 검색됨.");
            }

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                // 이미지 URL 가져오기 (album.images 배열)
                String image = item.getJSONObject("album")
                                   .getJSONArray("images")
                                   .getJSONObject(0)
                                   .getString("url");
                
                // duration_ms를 분:초 형식으로 변환
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                // release_date 가져오기
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);
                
                // Spotify Track ID 추출
                String spotifyId = item.getString("id");

                list.add(new AlbumDTO(title, artist, image, duration, formattedDate, spotifyId));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Trending Songs 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Get Track Details by Spotify ID
     */
    public AlbumDTO getTrackDetails(String accessToken, String trackId) {
        try {
            String apiUrl = "https://api.spotify.com/v1/tracks/" + trackId;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Track Details 요청 실패. 응답 코드: " + responseCode);
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

            System.out.println("[Spotify API] Track Details 조회 성공: " + title);
            return new AlbumDTO(title, artist, image, duration, formattedDate, spotifyId);

        } catch (Exception e) {
            System.err.println("[Spotify API] Track Details 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Weekly Top Songs 가져오기 (Search API 사용 - 다른 키워드)
    public List<AlbumDTO> getWeeklyTopSongs(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        
        try {
            // 장르나 인기 아티스트로 검색
            String query = URLEncoder.encode("genre:pop", "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=4";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Weekly Top Songs 요청 실패. 응답 코드: " + responseCode);
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
                String image = item.getJSONObject("album")
                                   .getJSONArray("images")
                                   .getJSONObject(0)
                                   .getString("url");

                list.add(new AlbumDTO(title, artist, image));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Weekly Top Songs 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    // Top Albums 가져오기 (Search API 사용)
    public List<AlbumDTO> getTopAlbums(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        
        try {
            String query = URLEncoder.encode("year:2024", "UTF-8");
            String apiUrl = "https://api.spotify.com/v1/search?q=" + query + "&type=album&limit=4";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Top Albums 요청 실패. 응답 코드: " + responseCode);
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
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                String image = item.getJSONArray("images").getJSONObject(0).getString("url");

                list.add(new AlbumDTO(title, artist, image));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Top Albums 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    // duration_ms를 "분:초" 형식으로 변환
    private String formatDuration(int durationMs) {
        int totalSeconds = durationMs / 1000;
        int minutes = totalSeconds / 60;
        int seconds = totalSeconds % 60;
        return String.format("%d:%02d", minutes, seconds);
    }
    
    // release_date를 "Nov 4, 2023" 형식으로 변환
    private String formatReleaseDate(String releaseDate) {
        try {
            // releaseDate 형식: "2023-11-04" 또는 "2023" 또는 "2023-11"
            String[] parts = releaseDate.split("-");
            if (parts.length == 3) {
                String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
                int month = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);
                String year = parts[0];
                return months[month - 1] + " " + day + ", " + year;
            } else if (parts.length == 2) {
                return parts[1] + ", " + parts[0]; // "11, 2023"
            } else {
                return releaseDate; // "2023"
            }
        } catch (Exception e) {
            return releaseDate;
        }
    }
    
    public List<AlbumDTO> searchTracks(String accessToken, String searchQuery) {
        List<AlbumDTO> list = new ArrayList<>();
        
        try {
            // 사용자 검색어를 UTF-8로 인코딩
            String query = URLEncoder.encode(searchQuery, "UTF-8");
            // API URL: 트랙 검색, 20개 제한
            // NOTE: 실제 Spotify API 엔드포인트는 "https://api.spotify.com/v1/search?q=" 입니다.
            String apiUrl = "https://api.spotify.com/v1/search?q=?q=" + query + "&type=track&limit=20";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[Spotify API] Search Tracks 요청 실패. 응답 코드: " + responseCode);
                return list;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // JSON 파싱
            JSONObject root = new JSONObject(response.toString());
            JSONObject tracks = root.getJSONObject("tracks");
            JSONArray items = tracks.getJSONArray("items");
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                // 이미지 URL 가져오기: 중간 크기 이미지를 선호
                JSONArray images = item.getJSONObject("album").getJSONArray("images");
                String image = "";
                if (images.length() > 0) {
                    int imageIndex = images.length() > 1 ? 1 : 0; 
                    image = images.getJSONObject(imageIndex).getString("url");
                }
                
                // duration_ms를 분:초 형식으로 변환
                int durationMs = item.getInt("duration_ms");
                String duration = formatDuration(durationMs);
                
                // release_date 가져오기
                String releaseDate = item.getJSONObject("album").getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);

                // AlbumDTO는 duration과 releaseDate 필드를 모두 가지고 있습니다.
                list.add(new AlbumDTO(title, artist, image, duration));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Search Tracks 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
}