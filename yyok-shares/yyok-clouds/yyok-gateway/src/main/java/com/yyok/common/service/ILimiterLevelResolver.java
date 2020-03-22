package com.yyok.common.service;


public interface ILimiterLevelResolver {

    default void save(RateLimiterLevel limiterLevel){}

    default RateLimiterLevel get(){
        return null;
    }
}
