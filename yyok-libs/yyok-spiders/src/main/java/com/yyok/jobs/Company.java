package com.yyok.jobs;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;

@SuppressWarnings("serial")
@AllArgsConstructor
@NoArgsConstructor
@Data
@Accessors(chain = true)
public class Company implements Serializable {

    private String cid;//id
    private String cname;//名称
    private String city;//所在城市
    private String size;//公司人数
    private String type;//公司类型
    private String url;//公司网址

}