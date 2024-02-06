package com.gdsc.solutionchallenge.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserInfoResponseDto {
    String email;
    String name;
    int age;
    String location;
    String language;
    String job;
    String sex;
    Long diaryCount;
}
