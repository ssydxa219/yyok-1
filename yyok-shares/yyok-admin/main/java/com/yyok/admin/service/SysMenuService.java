package com.yyok.admin.service;

import com.yyok.admin.mapper.SysMenuMapper;
import com.yyok.admin.model.MenuTree;
import com.yyok.admin.model.SysMenu;
import com.yyok.admin.util.MenuTreeUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class SysMenuService extends BaseService<SysMenuMapper, SysMenu> {

    public List<MenuTree> loadAllMenuTree() {
        List<MenuTree> list = this.mapper.selectByAll(1);
        return MenuTreeUtil.generateMenuTree(list);
    }

}
