package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.ApiResponse;
import com.gdsc.solutionchallenge.dto.request.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.response.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.request.MessageDto;
import com.gdsc.solutionchallenge.dto.response.OldestDiaryResponseDto;
import com.gdsc.solutionchallenge.service.DiaryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
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

    @PostMapping("/save") // localhost:8080/diary/save        { "emotion" : "", "secretDiary" : "", "shareDiary" : "", "date" : "너가 보내줄 달력 날짜"} 일기 저장
    public ApiResponse<DiaryResponseDto> writeDiary(@RequestBody DiaryRequestDto diaryRequestDto, Principal principal) {
        Long userId = Long.parseLong(principal.getName());
        DiaryResponseDto diary = diaryService.writeDiary(diaryRequestDto, userId);
        return ApiResponse.created(diary);
    }
    @ApiOperation(value = "일기 조회하는 메소드")
    @GetMapping("/{date}") // localhost:8080/diary/{diaryId}   일기 조회 반환 값{Long id, String emotion, String secretDiary, String shareDiary, String message, LocalDateTime date}
    public ApiResponse<DiaryResponseDto> getDiaryById(@PathVariable String date){
        DiaryResponseDto diary = diaryService.getDiary(date);
        return ApiResponse.ok(diary);
    }
    @GetMapping("/oldest")  // localhost:8080/diary/oldest     가장 오래된 공유 일기 조회 반환 값{ Long id, String shareDiary, String emotion }
    public ApiResponse<OldestDiaryResponseDto> getOldestDiary(){
        OldestDiaryResponseDto diary = diaryService.getOldestDiary();
        return ApiResponse.ok(diary);
    }

    @PostMapping("/writeMessage/{diaryId}") // localhost:8080/diary/writeMessage/{diaryId}    응원메세지 작성 { "message" : "" }
    public ApiResponse<DiaryResponseDto> writeMessage(@RequestBody MessageDto messageDto, @PathVariable Long diaryId){
        DiaryResponseDto result = diaryService.writeMessage(messageDto, diaryId);
        return ApiResponse.ok(result);
    }
}
