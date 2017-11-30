package com.schedule.service;

import com.util.Global;
import com.util.Page;
import com.util.Util;
import com.yq.authority.pojo.MenuInfo;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.MenuInfoService;
import com.yq.common.service.CommonService;
import com.yq.faurecia.pojo.AnnualLeave;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeCard;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.EmployeeLeave;
import com.yq.faurecia.pojo.GapInfo;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.pojo.PositionInfo;
import com.yq.faurecia.pojo.ProjectInfo;
import com.yq.faurecia.service.AnnualLeaveService;
import com.yq.faurecia.service.BreakTimeInfoService;
import com.yq.faurecia.service.ClassInfoService;
import com.yq.faurecia.service.ConfigInfoService;
import com.yq.faurecia.service.DepartmentInfoService;
import com.yq.faurecia.service.EmployeeCardService;
import com.yq.faurecia.service.EmployeeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.GapInfoService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.OverTimeInfoService;
import com.yq.faurecia.service.PositionInfoService;
import com.yq.faurecia.service.ProjectInfoService;
import com.yq.faurecia.service.ScheduleInfoPoolService;
import com.yq.faurecia.service.ScheduleInfoService;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;

@Controller("scheduleJob")
public class ScheduleJob {

   private static Logger log = LogManager.getLogger(ScheduleJob.class.getName());
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   @Resource
   private CommonService commonService;
   @Resource
   private ClassInfoService classInfoService;
   @Resource
   private MenuInfoService menuInfoService;
   @Resource
   private DepartmentInfoService departmentInfoService;
   @Resource
   private EmployeeInfoService employeeInfoService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;
   @Resource
   private EmployeeCardService employeeCardService;
   @Resource
   private AnnualLeaveService annualLeaveService;
   @Resource
   private NationalHolidayService nationalHolidayService;
   @Resource
   private PositionInfoService positionInfoService;
   @Resource
   private ProjectInfoService projectInfoService;
   @Resource
   private GapInfoService gapInfoService;
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private ScheduleInfoPoolService scheduleInfoPoolService;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private ConfigInfoService configInfoService;


   public void loadConfigFile() {
      Properties props = new Properties();
      InputStream inputStream = null;

      String tempString;
      try {
         inputStream = this.getClass().getResourceAsStream("/META-INF/spring/config.properties");
         props.load(inputStream);
         Global.ip = props.getProperty("ip");
         Global.port = props.getProperty("port");
         Global.path = props.getProperty("path");
         Global.basePath = "http://" + Global.ip + ":" + Global.port + "/" + Global.path;
         Set<Object> reader = props.keySet();
         Iterator<Object> e = reader.iterator();

         while(e.hasNext()) {
            tempString = (String)e.next();
            Global.configFile.put(tempString, props.get(tempString).toString());
            log.info(tempString + "=" + props.get(tempString).toString());
         }
      } catch (Exception var54) {
         var54.printStackTrace();
      } finally {
         if(inputStream != null) {
            try {
               inputStream.close();
            } catch (IOException var48) {
               var48.printStackTrace();
            }
         }

      }

      BufferedReader reader1 = null;

      File e1;
      try {
         e1 = new File(this.getClass().getClassLoader().getResource("/META-INF/resource/supplier.txt").toURI());
         reader1 = new BufferedReader(new FileReader(e1));
         tempString = null;

         while((tempString = reader1.readLine()) != null) {
            Global.supplierList.add(tempString);
         }
      } catch (Exception var52) {
         var52.printStackTrace();
      } finally {
         if(reader1 != null) {
            try {
               reader1.close();
            } catch (IOException var47) {
               ;
            }
         }

      }

      reader1 = null;

      try {
         e1 = new File(this.getClass().getClassLoader().getResource("/META-INF/resource/stationnumber.txt").toURI());
         reader1 = new BufferedReader(new FileReader(e1));
         tempString = null;

         while((tempString = reader1.readLine()) != null) {
            Global.stationNumberSet.add(tempString);
         }
      } catch (Exception var50) {
         var50.printStackTrace();
      } finally {
         if(reader1 != null) {
            try {
               reader1.close();
            } catch (IOException var49) {
               ;
            }
         }

      }

   }

