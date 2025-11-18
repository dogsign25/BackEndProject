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
bash```
CREATE TABLE `users` (
	`user_id`	VARCHAR(36)	NOT NULL primary key,
	`username`	VARCHAR(30)	NOT NULL,
	`email`	VARCHAR(100)	NOT NULL,
	`password`	VARCHAR(255)	NOT NULL,
	`nickname`	VARCHAR(30)	NULL,
	`created_at`	DATETIME	NULL	DEFAULT CURRENT_TIMESTAMP,
    `adminCheck` boolean default false 
);
```

삽입
bash```
INSERT INTO `MusicApp`.`users` (`user_id`, `username`, `email`, `password`, `nickname`, `created_at`, `adminCheck`)
VALUES ('admin', '어드민', 'admin@gmail.com', '1234', '관리자', now(), true);
```

