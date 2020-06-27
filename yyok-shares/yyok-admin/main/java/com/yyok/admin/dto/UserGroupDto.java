package com.yyok.admin.dto;

import com.yyok.common.dto.RequestDto;
import lombok.Data;

@Data
public class UserGroupDto extends RequestDto {

    /**
     * 用户Id
     */
    private int groupId;

    /**
     * 多个角色Id
     */
    private Long [] userIds;

}
