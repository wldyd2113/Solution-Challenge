package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.request.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.request.MessageDto;
import com.gdsc.solutionchallenge.dto.response.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.response.OldestDiaryResponseDto;
import com.gdsc.solutionchallenge.repository.DiaryRepository;
import com.gdsc.solutionchallenge.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryService {
    private final DiaryRepository diaryRepository;
    private final UserRepository userRepository;
    @Transactional
    public DiaryResponseDto writeDiary(DiaryRequestDto requestDto, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        String userDate = requestDto.getDate();
        if (diaryRepository.existsByDateAndUser(userDate, user)) {
            throw new IllegalArgumentException("해당 날짜에는 이미 일기가 작성되었습니다.");
        }
        Diary diary = Diary.create(requestDto, user);
        Diary savedDiary = diaryRepository.save(diary);
        return DiaryResponseDto.of(savedDiary);
    }
    @Transactional
    public DiaryResponseDto getDiary(String date, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        Diary diary = diaryRepository.findByDateAndUser(date, user)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 날짜의 일기를 찾을 수 없습니다."));
        return diary.toDto();
    }
    @Transactional
    public OldestDiaryResponseDto getOldestDiary(Long userId, String emotion){
        diaryRepository.findUncheeredDiaries(LocalDateTime.now().minusMinutes(30))
                .forEach(diary ->{
                        diary.setViewed(false);
                        diary.setViewedAt(null);
                });

        User loggedInUser = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        Diary oldestDiary = diaryRepository.findOldestDiary(loggedInUser, emotion)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기를 찾을 수 없습니다."));
        oldestDiary.setViewed(true);
        oldestDiary.setViewedAt(LocalDateTime.now());
        diaryRepository.save(oldestDiary);
        return oldestDiary.toOldestDto();
    }

    @Transactional
    public DiaryResponseDto writeMessage(MessageDto messageDto, Long diaryId, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        Diary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기는 존재하지 않습니다."));
        diary.setCheeringMessage(messageDto.getCheeringMessage());
        diary.setMessageLocation(user.getLocation());
        diaryRepository.save(diary);
        return DiaryResponseDto.of(diary);
    }

    @Transactional
    public Long getDiaryCount(Long userId){
        return userRepository.countDiariesByUserId(userId);
    }
}