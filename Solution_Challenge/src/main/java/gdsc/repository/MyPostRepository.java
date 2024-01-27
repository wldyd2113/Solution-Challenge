package gdsc.repository;

import gdsc.domain.MyPost;
import gdsc.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MyPostRepository extends JpaRepository<MyPost, Long> {

    @Query("SELECT mp FROM MyPost mp WHERE mp.user = :user AND DATE(mp.currentDate) = :date")
    List<MyPost> findByUserAndCreatedAt(@Param("user") User user, @Param("date") LocalDate date);
}