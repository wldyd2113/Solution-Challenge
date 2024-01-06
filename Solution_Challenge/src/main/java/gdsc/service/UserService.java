package gdsc.service;

import gdsc.domain.User;
import gdsc.dto.Token;
import gdsc.dto.UserRequestDto;
import gdsc.dto.UserResponseDto;
import gdsc.jwt.TokenProvider;
import gdsc.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
// UserService 클래스는 사용자의 가입, 로그인, ID로 사용자 조회 등의 비즈니스 로직을 담당합니다.

public class UserService {

    // Spring Security의 AuthenticationManagerBuilder를 주입받아 사용자 로그인에 사용합니다.
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    // UserRepository를 주입받아 사용자 정보를 조회 및 저장하는 데 사용합니다.
    private final UserRepository userRepository;
    // 비밀번호를 안전하게 인코딩하기 위한 PasswordEncoder를 주입받습니다.
    private final PasswordEncoder passwordEncoder;
    // JWT 토큰을 생성, 검증하는 데 사용되는 TokenProvider를 주입받습니다.
    private final TokenProvider tokenProvider;

    // 사용자의 회원가입을 처리하는 메소드입니다.
    @Transactional
    public UserResponseDto signup(UserRequestDto userRequestDto){
        // 이미 가입된 이메일인 경우 예외를 발생시킵니다.
        if(userRepository.existsByEmail(userRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 사용자입니다.");
        }
        // UserRequestDto를 기반으로 User 엔티티를 생성합니다.
        User user = userRequestDto.toUser(passwordEncoder);
        // 생성된 User 엔티티를 저장하고, 저장된 엔티티를 기반으로 UserResponseDto를 생성하여 반환합니다.
        return UserResponseDto.of(userRepository.save(user));
    }

    // 사용자의 로그인을 처리하는 메소드입니다.
    @Transactional
    public Token login(UserRequestDto userRequestDto){
        // UserRequestDto를 기반으로 인증 토큰을 생성합니다.
        UsernamePasswordAuthenticationToken authenticationToken = userRequestDto.toAuthentication();
        // AuthenticationManager를 사용하여 토큰을 인증하고, 인증된 토큰을 반환합니다.
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        // 토큰 생성자를 사용하여 로그인한 사용자에 대한 JWT 토큰을 생성하고 반환합니다.
        return tokenProvider.generateTokenDto(authentication);
    }

    // 사용자 ID를 기반으로 사용자 정보를 조회하는 메소드입니다.
    @Transactional
    public Optional<User> getUserById(long id) {
        // UserRepository를 사용하여 ID로 사용자를 조회하고 결과를 반환합니다.
        return userRepository.findUserById(id);
    }
}
