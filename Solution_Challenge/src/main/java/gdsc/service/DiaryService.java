package gdsc.service;

import gdsc.domain.SendDiary;
import gdsc.domain.User;
import gdsc.dto.SendDiaryRequestDto;
import gdsc.dto.SendDiaryResponseDto;
import gdsc.repository.SendDiaryRepository;
import gdsc.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DiaryService {

    private final SendDiaryRepository sendDiaryRepository;
    private final UserRepository userRepository;

    @Transactional
    public SendDiaryResponseDto createSendDiary(SendDiaryRequestDto sendDiaryRequestDto, Long userId){
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        SendDiary newSendDiary = SendDiary.builder()
                .body(sendDiaryRequestDto.getBody())
                .emotion(sendDiaryRequestDto.getEmotion())
                .senderUser(user)
                .build();

        SendDiary savedSendDiary = sendDiaryRepository.save(newSendDiary);
        return savedSendDiary.toDto();
    }

    @Transactional
    public SendDiaryResponseDto sendRandomDiary(SendDiaryRequestDto sendDiaryRequestDto) {
        // 랜덤 사용자 선택
        List<User> allUsers = userRepository.findAll();
        if (!allUsers.isEmpty()) {
            Random random = new Random();
            int randomIndex = random.nextInt(allUsers.size());
            User randomUser = allUsers.get(randomIndex);

            // createMyPost 메서드를 통해 일기를 생성하고 저장
            SendDiaryResponseDto createdDiary = createSendDiary(sendDiaryRequestDto, randomUser.getId());

            // 저장된 일기 정보를 이용하여 랜덤 사용자에게 일기 전송
            sendDiaryRequestDto.setBody("랜덤한 사용자에게 전송된 일기: " + createdDiary.getBody());
            sendDiaryRequestDto.setEmotion("랜덤한 사용자에게 전송된 감정");

            // 일기 전송
            SendDiary newSendDiary = SendDiary.builder()
                    .body(sendDiaryRequestDto.getBody())
                    .emotion(sendDiaryRequestDto.getEmotion())
                    .senderUser(randomUser)
                    .build();

            SendDiary savedSendDiary = sendDiaryRepository.save(newSendDiary);

            // 저장된 일기 정보 반환
            return savedSendDiary.toDto();
        } else {
            throw new RuntimeException("등록된 사용자가 없습니다.");
        }
    }

    @Transactional
    public List<SendDiaryResponseDto> getPostsByUserAndDate(Long userId, LocalDate date) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        List<SendDiary> posts = sendDiaryRepository.findByUserAndCreatedAt(user, date);

        return posts.stream()
                .map(SendDiary::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public SendDiaryResponseDto createAndSendRandomDiary(SendDiaryRequestDto sendDiaryRequestDto) {
        List<User> allUsers = userRepository.findAll();

        if (!allUsers.isEmpty()) {
            // 랜덤 보내는 사용자 선택
            Random random = new Random();
            int senderIndex = random.nextInt(allUsers.size());
            User senderUser = allUsers.get(senderIndex);

            // 랜덤 받는 사용자 선택
            int receiverIndex;
            do {
                receiverIndex = random.nextInt(allUsers.size());
            } while (receiverIndex == senderIndex); // 받는 사용자와 보내는 사용자가 같으면 다시 선택

            User receiverUser = allUsers.get(receiverIndex);

            // 일기 전송
            SendDiary newSendDiary = SendDiary.builder()
                    .body(sendDiaryRequestDto.getBody())
                    .emotion(sendDiaryRequestDto.getEmotion())
                    .senderUser(senderUser)
                    .receiverUser(receiverUser)
                    .build();

            SendDiary savedSendDiary = sendDiaryRepository.save(newSendDiary);
            return savedSendDiary.toDto();
        } else {
            throw new RuntimeException("등록된 사용자가 없습니다.");
        }
    }
    @Transactional
    public List<SendDiaryResponseDto> getReceivedDiariesForUser(Long userId) {
        // UserRepository를 사용하여 userId에 해당하는 사용자를 조회
        Optional<User> optionalUser = userRepository.findById(userId);

        if (optionalUser.isPresent()) {
            User receivingUser = optionalUser.get();

            // 해당 사용자가 받은 모든 일기 조회
            List<SendDiary> receivedDiaries = sendDiaryRepository.findByReceiverUser(receivingUser);

            return receivedDiaries.stream()
                    .map(SendDiary::toDto)
                    .collect(Collectors.toList());
        } else {
            throw new RuntimeException("사용자가 존재하지 않습니다.");
        }
    }
}
