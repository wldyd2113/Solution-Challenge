package com.gdsc.solutionchallenge.service;

import com.gdsc.solutionchallenge.domain.User;
import com.gdsc.solutionchallenge.dto.*;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
import com.gdsc.solutionchallenge.repository.UserRepository;
import lombok.RequiredArgsConstructor;
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
public class UserService {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;
    private final MailService mailService;

    @Transactional
    public UserResponseDto signup(UserRequestDto userRequestDto){
        if(userRepository.existsByEmail(userRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 이메일입니다.");
        }
        User user = userRequestDto.toUser(passwordEncoder);
        return UserResponseDto.of(userRepository.save(user));
    }
    @Transactional
    public UserResponseDto googleSignup(UserRequestDto userRequestDto){
        User user = userRequestDto.toGoogleUser();
        return UserResponseDto.of(userRepository.save(user));
    }

    @Transactional
    public TokenDto login(UserRequestDto userRequestDto){
        UsernamePasswordAuthenticationToken authenticationToken = userRequestDto.toAuthentication();

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        TokenDto tokenDto = tokenProvider.generateTokenDto(authentication);

        return tokenDto;
    }

    @Transactional
    public boolean checkEmail(String email){
        return userRepository.existsByEmail(email);
    }
    @Transactional
    public Optional<User> getUserById(long id){
        return userRepository.findUserById(id);
    }

    @Transactional
    public String findPasswordByEmail(String email){
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("해당하는 이메일의 사용자를 찾을 수 없습니다."));
        String temporaryPassword = mailService.sendPassword(email);
        user.setPassword(passwordEncoder.encode(temporaryPassword));
        userRepository.save(user);
        return temporaryPassword;
    }


    @Transactional
    public String makeRandomPassword() {
        int length = 8;
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
        String userEmail = authentication.getName();

        String currentPassword = changePasswordDto.getCurrentPassword();
        String newPassword = changePasswordDto.getNewPassword();

        User user = userRepository.findById(Long.valueOf(userEmail))
                .orElseThrow(() -> new RuntimeException("현재 로그인한 사용자를 찾을 수 없습니다."));
        if(!passwordEncoder.matches(currentPassword, user.getPassword())){
            throw new RuntimeException("현재 비밀번호가 일치하지 않습니다.");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}
