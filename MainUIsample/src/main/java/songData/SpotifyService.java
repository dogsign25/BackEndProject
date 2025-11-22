package songData;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

public class SpotifyService {
    // 실제 발급받은 ID와 Secret을 입력하세요.
    private static final String CLIENT_ID = "55de3e8154e14951af8483654af23200";
    private static final String CLIENT_SECRET = "e1203c3b586342ebbfda21a5a6e6fc31";
    
    // 1. 액세스 토큰 획득
    public String getAccessToken() {
        // 실제 토큰 API 주소: https://accounts.spotify.com/api/token
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
                System.err.println("[Spotify API] 토큰 요청 실패. 에러 메시지 확인:");
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

    // 2. 신곡 데이터 가져오기 (JSON 파싱 포함)
    public List<AlbumDTO> getNewReleases(String accessToken) {
        List<AlbumDTO> list = new ArrayList<>();
        // 실제 New Releases API 주소: https://api.spotify.com/v1/browse/new-releases?limit=4
        String apiUrl = "https://api.spotify.com/v1/browse/new-releases?limit=4"; 

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            // 응답 코드 확인
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                 System.err.println("[Spotify API] New Releases 요청 실패. 응답 코드: " + responseCode);
                 // 401 Unauthorized 에러일 경우 토큰 만료 등 확인 필요
                 return list;
            }
            

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // --- JSON 파싱 및 디버깅 로직 (가장 중요한 부분) ---
            String jsonString = response.toString();
            
            // 데이터가 있는지 확인 (500자까지만 출력)
            System.out.println("[Spotify API] New Releases 원본 JSON 데이터: " + 
                               jsonString.substring(0, Math.min(jsonString.length(), 500)) + "...");
            
            JSONObject root = new JSONObject(jsonString);
            JSONObject albums = root.getJSONObject("albums");
            JSONArray items = albums.getJSONArray("items");
            
            if (items.length() == 0) {
                 System.out.println("[Spotify API] 0개의 신규 앨범이 검색되었습니다.");
            }

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                
                String title = item.getString("name"); 
                
                // 가수는 배열로 되어있으므로 첫 번째 가수의 이름만 가져옵니다.
                String artist = item.getJSONArray("artists").getJSONObject(0).getString("name");
                
                // 이미지는 중간 크기(인덱스 1)의 URL을 가져옵니다.
                String image = item.getJSONArray("images").getJSONObject(1).getString("url");

                // AlbumDTO에 담아 리스트에 추가합니다. (AlbumDTO 생성자에 imageUrl = image로 수정했는지 확인 필수!)
                list.add(new AlbumDTO(title, artist, image));
            }

        } catch (Exception e) {
            // 파싱 오류 발생 시 에러 메시지를 콘솔에 출력합니다.
            System.err.println("[Spotify API] 데이터 파싱 중 Exception 발생! JSON 구조 문제 가능성 높음:");
            e.printStackTrace();
        }
        
        return list; // 가공된 리스트 반환
    }
}