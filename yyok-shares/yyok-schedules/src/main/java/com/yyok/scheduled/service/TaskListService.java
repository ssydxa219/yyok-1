package com.yyok.scheduled.service;

import com.yyok.scheduled.bean.TaskList;
import com.yyok.scheduled.repository.TaskListRepository;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Optional;

@Service
public class TaskListService {
	
	@Autowired
	private TaskListRepository taskListRepository;

	@Transactional
	public void save(TaskList taskList) {
		taskListRepository.save(taskList);
	}
	
	public void updateProxyCronById(String cron, Integer id){
		((TaskListService)AopContext.currentProxy()).updateCronById(cron, id);
	}

	public Page<TaskList> findAll(Specification<TaskList> spec, Pageable pageable) {
		return taskListRepository.findAll(spec,pageable);
	}

	public Optional<TaskList> findById(Integer id) {
		return taskListRepository.findById(id);
	}

	@Transactional
	@Async
	public void updateCronById(String cron, Integer id) {
		taskListRepository.updateCronById(cron, id);
	}
}
