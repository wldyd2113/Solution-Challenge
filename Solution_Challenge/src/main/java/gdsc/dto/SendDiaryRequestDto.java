package gdsc.dto;

import lombok.Data;

@Data
public class SendDiaryRequestDto {
    private String diary;
    private String emotion;
}
