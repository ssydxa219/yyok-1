package com.yyok.common.dto;

import lombok.Data;

@Data
public class RequestDto {

    private int size = 10;
    private int page = 1;
    private String name;
    private String key;

}
