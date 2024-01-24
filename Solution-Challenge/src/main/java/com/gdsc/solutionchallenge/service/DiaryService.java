package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.repository.DiaryRepository;
import com.gdsc.solutionchallenge.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DiaryService {
    private final DiaryRepository diaryRepository;
    private final UserRepository userRepository;

    public DiaryResponseDto writeDiary(DiaryRequestDto requestDto, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        Diary diary = Diary.create(requestDto, user);
        Diary savedDiary = diaryRepository.save(diary);
        return DiaryResponseDto.of(savedDiary);
    }

    public DiaryResponseDto getDiary(String date) {
        Diary diary = diaryRepository.findByDate(date)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기는 존재하지 않습니다."));
        return diary.toDto();
    }

    public OldestDiaryResponseDto getOldestDiary(){
        Diary oldestDiary = diaryRepository.findOldestDiary()
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기는 존재하지 않습니다."));
        oldestDiary.setViewed(true);
        diaryRepository.save(oldestDiary);
        return oldestDiary.toOldestDto();
    }


    public DiaryResponseDto writeMessage(MessageDto messageDto, Long diaryId) {
        Diary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기는 존재하지 않습니다."));

        diary.setMessage(messageDto.getMessage());
        diaryRepository.save(diary);
        return DiaryResponseDto.of(diary);
    }

}
