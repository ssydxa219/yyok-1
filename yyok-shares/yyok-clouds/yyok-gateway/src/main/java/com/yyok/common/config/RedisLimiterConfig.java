package com.yyok.common.config;

import com.yyok.common.service.impl.RedisLimiterLevelHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RedisLimiterConfig {

    @Bean
    public LimiterLevelResolver limiterLevelResolver(){
        return new RedisLimiterLevelHandler();
    }
}
