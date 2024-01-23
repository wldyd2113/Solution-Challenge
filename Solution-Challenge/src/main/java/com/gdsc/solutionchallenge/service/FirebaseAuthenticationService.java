package com.gdsc.solutionchallenge.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.auth.FirebaseAuthException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class FirebaseAuthenticationService {

    // Firebase Admin SDK를 사용하여 Firebase ID 토큰을 검증하고, Bearer 토큰을 생성하는 메소드
    public String authenticateAndGenerateBearerToken(String firebaseIdToken) throws FirebaseAuthException {
        try {
            // Firebase ID 토큰 검증
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseIdToken);
            String uid = decodedToken.getUid();

            // 필요한 경우 여기에서 추가적인 확인이나 작업 수행 가능

            // Bearer 토큰 생성
            return generateBearerToken(uid);
        } catch (FirebaseAuthException e) {
            e.printStackTrace();
            throw e; // FirebaseAuthException을 다시 던지거나 다른 예외 처리 방식을 선택
        }
    }

    // 사용자 UID를 기반으로 Bearer 토큰을 생성하는 메소드
    private String generateBearerToken(String uid) {
        // JWT 토큰 생성
        Date now = new Date();
        Date expiration = new Date(now.getTime() + 86400000); // 1일 동안 유효

        return Jwts.builder()
                .setSubject(uid)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(SignatureAlgorithm.HS256, "your-secret-key") // 시크릿 키 사용 (보안상의 이유로 외부에 노출되면 안됨)
                .compact();
    }
}
