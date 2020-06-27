package com.yyok.admin.dto;

import com.yyok.common.dto.RequestDto;
import lombok.Data;

@Data
public class PermissionResourceDto extends RequestDto {

    private Integer permissionId;

    private Long [] resourceIds;

}
