package com.yyok.admin.mapper;

import com.yyok.admin.model.SysUserRolePk;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;
import java.util.Map;

public interface SysUserRolePkMapper extends Mapper<SysUserRolePk> {

    Integer insertUserRoles(List<SysUserRolePk> list);

    Integer deleteUserRoles(Map<String, Object> map);


}
