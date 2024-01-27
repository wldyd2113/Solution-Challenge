package gdsc.controller;

import gdsc.domain.User;
import gdsc.dto.Token;
import gdsc.dto.UserRequestDto;
import gdsc.dto.UserResponseDto;
import gdsc.jwt.TokenProvider;
import gdsc.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final TokenProvider tokenProvider;

    @PostMapping("/signup")
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

    @GetMapping("/user/info")
    public ResponseEntity<String> user(@RequestHeader(name = HttpHeaders.AUTHORIZATION) String authorizationHeader) {
        String accessToken = authorizationHeader.replace("Bearer ", "");

        if (tokenProvider.validateToken(accessToken)) {
            org.springframework.security.core.Authentication authentication = tokenProvider.getAuthentication(accessToken);
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            // userDetails에서 이메일을 가져와서 UserRepository를 통해 User 정보를 불러옴
            String id = userDetails.getUsername();
            Optional<User> optionalUser = userService.getUserById(Long.parseLong(id));

            if (optionalUser.isPresent()) {
                // user에서 필요한 정보를 가져와서 사용할 수 있어
                String useremail = optionalUser.get().getEmail();
                String username = optionalUser.get().getName();
                Integer userage = optionalUser.get().getAge();
                String userlocation = optionalUser.get().getLocation();
                String userlanguage = optionalUser.get().getLanguage();
                //String userphone = optionalUser.get().getPhone();
                String userjob = optionalUser.get().getJob();
                String usersex = optionalUser.get().getSex();
                return ResponseEntity.ok("user name: " + username + "\nuser email: " + useremail + "\nuser sex: "+ usersex + "\nuser age: " + userage + /*"\nuser phone: " + userphone +*/ "\nuser job: " + userjob + "\nuser location: " + userlocation + "\nuser language: "+ userlanguage);
            } else {
                // 사용자 정보가 없을 경우 처리
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }

}