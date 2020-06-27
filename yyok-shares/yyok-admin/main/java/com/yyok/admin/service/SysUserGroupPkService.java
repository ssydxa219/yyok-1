package com.yyok.admin.service;

import com.github.pagehelper.PageHelper;
import com.yyok.admin.dto.UserGroupDto;
import com.yyok.admin.mapper.SysUserGroupPkMapper;
import com.yyok.admin.mapper.SysUserMapper;
import com.yyok.admin.model.SysUserGroupPk;
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
public class SysUserGroupPkService extends BaseService<SysUserGroupPkMapper, SysUserGroupPk> {

    @Autowired
    private SysUserMapper sysUserMapper;

    public void setSysUserMapper(SysUserMapper sysUserMapper) {
        this.sysUserMapper = sysUserMapper;
    }

    public ResponsePage loadGroupNoRelationUsers(UserGroupDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysUserMapper.selectGroupNoUsers(map));
    }

    public ResponsePage loadGroupUsers(UserGroupDto dto){
        PageHelper.startPage(dto.getPage(), dto.getSize());
        Map<String, Object> map = getQueryParams(dto);
        return new ResponsePage<>(sysUserMapper.selectGroupUsers(map));
    }

    private Map<String, Object> getQueryParams(UserGroupDto dto) {
        return new HashMap<String, Object>(1){{
            put("groupId", dto.getGroupId());
            if (StringUtils.isNotBlank(dto.getName())) {
                put("name", dto.getName());
            }
        }};
    }

    public Integer batchInsert(List<SysUserGroupPk> list) {
        return this.mapper.insertGroupUsers(list);
    }

    public Integer batchDelete(int groupId, Long [] userIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
            put("groupId", groupId);
            put("userIds", userIds);
        }};
        return this.mapper.deleteGroupUsers(map);
    }

}
