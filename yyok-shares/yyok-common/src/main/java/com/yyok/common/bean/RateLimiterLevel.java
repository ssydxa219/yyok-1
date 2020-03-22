package com.yyok.common.bean;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @description: TODO 限流等级配置
 */
@Data
public class RateLimiterLevel implements Serializable {
    private List<RateLimiterVO> levels;
}