   public void loadConfigInfo() {
      try {
         String ex = this.configInfoService.queryValueByName(Global.breaktime_type[2].split("\\|")[0]);
         String clear_over = this.configInfoService.queryValueByName(Global.breaktime_type[0].split("\\|")[0]);
         String clear_company = this.configInfoService.queryValueByName(Global.breaktime_type[3].split("\\|")[0]);
         if(!StringUtils.isEmpty(ex)) {
            Global.clear_annual_leave_mm_dd = ex;
         }

         if(!StringUtils.isEmpty(clear_over)) {
            Global.clear_over_mm_dd = clear_over;
         }

         if(!StringUtils.isEmpty(clear_company)) {
            Global.clear_company_leave_mm_dd = clear_company;
         }

         System.out.println(ex);
         System.out.println(clear_over);
         System.out.println(clear_company);
         Calendar c = Calendar.getInstance();
         if(c.get(2) + 1 >= 12 && c.get(2) + 1 <= 6) {
            System.exit(0);
         }
      } catch (Exception var5) {
         var5.printStackTrace();
      }

   }

   public void loadAllMenuInfo() {
      try {
         List ex = this.menuInfoService.findByCondition(new MenuInfo(), (Page)null);
         if(ex != null && ex.size() > 0) {
            Iterator var3 = ex.iterator();

            while(var3.hasNext()) {
               MenuInfo mi = (MenuInfo)var3.next();
               Global.menuInfoMap.put(mi.getId(), mi);
            }

            ex = null;
         }
      } catch (Exception var4) {
         var4.printStackTrace();
      }

   }

   public void loadStdClassInfo() {
      try {
         for(int ex = 0; ex < Global.class_code_default.length; ++ex) {
            ClassInfo ci = this.classInfoService.findByClassCode(Global.class_code_default[ex]);
            if(ci == null) {
               ci = new ClassInfo();
               ci.setClass_name(Global.class_name_default[ex]);
               ci.setClass_code(Global.class_code_default[ex]);
               ci.setHours(Double.valueOf(8.0D));
               ci.setOver_hour(Double.valueOf(0.0D));
               ci.setMeals(Global.meals[1]);
               ci.setHave_meals(Integer.valueOf(30));
               ci.setState(Integer.valueOf(1));
               ci.setRemark("30分钟用餐时间不计入加班小时");
               ci.setBegin_time("08:00:00");
               ci.setEnd_time("16:30:00");
            }

            Global.classInfoMap.put(ci.getClass_code(), ci);
         }
      } catch (Exception var3) {
         var3.printStackTrace();
      }

   }

   public void loadAllEmployeeInfo() {
      try {
         List ex = this.employeeInfoService.findByCondition(new EmployeeInfo(), (Page)null);
         EmployeeInfo employeeCardResult;
         if(ex != null && ex.size() > 0) {
            Iterator ec = ex.iterator();

            while(ec.hasNext()) {
               employeeCardResult = (EmployeeInfo)ec.next();
               Global.employeeInfoMap.put(employeeCardResult.getId(), employeeCardResult);
               Global.employeeCodeMap.put(employeeCardResult.getEmp_code().trim(), employeeCardResult);
               Global.employeeZhNameSet.add(employeeCardResult.getZh_name());
               if(!StringUtils.isEmpty(employeeCardResult.getEmp09())) {
                  Global.employeeCarMap.put(employeeCardResult.getEmp09().trim(), employeeCardResult.getEmp09());
               }
            }

            ex = null;
         }

         List employeeCardResult1 = this.employeeCardService.findByCondition(new EmployeeCard(), (Page)null);
         if(employeeCardResult1 != null && employeeCardResult1.size() > 0) {
            EmployeeCard ec1;
            for(Iterator var4 = employeeCardResult1.iterator(); var4.hasNext(); Global.icCardMap.put(ec1.getCard().trim(), ec1)) {
               ec1 = (EmployeeCard)var4.next();
               if(ec1.getState().intValue() == 1) {
                  Global.employeeCardMap.put(ec1.getEmp_id(), ec1);
               }
            }

            employeeCardResult = null;
         }
      } catch (Exception var5) {
         var5.printStackTrace();
      }

   }

