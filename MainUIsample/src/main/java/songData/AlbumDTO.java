package songData;

public class AlbumDTO {
    private String title;      // 노래 제목
    private String artist;     // 가수 이름
    private String imageUrl;   // 앨범 커버 이미지 URL
    private String duration;   // 음악 길이 (3:26 형식)
    private String releaseDate; // 발매일 (옵션)
    
    // 기본 생성자 (3개 파라미터)
    public AlbumDTO(String title, String artist, String imageUrl) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
    }
    
    // duration 포함 생성자 (4개 파라미터)
    public AlbumDTO(String title, String artist, String imageUrl, String duration) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.duration = duration;
    }
    
    // 모든 필드 포함 생성자 (5개 파라미터)
    public AlbumDTO(String title, String artist, String imageUrl, String duration, String releaseDate) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.duration = duration;
        this.releaseDate = releaseDate;
    }
    
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
}