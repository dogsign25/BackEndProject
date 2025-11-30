package songData;

import java.util.List;

/**
 * 앨범 정보를 담는 DTO (여러 트랙 포함 가능)
 */
public class AlbumDTO {
    private String albumName;      // 앨범 제목
    private String artist;         // 아티스트 이름
    private String imageUrl;       // 앨범 커버 이미지 URL
    private String releaseDate;    // 발매일
    private String spotifyAlbumId; // Spotify 앨범 ID
    private int totalTracks;       // 총 트랙 수
    private List<TrackDTO> tracks; // 앨범에 포함된 트랙 리스트
    
    // 기본 생성자
    public AlbumDTO() {
    }
    
    // 기본 생성자 (3개 파라미터 - 카드 표시용)
    public AlbumDTO(String albumName, String artist, String imageUrl) {
        this.albumName = albumName;
        this.artist = artist;
        this.imageUrl = imageUrl;
    }
    
    // 앨범 ID 포함 생성자 (4개 파라미터)
    public AlbumDTO(String albumName, String artist, String imageUrl, String spotifyAlbumId) {
        this.albumName = albumName;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.spotifyAlbumId = spotifyAlbumId;
    }
    
    // 전체 생성자
    public AlbumDTO(String albumName, String artist, String imageUrl, String releaseDate, 
                    String spotifyAlbumId, int totalTracks) {
        this.albumName = albumName;
        this.artist = artist;
        this.imageUrl = imageUrl;
        this.releaseDate = releaseDate;
        this.spotifyAlbumId = spotifyAlbumId;
        this.totalTracks = totalTracks;
    }
    
    // Getters and Setters
    public String getAlbumName() {
        return albumName;
    }
    
    public void setAlbumName(String albumName) {
        this.albumName = albumName;
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
    
    public String getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public String getSpotifyAlbumId() {
        return spotifyAlbumId;
    }
    
    public void setSpotifyAlbumId(String spotifyAlbumId) {
        this.spotifyAlbumId = spotifyAlbumId;
    }
    
    public int getTotalTracks() {
        return totalTracks;
    }
    
    public void setTotalTracks(int totalTracks) {
        this.totalTracks = totalTracks;
    }
    
    public List<TrackDTO> getTracks() {
        return tracks;
    }
    
    public void setTracks(List<TrackDTO> tracks) {
        this.tracks = tracks;
    }
}