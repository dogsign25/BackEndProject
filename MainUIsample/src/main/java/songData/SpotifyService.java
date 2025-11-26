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
    
    /**
     * Get Spotify Access Token
     */
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
                System.err.println("[Spotify API] Token request failed");
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

            System.out.println("[Spotify API] Access Token acquired successfully");
            return accessToken; 

        } catch (Exception e) {
            System.err.println("[Spotify API] Exception during token acquisition:");
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get New Releases (Albums) - 이미지 고화질 추출 로직 포함 (index 0)
     */
    public List<AlbumDTO> getNewReleases(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        // 새로운 릴리즈를 가져오는 Mock API URL
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

            // JSON 파싱 시작
            JSONObject root = new JSONObject(response.toString());
            // New Releases는 'albums' 객체 안에 있습니다.
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name");
                
                // 아티스트 정보 추출 (첫 번째 아티스트)
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                // 이미지 추출 로직 수정: 가장 큰 이미지 (index 0) 사용
                JSONArray images = item.getJSONArray("images");
                String image = "";
                if (images.length() > 0) {
                    // images 배열의 첫 번째 요소(index 0)에 가장 큰 이미지가 위치합니다.
                    image = images.getJSONObject(0).getString("url");
                }
                
                // 앨범 목록이므로 길이는 포함되지 않습니다.
                String duration = ""; 
                
                // 발매일 가져오기
                String releaseDate = item.getString("release_date");
                String formattedDate = formatReleaseDate(releaseDate);

                // AlbumDTO에 데이터 추가
                list.add(new AlbumDTO(title, artist, image, duration, formattedDate));
            }
            
            System.out.println("[Spotify API] Successfully processed " + list.size() + " New Releases");

        } catch (Exception e) {
            System.err.println("[Spotify API] Exception during New Releases fetch:");
            e.printStackTrace();
        }
        
        return list;
    }

    /**
     * Get Weekly Top Songs
     * Using album search with "single" type to get popular singles
     */
    public List<AlbumDTO> getWeeklyTopSongs(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        
        // Search for singles (which are essentially popular songs)
        // Using a broad query that returns popular results
        String apiUrl = "https://api.spotify.com/v1/search?q=genre:pop&type=album&limit=8";

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = conn.getResponseCode();
            System.out.println("[Spotify API] Weekly Top Songs Response Code: " + responseCode);

            if (responseCode != 200) {
                System.err.println("[Spotify API] Weekly Top Songs request failed. Response code: " + responseCode);
                
                BufferedReader errorBr = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                while ((errorLine = errorBr.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorBr.close();
                System.err.println("[Spotify API] Error: " + errorResponse.toString());
                
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
            System.out.println("[Spotify API] Weekly Top Songs JSON (preview): " + 
                               jsonString.substring(0, Math.min(jsonString.length(), 300)) + "...");
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");

            if (items.length() == 0) {
                System.out.println("[Spotify API] No top songs found");
                return list;
            }

            System.out.println("[Spotify API] Processing up to 4 top songs from " + items.length() + " results...");

            // Filter for singles and get only 4
            for (int i = 0; i < items.length() && list.size() < 4; i++) {
                try {
                    JSONObject album = items.getJSONObject(i);
                    
                    // Prefer singles (single tracks)
                    String albumType = album.optString("album_type", "");
                    
                    String title = album.getString("name");
                    String artist = album.getJSONArray("artists").getJSONObject(0).getString("name");

                    JSONArray images = album.getJSONArray("images");
                    String image = "";
                    
                    if (images.length() > 0) {
                        int imageIndex = images.length() > 1 ? 1 : 0;
                        image = images.getJSONObject(imageIndex).getString("url");
                    }

                    list.add(new AlbumDTO(title, artist, image));

                    System.out.println("[Spotify API] Top Song " + list.size() + ": " + title + " by " + artist + " [" + albumType + "]");

                } catch (Exception e) {
                    System.err.println("[Spotify API] Error parsing song at index " + i);
                    e.printStackTrace();
                }
            }
            
            System.out.println("[Spotify API] Successfully processed " + list.size() + " top songs");

        } catch (Exception e) {
            System.err.println("[Spotify API] Weekly Top Songs error:");
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Get Top Albums
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
            System.out.println("[Spotify API] Top Albums Response Code: " + responseCode);
            
            if (responseCode != 200) {
                System.err.println("[Spotify API] Top Albums request failed");
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
            System.out.println("[Spotify API] Top Albums JSON (preview): " + 
                               jsonString.substring(0, Math.min(jsonString.length(), 300)) + "...");
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");
            
            if (items.length() == 0) {
                System.out.println("[Spotify API] No top albums found");
                return list;
            }

            System.out.println("[Spotify API] Processing " + items.length() + " top albums...");

            for (int i = 0; i < items.length(); i++) {
                try {
                    JSONObject item = items.getJSONObject(i);
                    
                    String title = item.getString("name");
                    String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                    
                    JSONArray images = item.getJSONArray("images");
                    String image = "";
                    
                    if (images.length() > 0) {
                        int imageIndex = images.length() > 1 ? 1 : 0;
                        image = images.getJSONObject(imageIndex).getString("url");
                    }

                    AlbumDTO albumDTO = new AlbumDTO(title, artist, image);
                    list.add(albumDTO);
                    
                    System.out.println("[Spotify API] Top Album " + (i+1) + ": " + title + " by " + artist);
                    
                } catch (Exception e) {
                    System.err.println("[Spotify API] Error parsing top album at index " + i);
                    e.printStackTrace();
                }
            }
            
            System.out.println("[Spotify API] Successfully processed " + list.size() + " top albums");

        } catch (Exception e) {
            System.err.println("[Spotify API] Exception during Top Albums fetch:");
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

                list.add(new AlbumDTO(title, artist, image, duration, formattedDate));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Trending Songs 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Helper method to fetch albums from API
     */
    private List<AlbumDTO> fetchAlbumsFromAPI(String accessToken, String apiUrl, String type) {
        List<AlbumDTO> list = new ArrayList<>();

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            int responseCode = conn.getResponseCode();
            System.out.println("[Spotify API] " + type + " Response Code: " + responseCode);
            
            if (responseCode != 200) {
                System.err.println("[Spotify API] " + type + " request failed");
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
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");
            
            if (items.length() == 0) {
                System.out.println("[Spotify API] No " + type + " found");
                return list;
            }

            System.out.println("[Spotify API] Processing " + items.length() + " " + type + "...");

            for (int i = 0; i < items.length(); i++) {
                try {
                    JSONObject item = items.getJSONObject(i);
                    
                    String title = item.getString("name");
                    String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                    
                    JSONArray images = item.getJSONArray("images");
                    String image = "";
                    
                    if (images.length() > 0) {
                        int imageIndex = images.length() > 1 ? 1 : 0;
                        image = images.getJSONObject(imageIndex).getString("url");
                    }

                    AlbumDTO album = new AlbumDTO(title, artist, image);
                    list.add(album);
                    
                    System.out.println("[Spotify API] " + type + " " + (i+1) + ": " + title + " by " + artist);
                    
                } catch (Exception e) {
                    System.err.println("[Spotify API] Error parsing " + type + " at index " + i);
                    e.printStackTrace();
                }
            }
            
            System.out.println("[Spotify API] Successfully processed " + list.size() + " " + type);

        } catch (Exception e) {
            System.err.println("[Spotify API] Exception during " + type + " fetch:");
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
                list.add(new AlbumDTO(title, artist, image, duration, formattedDate));
            }

        } catch (Exception e) {
            System.err.println("[Spotify API] Search Tracks 파싱 중 Exception 발생:");
            e.printStackTrace();
        }
        
        return list;
    }
    
}