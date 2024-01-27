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
    @Column(name = "MY_DIARY")
    private String myDiary;
    @Column(name = "MY_EMOTION")
    private String emotion;

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_AT", updatable = false)
    private Date currentDate;


    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @Builder
    public MyPost( String myDiary, User user, String emotion){
        this.myDiary=myDiary;
        this.emotion=emotion;
        this.user=user;
    }

    public MyPostResponseDto toDto(){
        MyPostResponseDto myPostResponseDto = MyPostResponseDto.builder()
                .myDiary(this.getMyDiary())
                .emotion(this.getEmotion())
                .currentDate(this.getCurrentDate())
                .build();
        return myPostResponseDto;
    }
}
