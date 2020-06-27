package com.yyok.admin.dto;

import com.yyok.common.vo.RequestDto;
import lombok.Data;

@Data
public class RolePermissionDto extends RequestDto {

    /**
     * 角色Id
     */
    private Integer roleId;

    /**
     * 多个权限Id
     */
    private Integer [] permissionIds;

}
