package com.gdsc.solutionchallenge.domain;

import com.gdsc.solutionchallenge.dto.DiaryRequestDto;
import com.gdsc.solutionchallenge.dto.DiaryResponseDto;
import com.gdsc.solutionchallenge.dto.OldestDiaryResponseDto;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.Date;

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
    private String message;

    @Column(name = "IS_VIEWED")
    private boolean isViewed = false;

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_AT", updatable = false)
    private LocalDateTime date;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @Builder
    public Diary(String emotion, String secretDiary, String shareDiary, User user, LocalDateTime date){
        this.emotion = emotion;
        this.secretDiary = secretDiary;
        this.shareDiary = shareDiary;
        this.date = date;
        this.user = user;
    }
    public DiaryResponseDto toDto(){
        return DiaryResponseDto.builder()
                .id(this.id)
                .emotion(this.emotion)
                .secretDiary(this.secretDiary)
                .shareDiary(this.shareDiary)
                .date(this.date)
                .build();
    }
    public OldestDiaryResponseDto toOldestDto(){
        return OldestDiaryResponseDto.builder()
                .id(this.id)
                .shareDiary(this.shareDiary)
                .build();
    }

    public static Diary create(DiaryRequestDto requestDto, User user){
        return Diary.builder()
                .emotion(requestDto.getEmotion())
                .secretDiary(requestDto.getSecretDiary())
                .shareDiary(requestDto.getShareDiary())
                .user(user)
                .build();
    }

}
