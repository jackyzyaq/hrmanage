package com.schedule;

import com.schedule.service.ScheduleJob;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.annotation.Resource;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component("schedule")
public class Schedule {

   private static Logger log = LogManager.getLogger(Schedule.class.getName());
   @Resource
   private ScheduleJob scheduleJob;


   public void work() {}

   @Scheduled(
      fixedRate = 500654080L
   )
   public void firstExc() {
      log.info("*****启动时执行 开始 *****");
      this.scheduleJob.loadConfigFile();
      this.loadMem();
      log.info("*****启动时执行 结束 *****");
      log.info("*****启动时对加班、排班、排班池、请假没有单号的赋值 开始 *****");
      this.scheduleJob.updateWoNumberForNull();
      log.info("*****启动时对加班、排班、排班池、请假没有单号的赋值 结束 *****");
   }

   @Scheduled(
      cron = "0 0/7 * * * *"
   )
   public void loadData() {
      System.out.println("0 0/7 * * * * 加载数据到内存");
      this.loadMem();
   }

   @Scheduled(
      cron = "0 30 0 * * *"
   )
   public void sync() {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      Calendar c = Calendar.getInstance();
      c.add(5, -1);
      System.out.println("0 30 0 * * * 同步" + sdf.format(c.getTime()) + "考勤数据");
      this.scheduleJob.syncTimeSheet(c.getTime());
      System.out.println("0 30 0 * * * 同步" + sdf.format(c.getTime()) + "考勤数据\t完成");
      c.add(5, -2);
      System.out.println("计算" + sdf.format(c.getTime()) + "员工考勤详细数据");
      this.scheduleJob.empTimeSheet(c.getTime());
      System.out.println("计算" + sdf.format(c.getTime()) + "员工考勤详细数据\t完成");
   }

   @Scheduled(
      cron = "0 30 1 * * *"
   )
   public void exeSetHoliday() {
      System.out.println("0 30 1 * * * 设置 双休日，工作日");
      this.scheduleJob.setHoliday();
      System.out.println("0 30 1 * * * 设置 双休日，工作日\t结束");
   }

   @Scheduled(
      cron = "0 30 2 1 0 *"
   )
   public void exeLeave() {
      System.out.println("0 30 2 1 0 * 计算年假、公司假并保存");
      this.scheduleJob.reckonAnnualAndCompanyLeave();
      System.out.println("0 30 2 1 0 * 计算年假、公司假并保存\t\t结束");
   }

   private void loadMem() {
      System.out.println("加载配置");
      this.scheduleJob.loadConfigInfo();
      System.out.println("加载菜单");
      this.scheduleJob.loadAllMenuInfo();
      System.out.println("加载默认标准班次");
      this.scheduleJob.loadStdClassInfo();
      System.out.println("加载部门");
      this.scheduleJob.loadAllDeptInfo();
      System.out.println("加载职位");
      this.scheduleJob.loadAllPositionInfo();
      System.out.println("加载项目");
      this.scheduleJob.loadAllProjectInfo();
      System.out.println("加载GAP");
      this.scheduleJob.loadAllGapInfo();
      System.out.println("加载所有的年假和公司假");
      this.scheduleJob.loadAllHrStatus();
      System.out.println("加载所有员工信息");
      this.scheduleJob.loadAllEmployeeInfo();
   }
}
