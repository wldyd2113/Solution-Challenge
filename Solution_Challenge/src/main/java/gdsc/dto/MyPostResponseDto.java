package gdsc.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MyPostResponseDto {
    private String userName;
    private String title;
    private String body;
}
