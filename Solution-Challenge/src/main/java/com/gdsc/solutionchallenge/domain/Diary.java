//package com.gdsc.solutionchallenge.domain;
//
//import com.gdsc.solutionchallenge.dto.DiaryRequestDto;
//import com.gdsc.solutionchallenge.dto.DiaryResponseDto;
//import jakarta.persistence.*;
//import lombok.*;
//import org.hibernate.annotations.UpdateTimestamp;
//
//import java.time.LocalDate;
//
//@Entity
//@Getter
//@NoArgsConstructor
//@AllArgsConstructor
//public class Diary {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    @Column(name = "DIARY_ID")
//    private Long id;
//
//    @Column(name = "EMMOTION")
//    private String emotion;
//    @Column(name = "SECRETDIARY")
//    private String secretDiary;
//    @Column(name = "SHAREDIARY")
//    private String shareDiary;
//    @UpdateTimestamp
//    @Temporal(TemporalType.TIMESTAMP)
//    @Column(name = "CREATED_AT", updatable = false)
//    private LocalDate date;
//
//    @ManyToOne
//    @JoinColumn(name = "USER_ID")
//    private User user;
//
//    @Builder
//    public Diary(String emotion, String secretDiary, String shareDiary, User user){
//        this.emotion = emotion;
//        this.secretDiary = secretDiary;
//        this.shareDiary = shareDiary;
//        this.user = user;
//    }
//    public DiaryResponseDto toDto(){
//        DiaryResponseDto diaryResponseDto = DiaryResponseDto.builder()
//                .title(this.getSecretDiary())
//                .bdy(this.getShareDiary())
//                .emotion(this.getEmotion())
//                .createdAt(this.getCreatedAt())
//                .build();
//        return diaryResponseDto;
//    }
//
//}
