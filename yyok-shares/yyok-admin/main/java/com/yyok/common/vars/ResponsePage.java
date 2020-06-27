package com.yyok.common.vars;

import com.github.pagehelper.PageInfo;
import lombok.Data;

import java.util.List;

@Data
public class ResponsePage<T> {
    private int page;
    private int pages;
    private int size;
    private long total;
    private List<T> data;

    public ResponsePage(List<T> list) {
        PageInfo<T> pageInfo = new PageInfo<>(list);
        this.pages = pageInfo.getPages();
        this.page = pageInfo.getNextPage();
        this.size = pageInfo.getPageSize();
        this.total = pageInfo.getTotal();
        this.data = pageInfo.getList();
    }
}
