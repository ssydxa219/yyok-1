package com.yyok.common.bean;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StoreUser implements Serializable {
    private Object userId;
    private int limitLevel;
    private String userName;
}
