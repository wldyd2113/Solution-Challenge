//package com.gdsc.solutionchallenge.config;
//
//import com.google.api.services.storage.model.Bucket;
//import com.google.auth.oauth2.GoogleCredentials;
//import com.google.cloud.storage.StorageClass;
//import com.google.firebase.FirebaseApp;
//import com.google.firebase.FirebaseOptions;
//import com.google.firebase.auth.FirebaseAuth;
//import com.google.firebase.cloud.StorageClient;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//import java.io.FileInputStream;
//import java.io.IOException;
//
//@Configuration
//public class FirebaseConfig {
//
//    @Bean
//    public FirebaseApp firebaseApp() throws IOException{
//        FileInputStream serviceAccount = new FileInputStream("./SolutionChallenge.json");
//
//        FirebaseOptions options = FirebaseOptions.builder()
//                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
//                .setStorageBucket("solution-challenge-412508.appspot.com")
//                .build();
//        FirebaseApp app = FirebaseApp.initializeApp(options);
//
//        return app;
//    }
//    @Bean
//    public FirebaseAuth firebaseAuth() throws IOException{
//        return FirebaseAuth.getInstance(firebaseApp());
//    }
//
//
//}
