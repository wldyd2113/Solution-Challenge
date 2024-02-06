package com.gdsc.solutionchallenge.controller;

import com.gdsc.solutionchallenge.domain.Member;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.dto.request.ChangePasswordDto;
import com.gdsc.solutionchallenge.dto.request.MemberRequestDto;
import com.gdsc.solutionchallenge.dto.response.MemberInfoResponseDto;
import com.gdsc.solutionchallenge.dto.response.MemberResponseDto;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.UserRepository;
import com.gdsc.solutionchallenge.service.AuthService;
import com.gdsc.solutionchallenge.service.DiaryService;
import com.gdsc.solutionchallenge.service.FirebaseAuthenticationService;
import com.gdsc.solutionchallenge.service.MemberService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Optional;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final MemberService memberService;
    private final UserRepository userRepository;
    private final DiaryService diaryService;
    private final FirebaseAuthenticationService firebaseAuthenticationService;
    private final AuthService authService;
    private final TokenProvider tokenProvider;

    @PostMapping("/signup") // localhost:8080/user/signup  일반 회원가입 ( 이메일, 비밀번호 포함 모든 정보 )
    public ResponseEntity<MemberResponseDto> signup(@RequestBody MemberRequestDto memberRequestDto) {
        return ResponseEntity.ok(memberService.signup(memberRequestDto));
    }

    @PostMapping("/googleSignup") // localhost:8080/user/googleSignup  구글 회원가입 (이메일, 비밀번호 미포함 정보)
    public ResponseEntity<MemberResponseDto> googleSignup(@RequestBody MemberRequestDto memberRequestDto) {
        return ResponseEntity.ok(memberService.googleSignup(memberRequestDto));
    }

    @PostMapping("/login") // localhost:8080/user/login    로그인 ( 토큰 발급 )
    public ResponseEntity<TokenDto> login(@RequestBody MemberRequestDto memberRequestDto) {
        return ResponseEntity.ok(memberService.login(memberRequestDto));
    }

    @GetMapping("/email/{email}") // localhost:8080/user/check/{email}   가입된 이메일인지 확인
    public ResponseEntity<String> findEmail(@PathVariable String email) {
        boolean exist = userRepository.existsByEmail(email);
        if (exist)
            return ResponseEntity.ok("가입된 이메일");
        else
            return ResponseEntity.ok("가입되지 않은 이메일");

    }

    @GetMapping("/password/{email}")  // localhost:8080/user/password/{email}   이메일로 비밀번호 찾기 ( 이메일 인증 필수 )
    public ResponseEntity<String> findPasswordByEmail(@PathVariable String email) {
        memberService.findPasswordByEmail(email);
        return ResponseEntity.ok("비밀번호 초기화 이메일이 전송되었습니다. 새로운 비밀번호로 로그인하세요.");
    }

    @PostMapping("/password")
    // localhost:8080/user/password   비밀번호 변경  json { "currentPassword" : "현재 비밀번호 ", "newPassword" : "새로운 비밀번호" }
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordDto changePasswordDto) {
        try {
            memberService.changePassword(changePasswordDto);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/info")
    public ResponseEntity<MemberInfoResponseDto> getMemberInfo(Principal principal) {
        Long loggedInMembername = Long.parseLong(principal.getName());
        Optional<Member> memberOptional = userRepository.findById(loggedInMembername);

        if (memberOptional.isPresent()) {
            Member member = memberOptional.get();
            Long diaryCount = diaryService.getDiaryCount(loggedInMembername);
            MemberInfoResponseDto memberInfoResponseDto = MemberInfoResponseDto.builder()
                    .email(member.getEmail())
                    .name(member.getName())
                    .location(member.getLocation())
                    .job(member.getJob())
                    .age(member.getAge())
                    .sex(member.getSex())
                    .language(member.getLanguage())
                    .diaryCount(diaryCount)
                    .build();

            return new ResponseEntity<>(memberInfoResponseDto, HttpStatus.OK);
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

    @GetMapping("callback/google")
    public TokenDto googleCallback(@RequestParam(name = "code") String code){
        String googleAccessToken = authService.getGoogleAccessToken(code);
        return authService.loginOrSignUp(googleAccessToken);
    }

    @GetMapping("/checkName/{name}")
    public ResponseEntity<String> checkName(@PathVariable String name) {
        boolean isUnique = memberService.isNameUnique(name);
        if (isUnique) {
            return ResponseEntity.ok("닉네임 사용 가능 합니다.");
        } else {
            return ResponseEntity.badRequest().body("이미 존재하는 닉네임 입니다.");
        }
    }
    @GetMapping("/convert")
    public ResponseEntity<TokenDto> convertToken(String accessToken) {
        TokenDto tokenDto = tokenProvider.convertToken(accessToken);
        return ResponseEntity.ok(tokenDto);
    }
}