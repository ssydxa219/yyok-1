package com.yyok;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;


@SpringBootApplication
@Slf4j
@EnableDiscoveryClient
@EnableEurekaClient
public class YYOKHomeBootstrap {

    public static void main(String[] args) {
        SpringApplication.run(YYOKHomeBootstrap.class, args);
    }

}