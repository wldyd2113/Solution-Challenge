package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.request.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.response.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.request.MessageDto;
import com.gdsc.solutionchallenge.dto.response.OldestDiaryResponseDto;
import com.gdsc.solutionchallenge.repository.UserRepository;
import com.gdsc.solutionchallenge.service.DiaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;
    private final UserRepository userRepository;

    @PostMapping("/save")
    // localhost:8080/diary/save        { "emotion" : "", "secretDiary" : "", "shareDiary" : "", "date" : "너가 보내줄 달력 날짜"} 일기 저장
    public ResponseEntity<DiaryResponseDto> writeDiary(@RequestBody DiaryRequestDto diaryRequestDto, Principal principal) {
        Long userId = Long.parseLong(principal.getName());
        DiaryResponseDto diary = diaryService.writeDiary(diaryRequestDto, userId);
        return new ResponseEntity<>(diary, HttpStatus.CREATED);
    }

    @GetMapping("/{date}")
    // localhost:8080/diary/{diaryId}   일기 조회 반환 값{Long id, String emotion, String secretDiary, String shareDiary, String message, LocalDateTime date}
    public ResponseEntity<DiaryResponseDto> getDiaryById(@PathVariable String date, Principal principal) {
        Long userId = Long.parseLong(principal.getName());
        DiaryResponseDto diary = diaryService.getDiary(date, userId);
        return new ResponseEntity<>(diary, HttpStatus.OK);
    }

    @GetMapping("/oldest")  // localhost:8080/diary/oldezst     가장 오래된 공유 일기 조회 반환 값{ Long id, String shareDiary }
    public ResponseEntity<OldestDiaryResponseDto> getOldestDiary(Principal principal) {
        Long userId = Long.parseLong(principal.getName());
        OldestDiaryResponseDto diary = diaryService.getOldestDiary(userId);
        return new ResponseEntity<>(diary, HttpStatus.OK);
    }

    @PostMapping("/writeMessage/{diaryId}")
    // localhost:8080/diary/writeMessage/{diaryId}    응원메세지 작성 { "message" : "" }
    public ResponseEntity<DiaryResponseDto> writeMessage(@RequestBody MessageDto messageDto, @PathVariable Long diaryId, Principal principal) {
        Long userId = Long.parseLong(principal.getName());
        DiaryResponseDto result = diaryService.writeMessage(messageDto, diaryId, userId);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

}