package com.yyok.scheduled.repository;

import com.yyok.scheduled.bean.TaskList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;


public interface TaskListRepository extends JpaRepository<TaskList,Integer>,JpaSpecificationExecutor<TaskList> {

	public List<TaskList> findByStatus(Integer status);
	
	@Modifying
	@Query(value = "update task_list set cron=?1 where id=?2",nativeQuery = true)
	public void updateCronById(String cron, Integer id);
} 
