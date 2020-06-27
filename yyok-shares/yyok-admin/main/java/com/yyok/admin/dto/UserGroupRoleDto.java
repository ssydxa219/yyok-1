package com.yyok.admin.dto;

import com.yyok.common.dto.RequestDto;
import lombok.Data;

@Data
public class UserGroupRoleDto extends RequestDto {

    /**
     * 用户Id
     */
    private int groupId;

    /**
     * 多个角色Id
     */
    private int [] roleIds;

}
