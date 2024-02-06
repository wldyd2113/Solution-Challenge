package com.gdsc.solutionchallenge.domain;

import com.gdsc.solutionchallenge.dto.request.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.response.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.response.OldestDiaryResponseDto;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Diary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DIARY_ID")
    private Long id;

    @Column(name = "EMMOTION")
    private String emotion;

    @Column(name = "SECRETDIARY")
    private String secretDiary;

    @Column(name = "SHAREDIARY")
    private String shareDiary;

    @Column(name = "MESSAGE")
    private String cheeringMessage;

    @Column(name = "IS_VIEWED")
    private boolean isViewed = false;

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_AT", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "DATE")
    private String date;

    @Column(name = "MESSAGE_LOCATION")
    private String messageLocation;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;



    @Builder
    public Diary(String emotion, String secretDiary, String shareDiary, User user, String date, LocalDateTime createdAt){
        this.emotion = emotion;
        this.secretDiary = secretDiary;
        this.shareDiary = shareDiary;
        this.createdAt = createdAt;
        this.date = date;
        this.user = user;
    }
    public DiaryResponseDto toDto(){
        return DiaryResponseDto.builder()
                .id(this.id)
                .emotion(this.emotion)
                .secretDiary(this.secretDiary)
                .shareDiary(this.shareDiary)
                .createdAt(this.createdAt)
                .cheeringMessage(this.cheeringMessage)
                .date(this.date)
                .messageLocation(this.messageLocation)
                .build();
    }
    public OldestDiaryResponseDto toOldestDto(){
        return OldestDiaryResponseDto.builder()
                .id(this.id)
                .emotion(this.emotion)
                .shareDiary(this.shareDiary)
                .location(this.user.getLocation())
                .build();
    }

    public static Diary create(DiaryRequestDto requestDto, User user){
        return Diary.builder()
                .emotion(requestDto.getEmotion())
                .secretDiary(requestDto.getSecretDiary())
                .shareDiary(requestDto.getShareDiary())
                .date(requestDto.getDate())
                .user(user)
                .build();
    }

}