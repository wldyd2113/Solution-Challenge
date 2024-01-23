package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.DiaryResponseDto;
import com.gdsc.solutionchallenge.service.DiaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;

    @PostMapping("/save")
    public ResponseEntity<DiaryResponseDto> writeDiary(@RequestBody DiaryRequestDto diaryRequestDto, Principal principal) {
        Long userId = Long.parseLong(principal.getName());

        DiaryResponseDto diary = diaryService.writeDiary(diaryRequestDto, userId);

        return new ResponseEntity<>(diary, HttpStatus.CREATED);
    }
    @GetMapping("/{diaryId}")
    public ResponseEntity<DiaryResponseDto> getDiaryById(@PathVariable Long diaryId){
        DiaryResponseDto diary = diaryService.getDiary(diaryId);
        return new ResponseEntity<>(diary, HttpStatus.OK);
    }

}



