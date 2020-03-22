package com.yyok.common.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.core.constants.CommonConstants;
import com.example.common.core.entity.RateLimiterLevel;
import com.example.common.core.entity.RateLimiterVO;
import com.yyok.common.service.ILimiterLevelResolver;
import com.yyok.common.service.IRedisTokenStoreSerializationStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;

import java.util.ArrayList;
import java.util.List;

public class RedisLimiterLevelHandler implements ILimiterLevelResolver {

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private IRedisTokenStoreSerializationStrategy redisTokenStoreSerializationStrategy;

    @Override
    public void save(RateLimiterLevel limiterLevel) {
        byte[] key = redisTokenStoreSerializationStrategy.serialize(CommonConstants.REDIS_LIMIT_KEY);
        byte[] value = redisTokenStoreSerializationStrategy.serialize(limiterLevel);
        try{
            redisTemplate.getConnectionFactory().getConnection().openPipeline();
            redisTemplate.getConnectionFactory().getConnection().set(key, value);
            redisTemplate.getConnectionFactory().getConnection().closePipeline();
        }finally {
            redisTemplate.getConnectionFactory().getConnection().close();
        }
    }

    @Override
    public RateLimiterLevel get() {
        byte[] key = redisTokenStoreSerializationStrategy.serialize(CommonConstants.REDIS_LIMIT_KEY);
        byte[] value = redisTemplate.getConnectionFactory().getConnection().get(key);
        RateLimiterLevel rateLimiterLevel = redisTokenStoreSerializationStrategy.deserialize(value,RateLimiterLevel.class);
        if(ObjectUtil.isNull(value) ||  ObjectUtil.isNull(rateLimiterLevel) || CollUtil.isEmpty(rateLimiterLevel.getLevels())){
            rateLimiterLevel = new RateLimiterLevel();
            List<RateLimiterVO> vos = new ArrayList<>();
            vos.add(RateLimiterVO
                    .builder()
                    .level(CommonConstants.DEFAULT_LEVEL)
                    .burstCapacity(CommonConstants.DEFAULT_LIMIT_LEVEL)
                    .replenishRate(CommonConstants.DEFAULT_LIMIT_LEVEL)
                    .limitType(CommonConstants.DEFAULT_LIMIT_TYPE)
                    .build());
            rateLimiterLevel.setLevels(vos);
        }
        return rateLimiterLevel;
    }
}
