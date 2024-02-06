package com.gdsc.solutionchallenge.dto;

import com.google.gson.annotations.SerializedName;
import lombok.Data;

@Data
public class MemberInfo {
    private String id;
    private String email;
    @SerializedName("verified_email")
    private Boolean verifiedEmail;
    private String name;
    @SerializedName("given_name")
    private String givenName;
    @SerializedName("Family_name")
    private String familyName;
    @SerializedName("picture")
    private String pictureUrl;
    private String locale;
}