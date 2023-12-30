package gdsc.dto;

import gdsc.domain.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserResponseDto {

    private String email;
    private String name;
    private int age;
    private String location;
    private String language;
    private String sex;
    private String job;
    private String phone;

    public static UserResponseDto of(User user){
    return new UserResponseDto(user.getEmail(), user.getName(), user.getAge(), user.getLanguage(), user.getLocation(), user.getSex(), user.getJob(), user.getPhone());
    }

}
