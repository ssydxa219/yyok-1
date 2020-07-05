package com.yyok.scheduled.configuration;

import com.yyok.scheduled.bean.TaskList;
import com.yyok.scheduled.container.MapContainer;
import com.yyok.scheduled.repository.TaskListRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(1)
@Slf4j
public class LoadTaskList implements CommandLineRunner {

    @Autowired
    private TaskListRepository taskListRepository;

    public MapContainer mapContainer = MapContainer.getInstance();

    @Override
    public void run(String... args) throws Exception {
        log.info("系统启动后载入数据库中启动的定时任务");

        //获取当前启动的任务
        List<TaskList> taskList = taskListRepository.findByStatus(1);

        if (taskList == null || taskList.size() <= 0) {
            return;
        }
        log.info("LoadTaskList中的对象为 - " + mapContainer);
        for (TaskList t : taskList) {
            mapContainer.putMap(t);
        }
    }

}
