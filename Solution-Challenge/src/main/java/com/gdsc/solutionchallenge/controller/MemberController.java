package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.MemberRequestDto;
import com.gdsc.solutionchallenge.dto.MemberResponseDto;
import com.gdsc.solutionchallenge.dto.TokenDto;
import com.gdsc.solutionchallenge.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;

    @PostMapping("/signup/user")
    public ResponseEntity<MemberResponseDto> signup(@RequestBody MemberRequestDto memberRequestDto){
        return ResponseEntity.ok(memberService.signup(memberRequestDto));
    }
    @PostMapping("/signup/admin")
    public ResponseEntity<MemberResponseDto> adminSignup(@RequestBody MemberRequestDto memberRequestDto){
        return ResponseEntity.ok(memberService.adminSignup(memberRequestDto));
    }

    @PostMapping("/login")
    public ResponseEntity<TokenDto> login(@RequestBody MemberRequestDto memberRequestDto){
        return ResponseEntity.ok(memberService.login(memberRequestDto));
    }
    @GetMapping("/user")
    public ResponseEntity<String> user(){
        return ResponseEntity.ok("Hello User");
    }
    @GetMapping("/admin")
    public ResponseEntity<String> admin(){
        return ResponseEntity.ok("Hello Admin");
    }
}
