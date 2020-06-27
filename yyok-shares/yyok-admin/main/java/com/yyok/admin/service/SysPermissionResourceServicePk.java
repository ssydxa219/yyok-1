package com.yyok.admin.service;

import com.yyok.admin.dto.PermissionResourceDto;
import com.yyok.admin.mapper.SysPermissionResourcePkMapper;
import com.yyok.admin.mapper.SysResourceMapper;
import com.yyok.admin.model.SysPermissionResourcePk;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysPermissionResourceServicePk extends BaseService<SysPermissionResourcePkMapper, SysPermissionResourcePk> {

    @Autowired
    private SysResourceMapper sysResourceMapper;

    public void setSysResourceMapper(SysResourceMapper sysResourceMapper) {
        this.sysResourceMapper = sysResourceMapper;
    }

    private Map<String, Object> getQueryParams(PermissionResourceDto dto) {
        return new HashMap<String, Object>(1){{
            put("permissionId", dto.getPermissionId());
            if (StringUtils.isNotBlank(dto.getName())) {
                put("name", dto.getName());
            }
        }};
    }

    public Integer batchInsert(List<SysPermissionResourcePk> list) {
        return this.mapper.insertPermissionResources(list);
    }

    public Integer batchDelete(Integer permissionId, Long [] resourceIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
            put("permissionId", permissionId);
            put("resourceIds", resourceIds);
        }};
        return this.mapper.deletePermissionResources(map);
    }
}
