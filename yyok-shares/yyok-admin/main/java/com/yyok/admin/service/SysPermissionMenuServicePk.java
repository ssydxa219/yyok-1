package com.yyok.admin.service;

import com.yyok.admin.mapper.SysMenuMapper;
import com.yyok.admin.mapper.SysPermissionMenuPkMapper;
import com.yyok.admin.model.MenuTree;
import com.yyok.admin.model.SysPermissionMenuPk;
import com.yyok.admin.util.MenuTreeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysPermissionMenuServicePk extends BaseService<SysPermissionMenuPkMapper, SysPermissionMenuPk> {

    @Autowired
    private SysMenuMapper sysMenuMapper;

    public List<MenuTree> loadPermissionNoMenuTree(Integer permissionId){
        List<MenuTree> allList = sysMenuMapper.selectByAll(1);
        List<MenuTree> currentList = sysMenuMapper.selectPermissionNoExistMenus(permissionId);
        return MenuTreeUtil.filterGenerateSortMenu(allList, currentList);
    }

    public List<MenuTree> loadPermissionMenuTree(Integer permissionId){
        List<MenuTree> allList = sysMenuMapper.selectByAll(1);
        List<MenuTree> currentList = sysMenuMapper.selectPermissionMenus(permissionId);
        return MenuTreeUtil.filterGenerateSortMenu(allList, currentList);
    }

    public Integer batchInsert(List<SysPermissionMenuPk> list) {
        return this.mapper.insertPermissionMenus(list);
    }

    public Integer batchDelete(Integer permissionId, Integer [] menuIds) {
        Map<String, Object> map = new HashMap<String, Object>(2){{
            put("permissionId", permissionId);
            put("menuIds", menuIds);
        }};
        return this.mapper.deletePermissionMenus(map);
    }
}
