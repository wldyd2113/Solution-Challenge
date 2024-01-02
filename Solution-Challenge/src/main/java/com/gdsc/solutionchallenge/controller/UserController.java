package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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



}
