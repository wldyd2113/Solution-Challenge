package com.gdsc.solutionchallenge.repository;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DiaryRepository extends JpaRepository<Diary, Long> {
    @Query("SELECT d FROM Diary d WHERE d.shareDiary IS NOT NULL AND d.isViewed = false AND d.user <> :loggedInUser AND d.emotion = :emotion ORDER BY d.createdAt ASC LIMIT 1")
    Optional<Diary> findOldestDiary(@Param("loggedInUser") User loggedInUser, @Param("emotion") String emotion);

    Optional<Diary> findByDateAndUser(String date, User user);

    boolean existsByDateAndUser(String userDate, User user);

    @Query("SELECT d FROM Diary d WHERE d.isViewed = true AND d.cheeringMessage IS NULL")
    List<Diary> findViewedDiariesWithNullCheeringMessage();

    @Query("SELECT d FROM Diary d WHERE d.isViewed = true AND d.cheeringMessage IS NULL AND d.viewedAt IS NOT NULL AND d.viewedAt < :cutoffTime")
    List<Diary> findUncheeredDiaries(@Param("cutoffTime") LocalDateTime cutoffTime);


}