   public void loadAllDeptInfo() {
      try {
         List ex = this.departmentInfoService.findByCondition(new DepartmentInfo(), (Page)null);
         if(ex != null && ex.size() > 0) {
            Iterator var3 = ex.iterator();

            while(var3.hasNext()) {
               DepartmentInfo di = (DepartmentInfo)var3.next();
               Global.departmentInfoMap.put(di.getId(), di);
               Global.departmentCodeMap.put(di.getDept_code().trim(), di);
            }

            ex = null;
         }
      } catch (Exception var4) {
         var4.printStackTrace();
      }

   }

   public void loadAllPositionInfo() {
      try {
         List ex = this.positionInfoService.findByCondition(new PositionInfo(), (Page)null);
         if(ex != null && ex.size() > 0) {
            Iterator var3 = ex.iterator();

            while(var3.hasNext()) {
               PositionInfo pi = (PositionInfo)var3.next();
               Global.positionInfoMap.put(pi.getId(), pi);
               Global.positionCodeMap.put(pi.getPos_code().trim(), pi);
            }

            ex = null;
         }
      } catch (Exception var4) {
         var4.printStackTrace();
      }

   }

   public void loadAllProjectInfo() {
      try {
         List ex = this.projectInfoService.findByCondition(new ProjectInfo(), (Page)null);
         if(ex != null && ex.size() > 0) {
            Iterator var3 = ex.iterator();

            while(var3.hasNext()) {
               ProjectInfo pi = (ProjectInfo)var3.next();
               Global.projectInfoMap.put(pi.getId(), pi);
               Global.projectCodeMap.put(pi.getProject_code().trim(), pi);
            }

            ex = null;
         }
      } catch (Exception var4) {
         var4.printStackTrace();
      }

   }

   public void loadAllGapInfo() {
      try {
         List ex = this.gapInfoService.findByCondition(new GapInfo(), (Page)null);
         if(ex != null && ex.size() > 0) {
            Iterator var3 = ex.iterator();

            while(var3.hasNext()) {
               GapInfo gi = (GapInfo)var3.next();
               Global.gapInfoMap.put(gi.getId(), gi);
               Global.gapCodeMap.put(gi.getGap_code().trim(), gi);
            }

            ex = null;
         }
      } catch (Exception var4) {
         var4.printStackTrace();
      }

   }

   public void loadAllHrStatus() {
      try {
         List ex = this.annualLeaveService.queryHrStatus();
         AnnualLeave al;
         Iterator list1;
         if(ex != null && ex.size() > 0) {
            list1 = ex.iterator();

            while(list1.hasNext()) {
               al = (AnnualLeave)list1.next();
               Global.hrStatusMap.put(al.getHr_status_id(), al.getStatus_code());
               Global.hrStatusCodeMap.put(al.getStatus_code().trim(), al.getHr_status_id());
            }

            ex = null;
         }

         al = new AnnualLeave();
         al.setState(Integer.valueOf(1));
         List list11 = this.annualLeaveService.findByCondition(al, (Page)null);
         if(list11 != null && list11.size() > 0) {
            Iterator var5 = list11.iterator();

            while(var5.hasNext()) {
               AnnualLeave al1 = (AnnualLeave)var5.next();
               String status_code = (String)Global.hrStatusMap.get(al1.getHr_status_id());
               if(Global.annualLeaveMap.containsKey(status_code)) {
                  ((List)Global.annualLeaveMap.get(status_code)).add(al1);
               } else {
                  ArrayList alResult = new ArrayList();
                  alResult.add(al1);
                  Global.annualLeaveMap.put(status_code.trim(), alResult);
               }
            }

            list1 = null;
         }
      } catch (Exception var8) {
         var8.printStackTrace();
      }

   }

