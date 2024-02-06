package com.gdsc.solutionchallenge.dto.response;

import com.gdsc.solutionchallenge.domain.Member;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class MemberResponseDto {
    private String email;
    public static MemberResponseDto of(Member member){
        return new MemberResponseDto(member.getEmail());
    }
}
