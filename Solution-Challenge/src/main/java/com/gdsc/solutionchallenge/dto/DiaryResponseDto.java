package com.gdsc.solutionchallenge.dto;

import com.gdsc.solutionchallenge.domain.Diary;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.Date;

@Builder
@Getter
public class DiaryResponseDto {
    private Long id;
    private String emotion;
    private String secretDiary;
    private String shareDiary;
    private String message;
    private LocalDateTime date;


    @Builder
    private DiaryResponseDto(Long id, String emotion, String secretDiary, String shareDiary, String message, LocalDateTime date){
        this.id = id;
        this.emotion = emotion;
        this.secretDiary = secretDiary;
        this.shareDiary = shareDiary;
        this.message = message;
        this.date = date;
    }

    public static DiaryResponseDto of(Diary diary){
        return DiaryResponseDto.builder()
                .id(diary.getId())
                .emotion(diary.getEmotion())
                .secretDiary(diary.getSecretDiary())
                .shareDiary(diary.getShareDiary())
                .message(diary.getMessage())
                .date(diary.getDate())
                .build();
    }

}
