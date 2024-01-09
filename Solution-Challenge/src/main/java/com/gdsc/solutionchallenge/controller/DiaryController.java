//package com.gdsc.solutionchallenge.controller;
//
//import com.gdsc.solutionchallenge.dto.DiaryRequestDto;
//import com.gdsc.solutionchallenge.dto.DiaryResponseDto;
//import com.sun.net.httpserver.HttpsExchange;
//import lombok.RequiredArgsConstructor;
//import org.springframework.format.annotation.DateTimeFormat;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.security.Principal;
//import java.time.LocalDate;
//import java.util.List;
//
//@RestController
//@RequestMapping("/diary")
//@RequiredArgsConstructor
//public class DiaryController {
//
//    private final DiaryService diaryService;
//
//    @PostMapping("/save")
//    public ResponseEntity<DiaryResponseDto> writeDiary(@RequestBody DiaryRequestDto diaryRequestDto, Principal principal) {
//        try {
//            Long userId = Long.parseLong(principal.getName());
//
//            DiaryResponseDto writedDiary = diaryService.writeDiary(diaryRequestDto, userId);
//
//            return new ResponseEntity<>(writedDiary, HttpStatus.CREATED);
//        } catch (NullPointerException e) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
//        }
//    }
//
//    @GetMapping()
//    public ResponseEntity<List<DiaryResponseDto>> getDiary(Principal principal, LocalDate date) {
//        try {
//            Long userId = Long.parseLong(principal.getName());
//
//            List<DiaryResponseDto> diarys = diaryService.getDiary(userId, date);
//
//            return new ResponseEntity<>(diarys, HttpStatus.OK);
//        } catch (NullPointerException e) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
//        }
//
//    }
//}
