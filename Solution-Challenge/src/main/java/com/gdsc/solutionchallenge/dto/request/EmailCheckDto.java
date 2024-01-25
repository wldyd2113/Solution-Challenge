package com.gdsc.solutionchallenge.dto.request;


import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class EmailCheckDto {
    @Email
    @NotEmpty(message = "유효한 이메 주소를 입력해 주세요")
    private String email;

    @NotEmpty(message = "인증 번호를 입력해 주세요")
    private String authNum;
}
