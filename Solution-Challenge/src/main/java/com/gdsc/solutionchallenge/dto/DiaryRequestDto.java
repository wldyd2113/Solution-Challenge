package com.gdsc.solutionchallenge.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class DiaryRequestDto {

    private String emotion;
    private String secretDiary;
    private String shareDiary;
}
