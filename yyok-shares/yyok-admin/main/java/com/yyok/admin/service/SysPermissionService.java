package com.yyok.admin.service;

import com.yyok.admin.mapper.SysPermissionMapper;
import com.yyok.admin.mapper.SysPermissionMenuPkMapper;
import com.yyok.admin.mapper.SysPermissionResourcePkMapper;
import com.yyok.admin.mapper.SysResourceMapper;
import com.yyok.admin.model.SysPermission;
import com.yyok.admin.model.SysPermissionMenuPk;
import com.yyok.admin.model.SysPermissionResourcePk;
import com.yyok.admin.model.SysResource;
import com.yyok.common.utils.ListUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysPermissionService extends BaseService<SysPermissionMapper, SysPermission> {

    @Autowired
    private SysPermissionMenuPkMapper sysPermissionMenuPkMapper;

    @Autowired
    private SysPermissionResourcePkMapper sysPermissionResourcePkMapper;

    @Autowired
    private SysResourceMapper sysResourceMapper;

    public void delete(int id) {
        // 删除关联菜单
        SysPermissionMenuPk permissionMenuPk = new SysPermissionMenuPk();
        permissionMenuPk.setPermissionId(id);
        sysPermissionMenuPkMapper.delete(permissionMenuPk);
        // 删除关联资源
        SysPermissionResourcePk permissionResourcePk = new SysPermissionResourcePk();
        permissionResourcePk.setPermissionId(id);
        sysPermissionResourcePkMapper.delete(permissionResourcePk);
        // 删除权限
        this.deleteById(id);
    }

    public List<SysResource> selectPermissionResource(int permissionId) {
        List<SysResource> allSysResources = this.sysResourceMapper.selectAllResources();
        List<SysResource> currentSysResources = this.sysResourceMapper.selectPermissionResources(permissionId);
        List<Long> resourcesIds = new ArrayList<>();
        if (!ListUtils.isEmpty(currentSysResources)) {
            currentSysResources.forEach(item -> {
                resourcesIds.add(item.getId());
            });
        }
        List<SysResource> sysResources = new ArrayList<>();
        SysResource parent = null;
        for (int i = 0; i < allSysResources.size(); i ++) {
            SysResource item = allSysResources.get(i);
            if (resourcesIds.size() > 0 && resourcesIds.contains(item.getId())) {
                item.setChecked(true);
            }
            if (item.getLevel() == 1) {
                sysResources.add(item);
            } else {
                if (parent == null || !item.getParentId().equals(parent.getId())) {
                    for (int j = 0; j < sysResources.size(); j ++) {
                        SysResource parentItem = sysResources.get(j);
                        if (item.getParentId().equals(parentItem.getId())) {
                            parent = parentItem;
                            parent.setChildren(new ArrayList<>());
                            break;
                        }
                    }
                }
                parent.getChildren().add(item);
            }
        }
        return sysResources;
    }

    public Integer batchInsertPermissionResource(List<SysPermissionResourcePk> list) {
        SysPermissionResourcePk pk = new SysPermissionResourcePk();
        pk.setPermissionId(list.get(0).getPermissionId());
        this.sysPermissionResourcePkMapper.delete(pk);
        return this.sysPermissionResourcePkMapper.insertPermissionResources(list);
    }

}
