package gdsc.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class SendDiaryResponseDto {
    private String diary;
    private String emotion;
    private Date createdAt;
}
