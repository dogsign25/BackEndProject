package videoData;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class YouTubeService {

    private static final String API_KEY = "AIzaSyDejkq1OLtVOWv7BpTAD9TZ2krUFJ3hlV8";
    
    /**
     * 아티스트와 곡 제목으로 YouTube에서 라이브/커버 영상 검색
     * 
     * @param artist 아티스트 이름
     * @param title 곡 제목
     * @param maxResults 최대 검색 결과 개수 (기본 4개)
     * @return YouTube 영상 리스트
     */
    public List<YouTubeVideo> searchVideos(String artist, String title, int maxResults) {
        List<YouTubeVideo> videos = new ArrayList<>();
        
        try {
            // 검색어 구성: "아티스트 - 곡제목 live OR cover"
            String searchQuery = artist + " " + title + " (live OR cover OR performance)";
            String encodedQuery = URLEncoder.encode(searchQuery, "UTF-8");
            
            String apiUrl = String.format(
                "https://www.googleapis.com/youtube/v3/search?part=snippet&q=%s&type=video&maxResults=%d&key=%s",
                encodedQuery, maxResults, API_KEY
            );
            
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[YouTube API] 검색 요청 실패. Response Code: " + responseCode);
                return videos;
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
            JSONArray items = root.getJSONArray("items");
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                JSONObject id = item.getJSONObject("id");
                JSONObject snippet = item.getJSONObject("snippet");
                
                String videoId = id.getString("videoId");
                String videoTitle = snippet.getString("title");
                String thumbnailUrl = snippet.getJSONObject("thumbnails")
                                            .getJSONObject("medium")
                                            .getString("url");
                String channelTitle = snippet.getString("channelTitle");
                String publishedAt = snippet.getString("publishedAt");
                
                videos.add(new YouTubeVideo(videoId, videoTitle, thumbnailUrl, 
                                           channelTitle, publishedAt));
            }
            
            System.out.println("[YouTube API] " + videos.size() + "개의 영상을 찾았습니다.");
            
        } catch (Exception e) {
            System.err.println("[YouTube API] 검색 중 예외 발생:");
            e.printStackTrace();
        }
        
        return videos;
    }
    
    /**
     * searchVideos 메서드의 오버로드 버전 (기본 4개 검색)
     */
    public List<YouTubeVideo> searchVideos(String artist, String title) {
        return searchVideos(artist, title, 4);
    }
}