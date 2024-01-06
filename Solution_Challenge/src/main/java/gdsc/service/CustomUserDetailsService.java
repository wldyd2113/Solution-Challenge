package gdsc.service;

import gdsc.domain.User;
import gdsc.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;


@Service
@RequiredArgsConstructor
// CustomUserDetailsService 클래스는 Spring Security의 UserDetailsService를 구현하여 사용자 정보를 로드하는 역할을 합니다.

public class CustomUserDetailsService implements UserDetailsService {

    // UserRepository를 주입받아 사용자 정보를 조회하는 데 사용합니다.
    private final UserRepository userRepository;

    // 주입받은 UserRepository를 이용하여 사용자 정보를 조회하는 메소드입니다.
    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 사용자 이메일을 기반으로 UserRepository에서 사용자 정보를 조회합니다.
        return userRepository.findByEmail(username)
                .map(this::createUserDetails)
                .orElseThrow(() -> new UsernameNotFoundException(username + "-> DB에서 찾을 수 없습니다."));
    }

    // 사용자 정보를 기반으로 UserDetails 객체를 생성하는 메소드입니다.
    private UserDetails createUserDetails(User user) {
        // 사용자의 권한을 Spring Security의 GrantedAuthority로 변환합니다.
        GrantedAuthority grantedAuthority = new SimpleGrantedAuthority(user.getRole().toString());

        // UserDetails 인터페이스를 구현한 객체를 생성하여 반환합니다.
        return new org.springframework.security.core.userdetails.User(
                String.valueOf(user.getId()),  // 사용자의 ID를 문자열로 변환하여 사용합니다.
                user.getPassword(),  // 사용자의 비밀번호를 사용합니다.
                Collections.singleton(grantedAuthority)  // 사용자의 권한을 담은 Set을 사용합니다.
        );
    }
}
