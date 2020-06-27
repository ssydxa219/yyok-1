package com.yyok.admin.service;

import com.github.pagehelper.PageHelper;
import com.yyok.admin.dto.RolePermissionDto;
import com.yyok.admin.mapper.SysPermissionMapper;
import com.yyok.admin.mapper.SysRolePermissionPkMapper;
import com.yyok.admin.model.SysRolePermissionPk;
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
public class SysRolePermissionServicePk extends BaseService<SysRolePermissionPkMapper, SysRolePermissionPk> {

    @Autowired
    private SysPermissionMapper sysPermissionMapper;

    public void setSysPermissionMapper(SysPermissionMapper sysPermissionMapper) {
        this.sysPermissionMapper = sysPermissionMapper;
    }

    public ResponsePage loadRoleNoRelationPermissions(RolePermissionDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysPermissionMapper.selectRoleNoPermissions(map));
    }

    public ResponsePage loadRolePermissions(RolePermissionDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysPermissionMapper.selectRolePermissions(map));
    }

    private Map<String, Object> getQueryParams(RolePermissionDto dto) {
        return new HashMap<String, Object>(1){{
            put("roleId", dto.getRoleId());
            if (StringUtils.isNotBlank(dto.getName())) {
                put("name", dto.getName());
            }
        }};
    }

    public Integer batchInsert(List<SysRolePermissionPk> list) {
        return this.mapper.insertRolePermissions(list);
    }

    public Integer batchDelete(Integer roleId, Integer [] permissionIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
            put("roleId", roleId);
            put("permissionIds", permissionIds);
        }};
        return this.mapper.deleteRolePermissions(map);
    }
}
