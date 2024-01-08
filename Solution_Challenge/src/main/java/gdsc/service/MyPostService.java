package gdsc.service;

import gdsc.domain.MyPost;
import gdsc.domain.User;
import gdsc.dto.MyPostRequestDto;
import gdsc.dto.MyPostResponseDto;
import gdsc.repository.MyPostRepository;
import gdsc.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MyPostService {

    private final MyPostRepository myPostRepository;
    private final UserRepository userRepository;

    @Transactional
    public MyPostResponseDto createMyPost(MyPostRequestDto myPostRequestDto, Long userId){
        User user=userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        MyPost newMyPost = MyPost.builder()
                .title(myPostRequestDto.getTitle())
                .body(myPostRequestDto.getBody())
                .emotion(myPostRequestDto.getEmotion())
                .user(user)
                .build();

        MyPost savedMyPost = myPostRepository.save(newMyPost);
        return savedMyPost.toDto();
    }

    @Transactional
    public List<MyPostResponseDto> getPostsByUserAndDate(Long userId, LocalDate date) {
        // 사용자의 ID로 User 객체를 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        // 사용자의 ID와 날짜로 게시글을 조회하는 작업 수행
        List<MyPost> posts = myPostRepository.findByUserAndCreatedAt(user, date);

        // 조회된 게시글을 MyPostResponseDto로 변환하여 반환
        return posts.stream()
                .map(MyPost::toDto)
                .collect(Collectors.toList());
    }
}

