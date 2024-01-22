package gdsc.domain;

import gdsc.dto.SendDiaryResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class SendDiary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SEND_DAIRY_ID")
    private Long SendDairyId;
    @Column(name = "SEND_DAIRY_BODY")
    private String body;
    @Column(name = "SEND_DAIRY_EMOTION")
    private String emotion;

    @ManyToOne
    @JoinColumn(name = "SENDER_USER_ID") // 일기를 보낸 사용자의 ID
    private User senderUser;

    @ManyToOne
    @JoinColumn(name = "RECEIVER_USER_ID") // 일기를 받는 사용자의 ID
    private User receiverUser;

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_AT", updatable = false)
    private Date createdAt;

    @Builder
    public SendDiary(String body, User senderUser, User receiverUser, String emotion){
        this.body=body;
        this.emotion=emotion;
        this.senderUser=senderUser;
        this.receiverUser=receiverUser;
    }

    public SendDiaryResponseDto toDto(){
        SendDiaryResponseDto sendDiaryResponseDto = SendDiaryResponseDto.builder()
                .body(this.getBody())
                .emotion(this.getEmotion())
                .createdAt(this.getCreatedAt())
                .build();
        return sendDiaryResponseDto;
    }
}
