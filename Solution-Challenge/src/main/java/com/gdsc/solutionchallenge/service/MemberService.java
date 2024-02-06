package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.Member;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.dto.request.ChangePasswordDto;
import com.gdsc.solutionchallenge.dto.request.MemberRequestDto;
import com.gdsc.solutionchallenge.dto.response.MemberResponseDto;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;
    private final MailService mailService;

    @Transactional
    public MemberResponseDto signup(MemberRequestDto memberRequestDto){
        if(userRepository.existsByEmail(memberRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 이메일입니다.");
        }
        Member member = memberRequestDto.toMember(passwordEncoder);
        return MemberResponseDto.of(userRepository.save(member));
    }
    @Transactional
    public MemberResponseDto googleSignup(MemberRequestDto memberRequestDto){
        Member member = memberRequestDto.toGoogleUser();
        return MemberResponseDto.of(userRepository.save(member));
    }

    @Transactional
    public TokenDto login(MemberRequestDto memberRequestDto){
        UsernamePasswordAuthenticationToken authenticationToken = memberRequestDto.toAuthentication();

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        return tokenProvider.generateTokenDto(authentication);
    }

    @Transactional
    public Optional<Member> getMemberById(long id){
        return userRepository.findMemberById(id);
    }

    @Transactional
    public ResponseEntity<String> findPasswordByEmail(String email){
        Member member = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("해당하는 이메일의 사용자를 찾을 수 없습니다."));
        String temporaryPassword = mailService.sendPassword(email);
        member.setPassword(passwordEncoder.encode(temporaryPassword));
        userRepository.save(member);
        return ResponseEntity.ok("비밀번호 초기화 이메일이 전송되었습니다. 새로운 비밀번호로 로그인하세요.");
    }


    @Transactional
    public String makeRandomPassword() {
        int length = 10;
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder temporaryPassword = new StringBuilder();

        for(int i = 0; i < length; i++){
            int index = (int) (Math.random() * characters.length());
            temporaryPassword.append(characters.charAt(index));
        }
        return temporaryPassword.toString();
    }

    @Transactional
    public void changePassword(ChangePasswordDto changePasswordDto){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String memberEmail = authentication.getName();

        String currentPassword = changePasswordDto.getCurrentPassword();
        String newPassword = changePasswordDto.getNewPassword();

        Member member = userRepository.findById(Long.valueOf(memberEmail))
                .orElseThrow(() -> new RuntimeException("현재 로그인한 사용자를 찾을 수 없습니다."));

        if(!passwordEncoder.matches(currentPassword, member.getPassword())){
            throw new RuntimeException("현재 비밀번호가 일치하지 않습니다.");
        }
        member.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(member);
    }
}
