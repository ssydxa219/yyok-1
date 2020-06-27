package com.yyok.common.vars;

import lombok.Data;

@Data
public class RequestParam {

    private int size = 10;
    private int page = 1;
    private String name;
    private String key;

}
