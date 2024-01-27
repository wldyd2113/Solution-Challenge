package gdsc.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class MyPostResponseDto {
    private String myDiary;
    private String emotion;
    private Date currentDate;

}
