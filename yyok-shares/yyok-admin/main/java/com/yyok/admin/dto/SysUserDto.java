package com.yyok.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
public class SysUserDto {

    @NotBlank
    private String username;

    private String password;

    @NotBlank
    private String name;

    @NotBlank
    private String groupId;

    @NotBlank
    private String state;

    private String id;
}
