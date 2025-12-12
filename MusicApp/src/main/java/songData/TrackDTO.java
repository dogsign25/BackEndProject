package songData;

/**
 * 개별 트랙(곡) 정보를 담는 DTO
 */
public class TrackDTO {
    private String title;        // 곡 제목
    private String artist;       // 아티스트 이름
    private String imageUrl;     // 앨범 커버 이미지 URL
    private String duration;     // 재생 시간 (3:26 형식)
    private String releaseDate;  // 발매일
    private String spotifyId;    // Spotify 트랙 ID (재생용)
    private String albumName;    // 앨범 이름
    
    // 기본 생성자
    public TrackDTO() {
    }
    
    // 기본 생성자 (4개 파라미터)
    public TrackDTO(String title, String artist, String imageUrl, String spotifyId) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.spotifyId = spotifyId;
    }
    
    // 전체 생성자 (7개 파라미터)
    public TrackDTO(String title, String artist, String imageUrl, String duration, 
                    String releaseDate, String spotifyId, String albumName) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.duration = duration;
        this.releaseDate = releaseDate;
        this.spotifyId = spotifyId;
        this.albumName = albumName;
    }
    
    // Getters and Setters
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getArtist() {
        return artist;
    }
    
    public void setArtist(String artist) {
        this.artist = artist;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public String getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public String getSpotifyId() {
        return spotifyId;
    }
    
    public void setSpotifyId(String spotifyId) {
        this.spotifyId = spotifyId;
    }
    
    public String getAlbumName() {
        return albumName;
    }
    
    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }
}