    package com.gdsc.solutionchallenge.domain;

    import jakarta.persistence.*;
    import lombok.*;

    import java.util.ArrayList;
    import java.util.List;

    @Setter
    @Getter
    @Builder
    @Entity
    @NoArgsConstructor
    @AllArgsConstructor
    public class Member {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "MEMBER_ID")
        private Long id;

        @Column(name = "MEMBER_EMAIL")
        private String email;

        @Column(name = "MEMBER_PASSWORD")
        private String password;

        @Column(name = "MEMBER_NAME", nullable = false)
        private String name;

        @Column(name = "MEMBER_SEX", nullable = false)
        private String sex;

        @Column(name = "MEMBER_LOCATION", nullable = false)
        private String location;

        @Column(name = "MEMBER_JOB", nullable = false)
        private String job;

        @Column(name = "MEMBER_AGE", nullable = false)
        private int age;

        @Column(name = "MEMBER_LANGUAGE", nullable = false)
        private String language;

        @Enumerated(EnumType.STRING)
        @Column(name = "MEMBER_ROLE", nullable = false)
        private Role role;

        @OneToMany(mappedBy = "member")
        private List<Diary> diaries = new ArrayList<>();

        @Column(name = "MEMBER_PICUTRE_URL")
        private String pictureUrl;

//        @Builder
//        public Member(String email, String password, String name,Role role, String sex, String location, String job, int age, String language){
//            this.email = email;
//            this.password = password;
//            this.age = age;
//            this.job = job;
//            this.location = location;
//            this.language = language;
//            this.name = name;
//            this.role = role;
//            this.sex = sex;
//        }

    }
