package com.yyok.scheduled.container;

import com.yyok.scheduled.bean.TaskList;
import com.yyok.scheduled.bean.TaskListOpt;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

@Slf4j
@Component
public class MapContainer {

	// 静态内部类实现单例模式
	private MapContainer() {
	}

	private static class MapContainerInstance {
		private static final MapContainer INSTANCE = new MapContainer();
	}

	public static MapContainer getInstance() {
		return MapContainerInstance.INSTANCE;
	}

	/**
	 * 启动后存储任务列表
	 */
	public final static Map<Integer, TaskListOpt> currentHashMap = new ConcurrentHashMap<>();

	/**
	 * 工具类注入bean的方法
	 */
	@Autowired
	private ThreadPoolTaskScheduler threadPoolTaskScheduler;

	@PostConstruct
	public void init() {
		MapContainerInstance.INSTANCE.threadPoolTaskScheduler = this.threadPoolTaskScheduler;
	}

	/**
	 * 根据ID获取
	 * 
	 * @param id
	 * @return
	 */
	public TaskListOpt getById(Integer id) {
		return currentHashMap.get(id);
	}

	/**
	 * 返回执行的任务列表
	 * 
	 * @return
	 */
	public Map<Integer, TaskListOpt> getMapContainer() {
		return currentHashMap;
	}

	/**
	 * 将任务列表处理存入Map容器中
	 * 
	 * @param taskList
	 * @return
	 */
	public TaskListOpt putMap(TaskList taskList) {
		TaskListOpt taskListOpt = new TaskListOpt();
		taskListOpt.setCron(taskList.getCron());
		String clazz = taskList.getClazz();
		Object obj = null;
		try {
			obj = Class.forName(clazz).newInstance();
		} catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {
			log.error("putMap时,反射实例化发生错误,错误原因- {}",e.getMessage());
		}
		taskListOpt.setTask(obj);
		log.info("ThreadPoolTaskScheduler {}", threadPoolTaskScheduler);
		ScheduledFuture<?> future = threadPoolTaskScheduler.schedule((Runnable) obj,
				new CronTrigger(taskList.getCron()));
		taskListOpt.setFuture(future);
		currentHashMap.put(taskList.getId(), taskListOpt);
		log.info("TaskList的实例存储 - {}" , taskList);
		return taskListOpt;
	}

	/**
	 * 根据ID暂停任务,同时在容器中删除
	 * @param id
	 * @return
	 */
	public TaskListOpt cancelMap(Integer id) {
		TaskListOpt task = null;
		if(currentHashMap.containsKey(id)){
			task = currentHashMap.get(id);
			ScheduledFuture<?> future = task.getFuture();
			if (future != null) {
				future.cancel(true);
			}
			//删除任务
			currentHashMap.remove(id);
		}
		return task;
	}
	
	/**
	 * 根据ID删除,调用暂停的方法
	 * @param id
	 * @return
	 */
	public TaskListOpt deleteMap(Integer id){
		return cancelMap(id);
	}
	
	/**
	 * 重新启动
	 * @param
	 * @return
	 */
	public TaskListOpt restartMap(TaskList taskList) {
		TaskListOpt taskListOpt=putMap(taskList);
		return taskListOpt;
	}
}
