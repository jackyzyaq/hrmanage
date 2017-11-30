package com.mvc.web.common_web;

import com.mvc.web.BreakTimeInfoAction;
import com.util.Global;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.faurecia.pojo.BreakTimeInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.service.BreakTimeInfoService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.ScheduleInfoService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/serviceWeb/*"})
public class ServiceAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ServiceAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private NationalHolidayService nationalHolidayService;
   @Resource
   private BreakTimeInfoAction breakTimeInfoAction;


   @RequestMapping({"breakTimeBefareAdd.do"})
   public void breakTimeBefareAdd(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String emp_ids = StringUtils.defaultIfEmpty(request.getParameter("emp_ids"), "");
         String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
         String day_or_hour = StringUtils.defaultIfEmpty(request.getParameter("day_or_hour"), "");
         String start_date = StringUtils.defaultIfEmpty(request.getParameter("start_date"), "");
         String break_hour = StringUtils.defaultIfEmpty(request.getParameter("break_hour"), "");
         if(!StringUtils.isEmpty(emp_ids) && !StringUtils.isEmpty(type) && !StringUtils.isEmpty(day_or_hour) && !StringUtils.isEmpty(start_date) && !StringUtils.isEmpty(break_hour)) {
            if(start_date.indexOf(" ") == -1) {
               start_date = start_date + " 00:00:00";
            }

            e = "{\'flag\':\'" + Global.FLAG[1] + "\',\'total\':\'" + emp_ids.split(",").length + "\',\'emp_rows\':[";

            for(int i = 0; i < emp_ids.split(",").length; ++i) {
               int emp_id = Integer.valueOf(emp_ids.split(",")[i]).intValue();
               e = e + "{\'emp_id\':\'" + emp_id + "\'," + "\'emp_name\':\'" + ((EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id))).getZh_name() + "\'," + "\'breaktime_rows\':[" + this.getValidbreakTime(emp_id, this.sdf1.parse(start_date), Double.valueOf(break_hour).doubleValue(), day_or_hour, type, StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "")) + "]},";
            }

            e = e + "]}";
            sb.append(e);
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'栏位不能有空！\'");
            sb.append("}");
         }
      } catch (Exception var22) {
         var22.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
      } finally {
         JSONObject json = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(json.toString());
         } catch (IOException var21) {
            var21.printStackTrace();
         }

      }

   }

   private String getValidbreakTime(int emp_id, Date start_date, double total_break_hour, String day_or_hour, String type, String roleCode) throws Exception {
      ScheduleInfo si = this.scheduleInfoService.findSchedule(emp_id, start_date);
      if(si != null) {
         Date b_end_date = new Date(Util.parseDateStr(this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time()).getTime() + Util.getTimeInMillis(si.getHours().doubleValue(), "h") + Util.getTimeInMillis((double)si.getHave_meals().intValue(), "m"));
         if(day_or_hour.equals(Global.day_or_hour[0].split("\\|")[0])) {
            total_break_hour *= si.getHours().doubleValue();
         } else {
            day_or_hour.equals(Global.day_or_hour[1].split("\\|")[0]);
         }

         if(start_date.getTime() >= b_end_date.getTime()) {
            return "{\'msg\':\'" + this.sdf1.format(start_date) + "超过标准下班时间！\'},";
         } else if(!this.nationalHolidayService.isWorkDay(si.getBegin_date())) {
            return "{\'msg\':\'" + this.sdf1.format(si.getBegin_date()) + "不是工作日！\'},";
         } else {
            if(this.sdf1.format(start_date).indexOf("00:00:00") > -1 || start_date.getTime() < Util.parseDateStr(this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time()).getTime()) {
               start_date = Util.parseDateStr(this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time());
            }

            Date end_date = Util.parseDateStr(this.sdf.format(si.getEnd_date()) + " " + si.getEnd_time());
            double break_hour = Double.valueOf((double)(b_end_date.getTime() - start_date.getTime())).doubleValue() / 60.0D / 60.0D / 1000.0D;
            if(break_hour > 4.0D) {
               break_hour -= Util.getHourByTimeInMillis(Util.getTimeInMillis((double)si.getHave_meals().intValue(), "m"));
            }

            double diff_hour = total_break_hour - break_hour;
            if(diff_hour <= 0.0D) {
               return diff_hour == 0.0D?"{\'class_id\':\'" + si.getClass_id() + "\',\'schedule_id\':\'" + si.getId() + "\',\'start_date\':\'" + this.sdf1.format(start_date) + "\'," + "\'over_date\':\'" + this.sdf1.format(b_end_date) + "\'," + "\'break_hour\':\'" + break_hour + "\'," + "\'class_date\':\'" + this.sdf.format(si.getBegin_date()) + "\'," + "\'b_begin_date\':\'" + this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time() + "\'," + "\'b_end_date\':\'" + this.sdf1.format(b_end_date) + "\'," + "\'end_date\':\'" + this.sdf1.format(end_date) + "\'," + "\'msg\':\'" + StringUtils.defaultIfEmpty((String)this.breakTimeInfoAction.validate(new BreakTimeInfo(start_date, b_end_date, si.getBegin_date(), emp_id, si.getId().intValue(), break_hour, type, (Integer)null, (Integer)null), roleCode).get("msg"), "") + "\'},":"{\'class_id\':\'" + si.getClass_id() + "\',\'schedule_id\':\'" + si.getId() + "\',\'start_date\':\'" + this.sdf1.format(start_date) + "\'," + "\'over_date\':\'" + this.sdf1.format(new Date(start_date.getTime() + Util.getTimeInMillis(total_break_hour, "h") + (total_break_hour <= 4.0D?0L:Util.getTimeInMillis((double)si.getHave_meals().intValue(), "m")))) + "\'," + "\'break_hour\':\'" + total_break_hour + "\'," + "\'class_date\':\'" + this.sdf.format(si.getBegin_date()) + "\'," + "\'b_begin_date\':\'" + this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time() + "\'," + "\'b_end_date\':\'" + this.sdf1.format(b_end_date) + "\'," + "\'end_date\':\'" + this.sdf1.format(end_date) + "\'," + "\'msg\':\'" + StringUtils.defaultIfEmpty((String)this.breakTimeInfoAction.validate(new BreakTimeInfo(start_date, new Date(start_date.getTime() + Util.getTimeInMillis(total_break_hour, "h") + (total_break_hour <= 4.0D?0L:Util.getTimeInMillis((double)si.getHave_meals().intValue(), "m"))), si.getBegin_date(), emp_id, si.getId().intValue(), total_break_hour, type, (Integer)null, (Integer)null), roleCode).get("msg"), "") + "\'},";
            } else {
               String val = "{\'class_id\':\'" + si.getClass_id() + "\',\'schedule_id\':\'" + si.getId() + "\',\'start_date\':\'" + this.sdf1.format(start_date) + "\'," + "\'over_date\':\'" + this.sdf1.format(b_end_date) + "\'," + "\'break_hour\':\'" + break_hour + "\'," + "\'class_date\':\'" + this.sdf.format(si.getBegin_date()) + "\'," + "\'b_begin_date\':\'" + this.sdf.format(si.getBegin_date()) + " " + si.getBegin_time() + "\'," + "\'b_end_date\':\'" + this.sdf1.format(b_end_date) + "\'," + "\'end_date\':\'" + this.sdf1.format(end_date) + "\'," + "\'msg\':\'" + StringUtils.defaultIfEmpty((String)this.breakTimeInfoAction.validate(new BreakTimeInfo(start_date, b_end_date, si.getBegin_date(), emp_id, si.getId().intValue(), break_hour, type, (Integer)null, (Integer)null), roleCode).get("msg"), "") + "\'},";

               for(int i = 1; i < 50; ++i) {
                  start_date = new Date(start_date.getTime() + Util.getTimeInMillis(1.0D, "d"));
                  if(this.nationalHolidayService.isWorkDay(start_date)) {
                     val = val + this.getValidbreakTime(emp_id, Util.parseDateStr(this.sdf.format(start_date) + " 00:00:00"), diff_hour, Global.day_or_hour[1].split("\\|")[0], type, roleCode);
                     break;
                  }
               }

               return val;
            }
         }
      } else {
         return "{\'msg\':\'" + this.sdf1.format(start_date) + "没有排班记录！\'},";
      }
   }

   private List addBreakTimeList(ScheduleInfo si, Date start_date, double break_hour) {
      if(si != null && start_date != null && break_hour != 0.0D) {
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
         break_hour += Double.valueOf((double)si.getHave_meals().intValue()).doubleValue() / 60.0D;
         double b_hour = si.getHours().doubleValue() + Double.valueOf((double)si.getHave_meals().intValue()).doubleValue() / 60.0D;
         String b_begin_time = si.getBegin_time();
         Date class_date = Util.parseDateStr(sdf.format(si.getBegin_date()) + " " + b_begin_time);
         Date b_end_date = new Date(class_date.getTime() + Util.getTimeInMillis(b_hour, "h"));
         Date b_begin_date = start_date;
         double tmpHour = 0.5D;
         Date maxEndDate = start_date;
         int index = 1;
         HashMap maxVal = new HashMap();

         for(double i = 0.5D; i <= break_hour; i += 0.5D) {
            Date end_date = new Date(b_begin_date.getTime() + Util.getTimeInMillis(tmpHour, "h"));
            if(end_date.getTime() <= b_end_date.getTime()) {
               if(maxEndDate.getTime() < end_date.getTime()) {
                  maxEndDate = end_date;
                  maxVal.put(Integer.valueOf(index), "<tr><td>" + sdf1.format(b_begin_date) + "</td>" + "<td>" + sdf1.format(end_date) + "</td>" + "<td>" + (tmpHour - Double.valueOf((double)si.getHave_meals().intValue()).doubleValue() / 60.0D) + "</td>" + "<td>" + sdf.format(class_date) + "</td>" + "</tr>");
               }
            } else {
               ++index;
               break_hour += 0.5D;
               class_date = new Date(class_date.getTime() + Util.getTimeInMillis(1.0D, "d"));
               b_begin_date = class_date;
               b_end_date = new Date(class_date.getTime() + Util.getTimeInMillis(b_hour, "h"));
               maxEndDate = class_date;
               tmpHour = 0.5D;
            }

            tmpHour += 0.5D;
         }

         return null;
      } else {
         return null;
      }
   }

   public BreakTimeInfoService getBreakTimeInfoService() {
      return this.breakTimeInfoService;
   }

   public void setBreakTimeInfoService(BreakTimeInfoService breakTimeInfoService) {
      this.breakTimeInfoService = breakTimeInfoService;
   }

   public SimpleDateFormat getSdf() {
      return this.sdf;
   }

   public void setSdf(SimpleDateFormat sdf) {
      this.sdf = sdf;
   }

   public UserInfoService getUserService() {
      return this.userService;
   }

   public void setUserService(UserInfoService userService) {
      this.userService = userService;
   }

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }

   public RoleInfoService getRoleInfoService() {
      return this.roleInfoService;
   }

   public void setRoleInfoService(RoleInfoService roleInfoService) {
      this.roleInfoService = roleInfoService;
   }
}
