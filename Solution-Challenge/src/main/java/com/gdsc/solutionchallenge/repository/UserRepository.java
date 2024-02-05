package com.gdsc.solutionchallenge.repository;

import com.gdsc.solutionchallenge.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    //Optional<User> findByName(String name);
    Optional<User> findUserById(Long id);
    String findLocationById(Long id);

    boolean existsByEmail(String email);

    @Query("SELECT COUNT(d) FROM User u LEFT JOIN u.diaries d WHERE u.id = :userId")
    Long countDiariesByUserId(@Param("userId") Long userId);

    User findByName(String name);
}
