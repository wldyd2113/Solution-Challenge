package gdsc.jwt;

import gdsc.dto.Token;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
// TokenProvider 클래스는 JWT 토큰 생성, 검증 및 사용자 인증 정보 추출을 담당하는 역할을 합니다.
public class TokenProvider {

    // JWT 토큰 내 권한 정보를 담은 클레임의 키를 상수로 정의합니다.
    private static final String AUTHORITIES_KEY="auth";
    // JWT 토큰의 타입을 나타내는 상수로 정의합니다.
    private static final String BEARER_TYPE="bearer";
    // Access Token의 만료 시간을 상수로 정의합니다. (30분)
    private static final long ACCESS_TOKEN_EXPIRE_TIME=1000*60*30;

    // JWT 서명에 사용될 Key를 생성합니다.
    private final Key key;

    // 생성자에서 JWT 서명에 사용될 Key를 초기화합니다.
    public TokenProvider(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    // Authentication 객체를 기반으로 JWT 토큰을 생성하는 메소드입니다.
    public Token generateTokenDto(Authentication authentication){
        // 인증 객체가 없거나 인증되지 않은 사용자일 경우 예외를 발생시킵니다.
      //  if (authentication == null || !authentication.isAuthenticated()) {
          //  throw new RuntimeException("인증되지 않은 사용자입니다.");
    //    }

        // 권한 정보를 추출하여 쉼표로 구분된 문자열로 변환합니다.
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        // 현재 시간과 Access Token의 만료 시간을 설정합니다.
        long now = (new Date().getTime());
        Date accessTokenExpiresIn = new Date(now + ACCESS_TOKEN_EXPIRE_TIME);

        // JWT 토큰을 생성하고 반환합니다.
        String accessToken = Jwts.builder()
                .setSubject(authentication.getName())
                .claim(AUTHORITIES_KEY, authorities)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        // 생성된 JWT 토큰을 Token 객체로 래핑하여 반환합니다.
        return Token.builder()
                .grantType(BEARER_TYPE)
                .accessToken(accessToken)
                .build();
    }

    // JWT 토큰에서 사용자의 Authentication 객체를 추출하는 메소드입니다.
    public Authentication getAuthentication(String accessToken) {
        // JWT 토큰을 파싱하여 클레임을 추출합니다.
        Claims claims = parseClaims(accessToken);

        // 클레임에서 권한 정보를 추출합니다.
        if (claims.get(AUTHORITIES_KEY) == null) {
            throw new RuntimeException("권한 정보가 없는 토큰입니다.");
        }

        // 권한 정보를 기반으로 Spring Security의 GrantedAuthority 객체를 생성합니다.
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());

        // UserDetails 인터페이스를 구현한 객체를 생성하여 Authentication 객체를 반환합니다.
        UserDetails principal = new User(claims.getSubject(), "", authorities);

        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }

    // JWT 토큰의 유효성을 검증하는 메소드입니다.
    public boolean validateToken(String token) {
        try {
            // JWT 토큰을 파싱하여 서명을 검증합니다.
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            log.info("잘못된 JWT 서명입니다.");
        } catch (ExpiredJwtException e) {
            log.info("만료된 JWT 토큰입니다.");
        } catch (UnsupportedJwtException e) {
            log.info("지원되지 않는 JWT 토큰입니다.");
        } catch (IllegalArgumentException e) {
            log.info("JWT 토큰이 잘못되었습니다.");
        }
        return false;
    }

    // JWT 토큰에서 클레임을 추출하는 메소드입니다.
    private Claims parseClaims(String accessToken) {
        try {
            // JWT 토큰을 파싱하여 클레임을 추출합니다.
            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody();
        } catch (ExpiredJwtException e) {
            // 만료된 토큰인 경우, 만료된 클레임을 반환합니다.
            return e.getClaims();
        }
    }
}
