package gdsc.controller;

import gdsc.dto.MyPostRequestDto;
import gdsc.dto.MyPostResponseDto;
import gdsc.service.MyPostService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class MyPostController {

    private final MyPostService myPostService;


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
    @GetMapping("/findByUserAndDate")
    public ResponseEntity<List<MyPostResponseDto>> getPostsByUserAndDate(Principal principal,
                                                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            // Principal을 이용하여 현재 로그인한 사용자의 정보를 가져올 수 있음
            // 여기에서는 간단하게 사용자의 ID만 가져왔다고 가정
            Long userId = Long.parseLong(principal.getName());

            // PostService를 사용하여 사용자의 ID와 날짜로 게시글 조회
            List<MyPostResponseDto> posts = myPostService.getPostsByUserAndDate(userId, date);

            return new ResponseEntity<>(posts, HttpStatus.OK);
        } catch (NullPointerException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }
}
