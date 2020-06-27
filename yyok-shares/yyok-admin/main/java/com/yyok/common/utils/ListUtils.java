package com.yyok.common.utils;

import java.util.List;

/**
 * @description: List 工具类
 **/
public class ListUtils {

    /**
     * 非空且长度不为0的判断
     * @param list
     * @return
     */
    public static boolean isEmpty(List<?> list) {
        if (list == null || list.size() == 0) {
            return true;
        }
        return false;
    }

}
