package com.yyok.admin.mapper;

import com.yyok.admin.model.SysPermission;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

public interface SysPermissionMapper extends Mapper<SysPermission>{

    List<SysPermission> selectRoleNoPermissions(Map<String, Object> map);

    List<SysPermission> selectRolePermissions(Map<String, Object> map);

}
