package gdsc.jwt;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
// JwtAccessDeniedHandler 클래스는 Spring Security에서 접근이 거부될 때 호출되는 핸들러를 정의합니다.

public class JwtAccessDeniedHandler implements AccessDeniedHandler {

    // AccessDeniedHandler 인터페이스의 메소드를 구현합니다.
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       org.springframework.security.access.AccessDeniedException accessDeniedException)
            throws IOException {
        // 접근이 거부되면 HTTP 응답에 상태 코드 403(Forbidden)을 설정합니다.
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
    }
}
