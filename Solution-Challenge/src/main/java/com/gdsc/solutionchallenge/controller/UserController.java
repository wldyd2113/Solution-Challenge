package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.dto.request.ChangePasswordDto;
import com.gdsc.solutionchallenge.dto.request.UserRequestDto;
import com.gdsc.solutionchallenge.dto.response.UserResponseDto;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.UserRepository;
import com.gdsc.solutionchallenge.service.FirebaseAuthenticationService;
import com.gdsc.solutionchallenge.service.UserService;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.protobuf.Api;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final UserRepository userRepository;
    private final TokenProvider tokenProvider;
    private final FirebaseAuthenticationService firebaseAuthenticationService;

    @PostMapping("/signup") // localhost:8080/user/signup  일반 회원가입 ( 이메일, 비밀번호 포함 모든 정보 )
    public ApiResponse<UserResponseDto> signup(@RequestBody UserRequestDto userRequestDto){
        return ApiResponse.ok(userService.signup(userRequestDto));
    }
    @PostMapping("/googleSignup") // localhost:8080/user/googleSignup  구글 회원가입 (이메일, 비밀번호 미포함 정보)
    public ApiResponse<UserResponseDto> googleSignup(@RequestBody UserRequestDto userRequestDto){
        return ApiResponse.ok(userService.googleSignup(userRequestDto));
    }

    @PostMapping("/login") // localhost:8080/user/login    로그인 ( 토큰 발급 )
    public ApiResponse<TokenDto> login(@RequestBody UserRequestDto userRequestDto){
        return ApiResponse.ok(userService.login(userRequestDto));
    }

    @GetMapping // localhost:8080/user    로그인 테스트
    public ApiResponse<String> user(){
        return ApiResponse.ok("Hello User");
    }


    @GetMapping("/check/{email}") // localhost:8080/user/check/{email}   가입된 이메일인지 확인
    public ApiResponse<String> findEmail(@PathVariable String email){
        boolean exist = userRepository.existsByEmail(email);
        if(exist)
            return ApiResponse.ok("가입된 이메일");
        else
            return ApiResponse.ok("가입되지 않은 이메일");

    }

    @GetMapping("/password/{email}")  // localhost:8080/user/password/{email}   임시 비밀번호 발급 ( 이메일 인증 필수 )
    public ApiResponse<String> findPasswordByEmail(@PathVariable String email){
        String userPassword = userService.findPasswordByEmail(email);
        return ApiResponse.ok(userPassword);
    }
    @PostMapping("/password")  // localhost:8080/user/password   비밀번호 변경  json { "currentPassword" : "현재 비밀번호 ", "newPassword" : "새로운 비밀번호" }
    @PreAuthorize("isAuthenticated()")
    public ApiResponse<String> changePassword(@RequestBody ChangePasswordDto changePasswordDto){
        try {
            userService.changePassword(changePasswordDto);
            return ApiResponse.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (RuntimeException e){
            return ApiResponse.of(HttpStatus.BAD_REQUEST, e.getMessage(), null);
        }
    }
    @GetMapping("/info")
    public ApiResponse<String> user(@RequestHeader(name = HttpHeaders.AUTHORIZATION) String authorizationHeader) {
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
                return ApiResponse.ok("user name: " + username + "\nuser email: " + useremail + "\nuser sex: "+ usersex + "\nuser age: " + userage + "\nuser job: " + userjob + "\nuser location: " + userlocation + "\nuser language: "+ userlanguage);
            } else {
                return ApiResponse.of(HttpStatus.NOT_FOUND, "User not found", null);
            }
        } else {
            return ApiResponse.of(HttpStatus.UNAUTHORIZED,"Invalid token", null);
        }
    }
    @PostMapping("/authenticate-firebase")
    public ApiResponse<String> authenticateAndGenerateBearerToken(@RequestBody String firebaseIdToken) {
        try {
            // Firebase ID 토큰 검증하고 Bearer 토큰 생성
            String bearerToken = firebaseAuthenticationService.authenticateAndGenerateBearerToken(firebaseIdToken);
            return ApiResponse.ok(bearerToken);
        } catch (FirebaseAuthException e) {
            e.printStackTrace();
            return ApiResponse.of(HttpStatus.UNAUTHORIZED, "인증 실패", null);
        }
    }


}
