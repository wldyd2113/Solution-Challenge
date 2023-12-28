package gdsc.controller;

import gdsc.dto.Token;
import gdsc.dto.UserRequestDto;
import gdsc.dto.UserResponseDto;
import gdsc.jwt.TokenProvider;
import gdsc.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final TokenProvider tokenProvider;

    @PostMapping("/signup/user")
    public ResponseEntity<UserResponseDto> signup(@RequestBody UserRequestDto userRequestDto) {
        return ResponseEntity.ok(userService.signup(userRequestDto));
    }

    @PostMapping("/login")
    public ResponseEntity<Token> login(@RequestBody UserRequestDto userRequestDto) {
        return ResponseEntity.ok(userService.login(userRequestDto));
    }

    @GetMapping("/user")
    public ResponseEntity<String> user(){
        return ResponseEntity.ok("Hello User");
    }

    @GetMapping("/user2")
    public ResponseEntity<String> user(@RequestHeader(name = HttpHeaders.AUTHORIZATION) String authorizationHeader) {
        String accessToken = authorizationHeader.replace("Bearer ", "");

        if (tokenProvider.validateToken(accessToken)) {
            org.springframework.security.core.Authentication authentication = tokenProvider.getAuthentication(accessToken);
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            // 이제 userDetails에서 필요한 사용자 정보를 가져와서 사용할 수 있어
            String username = userDetails.getUsername();

            return ResponseEntity.ok("Hello " + username);
        } else {
            // 토큰이 유효하지 않으면 에러 응답을 보낼 수 있어
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }

}
