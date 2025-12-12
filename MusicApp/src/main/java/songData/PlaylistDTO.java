package songData;

import java.sql.Timestamp;
import java.util.List;

public class PlaylistDTO {
    private int playlist_id;
    private int user_id;
    private String name;
    private Timestamp created_at;
    private List<TrackDTO> tracks; // To hold the songs in the playlist
    private int songCount; // New field for the number of songs in the playlist

    // Constructors
    public PlaylistDTO() {
    }

    public PlaylistDTO(int playlist_id, int user_id, String name, Timestamp created_at, int songCount) {
        this.playlist_id = playlist_id;
        this.user_id = user_id;
        this.name = name;
        this.created_at = created_at;
        this.songCount = songCount;
    }

    // Getters and Setters
    public int getPlaylist_id() {
        return playlist_id;
    }

    public void setPlaylist_id(int playlist_id) {
        this.playlist_id = playlist_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public List<TrackDTO> getTracks() {
        return tracks;
    }

    public void setTracks(List<TrackDTO> tracks) {
        this.tracks = tracks;
    }
    
    public int getSongCount() {
        return songCount;
    }

    public void setSongCount(int songCount) {
        this.songCount = songCount;
    }
}
