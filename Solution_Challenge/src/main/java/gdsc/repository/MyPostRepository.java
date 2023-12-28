package gdsc.repository;

import gdsc.domain.MyPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MyPostRepository extends JpaRepository<MyPost,Long> {
}
