package com.yyok.admin.mapper;

import com.yyok.admin.model.SysPermissionResourcePk;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

public interface SysPermissionResourcePkMapper extends Mapper<SysPermissionResourcePk> {

    Integer insertPermissionResources(List<SysPermissionResourcePk> list);

    Integer deletePermissionResources(Map<String, Object> map);
}
