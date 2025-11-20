package songData;

public class AlbumDTO {
	private String title;      // 노래 제목
    private String artist;    // 가수 이름
    private String imageUrl;  // 앨범 커버 이미지 URL (Spotify API에서 제공)
    
    public AlbumDTO(String title, String artist, String imageUrl) {
        this.title = title;
        this.artist = artist;
        this.imageUrl = imageUrl;
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
    
    
}
