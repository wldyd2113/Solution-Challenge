package com.gdsc.solutionchallenge.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FirebaseIdTokenDto {
    private String firebaseIdToken;

    public String getFirebaseIdToken() {
        return firebaseIdToken;
    }

    public void setFirebaseIdToken(String firebaseIdToken) {
        this.firebaseIdToken = firebaseIdToken;
    }
}
