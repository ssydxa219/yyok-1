package com.yyok.admin.service;

import com.github.pagehelper.PageHelper;
import com.yyok.admin.dto.UserRoleDto;
import com.yyok.admin.mapper.SysRoleMapper;
import com.yyok.admin.mapper.SysUserRolePkMapper;
import com.yyok.admin.model.SysUserRolePk;
import com.yyok.common.vo.ResponsePage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysUserRolePkService extends BaseService<SysUserRolePkMapper, SysUserRolePk> {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    public void setSysRoleMapper(SysRoleMapper sysRoleMapper) {
        this.sysRoleMapper = sysRoleMapper;
    }

    public ResponsePage loadUserNoRelationRoles(UserRoleDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysRoleMapper.selectUserNoRoles(map));
    }

    public ResponsePage loadUserRoles(UserRoleDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysRoleMapper.selectUserRoles(map));
    }

    private Map<String, Object> getQueryParams(UserRoleDto dto) {
        return new HashMap<String, Object>(1){{
            put("userId", dto.getUserId());
            if (StringUtils.isNotBlank(dto.getName())) {
                put("name", dto.getName());
            }
        }};
    }

    public Integer batchInsert(List<SysUserRolePk> list) {
        return this.mapper.insertUserRoles(list);
    }

    public Integer batchDelete(Long userId, Integer [] roleIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
           put("userId", userId);
           put("roleIds", roleIds);
        }};
        return this.mapper.deleteUserRoles(map);
    }
}
