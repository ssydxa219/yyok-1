package com.yyok.admin.vo;

import com.yyok.admin.model.SysUser;

public class SysUserInfo extends SysUser {

    /**
     * 用户组Id
     */
    private Integer groupId;

    /**
     * 用户组名称
     */
    private String groupName;


    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
