package songData;

import userData.DBConnection; // Assuming DBConnection is in userData package
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LikedSongDAO {

    /**
     * 사용자가 특정 곡에 좋아요를 추가합니다.
     *
     * @param userId 좋아요를 누른 사용자의 ID
     * @param spotifyId 좋아요를 누른 곡의 Spotify ID
     * @return 성공적으로 추가되면 1, 아니면 0
     * @throws SQLException 데이터베이스 접근 오류 시
     */
    public int addLikedSong(int userId, String spotifyId) throws SQLException {
        String sql = "INSERT INTO liked_songs (user_id, track_spotify_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, spotifyId);
            return pstmt.executeUpdate();
        }
    }

    /**
     * 사용자가 특정 곡에 좋아요를 취소합니다.
     *
     * @param userId 좋아요를 취소할 사용자의 ID
     * @param spotifyId 좋아요를 취소할 곡의 Spotify ID
     * @return 성공적으로 삭제되면 1, 아니면 0
     * @throws SQLException 데이터베이스 접근 오류 시
     */
    public int removeLikedSong(int userId, String spotifyId) throws SQLException {
        String sql = "DELETE FROM liked_songs WHERE user_id = ? AND track_spotify_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, spotifyId);
            return pstmt.executeUpdate();
        }
    }

    /**
     * 사용자가 특정 곡에 좋아요를 눌렀는지 여부를 확인합니다.
     *
     * @param userId 확인할 사용자의 ID
     * @param spotifyId 확인할 곡의 Spotify ID
     * @return 좋아요를 눌렀으면 true, 아니면 false
     * @throws SQLException 데이터베이스 접근 오류 시
     */
    public boolean isSongLiked(int userId, String spotifyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM liked_songs WHERE user_id = ? AND track_spotify_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, spotifyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * 사용자가 좋아요를 누른 모든 곡의 Spotify ID 목록을 가져옵니다.
     *
     * @param userId 좋아요 목록을 가져올 사용자의 ID
     * @return 좋아요를 누른 곡의 Spotify ID 목록
     * @throws SQLException 데이터베이스 접근 오류 시
     */
    public List<String> getLikedSongSpotifyIds(int userId) throws SQLException {
        List<String> spotifyIds = new ArrayList<>();
        String sql = "SELECT track_spotify_id FROM liked_songs WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    spotifyIds.add(rs.getString("track_spotify_id"));
                }
            }
        }
        return spotifyIds;
    }

    /**
     * (옵션) 좋아요를 누른 곡의 상세 정보를 가져옵니다.
     * 이 메서드는 Spotify API 연동이나 로컬 'songs' 테이블이 있다고 가정해야 합니다.
     * 현재는 Spotify ID만 반환하도록 구현. 실제 곡 정보를 가져오려면 추가 로직 필요.
     *
     * @param userId 좋아요 목록을 가져올 사용자의 ID
     * @return 좋아요를 누른 곡들의 TrackDTO 목록
     * @throws SQLException 데이터베이스 접근 오류 시
     */
    public List<TrackDTO> getLikedSongs(int userId) throws SQLException {
        List<TrackDTO> likedSongs = new ArrayList<>();
        List<String> spotifyIds = getLikedSongSpotifyIds(userId);

        if (spotifyIds.isEmpty()) {
            return likedSongs; // 빈 리스트 반환
        }

        // Spotify API 연동 로직 또는 로컬 songs 테이블에서 상세 정보를 가져오는 로직이 필요.
        // 현재는 예시를 위해 단순한 TrackDTO 객체를 생성합니다.
        // 실제 구현에서는 SpotifyService 등을 호출하여 TrackDTO를 채워야 합니다.
        // 이 부분은 나중에 Spotify API 연동 시 구체화될 수 있습니다.
        for (String spotifyId : spotifyIds) {
            // 여기에 SpotifyService.getTrackDetails(spotifyId) 같은 호출이 와야 함
            // 예시로 TrackDTO를 바로 생성합니다.
            TrackDTO track = new TrackDTO();
            track.setSpotifyId(spotifyId);
            // track.setTitle("Sample Title for " + spotifyId);
            // track.setArtist("Sample Artist");
            // track.setImageUrl("https://example.com/placeholder.jpg");
            likedSongs.add(track);
        }
        return likedSongs;
    }
}
