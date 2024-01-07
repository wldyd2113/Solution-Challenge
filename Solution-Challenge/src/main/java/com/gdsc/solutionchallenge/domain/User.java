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

        @Column(name = "USER_GENDER", nullable = false)
        private String gender;

        @Column(name = "USER_COUNTRY", nullable = false)
        private String country;

        @Column(name = "USER_JOB", nullable = false)
        private String job;

        @Column(name = "USER_age", nullable = false)
        private int age;

        @Column(name = "USER_LANGUAGE", nullable = false)
        private String language;

        @Builder
        public User(String email, String password, String name, int phone, String gender, String country, String job, int age, String language){
            this.email = email;
            this.password = password;
            this.age = age;
            this.job = job;
            this.phone = phone;
            this.country = country;
            this.language = language;
            this.name = name;
            this.gender = gender;
        }

    }
