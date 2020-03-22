package com.yyok.common.bean;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PermissionEntityVO implements Serializable {
    private String name;
    private String permission;
    private String url;
    private String serviceId;
}
