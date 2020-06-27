package com.yyok.admin.mapper;

import com.yyok.admin.model.SysUserGroupRolePk;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

public interface SysUserGroupRolePkMapper extends Mapper<SysUserGroupRolePk> {

    Integer insertGroupRoles(List<SysUserGroupRolePk> list);

    Integer deleteGroupRoles(Map<String, Object> map);

}
