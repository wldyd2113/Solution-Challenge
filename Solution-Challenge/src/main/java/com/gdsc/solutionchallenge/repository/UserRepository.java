package com.gdsc.solutionchallenge.repository;

import com.gdsc.solutionchallenge.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByEmail(String email);
    Optional<Member> findByName(String name);
    Optional<Member> findMemberById(Long id);
    String findLocationById(Long id);

    boolean existsByEmail(String email);

    @Query("SELECT COUNT(d) FROM Member m LEFT JOIN m.diaries d WHERE m.id = :memberId")
    Long countDiariesByMemberId(@Param("memberId") Long memberId);

}
