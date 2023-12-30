package gdsc.controller;

import gdsc.dto.MyPostRequestDto;
import gdsc.dto.MyPostResponseDto;
import gdsc.service.MyPostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class MyPostController {

    private final MyPostService myPostService;

    @PreAuthorize("isAuthenticated()")
    @PostMapping("/save")
    public ResponseEntity<MyPostResponseDto> createPost(@RequestBody MyPostRequestDto myPostRequestDto, Principal principal) {
        // Principal이 null인 경우 사용자가 인증되지 않은 상태
        if (principal == null) {
            // 적절한 예외 처리 또는 오류 응답을 반환
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        // Principal이 null이 아닌 경우 사용자의 정보를 가져와서 사용
        Long userId = Long.parseLong(principal.getName());

        // PostService를 사용하여 게시글 생성
        MyPostResponseDto createdPost = myPostService.createMyPost(myPostRequestDto, userId);

        return new ResponseEntity<>(createdPost, HttpStatus.CREATED);
    }

}
