package gdsc.controller;

import gdsc.dto.MyPostRequestDto;
import gdsc.dto.MyPostResponseDto;
import gdsc.service.MyPostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class MyPostController {

    private final MyPostService myPostService;


    /*@PostMapping("/save")
    public ResponseEntity<String> createPost(Principal principal, @RequestBody MyPostRequestDto myPostRequestDto) {
        myPostService.createMyPost(myPostRequestDto, Long.parseLong(principal.getName()));
        return new ResponseEntity<>("글 작성 완료", HttpStatus.OK);
    }*/

    @PostMapping("/save")
    public ResponseEntity<MyPostResponseDto> createPost(@RequestBody MyPostRequestDto myPostRequestDto, Principal principal) {
        try {
            // Principal을 이용하여 현재 로그인한 사용자의 정보를 가져올 수 있음
            // 여기에서는 간단하게 사용자의 ID만 가져왔다고 가정
            Long userId = Long.parseLong(principal.getName());

            // PostService를 사용하여 게시글 생성
            MyPostResponseDto createdPost = myPostService.createMyPost(myPostRequestDto, userId);

            return new ResponseEntity<>(createdPost, HttpStatus.CREATED);
        } catch (NullPointerException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }

    @GetMapping("/{postId}")
    public ResponseEntity<MyPostResponseDto> getPostById(@PathVariable Long postId) {
        // PostService를 사용하여 게시글 조회
        MyPostResponseDto post = myPostService.findMyPostById(postId);

        return ResponseEntity.ok(post);
    }

}
