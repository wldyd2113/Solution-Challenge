package com.gdsc.solutionchallenge.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ChangePasswordDto {

    private String currentPassword;
    private String newPassword;

}