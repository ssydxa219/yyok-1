package com.yyok;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class YYOKGatewayBootstrap {
    public static void main(String[] args) {
        SpringApplication.run(YYOKGatewayBootstrap.class, args);
    }
}
