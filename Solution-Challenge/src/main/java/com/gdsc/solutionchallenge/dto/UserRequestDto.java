package com.gdsc.solutionchallenge.dto;

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
    private int phone;
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
                .phone(phone)
                .age(age)
                .location(location)
                .sex(sex)
                .job(job)
                .language(language)
                .name(name)
                .build();
    }
    public User toGoogleUser(){
        return User.builder()
                .phone(phone)
                .age(age)
                .location(location)
                .sex(sex)
                .job(job)
                .language(language)
                .name(name)
                .build();
    }
    public User toAdmin(PasswordEncoder passwordEncoder){
        return User.builder()
                .email(email)
                .password(passwordEncoder.encode(password))
                .build();
    }

    public UsernamePasswordAuthenticationToken toAuthentication(){
        return new UsernamePasswordAuthenticationToken(email, password);
    }
}
