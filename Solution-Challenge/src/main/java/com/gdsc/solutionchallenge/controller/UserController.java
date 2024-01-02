package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<UserResponseDto> signup(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.signup(userRequestDto));
    }
    @PostMapping("/googleSignup")
    public ResponseEntity<UserResponseDto> googleSignup(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.googleSignup(userRequestDto));
    }
    @PostMapping("/signup/admin")
    public ResponseEntity<UserResponseDto> adminSignup(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.adminSignup(userRequestDto));
    }

    @PostMapping("/login")
    public ResponseEntity<TokenDto> login(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.login(userRequestDto));
    }

    @GetMapping
    public ResponseEntity<String> user(){
        return ResponseEntity.ok("Hello User");
    }


    @GetMapping("/admin")
    public ResponseEntity<String> admin(){
        return ResponseEntity.ok("Hello Admin");
    }

    @GetMapping("/email/{name}")
    public ResponseEntity<String> findEmailByName(@PathVariable String name){
        String userEmail = userService.findEmailByName(name);
        return ResponseEntity.ok(userEmail);
    }

    @GetMapping("/password/{email}")
    public ResponseEntity<String> findPasswordByEmail(@PathVariable String email){
        String userPassword = userService.findPasswordByEmail(email);
        return ResponseEntity.ok(userPassword);
    }

    @PostMapping("/password")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordDto changePasswordDto){
        try {
            userService.changePassword(changePasswordDto);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }





}
