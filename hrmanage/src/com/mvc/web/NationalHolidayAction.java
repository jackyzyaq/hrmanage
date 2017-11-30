package com.mvc.web;

import com.util.Page;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.service.NationalHolidayService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/nationalHoliday/*"})
public class NationalHolidayAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(NationalHolidayAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   @Resource
   private UserInfoService userService;
   @Resource
   private NationalHolidayService nationalHolidayService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"nationalHolidayAdd.do"})
   public void nationalHolidayAdd(String holiday_names, String holidays, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(StringUtils.isEmpty(holiday_names) || StringUtils.isEmpty(holidays)) {
            e = "选择为空！";
         }

         this.nationalHolidayService.save(holiday_names, holidays);
         e = "操作成功！";
         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
      } finally {
         JSONObject json = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(json.toString());
         } catch (IOException var15) {
            var15.printStackTrace();
         }

      }

   }

   @RequestMapping({"nationalHolidayView.do"})
   public void nationalHolidayView(String holiday, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         Calendar e = Calendar.getInstance();
         e.setTime(this.sdf.parse(holiday));
         int year = e.get(1);
         int m = e.get(2) + 1;
         HashMap map = new HashMap();
         map.put("begin_holiday", this.sdf.format(e.getTime()));
         map.put("end_holiday", year + "-" + m + "-" + e.getActualMaximum(5));
         List holidayList = this.nationalHolidayService.findByCondition(map, (Page)null);
         sb.append("{\'msg\':\'\',\'rows\':[");
         if(holidayList != null && holidayList.size() > 0) {
            Iterator var11 = holidayList.iterator();

            while(var11.hasNext()) {
               NationalHoliday nh = (NationalHoliday)var11.next();
               sb.append("{\'state\':" + nh.getState().intValue() + ",\'holiday\':\'" + this.sdf.format(nh.getHoliday()) + "\',\'holiday_name\':\'" + StringUtils.defaultString(nh.getHoliday_name(), "") + "\'},");
            }
         }

         if(holidayList.size() > 0) {
            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]}");
      } catch (Exception var21) {
         var21.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
      } finally {
         JSONObject json = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(json.toString());
         } catch (IOException var20) {
            var20.printStackTrace();
         }

      }

   }

   public NationalHolidayService getNationalHolidayService() {
      return this.nationalHolidayService;
   }

   public void setNationalHolidayService(NationalHolidayService nationalHolidayService) {
      this.nationalHolidayService = nationalHolidayService;
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
