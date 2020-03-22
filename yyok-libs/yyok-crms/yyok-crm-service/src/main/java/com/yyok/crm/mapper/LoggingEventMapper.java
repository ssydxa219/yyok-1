package com.yyok.crm.mapper;

import com.yyok.crm.bean.LoggingEvent;
import com.yyok.crm.bean.LoggingEventExample;

import java.util.List;

/**
 * LoggingEventMapper继承基类
 */
public interface LoggingEventMapper extends MyBatisBaseDao<LoggingEvent, Long, LoggingEventExample> {
	
	/**
	 * 描述：
	    * @Title: selectByExampleWithBLOBs
	    * @Description: TODO(查询含有text文本类型的结果集)
	    * @param @param loggingEventExample
	    * @param @return    参数
	    * @return List<LoggingEvent>    返回类型
	    * @throws
	    * @author huangqingwen
	 */
	public List<LoggingEvent> selectByExampleWithBLOBs(LoggingEventExample loggingEventExample);
	
	public int insertLog(LoggingEvent loggingEvent);
}