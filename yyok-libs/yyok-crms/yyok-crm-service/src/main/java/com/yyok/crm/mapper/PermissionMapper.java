package com.yyok.crm.mapper;

import com.yyok.crm.bean.Permission;
import com.yyok.crm.bean.PermissionExample;

import java.util.List;

/**
 * PermissionMapper继承基类
 * @author MybatisGenerator
 */
public interface PermissionMapper extends MyBatisBaseDao<Permission, Integer, PermissionExample> {
	
	/**
	 * 查询父级权限
	 * @param pid
	 * @return
	 */
	public Permission selectParentPermissionByPid(Integer pid);
	
	/**
	 * 查询权限树结构
	 * @param 
	 * @return  List<Permission>
	 */
	public List<Permission> selectTreePermission();
	
	/**
	* 描述：根据当前id查询改id下的所有子权限
    * @Title: selectChildPermission
    * @Description: TODO(根据当前id查询改id下的所有子权限)
    * @param @param id
    * @param @return    参数
    * @return List<Permission>    返回类型
    * @throws
	*/
	public List<Permission> selectChildPermission(Integer id);

	/**
	* 描述： 设置当前权限为顶级权限
    * @Title: selectChildPermission
    * @Description: TODO(设置当前权限为顶级权限)
    * @param permission
    * @return int
    * @throws
	*/
	public int setTopPermission(Permission permission);
}