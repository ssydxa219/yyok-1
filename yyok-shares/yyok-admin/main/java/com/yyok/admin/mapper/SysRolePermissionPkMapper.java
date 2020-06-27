package com.yyok.admin.mapper;

import com.yyok.admin.model.SysRolePermissionPk;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

public interface SysRolePermissionPkMapper extends Mapper<SysRolePermissionPk> {

    Integer insertRolePermissions(List<SysRolePermissionPk> list);

    Integer deleteRolePermissions(Map<String, Object> map);
}