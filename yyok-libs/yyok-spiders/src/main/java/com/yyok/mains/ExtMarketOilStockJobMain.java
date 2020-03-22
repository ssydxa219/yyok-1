package com.yyok.mains;

import com.yyok.quote.eastmoney.ExtMarketOilStockJob;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;


public class ExtMarketOilStockJobMain {

    public void go() throws Exception {
        // 首先，必需要取得一个Scheduler的引用
        SchedulerFactory sf = new StdSchedulerFactory();
        Scheduler sched = sf.getScheduler();
        //jobs可以在scheduled的sched.start()方法前被调用
        JobDetail job = newJob(ExtMarketOilStockJob.class).withIdentity("stockjob", "stockgroup").build();
        //每周一到周五8点39开始执行job
        CronTrigger trigger = newTrigger().withIdentity("stocktrigger", "stockgroup").withSchedule(cronSchedule("0 39 20 ? * MON-FRI")).build();
        Date ft = sched.scheduleJob(job, trigger);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
        System.out.println(job.getKey() + " 已被安排执行于: " + sdf.format(ft) + "，并且以如下重复规则重复执行: " + trigger.getCronExpression());
        sched.start();
    }

    public static void main(String[] args) throws Exception {
        ExtMarketOilStockJobMain maingo = new ExtMarketOilStockJobMain();
        maingo.go();
    }

}