package com.yyok.admin.dto;

import com.yyok.common.vo.RequestDto;
import lombok.Data;

@Data
public class UserRoleDto extends RequestDto {

    /**
     * 用户Id
     */
    private Long userId;

    /**
     * 多个角色Id
     */
    private Integer [] roleIds;

}
