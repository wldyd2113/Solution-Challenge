package com.gdsc.solutionchallenge.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.security.Principal;

@Builder
@Getter
@Setter
public class OldestDiaryResponseDto {
    private Long id;
    private String shareDiary;
    private String emotion;
    private String location;

}
