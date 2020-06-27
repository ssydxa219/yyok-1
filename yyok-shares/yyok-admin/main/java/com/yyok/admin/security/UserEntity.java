package com.yyok.admin.security;

import com.yyok.common.constants.SysConstant;
import com.yyok.common.utils.ListUtils;
import lombok.Data;

import java.util.List;

@Data
public class UserEntity {

    private Long userId;

    private String username;

    private List<String> roles;

    public UserEntity(Long userId, String username) {
        this.userId = userId;
        this.username = username;
    }

    public UserEntity(Long userId, String username, List<String> roles) {
        this.userId = userId;
        this.username = username;
        this.roles = roles;
    }

    /**
     * 判断用户是否拥有角色
     * @return
     */
    public boolean isRoles() {
        return !ListUtils.isEmpty(this.roles);
    }

    /**
     * 判断是否是超级管理员
     * @return
     */
    public boolean isAdmin() {
        if (this.isRoles() && this.getRoles().contains(SysConstant.SUPER_ADMIN_ROLE_CODE)) {
            return true;
        }
        return false;
    }

}
