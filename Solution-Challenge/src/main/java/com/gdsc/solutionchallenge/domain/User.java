    package com.gdsc.solutionchallenge.domain;

    import jakarta.persistence.*;
    import lombok.Builder;
    import lombok.Getter;
    import lombok.NoArgsConstructor;
    import lombok.Setter;

    @Entity
    @Setter
    @Getter
    @NoArgsConstructor
    public class User {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "USER_ID")
        private Long id;

        @Column(name = "USER_EMAIL")
        private String email;

        @Column(name = "USER_PASSWORD")
        private String password;

        @Column(name = "USER_NAME", nullable = false)
        private String name;

        @Column(name = "USER_PHONE", nullable = false)
        private int phone;

        @Column(name = "USER_SEX", nullable = false)
        private String sex;

        @Column(name = "USER_LOCATION", nullable = false)
        private String location;

        @Column(name = "USER_JOB", nullable = false)
        private String job;

        @Column(name = "USER_AGE", nullable = false)
        private int age;

        @Column(name = "USER_LANGUAGE", nullable = false)
        private String language;

        @Enumerated(EnumType.STRING)
        @Column(name = "USER_ROLE", nullable = false)
        private Role role;

        @Builder
        public User(String email, String password, String name,Role role, int phone, String sex, String location, String job, int age, String language){
            this.email = email;
            this.password = password;
            this.age = age;
            this.job = job;
            this.phone = phone;
            this.location = location;
            this.language = language;
            this.name = name;
            this.role = role;
            this.sex = sex;
        }

    }
