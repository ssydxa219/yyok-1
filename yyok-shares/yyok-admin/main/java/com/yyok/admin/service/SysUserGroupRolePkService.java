package com.yyok.admin.service;

import com.github.pagehelper.PageHelper;
import com.yyok.admin.dto.UserGroupRoleDto;
import com.yyok.admin.mapper.SysRoleMapper;
import com.yyok.admin.mapper.SysUserGroupRolePkMapper;
import com.yyok.admin.model.SysUserGroupRolePk;
import com.yyok.common.vars.ResponsePage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysUserGroupRolePkService extends BaseService<SysUserGroupRolePkMapper, SysUserGroupRolePk> {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    public void setSysRoleMapper(SysRoleMapper sysRoleMapper) {
        this.sysRoleMapper = sysRoleMapper;
    }

    public ResponsePage loadGroupNoRelationRoles(UserGroupRoleDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysRoleMapper.selectUserGroupNoRoles(map));
    }

    public ResponsePage loadGroupRoles(UserGroupRoleDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysRoleMapper.selectUserGroupRoles(map));
    }

    private Map<String, Object> getQueryParams(UserGroupRoleDto dto) {
        return new HashMap<String, Object>(1){{
            put("groupId", dto.getGroupId());
            if (StringUtils.isNotBlank(dto.getName())) {
                put("name", dto.getName());
            }
        }};
    }

    public Integer batchInsert(List<SysUserGroupRolePk> list) {
        return this.mapper.insertGroupRoles(list);
    }

    public Integer batchDelete(int groupId, int [] roleIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
            put("groupId", groupId);
            put("roleIds", roleIds);
        }};
        return this.mapper.deleteGroupRoles(map);
    }

}
