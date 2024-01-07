package gdsc.domain;

import gdsc.dto.MyPostResponseDto;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class MyPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MYPOST_ID")
    private Long myPostId;
    @Column(name = "MY_POST_TITLE")
    private String title;
    @Column(name = "MY_POST_BODY")
    private String body;
    @Column(name = "MY_EMOTION")
    private String emotion;

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_AT", updatable = false)
    private Date createdAt;


    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @Builder
    public MyPost( String title, String body, User user, String emotion){
        this.title=title;
        this.body=body;
        this.emotion=emotion;
        this.user=user;
    }

    public MyPostResponseDto toDto(){
        MyPostResponseDto myPostResponseDto = MyPostResponseDto.builder()
                .title(this.getTitle())
                .body(this.getBody())
                .emotion(this.getEmotion())
                .createdAt(this.getCreatedAt())
                .build();
        return myPostResponseDto;
    }
}
