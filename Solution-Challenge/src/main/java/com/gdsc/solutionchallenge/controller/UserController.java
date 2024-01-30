package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.dto.request.ChangePasswordDto;
import com.gdsc.solutionchallenge.dto.request.UserRequestDto;
import com.gdsc.solutionchallenge.dto.response.UserInfoResponseDto;
import com.gdsc.solutionchallenge.dto.response.UserResponseDto;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.UserRepository;
import com.gdsc.solutionchallenge.service.FirebaseAuthenticationService;
import com.gdsc.solutionchallenge.service.MailService;
import com.gdsc.solutionchallenge.service.UserService;
import com.google.firebase.auth.FirebaseAuthException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
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
    public ResponseEntity<UserResponseDto> signup(@RequestBody UserRequestDto userRequestDto) {
        return ResponseEntity.ok(userService.signup(userRequestDto));
    }

    @PostMapping("/googleSignup") // localhost:8080/user/googleSignup  구글 회원가입 (이메일, 비밀번호 미포함 정보)
    public ResponseEntity<UserResponseDto> googleSignup(@RequestBody UserRequestDto userRequestDto) {
        return ResponseEntity.ok(userService.googleSignup(userRequestDto));
    }

    @PostMapping("/login") // localhost:8080/user/login    로그인 ( 토큰 발급 )
    public ResponseEntity<TokenDto> login(@RequestBody UserRequestDto userRequestDto) {
        return ResponseEntity.ok(userService.login(userRequestDto));
    }

    @GetMapping // localhost:8080/user    로그인 테스트
    public ResponseEntity<String> user() {
        return ResponseEntity.ok("Hello User");
    }


    @GetMapping("/check/{email}") // localhost:8080/user/check/{email}   가입된 이메일인지 확인
    public ResponseEntity<String> findEmail(@PathVariable String email) {
        boolean exist = userRepository.existsByEmail(email);
        if (exist)
            return ResponseEntity.ok("가입된 이메일");
        else
            return ResponseEntity.ok("가입되지 않은 이메일");

    }

    @GetMapping("/password/{email}")  // localhost:8080/user/password/{email}   이메일로 비밀번호 찾기 ( 이메일 인증 필수 )
    public ResponseEntity<String> findPasswordByEmail(@PathVariable String email) {
        String userPassword = userService.findPasswordByEmail(email);
        return ResponseEntity.ok(userPassword);
    }

    @PostMapping("/password")
    // localhost:8080/user/password   비밀번호 변경  json { "currentPassword" : "현재 비밀번호 ", "newPassword" : "새로운 비밀번호" }
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordDto changePasswordDto) {
        try {
            userService.changePassword(changePasswordDto);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/userInfo")
    public ResponseEntity<UserInfoResponseDto> getUserInfo(Principal principal) {
        Long loggedInUsername = Long.parseLong(principal.getName());
        Optional<User> userOptional = userRepository.findById(loggedInUsername);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            UserInfoResponseDto userInfoResponseDto = UserInfoResponseDto.builder()
                    .email(user.getEmail())
                    .name(user.getName())
                    .location(user.getLocation())
                    .job(user.getJob())
                    .age(user.getAge())
                    .sex(user.getSex())
                    .language(user.getLanguage())
                    .build();

            return new ResponseEntity<>(userInfoResponseDto, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/authenticate-firebase")
    public ResponseEntity<String> authenticateAndGenerateBearerToken(@RequestBody String firebaseIdToken) {
        try {
            // Firebase ID 토큰 검증하고 Bearer 토큰 생성
            String bearerToken = firebaseAuthenticationService.authenticateAndGenerateBearerToken(firebaseIdToken);
            return ResponseEntity.ok(bearerToken);
        } catch (FirebaseAuthException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증 실패");
        }
    }


}