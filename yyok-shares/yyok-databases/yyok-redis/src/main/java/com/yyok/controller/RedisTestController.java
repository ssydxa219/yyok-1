package com.yyok.controller;


import com.yyok.config.RedisConstants;
import com.yyok.service.RedisServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @Description:
 */
@Controller
@RequestMapping("/redis")
public class RedisTestController {

    @Autowired
    RedisServiceImpl redisServiceImpl;

    /**
     * @return: org.springframework.ui.ModelMap
     * @Description: 测试redis存储&读取
     */
    @RequestMapping(value = "/test")
    @ResponseBody
    public String test() {
        try {
            redisServiceImpl.set("redisTemplate", "这是一条测试数据", RedisConstants.datebase2);
            String value = redisServiceImpl.get("redisTemplate", RedisConstants.datebase2).toString();
            return "操作成功";
        } catch (Exception e) {
            e.printStackTrace();
            return "操作失败";
        }
    }

}
