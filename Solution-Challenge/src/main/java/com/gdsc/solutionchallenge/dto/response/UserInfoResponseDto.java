package com.gdsc.solutionchallenge.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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
}
