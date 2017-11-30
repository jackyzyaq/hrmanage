package com.yq.faurecia.service;

import com.util.Global;
import com.util.Util;
import com.yq.faurecia.pojo.BreakTimeInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.pojo.OverTimeInfo;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.pojo.TimeSheet;
import com.yq.faurecia.service.BreakTimeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.OverTimeInfoService;
import com.yq.faurecia.service.ScheduleInfoService;
import com.yq.faurecia.service.TimeSheetService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class TimeSheetDetailService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private TimeSheetService timeSheetService;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private NationalHolidayService nationalHolidayService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;


   public Map runTimeSheetDetailNew(EmployeeInfo ei, Date class_date, int range) throws Exception {
      if(ei != null && ei.getId() != null && class_date != null) {
         int emp_id = ei.getId().intValue();
         StringBuffer abnormal_cause = new StringBuffer("");
         HashMap detailMap = new HashMap();
         detailMap.put("emp_id", Integer.valueOf(emp_id));
         detailMap.put("class_date", class_date);
         detailMap.put("ot1_hours", Double.valueOf(0.0D));
         detailMap.put("ot2_hours", Double.valueOf(0.0D));
         detailMap.put("ot3_hours", Double.valueOf(0.0D));
         detailMap.put("ts_number", Integer.valueOf(0));
         detailMap.put("tb_01", Integer.valueOf(0));
         detailMap.put("tb_02", Integer.valueOf(0));
         detailMap.put("arrive_work_hours", Double.valueOf(0.0D));
         detailMap.put("absence_hours", Double.valueOf(0.0D));
         detailMap.put("deficit_hours", Double.valueOf(0.0D));
         detailMap.put("shift1_number", Double.valueOf(0.0D));
         detailMap.put("shift2_number", Double.valueOf(0.0D));
         detailMap.put("should_work_hours", Double.valueOf(0.0D));
         detailMap.put("over_hour", Double.valueOf(0.0D));
         detailMap.put("shift3_number", Double.valueOf(0.0D));
         detailMap.put("hour50", Double.valueOf(0.0D));
         detailMap.put("holiday_name", "");
         ScheduleInfo scheduleInfo = this.getScheduleInfo(ei, class_date, detailMap);
         if(scheduleInfo != null) {
            abnormal_cause.append(this.getTimeSheet(ei, class_date, range, scheduleInfo, detailMap));
            abnormal_cause.append(this.getBreakTime(ei, class_date, scheduleInfo, detailMap));
            if(ei.getType().equals(Global.employee_type[0])) {
               this.getLineOverTime(ei, class_date, scheduleInfo, detailMap);
            } else if(ei.getType().equals(Global.employee_type[1])) {
               this.getOfficeOverTime(ei, class_date, scheduleInfo, detailMap);
            }

            this.getShiftNumber(ei, class_date, scheduleInfo, detailMap);
            this.getDeficitHours(ei, class_date, scheduleInfo, detailMap);
         } else {
            abnormal_cause.append("没有排班记录\r\n");
         }

         detailMap.put("abnormal_cause", StringUtils.isEmpty(abnormal_cause.toString().trim())?"正常":abnormal_cause.toString());
         if(abnormal_cause.toString().indexOf(Global.breaktime_type[0].split("\\|")[0]) > -1 || abnormal_cause.toString().indexOf("迟到") > -1 || abnormal_cause.toString().indexOf("早退") > -1 || abnormal_cause.toString().indexOf("有缺勤，没有请假记录") > -1) {
            String holiday_name = (String)detailMap.get("holiday_name");
            if(!StringUtils.isEmpty(holiday_name) && holiday_name.equals(Global.holidays_name[2])) {
               detailMap.put("hour50", (Double)detailMap.get("absence_hours"));
            }
         }

         return detailMap;
      } else {
         return null;
      }
   }

   private ScheduleInfo getScheduleInfo(EmployeeInfo ei, Date class_date, Map detailMap) {
      ScheduleInfo scheduleInfo = null;
      StringBuffer abnormal_cause = new StringBuffer("");

      try {
         if(ei.getType().equals(Global.employee_type[1])) {
            scheduleInfo = this.scheduleInfoService.getOfficeClassInfo(class_date);
         } else {
            scheduleInfo = this.scheduleInfoService.queryByEmpId(ei.getId().intValue(), class_date);
         }
      } catch (Exception var8) {
         var8.printStackTrace();
      }

      if(scheduleInfo != null) {
         Date scheduleBeginDate = Util.parseDateStr(this.sdf.format(scheduleInfo.getBegin_date()) + " " + scheduleInfo.getBegin_time());
         Date scheduleEndDate = Util.parseDateStr(this.sdf.format(scheduleInfo.getEnd_date()) + " " + scheduleInfo.getEnd_time());
         detailMap.put("class_name", scheduleInfo.getClass_name());
         detailMap.put("class_type", StringUtils.defaultString(scheduleInfo.getType(), ""));
         detailMap.put("class_begin_date", scheduleBeginDate);
         detailMap.put("class_end_date", scheduleEndDate);
         detailMap.put("tb_01", Integer.valueOf(StringUtils.isEmpty(scheduleInfo.getMeals())?0:scheduleInfo.getMeals().split(",").length));
         detailMap.put("should_work_hours", Double.valueOf(scheduleInfo.getHours().doubleValue() + scheduleInfo.getOver_hour().doubleValue()));
      } else {
         abnormal_cause.append("没有排班记录\r\n");
      }

      detailMap.put("abnormal_cause", abnormal_cause);
      return scheduleInfo;
   }

   private String getTimeSheet(EmployeeInfo ei, Date class_date, int range, ScheduleInfo scheduleInfo, Map detailMap) throws Exception {
      List timeSheetList = null;
      StringBuffer abnormal_cause = new StringBuffer("");
      Date scheduleBeginDate = (Date)detailMap.get("class_begin_date");
      Date scheduleEndDate = (Date)detailMap.get("class_end_date");

      try {
         timeSheetList = this.timeSheetService.queryByEmpId(ei.getId().intValue(), scheduleBeginDate, scheduleEndDate, range, (String)null);
      } catch (Exception var28) {
         var28.printStackTrace();
      }

      int timeSheetCount = 0;
      if(timeSheetList != null && timeSheetList.size() > 0) {
         ArrayList timeUPDate = new ArrayList();
         ArrayList timeDownDate = new ArrayList();
         int mealsCount = 0;
         Iterator var15 = timeSheetList.iterator();

         while(var15.hasNext()) {
            TimeSheet maxMillis = (TimeSheet)var15.next();
            if(Global.timesheet_type[0].equals(maxMillis.getType())) {
               timeUPDate.add(maxMillis.getInner_date());
            }

            if(Global.timesheet_type[1].equals(maxMillis.getType())) {
               timeDownDate.add(maxMillis.getInner_date());
            }

            if(Global.timesheet_type[2].equals(maxMillis.getType())) {
               ++mealsCount;
            }
         }

         if(timeDownDate.size() > 1) {
            abnormal_cause.append("打卡出去记录：");
            var15 = timeDownDate.iterator();

            while(var15.hasNext()) {
               Date var29 = (Date)var15.next();
               abnormal_cause.append(this.sdf1.format(var29) + "、");
            }

            abnormal_cause.append("\r\n");
         }

         long var30 = 0L;
         long minMillis = 0L;
         Date ts_begin_date = null;
         Date ts_end_date = null;
         boolean upTSTrue = true;
         boolean downTSTrue = true;
         double list;
         Date isTrue;
         if(timeUPDate.size() > 0) {
            isTrue = (Date)Collections.min(timeUPDate);
            ts_begin_date = isTrue;
            minMillis = isTrue.getTime();
            list = Util.round(Util.getHourByTimeInMillis(minMillis - scheduleBeginDate.getTime()));
            if(list > 0.0D && list >= 4.0D) {
               abnormal_cause.append("迟到" + String.format("%.2f", new Object[]{Double.valueOf(list)}) + "小时，超4小时旷工\r\n");
            } else if(list > 0.0D && list < 4.0D) {
               abnormal_cause.append("迟到" + String.format("%.2f", new Object[]{Double.valueOf(list)}) + "小时\r\n");
            }

            timeSheetCount += timeUPDate.size();
         } else {
            abnormal_cause.append("上班未打卡\r\n");
            upTSTrue = false;
         }

         if(timeDownDate.size() > 0) {
            isTrue = (Date)Collections.max(timeDownDate);
            ts_end_date = isTrue;
            var30 = isTrue.getTime();
            list = Util.round(Util.getHourByTimeInMillis(var30 - scheduleEndDate.getTime()));
            if(list < 0.0D && list <= -4.0D) {
               abnormal_cause.append("早退" + String.format("%.2f", new Object[]{Double.valueOf(list)}) + "小时，超4小时旷工\r\n");
            } else if(list < 0.0D && list > -4.0D) {
               abnormal_cause.append("早退" + String.format("%.2f", new Object[]{Double.valueOf(list)}) + "小时\r\n");
            }

            timeSheetCount += timeDownDate.size();
         } else {
            abnormal_cause.append("下班未打卡\r\n");
            downTSTrue = false;
         }

         boolean var31 = false;
         List var32 = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(class_date) + "\'");
         if(var32 != null && var32.size() != 0 && var32.size() <= 1) {
            String arrive_work_hours = ((NationalHoliday)var32.get(0)).getHoliday_name();
            detailMap.put("holiday_name", arrive_work_hours);
            if(arrive_work_hours.equals(Global.holidays_name[1]) && StringUtils.defaultString(scheduleInfo.getType(), "").trim().equals(Global.schedule_type[1])) {
               var31 = true;
               System.out.println(ei.getZh_name() + "(" + Util.alternateZero(ei.getId().intValue()) + ")" + "没有扣除用餐时长");
            }
         }

         double var33 = 0.0D;
         if(upTSTrue && downTSTrue) {
            Date absence_hours = null;
            Date tmp_e = null;
            if(scheduleBeginDate.getTime() <= ts_begin_date.getTime()) {
               absence_hours = ts_begin_date;
            } else {
               absence_hours = scheduleBeginDate;
            }

            if(scheduleEndDate.getTime() <= ts_end_date.getTime()) {
               tmp_e = scheduleEndDate;
            } else {
               tmp_e = ts_end_date;
            }

            var33 = Util.round(Util.getHourByTimeInMillis(tmp_e.getTime() - absence_hours.getTime()));
            if(var33 >= 4.0D && !var31) {
               var33 -= Util.round(Util.getHourByTimeInMillis(Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m")));
            }
         }

         var33 = upTSTrue && downTSTrue?var33:0.0D;
         double var34 = var33 - scheduleInfo.getHours().doubleValue();
         detailMap.put("tb_02", Integer.valueOf(mealsCount));
         detailMap.put("ts_begin_date", ts_begin_date);
         detailMap.put("ts_end_date", ts_end_date);
         detailMap.put("arrive_work_hours", Double.valueOf(var33));
         detailMap.put("absence_hours", Double.valueOf(var34 >= 0.0D?0.0D:var34));
      } else {
         detailMap.put("absence_hours", Double.valueOf(0.0D - scheduleInfo.getHours().doubleValue()));
         abnormal_cause.append("没有打卡记录\r\n");
      }

      detailMap.put("ts_number", Integer.valueOf(timeSheetCount));
      timeSheetList = null;
      return abnormal_cause.toString();
   }

   private String getBreakTime(EmployeeInfo ei, Date class_date, ScheduleInfo scheduleInfo, Map detailMap) {
      List breakTimeInfoList = null;
      StringBuffer abnormal_cause = new StringBuffer("");
      double absence_hours = ((Double)detailMap.get("absence_hours")).doubleValue();

      try {
         breakTimeInfoList = this.breakTimeInfoService.queryByEmpIdAndClassDate(ei.getId().intValue(), class_date);
      } catch (Exception var14) {
         var14.printStackTrace();
      }

      double breaktime_hours = 0.0D;
      String breaktime_type = "";
      if(breakTimeInfoList != null && breakTimeInfoList.size() > 0) {
         BreakTimeInfo breakTimeCount;
         for(Iterator var13 = breakTimeInfoList.iterator(); var13.hasNext(); breaktime_type = breaktime_type + breakTimeCount.getType() + "|") {
            breakTimeCount = (BreakTimeInfo)var13.next();
            breaktime_hours += breakTimeCount.getBreak_hour().doubleValue();
         }

         detailMap.put("breakTimeInfoList", breakTimeInfoList);
         breaktime_type = "（" + breaktime_type.substring(0, breaktime_type.length() - 1) + "）";
      }

      int breakTimeCount1 = breakTimeInfoList == null?0:breakTimeInfoList.size();
      if(absence_hours != 0.0D || breakTimeCount1 != 0) {
         if(absence_hours != 0.0D && breakTimeCount1 == 0) {
            abnormal_cause.append("有缺勤，没有请假记录\r\n");
         } else if(absence_hours != 0.0D && breakTimeCount1 > 0) {
            abnormal_cause.append("有缺勤，有请假记录" + breaktime_type + "\r\n");
         } else if(absence_hours == 0.0D && breakTimeCount1 > 0) {
            abnormal_cause.append("没有缺勤，有请假记录" + breaktime_type + "\r\n");
         }
      }

      breakTimeInfoList = null;
      return abnormal_cause.toString();
   }

   private void getOfficeOverTime(EmployeeInfo ei, Date class_date, ScheduleInfo scheduleInfo, Map detailMap) {
      List overTimeInfoList = null;
      double ot1_hours = 0.0D;
      double ot2_hours = 0.0D;
      double ot3_hours = 0.0D;
      boolean is_ot1 = false;
      boolean is_ot2 = false;
      boolean is_ot3 = false;
      Date ts_begin_date = (Date)detailMap.get("ts_begin_date");
      Date ts_end_date = (Date)detailMap.get("ts_end_date");
      Date class_begin_date = (Date)detailMap.get("class_begin_date");
      Date class_end_date = (Date)detailMap.get("class_end_date");
      List tmpList = null;
      NationalHoliday nh = null;
      if(ts_begin_date != null && ts_end_date != null && class_begin_date != null && class_end_date != null) {
         try {
            overTimeInfoList = this.overTimeInfoService.queryByEmpIdAndClassDate(ei.getId().intValue(), class_date, (String)null);
            if(overTimeInfoList != null && overTimeInfoList.size() > 0) {
               double e = 0.0D;

               OverTimeInfo tmp_b;
               Iterator tmp_e;
               for(tmp_e = overTimeInfoList.iterator(); tmp_e.hasNext(); e += tmp_b.getOver_hour().doubleValue()) {
                  tmp_b = (OverTimeInfo)tmp_e.next();
               }

               tmpList = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(class_date) + "\'");
               if(tmpList != null && tmpList.size() > 0) {
                  nh = (NationalHoliday)tmpList.get(0);
                  if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[0])) {
                     is_ot3 = true;
                  } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[1])) {
                     is_ot2 = true;
                  } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[2])) {
                     is_ot1 = true;
                  }
               }

               Date tmp_e1;
               Date tmp_b1;
               if(is_ot3) {
                  tmp_b = null;
                  tmp_e = null;
                  if(class_begin_date.getTime() <= ts_begin_date.getTime()) {
                     tmp_b1 = ts_begin_date;
                  } else {
                     tmp_b1 = class_begin_date;
                  }

                  if(class_end_date.getTime() <= ts_end_date.getTime()) {
                     tmp_e1 = class_end_date;
                  } else {
                     tmp_e1 = ts_end_date;
                  }

                  ot3_hours = Util.getHourByTimeInMillis(tmp_e1.getTime() - tmp_b1.getTime());
                  ot3_hours = e <= ot3_hours?e:ot3_hours;
               }

               ot3_hours -= Util.getHourByTimeInMillis(Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m"));
               if(is_ot2) {
                  tmp_b = null;
                  tmp_e = null;
                  if(class_begin_date.getTime() <= ts_begin_date.getTime()) {
                     tmp_b1 = ts_begin_date;
                  } else {
                     tmp_b1 = class_begin_date;
                  }

                  if(class_end_date.getTime() <= ts_end_date.getTime()) {
                     tmp_e1 = class_end_date;
                  } else {
                     tmp_e1 = ts_end_date;
                  }

                  ot2_hours = Util.getHourByTimeInMillis(tmp_e1.getTime() - tmp_b1.getTime());
                  ot2_hours = e <= ot2_hours?e:ot2_hours;
               }

               ot2_hours -= Util.getHourByTimeInMillis(Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m"));
               if(is_ot1) {
                  tmp_b = null;
                  tmp_e = null;
                  if(class_begin_date.getTime() > ts_begin_date.getTime()) {
                     ;
                  }

                  if(class_end_date.getTime() <= ts_end_date.getTime()) {
                     tmp_e1 = class_end_date;
                  } else {
                     tmp_e1 = ts_end_date;
                  }

                  ot1_hours = Util.getHourByTimeInMillis(tmp_e1.getTime() - class_end_date.getTime());
                  ot1_hours = e <= ot1_hours?e:ot1_hours;
               }
            }
         } catch (Exception var25) {
            var25.printStackTrace();
         }
      }

      detailMap.put("ot1_hours", Double.valueOf(Util.round(ot1_hours < 0.0D?0.0D:ot1_hours)));
      detailMap.put("ot2_hours", Double.valueOf(Util.round(ot2_hours < 0.0D?0.0D:ot2_hours)));
      detailMap.put("ot3_hours", Double.valueOf(Util.round(ot3_hours < 0.0D?0.0D:ot3_hours)));
      overTimeInfoList = null;
      tmpList = null;
   }

   private void getLineOverTime(EmployeeInfo ei, Date class_date, ScheduleInfo scheduleInfo, Map detailMap) {
      Object overTimeInfoList = null;
      double ot1_hours = 0.0D;
      double ot2_hours = 0.0D;
      double ot3_hours = 0.0D;
      Date ts_begin_date = (Date)detailMap.get("ts_begin_date");
      Date ts_end_date = (Date)detailMap.get("ts_end_date");
      Date class_begin_date = (Date)detailMap.get("class_begin_date");
      Date class_end_date = (Date)detailMap.get("class_end_date");
      new Date(class_begin_date.getTime() + Util.getTimeInMillis(scheduleInfo.getHours().doubleValue(), "h") + Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m"));
      List tmpList = null;
      NationalHoliday nh = null;
      boolean is_ts3_begin = false;
      boolean is_ts3_end = false;
      boolean is_class3_begin = false;
      boolean is_class3_end = false;
      boolean is_ts2_begin = false;
      boolean is_ts2_end = false;
      boolean is_class2_begin = false;
      boolean is_class2_end = false;
      boolean is_ts1_begin = false;
      boolean is_ts1_end = false;
      boolean is_class1_begin = false;
      boolean is_class1_end = false;
      if(ts_begin_date != null && ts_end_date != null && class_begin_date != null && class_end_date != null) {
         try {
            tmpList = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(ts_begin_date) + "\'");
            if(tmpList != null && tmpList.size() > 0) {
               nh = (NationalHoliday)tmpList.get(0);
               if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[0])) {
                  is_ts3_begin = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[1])) {
                  is_ts2_begin = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[2])) {
                  is_ts1_begin = true;
               }
            }

            nh = null;
            tmpList = null;
            tmpList = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(ts_end_date) + "\'");
            if(tmpList != null && tmpList.size() > 0) {
               nh = (NationalHoliday)tmpList.get(0);
               if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[0])) {
                  is_ts3_end = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[1])) {
                  is_ts2_end = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[2])) {
                  is_ts1_end = true;
               }
            }

            nh = null;
            tmpList = null;
            tmpList = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(class_begin_date) + "\'");
            if(tmpList != null && tmpList.size() > 0) {
               nh = (NationalHoliday)tmpList.get(0);
               if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[0])) {
                  is_class3_begin = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[1])) {
                  is_class2_begin = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[2])) {
                  is_class1_begin = true;
               }
            }

            nh = null;
            tmpList = null;
            tmpList = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(class_end_date) + "\'");
            if(tmpList != null && tmpList.size() > 0) {
               nh = (NationalHoliday)tmpList.get(0);
               if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[0])) {
                  is_class3_end = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[1])) {
                  is_class2_end = true;
               } else if(!StringUtils.isEmpty(nh.getHoliday_name()) && nh.getHoliday_name().equals(Global.holidays_name[2])) {
                  is_class1_end = true;
               }
            }

            if(!is_class3_begin && is_class3_end) {
               if(class_end_date.getTime() <= ts_end_date.getTime()) {
                  ot3_hours = Util.getHourByTimeInMillis(class_end_date.getTime() - Util.parseDateStr(this.sdf.format(class_end_date)).getTime());
               } else {
                  ot3_hours = Util.getHourByTimeInMillis(ts_end_date.getTime() - Util.parseDateStr(this.sdf.format(class_end_date)).getTime());
               }
            }

            if(is_class3_begin && !is_class3_end) {
               if(class_begin_date.getTime() <= ts_begin_date.getTime()) {
                  ot3_hours = Util.getHourByTimeInMillis(Util.parseDateStr(this.sdf.format(class_end_date)).getTime() - ts_begin_date.getTime());
               } else {
                  ot3_hours = Util.getHourByTimeInMillis(Util.parseDateStr(this.sdf.format(class_end_date)).getTime() - class_begin_date.getTime());
               }
            }

            Date e;
            Date tmp_e;
            if(is_class3_begin && is_class3_end) {
               e = null;
               tmp_e = null;
               if(class_begin_date.getTime() <= ts_begin_date.getTime()) {
                  e = ts_begin_date;
               } else {
                  e = class_begin_date;
               }

               if(class_end_date.getTime() <= ts_end_date.getTime()) {
                  tmp_e = class_end_date;
               } else {
                  tmp_e = ts_end_date;
               }

               ot3_hours = Util.getHourByTimeInMillis(tmp_e.getTime() - e.getTime());
            }

            if(!is_ts3_begin) {
               ;
            }

            ot3_hours -= Util.getHourByTimeInMillis(Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m"));
            if(!is_class2_begin) {
               ;
            }

            if(is_class2_begin && !is_class2_end || is_class2_begin && is_class2_end) {
               e = null;
               tmp_e = null;
               if(class_begin_date.getTime() <= ts_begin_date.getTime()) {
                  e = ts_begin_date;
               } else {
                  e = class_begin_date;
               }

               if(class_end_date.getTime() <= ts_end_date.getTime()) {
                  tmp_e = class_end_date;
               } else {
                  tmp_e = ts_end_date;
               }

               ot2_hours = Util.getHourByTimeInMillis(tmp_e.getTime() - e.getTime());
            }

            if(StringUtils.defaultString(scheduleInfo.getType(), "").trim().equals(Global.schedule_type[1])) {
               System.out.println(ei.getZh_name() + "(" + Util.alternateZero(ei.getId().intValue()) + ")" + "没有扣除用餐时长");
            } else {
               ot2_hours -= Util.getHourByTimeInMillis(Util.getTimeInMillis((double)scheduleInfo.getHave_meals().intValue(), "m"));
            }

            if(is_class1_begin && !is_class1_end || is_class1_begin && is_class1_end) {
               ot1_hours = ((Double)detailMap.get("arrive_work_hours")).doubleValue() - scheduleInfo.getHours().doubleValue();
            }
         } catch (Exception var33) {
            var33.printStackTrace();
         }
      }

      detailMap.put("ot1_hours", Double.valueOf(Util.round(ot1_hours < 0.0D?0.0D:ot1_hours)));
      detailMap.put("ot2_hours", Double.valueOf(Util.round(ot2_hours < 0.0D?0.0D:ot2_hours)));
      detailMap.put("ot3_hours", Double.valueOf(Util.round(ot3_hours < 0.0D?0.0D:ot3_hours)));
      overTimeInfoList = null;
      tmpList = null;
   }

   private void getShiftNumber(EmployeeInfo ei, Date class_date, ScheduleInfo scheduleInfo, Map detailMap) {
      double shift1_number = 0.0D;
      double shift2_number = 0.0D;
      double shift3_number = 0.0D;
      if(ei.getType().equals(Global.employee_type[0]) && scheduleInfo.getType().equals(Global.schedule_type[0])) {
         if((!scheduleInfo.getBegin_time().equals("07:00:00") || !scheduleInfo.getEnd_time().equals("15:30:00")) && (!scheduleInfo.getBegin_time().equals("07:00:00") || !scheduleInfo.getEnd_time().equals("16:30:00")) && (!scheduleInfo.getBegin_time().equals("07:00:00") || !scheduleInfo.getEnd_time().equals("17:30:00")) && (!scheduleInfo.getBegin_time().equals("07:00:00") || !scheduleInfo.getEnd_time().equals("18:30:00")) && (!scheduleInfo.getBegin_time().equals("07:00:00") || !scheduleInfo.getEnd_time().equals("19:00:00"))) {
            if((!scheduleInfo.getBegin_time().equals("15:30:00") || !scheduleInfo.getEnd_time().equals("0:00:00")) && (!scheduleInfo.getBegin_time().equals("16:30:00") || !scheduleInfo.getEnd_time().equals("2:00:00"))) {
               if((!scheduleInfo.getBegin_time().equals("17:30:00") || !scheduleInfo.getEnd_time().equals("4:00:00")) && (!scheduleInfo.getBegin_time().equals("18:30:00") || !scheduleInfo.getEnd_time().equals("6:00:00"))) {
                  if(scheduleInfo.getBegin_time().equals("19:00:00") && scheduleInfo.getEnd_time().equals("7:00:00")) {
                     shift1_number = 0.0D;
                     shift2_number = 0.5D;
                     shift3_number = 1.0D;
                  } else if(scheduleInfo.getBegin_time().equals("00:00:00") && scheduleInfo.getEnd_time().equals("7:00:00")) {
                     shift1_number = 0.0D;
                     shift2_number = 0.0D;
                     shift3_number = 1.0D;
                  }
               } else {
                  shift1_number = 0.0D;
                  shift2_number = 1.0D;
                  shift3_number = 0.5D;
               }
            } else {
               shift1_number = 0.0D;
               shift2_number = 1.0D;
               shift3_number = 0.0D;
            }
         } else {
            shift1_number = 1.0D;
            shift2_number = 0.0D;
            shift3_number = 0.0D;
         }
      }

      detailMap.put("shift1_number", Double.valueOf(shift1_number));
      detailMap.put("shift2_number", Double.valueOf(shift2_number));
      detailMap.put("shift3_number", Double.valueOf(shift3_number));
   }

   private void getDeficitHours(EmployeeInfo ei, Date class_date, ScheduleInfo scheduleInfo, Map detailMap) {
      double surplus_over_hours = 0.0D;

      try {
         Map e = this.overTimeInfoService.findStandardOverHour(ei.getId().intValue());
         Integer leaveMap;
         if(e != null && e.size() > 0) {
            Map el;
            for(Iterator year = e.keySet().iterator(); year.hasNext(); surplus_over_hours += ((Double)el.get("surplus_over_hour")).doubleValue()) {
               leaveMap = (Integer)year.next();
               el = (Map)e.get(leaveMap);
            }

            e.clear();
            e = null;
         }

         Map leaveMap1 = this.employeeLeaveService.findStandardLeave(ei.getId().intValue());
         if(leaveMap1 != null && leaveMap1.size() > 0) {
            Map el1;
            for(Iterator el2 = leaveMap1.keySet().iterator(); el2.hasNext(); surplus_over_hours += ((Double)el1.get("surplus_company_leave")).doubleValue() + ((Double)el1.get("surplus_annual_leave")).doubleValue()) {
               Integer year1 = (Integer)el2.next();
               el1 = (Map)leaveMap1.get(year1);
            }

            leaveMap1.clear();
            leaveMap = null;
         }
      } catch (Exception var12) {
         var12.printStackTrace();
      }

      detailMap.put("deficit_hours", Double.valueOf(surplus_over_hours > 0.0D?0.0D:surplus_over_hours));
   }
}