   public void setHoliday() {
      try {
         Calendar ex = Calendar.getInstance();
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         String holidayName = null;
         String holidayDate = null;

         for(int i = 0; i < 365; ++i) {
            Date now = ex.getTime();
            NationalHoliday nh = this.nationalHolidayService.queryByHoliday(now, Integer.valueOf(1));
            if(nh == null) {
               int week = ex.get(7);
               holidayDate = sdf.format(now);
               if(week != 7 && week != 1) {
                  holidayName = Global.holidays_name[2];
               } else {
                  holidayName = Global.holidays_name[1];
               }

               this.nationalHolidayService.save(holidayName, holidayDate);
            }

            ex.add(5, 1);
         }
      } catch (Exception var9) {
         var9.printStackTrace();
      }

   }

   public void reckonAnnualAndCompanyLeave() {
      try {
         if(Global.annualLeaveMap.size() > 0) {
            Iterator var2 = Global.employeeInfoMap.keySet().iterator();

            while(var2.hasNext()) {
               Integer ex = (Integer)var2.next();
               EmployeeInfo ei = (EmployeeInfo)Global.employeeInfoMap.get(ex);
               EmployeeLeave el = Util.getEmployeeLeave(Util.getAnnualLeaveDays(ei));
               if(el != null) {
                  this.employeeLeaveService.save(el);
               }
            }
         }
      } catch (Exception var5) {
         var5.printStackTrace();
      }

   }

   public void clearAnnualAndCompanyLeave(int year) {
      try {
         Iterator var3 = Global.employeeInfoMap.keySet().iterator();

         while(var3.hasNext()) {
            Integer ex = (Integer)var3.next();
            EmployeeInfo ei = (EmployeeInfo)Global.employeeInfoMap.get(ex);
            EmployeeLeave el = this.employeeLeaveService.findByEmpIdAnyYear(ei.getId().intValue(), year);
            if(el != null) {
               el.setAnnualDays(Double.valueOf(0.0D));
               el.setCompanyDays(Double.valueOf(0.0D));
               this.employeeLeaveService.update(el);
            }
         }
      } catch (Exception var6) {
         var6.printStackTrace();
      }

   }

   public void syncTimeSheet(Date class_date) {
      try {
         this.commonService.runEmpTimeSheet(class_date, (UserInfo)null);
      } catch (Exception var3) {
         var3.printStackTrace();
      }

   }

   public void empTimeSheet(Date class_date) {
      try {
         class_date = this.sdf.parse(this.sdf.format(class_date));

         Map mapDetail;
         for(Iterator var3 = Global.employeeInfoMap.keySet().iterator(); var3.hasNext(); mapDetail = null) {
            Integer ex = (Integer)var3.next();
            EmployeeInfo ei = (EmployeeInfo)Global.employeeInfoMap.get(ex);
            mapDetail = this.commonService.runTimeSheetDetail(ei, class_date, 500);
            this.commonService.innerTimeSheetDetail(mapDetail);
         }
      } catch (Exception var6) {
         var6.printStackTrace();
      }

   }

   public void updateWoNumberForNull() {
      try {
         this.scheduleInfoService.updateWoNumberForNull();
         this.scheduleInfoPoolService.updateWoNumberForNull();
         this.breakTimeInfoService.updateWoNumberForNull();
         this.overTimeInfoService.updateWoNumberForNull();
      } catch (Exception var2) {
         var2.printStackTrace();
      }

   }
}
