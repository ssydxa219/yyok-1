package com.yyok.jobs;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@SuppressWarnings("serial")
@AllArgsConstructor
@NoArgsConstructor
@Data
@Accessors(chain = true)
public class Product {
    private String pid;
    private String url;
    private Double price;
    private String brand;
    private String title;
    private String pname;
}