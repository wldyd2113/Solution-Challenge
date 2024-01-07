package gdsc.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class MyPostResponseDto {
    private String title;
    private String body;
    private String emotion;
    private Date createdAt;
}
