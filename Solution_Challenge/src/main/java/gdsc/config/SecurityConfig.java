package gdsc.config;


import gdsc.jwt.JwtAccessDeniedHandler;
import gdsc.jwt.JwtAuthenticationEntryPoint;
import gdsc.jwt.JwtFliter;
import gdsc.jwt.TokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@RequiredArgsConstructor
// SecurityConfig 클래스는 Spring Security의 설정을 관리하는 클래스입니다.

public class SecurityConfig {

    // TokenProvider를 주입받아 사용할 수 있도록 하는 생성자입니다.
    private final TokenProvider tokenProvider;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    // JwtAuthenticationEntryPoint 객체를 주입
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;
    // JwtAccessDeniedHandler 객체를 주입

    // PasswordEncoder 빈을 등록하는 메소드입니다.
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    // SecurityFilterChain 빈을 등록하는 메소드입니다.
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .exceptionHandling(exceptionHandling ->
                        exceptionHandling
                                .authenticationEntryPoint(jwtAuthenticationEntryPoint)
                                .accessDeniedHandler(jwtAccessDeniedHandler))
                // 기본적인 HTTP 기반의 인증을 비활성화합니다.
                .httpBasic(AbstractHttpConfigurer::disable)
                // CSRF(Cross-Site Request Forgery) 공격 방지를 비활성화합니다.
                .csrf(AbstractHttpConfigurer::disable)
                // 세션 관리 정책을 설정합니다. 항상 새로운 세션을 생성합니다.
                .sessionManagement(sessionManagement -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // 폼 로그인을 비활성화합니다.
                .formLogin(AbstractHttpConfigurer::disable)
                // HTTP 요청에 대한 인가 규칙을 설정합니다.
                .authorizeHttpRequests(authorizeRequests -> authorizeRequests
                        // "/login"과 "/signup/**"에 대한 요청은 인증 없이 허용합니다.
                        .requestMatchers("/login","/signup").permitAll()
                        // "/api/posts/**", "/user**", "/user2/**", "/error/**"에 대한 요청은 인증이 필요합니다.
                        .requestMatchers("/api/posts/**","/user","/user/info","/error/**").authenticated()
                        // 나머지 요청에 대해서도 인증이 필요합니다.
                        .anyRequest().authenticated()
                )
                // CORS(Cross-Origin Resource Sharing) 설정을 구성합니다.
                .cors(cors -> cors.configurationSource(configurationSource()))
                .addFilterBefore(new JwtFliter(tokenProvider), UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    // CORS 설정을 정의하는 메소드입니다.
    @Bean
    public CorsConfigurationSource configurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        // 허용된 오리진 패턴을 설정합니다.
        configuration.setAllowedOriginPatterns(List.of("*"));
        // 허용된 HTTP 메서드를 설정합니다.
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        // 허용된 헤더를 설정합니다.
        configuration.setAllowedHeaders(List.of("*"));
        // 노출된 헤더를 설정합니다.
        configuration.setExposedHeaders(List.of("Access-Control-Allow-Credentials", "Authorization", "Set-Cookie"));
        // 자격 증명을 허용합니다.
        configuration.setAllowCredentials(true);
        // Preflight 요청에 대한 최대 유지 시간을 설정합니다.
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        // 모든 경로에 대해서 CORS 설정을 적용합니다.
        source.registerCorsConfiguration("/**", configuration);

        return source;
    }
}
