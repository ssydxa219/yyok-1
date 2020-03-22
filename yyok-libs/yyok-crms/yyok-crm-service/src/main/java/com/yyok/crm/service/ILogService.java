package com.yyok.crm.service;

import com.yyok.crm.bean.Log;
import com.yyok.crm.bean.LogExample;

import java.util.List;

public interface ILogService {
	/**
	 * 
	 * 描述： 按照Example 统计记录总数
	 * @param logExample 查询条件
	 * @return long 数据的数量
	 *
	 */ 	
	public long countByLogExample(LogExample logExample);

	/**
	 * 
	 * 描述：按照Example 删除Log
	 * @param logExample
	 * @return boolean 删除的结果
	 *
	 */
	public boolean deleteByLogExample(LogExample logExample);

	/**
	 * 
	 * 描述：按照Log主键id删除Log
	 * @param id 数据字典id
	 * @return boolean 删除结果
	 *
	 */
	public boolean deleteByPrimaryKey(Integer id);
	
	/**
	 * 
	 * 描述：插入一条Log数据 如字段为空，则插入null
	 * @param log  客户数据
	 * @return boolean 插入结果
	 *
	 */
	public boolean insertLog(Log log);
	
	/**
	 * 
	 * 描述：插入一条Log数据，如字段为空，则插入数据库表字段的默认值
	 * @param log 客户数据
	 * @return boolean 插入结果
	 *
	 */
	public boolean insertSelective(Log log);
	
	/**
	 * 
	 * 描述：按照Example条件 模糊查询
	 * @param logExample 查询条件
	 * @return List<Log> 含Log的list
	 *
	 */
	public List<Log> selectByLogExample(LogExample logExample);
	
	/**
	 * 
	 * 描述：按照Log 的id 查找 Log
	 * @param id 要查询的id
	 * @return Log 查到的数据或空值
	 *
	 */
	public Log selectLogByPrimaryKey(Integer id);
	
	/**
	 * 
	 * 描述：更新Log
	 * @param log 对象中若有空则更新字段为null
	 * @param logExample 为where条件
	 * @return boolean 更新结果
	 *
	 */
	public boolean updateByLogExample(Log log, LogExample logExample);
	
	/**
	 * 
	 * 描述：更新Log 
	 * @param log 对象中若有空则不会更新此字段
	 * @param logExample 为where条件
	 * @return boolean 更新结果
	 *
	 */
	public boolean updateByLogExampleSelective(Log log, LogExample logExample);
		
	/**
	 * 
	 * 描述：按照Log id 更新Log
	 * @param log 对象中如有空则不会更新此字段
	 * @return boolean
	 *
	 */
	public boolean updateLogByPrimaryKeySelective(Log log);
	
	/**
	 * 
	 * 描述：按照Log id 更新Log
	 * @param log 对象中如有空则更新此字段为null
	 * @return boolean
	 *
	 */
	public boolean updateLogByPrimaryKey(Log log);	
}
