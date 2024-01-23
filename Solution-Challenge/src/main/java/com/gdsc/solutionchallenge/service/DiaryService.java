package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.UserRequestDto;
import com.gdsc.solutionchallenge.repository.DiaryRepository;
import com.gdsc.solutionchallenge.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class DiaryService {
    private final DiaryRepository diaryRepository;
    private final UserService userService;
    private final UserRepository userRepository;

    public DiaryResponseDto writeDiary(DiaryRequestDto requestDto, Long userId){
        User user = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        Diary diary = Diary.create(requestDto, user);
        Diary savedDiary = diaryRepository.save(diary);
        return DiaryResponseDto.of(savedDiary);
    }
    public DiaryResponseDto getDiary(Long diaryId){
        Diary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new IllegalArgumentException("해당하는 일기는 존재하지 않습니다."));
        return diary.toDto();
    }

}
