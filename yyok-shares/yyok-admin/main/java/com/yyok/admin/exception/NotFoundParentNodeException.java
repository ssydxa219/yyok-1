package com.yyok.admin.exception;


import com.yyok.admin.model.MenuTree;

public class NotFoundParentNodeException extends Exception {

    public NotFoundParentNodeException() {}

    public NotFoundParentNodeException(MenuTree node) {
        super(new StringBuffer("菜单错误错误 无法找到父节点 ").append(node.toString()).toString());
    }

}
