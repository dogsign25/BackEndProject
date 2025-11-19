# 이번주 해야 할 일!!!!
- 회원가입, 로그인
- 회원 마이페이지
- 관리자 페이지-회원 관리

# 1.음악 API
https://developer.spotify.com/documentation/web-api

# 2.음악 추천 알고리즘

# 3.음악 숏폼화

# 4.음악 관련 영상 띄우기

# 5.음악 커버곡 등록

# 6.옷 스타일 별 곡 추천

# 7.LP상품 구매 사이트

# 8.청취기록 업다운 퀴즈(포인트)

# 데이터베이스
회원 테이블

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
('송민호', 'song@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz', '010-0123-4567', 'free', 'inactive', '1987-06-17', '2024-10-22', '2024-10-25');

```

만약에 취향 같은거 넣을거면 users에 필드 추가

