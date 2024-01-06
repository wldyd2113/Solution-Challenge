package gdsc.jwt;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
// JwtAuthenticationEntryPoint 클래스는 Spring Security에서 인증되지 않은 사용자가 보호된 리소스에 액세스하려고 할 때 호출되는 핸들러를 정의합니다.

public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    // AuthenticationEntryPoint 인터페이스의 메소드를 구현합니다.
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
            throws IOException {
        // 인증되지 않은 사용자가 보호된 리소스에 액세스하려고 할 때, HTTP 응답에 상태 코드 401(Unauthorized)을 설정합니다.
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
    }
}
