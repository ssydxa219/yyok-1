package com.yyok;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import tk.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@EnableEurekaClient
@EnableFeignClients
@MapperScan("com.yyok.admin.mapper")
public class YYOKAdminBootstrap {

	public static void main(String[] args) {
		SpringApplication.run(YYOKAdminBootstrap.class, args);
	}

}
