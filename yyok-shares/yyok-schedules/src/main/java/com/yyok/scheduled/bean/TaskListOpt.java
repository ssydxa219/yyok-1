package com.yyok.scheduled.bean;

import lombok.Data;

import java.util.concurrent.ScheduledFuture;

@Data
public class TaskListOpt {
	private String cron;
	
	private Object task;
	
	private ScheduledFuture<?> future;
}
