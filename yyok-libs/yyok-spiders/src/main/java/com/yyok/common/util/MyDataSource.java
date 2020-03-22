package com.yyok.common.util;

import org.apache.commons.dbcp2.BasicDataSource;

import javax.sql.DataSource;

public class MyDataSource {

    public static DataSource getDataSource(String connectURI){

        BasicDataSource ds = new BasicDataSource();
        //MySQL的jdbc驱动
        ds.setDriverClassName("com.mysql.jdbc.Driver");
        ds.setUsername("root");              //所要连接的数据库名
        ds.setPassword("root");                //MySQL的登陆密码
        ds.setUrl(connectURI);

        return ds;

    }

}