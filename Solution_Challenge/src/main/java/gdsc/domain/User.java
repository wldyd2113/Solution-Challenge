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
    @Column(name = "USER_NAME", nullable = false)
    private String name;
    @Column(name="USER_AGE", nullable = false)
    private Integer age;
    @Column(name="USER_SEX", nullable = false)
    private String sex;
    @Column(name="USER_LOCATION", nullable = false)
    private String location;
    @Column(name="USER_LANGUAGE", nullable = false)
    private String language;
    //@Column(name = "USER_PHONE", nullable = false)
    //private String phone;
    @Column(name = "USER_JOB")
    private String job;

    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "USER_ROLE", nullable = false)
    private Role role;

    @Builder
    public User(String email, String password, Integer age, String name, String sex, String location, String language, /*String phone,*/ String job, Role role){
        this.email=email;
        this.password=password;
         this.age=age;
         this.name=name;
        this.sex=sex;
        this.location=location;
        this.language=language;
      //  this.phone=phone;
        this.job=job;
        this.role=role;
    }
}
