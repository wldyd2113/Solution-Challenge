package gdsc.controller;

import gdsc.dto.MyPostResponseDto;
import gdsc.dto.SendDiaryRequestDto;
import gdsc.dto.SendDiaryResponseDto;
import gdsc.service.DiaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/diary")
public class DiaryController {

    private final DiaryService diaryService;

    @Autowired
    public DiaryController(DiaryService diaryService) {
        this.diaryService = diaryService;
    }

    @PostMapping("/createAndSendRandom")
    public ResponseEntity<SendDiaryResponseDto> createAndSendRandomDiary(@RequestBody SendDiaryRequestDto sendDiaryRequestDto) {
        SendDiaryResponseDto createdAndSentDiary = diaryService.createAndSendRandomDiary(sendDiaryRequestDto);
        return new ResponseEntity<>(createdAndSentDiary, HttpStatus.CREATED);
    }

    @GetMapping("/findSendDiary")
    public ResponseEntity<List<SendDiaryResponseDto>> getPostsByUserAndDate(Principal principal,
                                                                         @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            // Principal을 이용하여 현재 로그인한 사용자의 정보를 가져올 수 있음
            // 여기에서는 간단하게 사용자의 ID만 가져왔다고 가정
            Long userId = Long.parseLong(principal.getName());

            // PostService를 사용하여 사용자의 ID와 날짜로 게시글 조회
            List<SendDiaryResponseDto> posts = diaryService.getPostsByUserAndDate(userId, date);

            return new ResponseEntity<>(posts, HttpStatus.OK);
        } catch (NullPointerException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }
    // 현재 로그인한 사용자가 받은 일기 조회
    @GetMapping("/receivedDiaries")
    public ResponseEntity<List<SendDiaryResponseDto>> getReceivedDiariesForCurrentUser(Principal principal) {
        try {
            // Principal을 이용하여 현재 로그인한 사용자의 정보를 가져옴
            // 여기에서는 간단하게 사용자의 ID만 가져왔다고 가정
            Long userId = Long.parseLong(principal.getName());

            // DiaryService를 사용하여 사용자의 ID로 받은 일기 조회
            List<SendDiaryResponseDto> receivedDiaries = diaryService.getReceivedDiariesForUser(userId);

            return new ResponseEntity<>(receivedDiaries, HttpStatus.OK);
        } catch (NullPointerException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }

}