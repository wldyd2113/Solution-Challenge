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
                .userName(user.getName())
                .title(myPostRequestDto.getTitle())
                .body(myPostRequestDto.getBody())
                .user(user)
                .build();

        MyPost savedMyPost = myPostRepository.save(newMyPost);
        return savedMyPost.toDto();
    }

    @Transactional
    public MyPostResponseDto findMyPostById(Long myPostId){
        MyPost myPost = myPostRepository.findById(myPostId)
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));

        return myPost.toDto();
    }
}
