package com.gdsc.solutionchallenge.repository;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Optional;

public interface DiaryRepository extends JpaRepository<Diary, Long> {
    @Query("SELECT d FROM Diary d WHERE d.shareDiary IS NOT NULL AND d.isViewed = false AND d.user <> :loggedInUser ORDER BY d.createdAt ASC LIMIT 1")
    Optional<Diary> findOldestDiary(@Param("loggedInUser") User loggedInUser);

    Optional<Diary> findByDateAndUser(String date, User user);

    boolean existsByDateAndUser(String userDate, User user);
}
