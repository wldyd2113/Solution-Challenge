package com.gdsc.solutionchallenge.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Random;

@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender;
    private int authNumber;

    @Autowired
    private RedisUtil redisUtil;

    public boolean CheckAuthNum(String email, String authNum){
        if(redisUtil.getData(authNum)==null){
            return false;
        }
        else if (redisUtil.getData(authNum).equals(email)){
            return true;
        }
        else{
            return false;
        }
    }
    public void makeRandomNumber(){
        Random r = new Random();
        StringBuilder randomNumber = new StringBuilder();
        randomNumber.append(1 + r.nextInt(9));
        for(int i = 0; i < 5; i++){
            randomNumber.append(r.nextInt(10));
        }
        authNumber = Integer.parseInt(randomNumber.toString());
    }

    public String joinEmail(String email) {
        makeRandomNumber();
        String setFrom = "sukwan1106@gmail.com";
        String toMail = email;
        String title = "회원 가입 인증 이메일 입니다.";
        String content =
                "GDSC에 방문해주셔서 감사합니다." +
                        "<br><br>" +
                        "인증 번호는 " + authNumber + "입니다." +
                        "<br>" +
                        "인증번호를 정확히 입력해주세요";
        sendMail(setFrom, toMail, title, content);
        return Integer.toString(authNumber);
    }
    public void sendMail(String setFrom, String toMail, String title, String content){
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        redisUtil.setDataExpire(Integer.toString(authNumber),toMail,60*5L);
    }
}
