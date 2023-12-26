package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.EmailCheckDto;
import com.gdsc.solutionchallenge.dto.EmailRequestDto;
import com.gdsc.solutionchallenge.service.MailService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/mail")
@RequiredArgsConstructor
public class MailController {
    private final MailService mailService;


    @PostMapping("/auth")
    public String mailSend(@RequestBody @Valid EmailRequestDto emailDto){
        System.out.println("이메일 인증 이메일 : "+emailDto.getEmail());
        return mailService.joinEmail(emailDto.getEmail());
    }
    @PostMapping("/authCheck")
    public String authCheck(@RequestBody @Valid EmailCheckDto emailCheckDto){
        Boolean checked=mailService.CheckAuthNum(emailCheckDto.getEmail(), emailCheckDto.getAuthNum());
        if(checked){
            return "ok";
        } else {
            throw new NullPointerException("오류!");
        }

    }
}
