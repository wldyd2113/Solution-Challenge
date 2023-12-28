package gdsc.domain;

import gdsc.dto.MyPostResponseDto;
import jakarta.persistence.*;
import lombok.*;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class MyPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MYPOST_ID")
    private Long myPostId;
    @Column(name = "USER_NAME")
    private String userName;
    @Column(name = "MY_POST_TITLE")
    private String title;
    @Column(name = "MY_POST_BODY")
    private String body;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @Builder
    public MyPost(String userName, String title, String body, User user){
        this.userName=userName;
        this.title=title;
        this.body=body;
        this.user=user;
    }

    public MyPostResponseDto toDto(){
        MyPostResponseDto myPostResponseDto = MyPostResponseDto.builder()
                .userName(this.getUserName())
                .title(this.getTitle())
                .body(this.getBody())
                .build();
        return myPostResponseDto;
    }
}
