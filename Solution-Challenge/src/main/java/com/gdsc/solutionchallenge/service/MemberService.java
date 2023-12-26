package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.Member;
import com.gdsc.solutionchallenge.dto.MemberRequestDto;
import com.gdsc.solutionchallenge.dto.MemberResponseDto;
import com.gdsc.solutionchallenge.dto.TokenDto;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
@Service
@RequiredArgsConstructor
public class MemberService {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;

    @Transactional
    public MemberResponseDto signup(MemberRequestDto memberRequestDto){
        if(memberRepository.existsByEmail(memberRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 이메일입니다.");
        }
        Member member = memberRequestDto.toMember(passwordEncoder);
        return MemberResponseDto.of(memberRepository.save(member));
    }
    @Transactional
    public MemberResponseDto adminSignup(MemberRequestDto memberRequestDto){
        if(memberRepository.existsByEmail(memberRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 이메일입니다.");
        }
        Member member = memberRequestDto.toAdmin(passwordEncoder);
        return MemberResponseDto.of(memberRepository.save(member));
    }

    @Transactional
    public TokenDto login(MemberRequestDto memberRequestDto){
        UsernamePasswordAuthenticationToken authenticationToken = memberRequestDto.toAuthentication();

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        TokenDto tokenDto = tokenProvider.generateTokenDto(authentication);

        return tokenDto;
    }
}
