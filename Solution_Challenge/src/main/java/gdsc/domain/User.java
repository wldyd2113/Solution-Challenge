package gdsc.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "USER_ID")
    private Long id;
    @Column(name="USER_EMAIL", nullable = false)
    private String email;
    @Column(name="USER_AGE", nullable = false)
    private Integer age;
    @Column(name="USER_SEX", nullable = false)
    private String sex;
    @Column(name="USER_LOCATION", nullable = false)
    private String location;
    @Column(name="USER_LANGUAGE", nullable = false)
    private String language;

    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "USER_ROLE", nullable = false)
    private Role role;

    @Builder
    public User(String email, String password, Integer age, String sex, String location, String language, Role role){
        this.email=email;
        this.password=password;
         this.age=age;
        this.sex=sex;
        this.location=location;
        this.language=language;
        this.role=role;
    }
}
