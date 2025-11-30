package userData;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import songData.PlaylistDTO;

public class PlaylistDAO {

    /**
     * Creates a new playlist for a given user.
     * @param name The name of the playlist.
     * @param userId The ID of the user creating the playlist.
     * @return true if the playlist was created successfully, false otherwise.
     */
    public boolean createPlaylist(String name, int userId) {
        String sql = "INSERT INTO playlists (user_id, name) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, name);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating playlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Adds a song to a specified playlist.
     * @param playlistId The ID of the playlist.
     * @param trackSpotifyId The Spotify ID of the track to add.
     * @return true if the song was added successfully, false otherwise.
     */
    public boolean addSongToPlaylist(int playlistId, String trackSpotifyId) {
        String sql = "INSERT INTO playlist_songs (playlist_id, track_spotify_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setString(2, trackSpotifyId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            // UNIQUE constraint violation (code 1062 for MySQL) likely means the song is already in the playlist.
            if (e.getErrorCode() == 1062) {
                System.err.println("Song is already in the playlist.");
                return false;
            }
            System.err.println("Error adding song to playlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all playlists owned by a specific user.
     * @param userId The ID of the user.
     * @return A list of PlaylistDTO objects.
     */
    public List<PlaylistDTO> getPlaylistsByUserId(int userId) {
        List<PlaylistDTO> playlists = new ArrayList<>();
        String sql = "SELECT p.playlist_id, p.user_id, p.name, p.created_at, " +
                     "COUNT(ps.track_spotify_id) AS song_count " +
                     "FROM playlists p " +
                     "LEFT JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id " +
                     "WHERE p.user_id = ? " +
                     "GROUP BY p.playlist_id, p.user_id, p.name, p.created_at " +
                     "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                PlaylistDTO playlist = new PlaylistDTO();
                playlist.setPlaylist_id(rs.getInt("playlist_id"));
                playlist.setUser_id(rs.getInt("user_id"));
                playlist.setName(rs.getString("name"));
                playlist.setCreated_at(rs.getTimestamp("created_at"));
                playlist.setSongCount(rs.getInt("song_count")); // Set the new songCount
                playlists.add(playlist);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving playlists: " + e.getMessage());
            e.printStackTrace();
        }
        
        return playlists;
    }
    
    /**
     * Retrieves all track Spotify IDs for a given playlist.
     * @param playlistId The ID of the playlist.
     * @return A list of track Spotify IDs.
     */
    public List<String> getTrackSpotifyIdsByPlaylistId(int playlistId) {
        List<String> trackIds = new ArrayList<>();
        String sql = "SELECT track_spotify_id FROM playlist_songs WHERE playlist_id = ? ORDER BY added_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                trackIds.add(rs.getString("track_spotify_id"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving track Spotify IDs from playlist: " + e.getMessage());
            e.printStackTrace();
        }

        return trackIds;
    }

    /**
     * Retrieves a single playlist by its ID, including the count of songs.
     * @param playlistId The ID of the playlist.
     * @return A PlaylistDTO object, or null if not found.
     */
    public PlaylistDTO getPlaylistById(int playlistId) {
        PlaylistDTO playlist = null;
        String sql = "SELECT p.playlist_id, p.user_id, p.name, p.created_at, " +
                     "COUNT(ps.track_spotify_id) AS song_count " +
                     "FROM playlists p " +
                     "LEFT JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id " +
                     "WHERE p.playlist_id = ? " +
                     "GROUP BY p.playlist_id, p.user_id, p.name, p.created_at";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                playlist = new PlaylistDTO();
                playlist.setPlaylist_id(rs.getInt("playlist_id"));
                playlist.setUser_id(rs.getInt("user_id"));
                playlist.setName(rs.getString("name"));
                playlist.setCreated_at(rs.getTimestamp("created_at"));
                playlist.setSongCount(rs.getInt("song_count"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving playlist by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return playlist;
    }

    /**
     * Deletes a playlist.
     * @param playlistId The ID of the playlist to delete.
     * @return true if deletion was successful, false otherwise.
     */
    public boolean deletePlaylist(int playlistId) {
        String sql = "DELETE FROM playlists WHERE playlist_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting playlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes a song from a playlist.
     * @param playlistId The ID of the playlist.
     * @param trackSpotifyId The Spotify ID of the track to remove.
     * @return true if removal was successful, false otherwise.
     */
    public boolean removeSongFromPlaylist(int playlistId, String trackSpotifyId) {
        String sql = "DELETE FROM playlist_songs WHERE playlist_id = ? AND track_spotify_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setString(2, trackSpotifyId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error removing song from playlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
