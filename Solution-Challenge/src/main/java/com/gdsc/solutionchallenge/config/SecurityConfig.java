package com.gdsc.solutionchallenge.config;

import com.gdsc.solutionchallenge.jwt.JwtAccessDeniedHandler;
import com.gdsc.solutionchallenge.jwt.JwtAuthenticationEntryPoint;
import com.gdsc.solutionchallenge.jwt.JwtFilter;
import com.gdsc.solutionchallenge.jwt.TokenProvider;
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
public class SecurityConfig {
    private final TokenProvider tokenProvider;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .exceptionHandling(exceptionHandling ->
                        exceptionHandling
                                .authenticationEntryPoint(jwtAuthenticationEntryPoint)
                                .accessDeniedHandler(jwtAccessDeniedHandler))
                .httpBasic(AbstractHttpConfigurer::disable) // 기본적인 HTTP 기반의 인증 비활성화
                .csrf(AbstractHttpConfigurer::disable)  // CSRF(Cross-Site Request Forgery) 공격 방지 비활성화
                .sessionManagement(sessionManagement -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))   // 세션 관리 정책을 항상 새로운 세션을 생성하도록 설정
                .formLogin(AbstractHttpConfigurer::disable) // 폼 로그인 비활성화
                .authorizeHttpRequests(authorizeRequests -> authorizeRequests   // HTTP 요청에 대한 인가 규칙 설정
                        .requestMatchers("/user/**").permitAll()    // "/user/**"에 대한 요청은 모두에게 허용
//                        .requestMatchers("/user/info").authenticated()
                        .requestMatchers("/mail/*").permitAll()
                        .anyRequest().authenticated()
                )
                .cors(cors -> cors.configurationSource(configurationSource()))
                .addFilterBefore(new JwtFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class)
                .build();
    }


    @Bean
    public CorsConfigurationSource configurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        configuration.setAllowedOriginPatterns(List.of("*"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setExposedHeaders(List.of("Access-Control-Allow-Credentials", "Authorization", "Set-Cookie"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);

        return source;

    }
}
