package com.yyok.controller;

import com.github.pagehelper.PageInfo;
import com.yyok.common.ResponseData;
import com.yyok.common.TableData;

import java.util.List;

/**
 * 单表维护 Controller 模板
 */
abstract public class CrudController<T, R> {

    /**
     * 表格查询
     */
    abstract protected ResponseData<TableData<T>> queryRecord(R query);

    /**
     * 添加记录
     */
    abstract protected ResponseData<T> addRecord(T record);

    /**
     * 批量删除记录
     */
    abstract protected ResponseData<T> deleteRecord(List<T> record);

    /**
     * 更新记录
     */
    abstract protected ResponseData<T> updateRecord(T record);

    /**
     * 返回表格数据
     */
    protected ResponseData<TableData<T>> getTableData(Integer code, String message, PageInfo<T> pageInfo) {
        TableData<T> data = new TableData();
        data.setTotal(pageInfo.getTotal());
        data.setRows(pageInfo.getList());
        return new ResponseData(code, message, data);
    }


    static
    {
        System.getProperty("java.library.path");
        System.loadLibrary("libIAL");//载入需要调用的dll  Connector.dll

        //System.load("libIAL.so");//载入dll  Connector.dll
    }

    public static void main(String[] args) {
        System.out.println("fffffff");

    }
}