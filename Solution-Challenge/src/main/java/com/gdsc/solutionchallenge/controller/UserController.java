package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.service.MailService;
import com.gdsc.solutionchallenge.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final TokenProvider tokenProvider;

    @PostMapping("/signup") // localhost:8080/user/signup  일반 회원가입 ( 이메일, 비밀번호 포함 모든 정보 )
    public ResponseEntity<UserResponseDto> signup(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.signup(userRequestDto));
    }
    @PostMapping("/googleSignup") // localhost:8080/user/googleSignup  구글 회원가입 (이메일, 비밀번호 미포함 정보)
    public ResponseEntity<UserResponseDto> googleSignup(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.googleSignup(userRequestDto));
    }

    @PostMapping("/login") // localhost:8080/user/login    로그인 ( 토큰 발급 )
    public ResponseEntity<TokenDto> login(@RequestBody UserRequestDto userRequestDto){
        return ResponseEntity.ok(userService.login(userRequestDto));
    }

    @GetMapping // localhost:8080/user    로그인 테스트
    public ResponseEntity<String> user(){
        return ResponseEntity.ok("Hello User");
    }


    @GetMapping("/admin")
    public ResponseEntity<String> admin(){
        return ResponseEntity.ok("Hello Admin");
    }

    @GetMapping("/email/{name}") // localhost:8080/user/email/{이름}   이름으로 이메일 찾기
    public ResponseEntity<String> findEmailByName(@PathVariable String name){
        String userEmail = userService.findEmailByName(name);
        return ResponseEntity.ok(userEmail);
    }

    @GetMapping("/password/{email}")  // localhost:8080/user/password/{email}   이메일로 비밀번호 찾기 ( 이메일 인증 필수 )
    public ResponseEntity<String> findPasswordByEmail(@PathVariable String email){
        String userPassword = userService.findPasswordByEmail(email);
        return ResponseEntity.ok(userPassword);
    }
    @PostMapping("/password")  // localhost:8080/user/password   비밀번호 변경  json { "currentPassword" : "현재 비밀번호 ", "newPassword" : "새로운 비밀번호" }
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordDto changePasswordDto){
        try {
            userService.changePassword(changePasswordDto);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/info")
    public ResponseEntity<String> user(@RequestHeader(name = HttpHeaders.AUTHORIZATION) String authorizationHeader) {
        String accessToken = authorizationHeader.replace("Bearer ", "");

        if (tokenProvider.validateToken(accessToken)) {
            org.springframework.security.core.Authentication authentication = tokenProvider.getAuthentication(accessToken);
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            String id = userDetails.getUsername();
            Optional<User> optionalUser = userService.getUserById(Long.parseLong(id));

            if (optionalUser.isPresent()) {
                String useremail = optionalUser.get().getEmail();
                String username = optionalUser.get().getName();
                int userage = optionalUser.get().getAge();
                String userlocation = optionalUser.get().getLocation();
                String userlanguage = optionalUser.get().getLanguage();
                String userjob = optionalUser.get().getJob();
                String usersex = optionalUser.get().getSex();
                return ResponseEntity.ok("user name: " + username + "\nuser email: " + useremail + "\nuser sex: "+ usersex + "\nuser age: " + userage + "\nuser job: " + userjob + "\nuser location: " + userlocation + "\nuser language: "+ userlanguage);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }

}
