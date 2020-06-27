package com.yyok.admin.util.comparator;


import com.yyok.admin.model.MenuTree;

import java.util.Comparator;

/**
 * @description: 所有的排序都是按照字段的升序处理 优先级别同 菜单查询SQL {Order By level, sort, id Asc} 一致
 **/
public class MenuTreeComparator implements Comparator<MenuTree> {

    @Override
    public int compare(MenuTree o1, MenuTree o2) {
        if (!o1.getLevel().equals(o2.getLevel())) {
            return o1.getLevel() - o2.getLevel();
        } else if (o1.getSort() != null && o2.getSort() != null) {
            return o1.getSort() - o2.getSort();
        } else {
            return o1.getId() - o2.getId();
        }
    }

}
