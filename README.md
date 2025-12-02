# 이번주 해야 할 일!!!!
- 구현할 거 옆에 이름 적어주세요

## 폴더, 경로 정리 - 나민혁

## 좋아요 누르기 - 김민서

## 유튜브 API랑 연동 - 김동진

## 관리자 페이지 기능 추가 - 김동진 (진행 중)



# 데이터베이스

## 플레이리스트 테이블
```sql
CREATE TABLE playlists (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES members(id) ON DELETE CASCADE
);

CREATE TABLE playlist_songs (
    playlist_song_id INT AUTO_INCREMENT PRIMARY KEY,
    playlist_id INT NOT NULL,
    track_spotify_id VARCHAR(255) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    UNIQUE KEY (playlist_id, track_spotify_id)
);
```

## 회원 테이블

```

-- 회원 테이블
CREATE TABLE IF NOT EXISTS members (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '자동으로 증가하는 회원 코드 insert X',
    name VARCHAR(100) NOT NULL COMMENT '회원 이름',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT '이메일 (로그인 ID)',
    password VARCHAR(255) NOT NULL COMMENT '암호화된 비밀번호',
    phone VARCHAR(20) COMMENT '전화번호',
    birthdate DATE COMMENT '생년월일',
    type ENUM('free', 'premium','admin') DEFAULT 'free' COMMENT '회원 유형',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '회원 상태',
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    last_login DATETIME COMMENT '최근 접속일',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_join_date (join_date)
)


```

삽입

```
INSERT INTO members (name, email, password, phone, type, status, birthdate, join_date, last_login) VALUES
('김철수', 'kim@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-1234-5678', 'premium', 'active', '1990-05-15', '2024-01-15', '2024-11-15'),
('이영희', 'lee@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-2345-6789', 'free', 'active', '1992-08-20', '2024-02-20', '2024-11-14'),
('박민수', 'park@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-3456-7890', 'premium', 'inactive', '1988-03-10', '2024-03-10', '2024-10-20'),
('최지은', 'choi@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-4567-8901', 'free', 'suspended', '1995-12-05', '2024-04-05', '2024-09-15'),
('정대호', 'jung@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-5678-9012', 'premium', 'active', '1993-07-22', '2024-05-12', '2024-11-16'),
('강수진', 'kang@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-6789-0123', 'free', 'active', '1991-11-30', '2024-06-18', '2024-11-13'),
('윤서연', 'yoon@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-7890-1234', 'premium', 'active', '1994-02-14', '2024-07-25', '2024-11-17'),
('임재현', 'lim@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-8901-2345', 'free', 'active', '1989-09-08', '2024-08-30', '2024-11-12'),
('한지민', 'han@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-9012-3456', 'premium', 'active', '1996-04-25', '2024-09-14', '2024-11-18'),
('송민호', 'song@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-0123-4567', 'free', 'inactive', '1987-06-17', '2024-10-22', '2024-10-25');

```

만약에 취향 같은거 넣을거면 users에 필드 추가

<img width="963" height="843" alt="spotify" src="https://github.com/user-attachments/assets/9694b550-ea96-4ef3-b098-de7bbf652857" />

