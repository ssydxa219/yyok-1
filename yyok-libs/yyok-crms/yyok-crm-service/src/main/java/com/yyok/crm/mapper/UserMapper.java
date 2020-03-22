package com.yyok.crm.mapper;


import com.yyok.crm.bean.User;
import com.yyok.crm.bean.UserExample;

/**
 * UserMapper继承基类
 */
public interface UserMapper extends MyBatisBaseDao<User, Integer, UserExample> {
}