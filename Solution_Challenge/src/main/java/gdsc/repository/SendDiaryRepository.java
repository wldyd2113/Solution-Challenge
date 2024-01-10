package gdsc.repository;

import gdsc.domain.SendDiary;
import gdsc.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SendDiaryRepository extends JpaRepository <SendDiary, Long> {

    @Query("SELECT mp FROM SendDiary mp WHERE mp.user = :user AND DATE(mp.createdAt) = :date")
    List<SendDiary> findByUserAndCreatedAt(@Param("user") User user, @Param("date") LocalDate date);
}
