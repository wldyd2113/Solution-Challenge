package com.gdsc.solutionchallenge.dto.response;

import com.gdsc.solutionchallenge.domain.Diary;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class DiaryResponseDto {
    private Long id;
    private String emotion;
    private String secretDiary;
    private String shareDiary;
    private String cheeringMessage;
    private LocalDateTime createdAt;
    private String date;
    private String errorMessage;

    @Builder
    private DiaryResponseDto(Long id, String emotion, String secretDiary, String shareDiary, String cheeringMessage, LocalDateTime createdAt, String date) {
        this.id = id;
        this.emotion = emotion;
        this.secretDiary = secretDiary;
        this.shareDiary = shareDiary;
        this.cheeringMessage = cheeringMessage;
        this.createdAt = createdAt;
        this.date = date;
    }

    public DiaryResponseDto(String message) {
        this.errorMessage = message;
    }

    public static DiaryResponseDto of(Diary diary) {
        return DiaryResponseDto.builder()
                .id(diary.getId())
                .emotion(diary.getEmotion())
                .secretDiary(diary.getSecretDiary())
                .shareDiary(diary.getShareDiary())
                .cheeringMessage(diary.getCheeringMessage())
                .createdAt(diary.getCreatedAt())
                .date(diary.getDate())
                .build();
    }


}
