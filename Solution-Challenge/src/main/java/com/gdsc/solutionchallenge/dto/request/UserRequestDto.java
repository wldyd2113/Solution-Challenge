package com.gdsc.solutionchallenge.dto.request;

import com.gdsc.solutionchallenge.domain.Role;
import com.gdsc.solutionchallenge.domain.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserRequestDto {

    private String email;
    private String password;
    private String sex;
    private String language;
    private int age;
    private String location;
    private String job;
    private String name;

    public User toUser(PasswordEncoder passwordEncoder){
        return User.builder()
                .email(email)
                .password(passwordEncoder.encode(password))
                .age(age)
                .location(location)
                .sex(sex)
                .job(job)
                .language(language)
                .role(Role.ROLE_USER)
                .name(name)
                .build();
    }
    public User toGoogleUser(){
        return User.builder()
                .age(age)
                .location(location)
                .sex(sex)
                .job(job)
                .language(language)
                .role(Role.ROLE_USER)
                .name(name)
                .build();
    }

    public UsernamePasswordAuthenticationToken toAuthentication(){
        return new UsernamePasswordAuthenticationToken(email, password);
    }
}