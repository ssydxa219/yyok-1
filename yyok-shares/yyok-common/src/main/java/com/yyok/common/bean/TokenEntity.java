package com.yyok.common.bean;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class TokenEntity {

    private String token;
    @DateTimeFormat
    private LocalDateTime expiration;
    private Integer userId;
    private String username;
    private String clientId;
    private String grantType;
    private Integer limitLevel;
}
