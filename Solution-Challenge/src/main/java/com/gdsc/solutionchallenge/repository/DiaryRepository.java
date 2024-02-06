package com.gdsc.solutionchallenge.repository;

import com.gdsc.solutionchallenge.domain.Diary;
import com.gdsc.solutionchallenge.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface DiaryRepository extends JpaRepository<Diary, Long> {
    @Query("SELECT d FROM Diary d WHERE d.shareDiary IS NOT NULL AND d.isViewed = false AND d.member <> :loggedInMember AND d.emotion = :emotion ORDER BY d.createdAt ASC LIMIT 1")
    Optional<Diary> findOldestDiary(@Param("loggedInMember") Member loggedInMember, @Param("emotion") String emotion);

    Optional<Diary> findByDateAndMember(String date, Member member);

    boolean existsByDateAndMember(String memberDate, Member member);
}
