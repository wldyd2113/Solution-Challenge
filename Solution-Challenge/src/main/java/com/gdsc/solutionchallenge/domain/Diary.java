package com.gdsc.solutionchallenge.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Setter
@Getter
@NoArgsConstructor
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
    private LocalDate date;

    @Builder
    public Diary(String emotion, String secretDiary, String shareDiary){
        this.emotion = emotion;
        this.secretDiary = secretDiary;
        this.shareDiary = shareDiary;
    }

}
