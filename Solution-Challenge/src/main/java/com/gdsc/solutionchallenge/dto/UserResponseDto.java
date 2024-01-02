package com.gdsc.solutionchallenge.dto;

import com.gdsc.solutionchallenge.domain.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserResponseDto {
    private String name;
    public static UserResponseDto of(User user){
        return new UserResponseDto(user.getName());
    }
}
