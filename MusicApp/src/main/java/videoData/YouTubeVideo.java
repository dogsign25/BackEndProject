package videoData;

public class YouTubeVideo {
	private String videoId;
    private String title;
    private String thumbnailUrl;
    private String channelTitle;
    private String publishedAt;
    
    public YouTubeVideo(String videoId, String title, String thumbnailUrl, 
                       String channelTitle, String publishedAt) {
        this.videoId = videoId;
        this.title = title;
        this.thumbnailUrl = thumbnailUrl;
        this.channelTitle = channelTitle;
        this.publishedAt = publishedAt;
    }
    
    // Getters
    public String getVideoId() { return videoId; }
    public String getTitle() { return title; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public String getChannelTitle() { return channelTitle; }
    public String getPublishedAt() { return publishedAt; }
}
