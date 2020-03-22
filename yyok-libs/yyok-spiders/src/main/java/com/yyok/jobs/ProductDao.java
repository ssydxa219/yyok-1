package com.yyok.jobs;


import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.springframework.jdbc.core.JdbcTemplate;

import java.beans.PropertyVetoException;

public class ProductDao extends JdbcTemplate{

    public ProductDao()  {
        ComboPooledDataSource ds = new ComboPooledDataSource();
        try {
            ds.setJdbcUrl("jdbc:mysql://localhost:3306/spider13");
            ds.setUser("root");
            ds.setPassword("root");
            ds.setDriverClass("com.mysql.jdbc.Driver");
        } catch (PropertyVetoException e) {
            e.printStackTrace();
        }
        super.setDataSource(ds);
    }
    public void addProduct(Product product){
        String sql = "insert into product values(?,?,?,?,?,?)";
        Object[] params = {product.getPid(),product.getTitle(),product.getPrice(),product.getPname(),product.getUrl(),product.getBrand()};
        update(sql,params);
    }
    public int addCompany(Company company){
        String sql = "insert into company values(?,?,?,?,?,?)";
        Object[] params = {company.getCid(),company.getCname(),company.getCity(),company.getSize(),company.getType(),company.getUrl()};
        return update(sql,params);
    }
    public int addPostInfo(PostInfo postInfo){
        String sql = "insert into postInfo values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        Object[] params = {postInfo.getPid(),postInfo.getJobName(),postInfo.getSalary(),postInfo.getPostAddres(),postInfo.getWorkingExp(),
                postInfo.getEduLevel(),postInfo.getEmplType(),postInfo.getPeopleNum(),postInfo.getWelfare(),
                postInfo.getPositionInfo(),postInfo.getCid(),postInfo.getPositionURL(),postInfo.getUpdateDate(),
                postInfo.getCreateDate(),postInfo.getEndDate(),postInfo.getIntroduce()};
        return update(sql,params);
    }
}