package com.yyok.admin.service;

import com.yyok.admin.mapper.SysRoleMapper;
import com.yyok.admin.mapper.SysRolePermissionPkMapper;
import com.yyok.admin.model.SysRole;
import com.yyok.admin.model.SysRolePermissionPk;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysRoleService extends BaseService<SysRoleMapper, SysRole>{

    @Autowired
    private SysRolePermissionPkMapper sysRolePermissionPkMapper;

    @Override
    public void deleteById(Object id) {
        // 删除关联的权限
        SysRolePermissionPk rolePermissionPk = new SysRolePermissionPk();
        rolePermissionPk.setRoleId(Integer.valueOf(id.toString()));
        sysRolePermissionPkMapper.delete(rolePermissionPk);
        // 删除角色
        super.deleteById(id);
    }


    public List<SysRole> selectUserAndGroupResultRoles(Long userId) {
        return this.mapper.selectUserAndGroupResultRoles(userId);
    }

}
