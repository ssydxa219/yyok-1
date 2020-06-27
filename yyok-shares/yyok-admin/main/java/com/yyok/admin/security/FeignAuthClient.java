package com.yyok.admin.security;

import com.yyok.admin.model.SysUser;
import com.yyok.common.vars.HttpResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "yyok-admin")
public interface FeignAuthClient {

    /**
     * 远程获取用户资源
     * @param userId
     * @return
     */
    @GetMapping(value = "public/api/sysUser/userResources")
    HttpResponse<SysUser> getUserResources(@RequestParam(value = "userId") Long userId);

}


