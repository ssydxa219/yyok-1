package com.yyok.common.config;

import com.yyok.common.service.impl.JdkSerializationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @description: TODO 配置token序列化
 */
@Configuration
public class StandardStringSerializationConfig {

    @Bean
    public RedisTokenStoreSerializationStrategy redisTokenStoreSerializationStrategy(){
        return new JdkSerializationStrategy();
    }
}
