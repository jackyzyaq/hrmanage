package com.mvc.web;

import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.faurecia.pojo.BreakTimeInfo;
import com.yq.faurecia.pojo.BreakTimeInfoHistory;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.FlowInfo;
import com.yq.faurecia.pojo.FlowStep;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.service.BreakTimeInfoService;
import com.yq.faurecia.service.ClassInfoService;
import com.yq.faurecia.service.EmployeeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.FlowInfoService;
import com.yq.faurecia.service.FlowStepService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.OverTimeInfoService;
import com.yq.faurecia.service.ScheduleInfoService;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/breakTimeInfo/*"})
public class BreakTimeInfoAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(BreakTimeInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;
   @Resource
   private EmployeeInfoService employeeInfoService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private ClassInfoService classInfoService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private FlowInfoService flowInfoService;
   @Resource
   private FlowStepService flowStepService;
   @Resource
   private NationalHolidayService nationalHolidayService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.breakTimeInfoService.findCountByCondition(breakTimeInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(breakTimeInfo.getDept_ids())) {
            breakTimeInfo.setDept_ids(deptIdsRole);
         }

         List<?> result = this.breakTimeInfoService.findByCondition(breakTimeInfo, page);
         sb.append("\'rows\':[");
         Iterator<?> var10 = result.iterator();

         while(var10.hasNext()) {
            BreakTimeInfo json = (BreakTimeInfo)var10.next();
            sb.append("{");
            ArrayList<?> attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'flow_type\':").append("\'" + Global.flow_type[1] + "\',");
            Iterator var13 = attrList.iterator();
            while(var13.hasNext()) {
            	
               String attr = (String)var13.next();
               sb.append("\'" + attr + "\':").append("\'" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)) + "\',");
            }

            if(attrList.size() > 0) {
               sb.deleteCharAt(sb.length() - 1);
            }

            attrList = null;
            sb.append("},");
         }

         if(result.size() > 0) {
            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]}");
         JSONObject json1 = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");
         response.getWriter().println(json1.toString());
      } catch (JSONException var14) {
         var14.printStackTrace();
      } catch (Exception var15) {
         var15.printStackTrace();
      }

   }

   @RequestMapping({"queryWOResult.do"})
   public void queryWOResult(Page page, BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"count");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.breakTimeInfoService.findWOCountByCondition(breakTimeInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(breakTimeInfo.getDept_ids())) {
            breakTimeInfo.setDept_ids(deptIdsRole);
         }

         List result = this.breakTimeInfoService.findWOByCondition(breakTimeInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            BreakTimeInfo json = (BreakTimeInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'dept_names\':").append("\'" + this.breakTimeInfoService.getDeptNameByWO(json.getWo_number()) + "\',");
            sb.append("\'count\':").append("\'" + json.getCount() + "\',");
            sb.append("\'flow_type\':").append("\'" + json.getFlow_type() + "\',");

            String attr;
            for(Iterator var13 = attrList.iterator(); var13.hasNext(); sb.append("\'" + attr + "\':").append("\'" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)) + "\',")) {
               attr = (String)var13.next();
               if(attr.equals("id")) {
                  sb.append("\'id\':").append("\'" + json.getWo_number() + "\',");
               }
            }

            if(attrList.size() > 0) {
               sb.deleteCharAt(sb.length() - 1);
            }

            attrList = null;
            sb.append("},");
         }

         if(result.size() > 0) {
            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]}");
         JSONObject json1 = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");
         response.getWriter().println(json1.toString());
      } catch (JSONException var14) {
         var14.printStackTrace();
      } catch (Exception var15) {
         var15.printStackTrace();
      }

   }

   @RequestMapping({"breakTimeAdd.do"})
   public void breakTimeAdd(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         breakTimeInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
         breakTimeInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
         breakTimeInfo.setYear(Integer.valueOf(breakTimeInfo.getYear() == null?0:breakTimeInfo.getYear().intValue()));
         breakTimeInfo.setDept_id(((EmployeeInfo)Global.employeeInfoMap.get(breakTimeInfo.getEmp_id())).getDept_id());
         Map e = this.validate(breakTimeInfo, StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), ""));
         String msg = StringUtils.defaultIfEmpty((String)e.get("msg"), "");
         if(msg.trim().equals("")) {
            breakTimeInfo = (BreakTimeInfo)e.get("breakTimeInfo");
            breakTimeInfo.setAvailable(Integer.valueOf(1));
            this.breakTimeInfoService.save(breakTimeInfo);
            msg = "操作成功！";
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         }
      } catch (Exception var16) {
         var16.printStackTrace();
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
         } catch (IOException var15) {
            var15.printStackTrace();
         }

      }

   }

   @RequestMapping({"breakTimeEdit.do"})
   public void breakTimeEdit(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         breakTimeInfo.setYear(Integer.valueOf(breakTimeInfo.getYear() == null?0:breakTimeInfo.getYear().intValue()));
         String msg = "";
         BreakTimeInfo oti = this.breakTimeInfoService.findById(breakTimeInfo.getId());
         if(oti.getStatus().intValue() == Global.flow_check_status[2] && !Util.contains(e, Global.default_role[1], ",")) {
            msg = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0 && !Util.contains(e, Global.default_role[1], ",")) {
            msg = "此记录已经无效，不能操作";
         } else {
            ReflectPOJO.alternateObject(breakTimeInfo, oti);
            Map mapValidate = this.validate(breakTimeInfo, StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), ""));
            msg = StringUtils.defaultIfEmpty((String)mapValidate.get("msg"), "");
            if(msg.trim().equals("")) {
               BreakTimeInfoHistory otih = null;
               if(!Util.contains(e, Global.default_role[1], ",")) {
                  FlowStep fs = new FlowStep();
                  fs.setFlow_id(oti.getFlow_id());
                  fs.setHandle_id(oti.getId());
                  List fsList = this.flowStepService.findByCondition(fs, (Page)null);
                  if(fsList != null && fsList.size() > 0) {
                     if(breakTimeInfo.getStatus().intValue() != Global.flow_check_status[0]) {
                        otih = new BreakTimeInfoHistory();
                        ReflectPOJO.copyObject(otih, oti);
                        otih.setBreaktime_info_id(oti.getId());
                     }

                     FlowInfo flowInfo = this.flowInfoService.findById(breakTimeInfo.getFlow_id());
                     String step = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")[0];
                     breakTimeInfo.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(step.split(",")[1].split("\\|")[0])));
                     breakTimeInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
                     breakTimeInfo.setCheck_emp_id((Integer)null);
                     breakTimeInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
                     breakTimeInfo.setCheck_remark((String)null);
                     breakTimeInfo.setCheck_state_date((Date)null);
                  }
               }

               this.breakTimeInfoService.update(breakTimeInfo, (FlowStep)null, otih);
            }
         }

         if(msg.trim().equals("")) {
            msg = "操作成功！";
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         }
      } catch (Exception var23) {
         var23.printStackTrace();
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
         } catch (IOException var22) {
            var22.printStackTrace();
         }

      }

   }

   @RequestMapping({"breakTimeCheck.do"})
   public void breakTimeCheck(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      EmployeeInfo employeeInfo = (EmployeeInfo)request.getSession().getAttribute("employeeInfo");

      try {
         String e = "";
         BreakTimeInfo oti = this.breakTimeInfoService.findById(breakTimeInfo.getId());
         if(oti.getStatus().intValue() == Global.flow_check_status[2]) {
            e = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0) {
            e = "此记录已经无效，不能操作";
         } else if(employeeInfo != null && employeeInfo.getId() != null && employeeInfo.getId().intValue() != 0 && oti.getNext_check_emp_id().intValue() == employeeInfo.getId().intValue()) {
            FlowStep fs = new FlowStep();
            fs.setFlow_id(oti.getFlow_id());
            fs.setHandle_id(oti.getId());
            List fsList = this.flowStepService.findByCondition(fs, (Page)null);
            int last_check_emp_id = 0;
            if(fsList != null && fsList.size() > 0) {
               last_check_emp_id = ((FlowStep)fsList.get(fsList.size() - 1)).getEmp_id().intValue();
            }

            FlowInfo flowInfo = this.flowInfoService.findById(oti.getFlow_id());
            String[] steps = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]");
            int current_check_emp_id = 0;
            int next_check_emp_id = 0;
            if(last_check_emp_id == 0) {
               current_check_emp_id = Integer.parseInt(steps[0].split(",")[1].split("\\|")[0]);
               next_check_emp_id = Integer.parseInt(steps[1].split(",")[1].split("\\|")[0]);
               oti.setStatus(Integer.valueOf(Global.flow_check_status[1]));
            } else {
               for(int cal = 0; cal < steps.length; ++cal) {
                  int step_emp_id = Integer.parseInt(steps[cal].split(",")[1].split("\\|")[0]);
                  if(step_emp_id == oti.getNext_check_emp_id().intValue()) {
                     current_check_emp_id = Integer.parseInt(steps[cal].split(",")[1].split("\\|")[0]);
                     if(cal + 1 != steps.length) {
                        next_check_emp_id = Integer.parseInt(steps[cal + 1].split(",")[1].split("\\|")[0]);
                        oti.setStatus(Integer.valueOf(Global.flow_check_status[1]));
                        break;
                     }

                     next_check_emp_id = 0;
                     oti.setStatus(Integer.valueOf(Global.flow_check_status[2]));
                  }
               }
            }

            if(employeeInfo.getId().intValue() != current_check_emp_id) {
               e = "流程变更，此环节不是您审批！";
            } else {
               Calendar var28 = Calendar.getInstance();
               if(breakTimeInfo.getCheck_state().intValue() == Global.flow_check_state[2]) {
                  oti.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(steps[0].split(",")[1].split("\\|")[0])));
                  oti.setStatus(Integer.valueOf(Global.flow_check_status[0]));
               } else {
                  oti.setNext_check_emp_id(Integer.valueOf(next_check_emp_id));
               }

               oti.setCheck_emp_id(employeeInfo.getId());
               oti.setCheck_remark(breakTimeInfo.getCheck_remark());
               oti.setCheck_state(breakTimeInfo.getCheck_state());
               oti.setCheck_state_date(var28.getTime());
               fs.setState(breakTimeInfo.getCheck_state());
               fs.setEmp_id(employeeInfo.getId());
               fs.setEmp_name(employeeInfo.getZh_name());
               fs.setRemark(breakTimeInfo.getCheck_remark());
               fs.setState_date(var28.getTime());
               this.breakTimeInfoService.update(oti, fs, (BreakTimeInfoHistory)null);
            }
         } else {
            e = "您不是当前记录的审批人！";
         }

         if(e.trim().equals("")) {
            e = "操作成功！";
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'" + e + "\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'" + e + "\'");
            sb.append("}");
         }
      } catch (Exception var26) {
         var26.printStackTrace();
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
         } catch (IOException var25) {
            var25.printStackTrace();
         }

      }

   }

   @RequestMapping({"breakTimeInvalid.do"})
   public void breakTimeInvalid(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         String msg = "";
         BreakTimeInfo oti = this.breakTimeInfoService.findById(breakTimeInfo.getId());
         if(e.indexOf(Global.default_role[1]) == -1 && oti.getStatus().intValue() == Global.flow_check_status[2]) {
            msg = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0) {
            msg = "此记录已经无效，不能操作";
         } else {
            breakTimeInfo.setAvailable(Integer.valueOf(0));
            ReflectPOJO.alternateObject(breakTimeInfo, oti);
            BreakTimeInfoHistory otih = new BreakTimeInfoHistory();
            ReflectPOJO.copyObject(otih, oti);
            otih.setBreaktime_info_id(oti.getId());
            this.breakTimeInfoService.update(breakTimeInfo, (FlowStep)null, otih);
         }

         if(msg.trim().equals("")) {
            msg = "操作成功！";
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'" + msg + "\'");
            sb.append("}");
         }
      } catch (Exception var18) {
         var18.printStackTrace();
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
         } catch (IOException var17) {
            var17.printStackTrace();
         }

      }

   }

   public Map validate(BreakTimeInfo bti, String roleCodes) throws Exception {
      HashMap mapValidate = new HashMap();
      String msg = "";
      Calendar employeeInfo;
      Date breakContent;
      Date breakTimeName;
      Date isTrue;
      if(!Util.contains(roleCodes, Global.default_role[1], ",") && msg.trim().equals("") && ((EmployeeInfo)Global.employeeInfoMap.get(bti.getEmp_id())).getType().equals(Global.employee_type[0])) {
         employeeInfo = Calendar.getInstance();
         breakContent = employeeInfo.getTime();
         employeeInfo.set(5, 16);
         breakTimeName = employeeInfo.getTime();
         employeeInfo.add(2, -1);
         isTrue = employeeInfo.getTime();
         if(this.sdf.parse(this.sdf.format(breakContent)).getTime() >= this.sdf.parse(this.sdf.format(breakTimeName)).getTime()) {
            if(this.sdf.parse(this.sdf.format(breakTimeName)).getTime() > bti.getBegin_date().getTime()) {
               msg = "当前时间大于等于本月16号，只能请本月16号（含）之后假";
            }
         } else if(this.sdf.parse(this.sdf.format(isTrue)).getTime() > bti.getBegin_date().getTime()) {
            msg = "当前时间小于本月16号，只能请上月16号（含）之后假";
         }
      }

      List var12;
      String var16;
      if(msg.trim().equals("")) {
         var12 = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(bti.getClass_date()) + "\'");
         if(var12 != null && var12.size() != 0) {
            if(var12.size() > 1) {
               msg = "联系HR，" + "\'" + this.sdf.format(bti.getClass_date()) + "\'" + "在HR日历中存在多条记录！";
            } else {
               var16 = ((NationalHoliday)var12.get(0)).getHoliday_name();
               if(var16.equals(Global.holidays_name[0]) || var16.equals(Global.holidays_name[1])) {
                  msg = Global.holidays_name[0] + "、" + Global.holidays_name[1] + "不需要填申请";
               }
            }
         } else {
            msg = "联系HR，在HR日历中找不到日期类型！";
         }
      }

      if(msg.trim().equals("")) {
         if(((EmployeeInfo)Global.employeeInfoMap.get(bti.getEmp_id())).getType().equals(Global.employee_type[0])) {
            ScheduleInfo var14 = this.scheduleInfoService.findSchedule(bti.getEmp_id().intValue(), bti.getBegin_date());
            if(var14 == null) {
               msg = "您选择的“" + this.sdf1.format(bti.getBegin_date()) + "”没有排班，请先确认！";
            }
         } else if(((EmployeeInfo)Global.employeeInfoMap.get(bti.getEmp_id())).getType().equals(Global.employee_type[1])) {
            ClassInfo var13 = this.classInfoService.findByClassCode(Global.class_code_default[0]);
            breakContent = Util.parseDateStr(this.sdf.format(bti.getClass_date()) + " " + var13.getBegin_time());
            breakTimeName = new Date(breakContent.getTime() + Util.getTimeInMillis(var13.getHours().doubleValue(), "h") + Util.getTimeInMillis((double)var13.getHave_meals().intValue(), "m"));
            if(bti.getBegin_date().getTime() < breakContent.getTime() || bti.getEnd_date().getTime() > breakTimeName.getTime()) {
               msg = "是" + Global.employee_type[1] + ",请按常班班的标准时间填写";
            }
         } else {
            msg = "找不到是" + Global.employee_type[0] + "还是" + Global.employee_type[1] + "，请联系HR";
         }
      }

      if(msg.trim().equals("") && bti.getBreak_hour().doubleValue() > 8.0D) {
         msg = this.sdf.format(bti.getClass_date()) + "请假超过8小时！";
      }

      if(msg.trim().equals("")) {
         Date var15 = this.sdf.parse(this.sdf.format(bti.getBegin_date()));
         if(bti.getType().equals(Global.breaktime_type[0].split("\\|")[0])) {
            if(var15.getTime() > Util.getIntervalDate(Global.clear_over_mm_dd).getTime()) {
               msg = bti.getType() + "超过当年截止日期";
            }
         } else if(bti.getType().equals(Global.breaktime_type[2].split("\\|")[0])) {
            if(var15.getTime() > Util.getIntervalDate(Global.clear_annual_leave_mm_dd).getTime()) {
               msg = bti.getType() + "超过当年截止日期";
            }
         } else if(bti.getType().equals(Global.breaktime_type[3].split("\\|")[0]) && var15.getTime() > Util.getIntervalDate(Global.clear_company_leave_mm_dd).getTime()) {
            msg = bti.getType() + "超过当年截止日期";
         }
      }

      List var21;
      String var25;
      if(msg.trim().equals("")) {
         employeeInfo = null;
         if(bti.getBreak_hour().doubleValue() == 8.0D) {
            BreakTimeInfo var18 = new BreakTimeInfo();
            var18.setAvailable(Integer.valueOf(1));
            var18.setEmp_id(bti.getEmp_id());
            var18.setBreak_hour(Double.valueOf(8.0D));
            var21 = this.breakTimeInfoService.findByCondition(var18, (Page)null);
            ArrayList var23 = new ArrayList();
            int year;
            if(var21 != null && var21.size() > 0) {
               for(year = 0; year < var21.size(); ++year) {
                  if(bti.getId() == null || bti.getId().intValue() != ((BreakTimeInfo)var21.get(year)).getId().intValue()) {
                     var23.add(Long.valueOf(((BreakTimeInfo)var21.get(year)).getClass_date().getTime()));
                  }
               }
            }

            year = Util.serialDays(Long.valueOf(bti.getClass_date().getTime()), var23);
            isTrue = null;
            breakTimeName = null;
            var12 = this.flowInfoService.getFlowBy(bti.getEmp_id().intValue(), Global.flow_type[1], year);
         } else {
            var12 = this.flowInfoService.getFlowBy(bti.getEmp_id().intValue(), Global.flow_type[1], (int)Math.ceil(bti.getBreak_hour().doubleValue() / 8.0D));
         }

         FlowInfo var17 = var12 != null && var12.size() == 1?(FlowInfo)var12.get(0):null;
         if(bti.getId() != null && bti.getId().intValue() > 0) {
            if(var17 == null || bti.getFlow_id().intValue() != var17.getId().intValue()) {
               msg = "流程需要变更，连续请假超过规定天数，先关单，重新申请!";
            }
         } else if(var17 == null) {
            msg = "没找到对应的审批流或连续请假超过规定天数，请联系HR!";
         } else {
            bti.setFlow_id(var17.getId());
            var25 = StringUtils.defaultIfEmpty(var17.getStep_info(), "").split("]")[0];
            bti.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(var25.split(",")[1].split("\\|")[0])));
         }
      }

      if(msg.trim().equals("")) {
         BreakTimeInfo var19 = new BreakTimeInfo();
         var19.setAvailable(Integer.valueOf(1));
         var19.setEmp_id(bti.getEmp_id());
         var19.setBegin_date(bti.getBegin_date());
         var19.setEnd_date(bti.getEnd_date());
         int var20 = 0;

         try {
            var21 = this.breakTimeInfoService.findByCondition(var19, (Page)null);
            Iterator var30 = var21.iterator();

            while(var30.hasNext()) {
               BreakTimeInfo var28 = (BreakTimeInfo)var30.next();
               if(bti.getId() == null || bti.getId().intValue() <= 0 || bti.getId().intValue() != var28.getId().intValue()) {
                  ++var20;
               }
            }
         } catch (Exception var11) {
            var11.printStackTrace();
         }

         if(var20 > 0) {
            msg = "休假日期不能重复提交！";
         }
      }

      if(msg.trim().equals("") && (bti.getType().equals(Global.breaktime_type[2].split("\\|")[0]) || bti.getType().equals(Global.breaktime_type[3].split("\\|")[0]) || bti.getType().equals(Global.breaktime_type[0].split("\\|")[0]))) {
         EmployeeInfo var24 = this.employeeInfoService.queryById(bti.getEmp_id().intValue());
         if(var24.getType().equals(Global.employee_type[0])) {
            if(!bti.getType().equals(Global.breaktime_type[2].split("\\|")[0]) && !bti.getType().equals(Global.breaktime_type[3].split("\\|")[0])) {
               bti.getType().equals(Global.breaktime_type[0].split("\\|")[0]);
            } else {
               var16 = this.getLineBreakTimeTypeAndHours(bti);
               if(StringUtils.isEmpty(var16)) {
                  msg = "“" + Global.breaktime_type[2] + "、" + Global.breaktime_type[3] + "”都已经休完，请选择其它假别！";
               } else {
                  int var29 = Integer.parseInt(var16.split("\\|")[0]);
                  String var26 = var16.split("\\|")[1];
                  double var32 = Double.parseDouble(var16.split("\\|")[2]);
                  if(bti.getYear() != null && bti.getYear().intValue() != 0) {
                     if(bti.getYear().intValue() == var29 && bti.getType().equals(var26)) {
                        if(var32 < bti.getBreak_hour().doubleValue()) {
                           msg = var29 + "不够休假时长，" + var26 + "剩余还有" + var32 + " h！";
                        }
                     } else {
                        msg = var29 + var26 + "时数还有" + var32 + "，请先休完！";
                     }
                  } else {
                     if(!bti.getType().equals(var26)) {
                        msg = var29 + var26 + "时数还有" + var32 + "，请先休完！";
                     } else if(var32 < bti.getBreak_hour().doubleValue()) {
                        msg = var29 + "不够休假时长，" + var26 + "剩余还有" + var32 + " h！";
                     }

                     bti.setYear(Integer.valueOf(var29));
                  }
               }
            }
         } else if(bti.getType().equals(Global.breaktime_type[0].split("\\|")[0]) || bti.getType().equals(Global.breaktime_type[2].split("\\|")[0]) || bti.getType().equals(Global.breaktime_type[3].split("\\|")[0])) {
            Map var22 = this.getBreakTimeTypeAndHours(bti);
            if(var22 != null && !var22.isEmpty()) {
               if(var22.containsKey(bti.getType())) {
                  Map var27 = (Map)var22.get(bti.getType());
                  boolean var31 = false;
                  Iterator var10 = var27.keySet().iterator();

                  while(var10.hasNext()) {
                     Integer var34 = (Integer)var10.next();
                     if(((Double)var27.get(var34)).doubleValue() >= bti.getBreak_hour().doubleValue()) {
                        var31 = true;
                        bti.setYear(var34);
                        break;
                     }
                  }

                  if(!var31) {
                     msg = bti.getType() + "不够休假时长！";
                  }
               } else {
                  for(Iterator var33 = var22.keySet().iterator(); var33.hasNext(); msg = msg + var25 + "、") {
                     var25 = (String)var33.next();
                  }

                  msg = msg.substring(0, msg.length() - 1) + "还有剩余时数，请先休完！";
               }
            } else {
               msg = "“" + Global.breaktime_type[2] + "、" + Global.breaktime_type[0] + "、" + Global.breaktime_type[3] + "”都已经休完，请选择其它假别！";
            }
         }
      }

      if(!msg.trim().equals("")) {
         msg = StringUtils.defaultIfEmpty(bti.getEmp_name(), "") + msg;
      }

      mapValidate.put("msg", msg);
      mapValidate.put("breakTimeInfo", bti);
      return mapValidate;
   }

   public Map getBreakTimeTypeAndHours(BreakTimeInfo bti) throws Exception {
      Map leaveMap = this.employeeLeaveService.findStandardLeave(bti.getEmp_id().intValue());
      Map overMap = this.overTimeInfoService.findStandardOverHour(bti.getEmp_id().intValue());
      Date beginDate = this.sdf.parse(this.sdf.format(bti.getBegin_date()));
      Integer year;
      Iterator var6;
      if(beginDate.getTime() > Util.getIntervalDate(Global.clear_company_leave_mm_dd).getTime()) {
         var6 = leaveMap.keySet().iterator();

         while(var6.hasNext()) {
            year = (Integer)var6.next();
            ((Map)leaveMap.get(year)).put("surplus_company_leave", Double.valueOf(0.0D));
         }
      }

      if(beginDate.getTime() > Util.getIntervalDate(Global.clear_annual_leave_mm_dd).getTime()) {
         var6 = leaveMap.keySet().iterator();

         while(var6.hasNext()) {
            year = (Integer)var6.next();
            ((Map)leaveMap.get(year)).put("surplus_annual_leave", Double.valueOf(0.0D));
         }
      }

      if(beginDate.getTime() > Util.getIntervalDate(Global.clear_over_mm_dd).getTime()) {
         var6 = leaveMap.keySet().iterator();

         while(var6.hasNext()) {
            year = (Integer)var6.next();
            ((Map)leaveMap.get(year)).put("surplus_over_hour", Double.valueOf(0.0D));
         }
      }

      return this.breakTimeInfoService.getBreakTimeTypeAndHours(leaveMap, overMap);
   }

   public String getLineBreakTimeTypeAndHours(BreakTimeInfo bti) throws Exception {
      Map leaveMap = this.employeeLeaveService.findStandardLeave(bti.getEmp_id().intValue());
      Date set = this.sdf.parse(this.sdf.format(bti.getBegin_date()));
      Integer breakContent;
      Iterator year;
      if(set.getTime() > Util.getIntervalDate(Global.clear_company_leave_mm_dd).getTime()) {
         year = leaveMap.keySet().iterator();

         while(year.hasNext()) {
            breakContent = (Integer)year.next();
            ((Map)leaveMap.get(breakContent)).put("surplus_company_leave", Double.valueOf(0.0D));
         }
      }

      if(set.getTime() > Util.getIntervalDate(Global.clear_annual_leave_mm_dd).getTime()) {
         year = leaveMap.keySet().iterator();

         while(year.hasNext()) {
            breakContent = (Integer)year.next();
            ((Map)leaveMap.get(breakContent)).put("surplus_annual_leave", Double.valueOf(0.0D));
         }
      }

      TreeSet set1 = new TreeSet();
      if(leaveMap != null && leaveMap.size() > 0) {
         year = leaveMap.keySet().iterator();

         while(year.hasNext()) {
            breakContent = (Integer)year.next();
            set1.add(breakContent);
         }
      }

      String breakContent1 = null;
      Iterator var6 = set1.iterator();

      while(var6.hasNext()) {
         Integer year1 = (Integer)var6.next();
         breakContent1 = this.breakTimeInfoService.getLineBreakTimeTypeAndHours(leaveMap, year1.intValue());
         if(!StringUtils.isEmpty(breakContent1)) {
            break;
         }
      }

      leaveMap = null;
      set = null;
      return breakContent1;
   }

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(BreakTimeInfo breakTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(breakTimeInfo.getDept_ids())) {
            breakTimeInfo.setDept_ids(e);
         }

         List<?> result = this.breakTimeInfoService.findByCondition(breakTimeInfo, (Page)null);
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         BreakTimeInfo csvWtriter;
         if(result != null && result.size() > 0) {
            Iterator e1 = result.iterator();

            while(e1.hasNext()) {
               csvWtriter = (BreakTimeInfo)e1.next();
               byte writerSettings = 0;
               Object[] writer = new Object[Global.breaktime_column.length];
               int var16 = writerSettings + 1;
               writer[writerSettings] = StringUtils.defaultString(csvWtriter.getDept_name(), "");
               writer[var16++] = StringUtils.defaultString(csvWtriter.getEmp_name(), "");
               writer[var16++] = this.sdf1.format(csvWtriter.getBegin_date());
               writer[var16++] = this.sdf1.format(csvWtriter.getEnd_date());
               writer[var16++] = csvWtriter.getBreak_hour() == null?"0":csvWtriter.getBreak_hour();
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getType(), "");
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getRemark(), "");
               writer[var16++] = Global.flow_check_status_name[csvWtriter.getStatus().intValue()];
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getCheck_emp_name(), "");
               writer[var16++] = Global.flow_check_state_name[csvWtriter.getCheck_state().intValue()];
               writer[var16++] = csvWtriter.getCheck_state_date() == null?"":this.sdf1.format(csvWtriter.getCheck_state_date());
               writer[var16++] = csvWtriter.getCreate_date() == null?"":this.sdf1.format(csvWtriter.getCreate_date());
               writer[var16++] = csvWtriter.getUpdate_date() == null?"":this.sdf1.format(csvWtriter.getUpdate_date());
               objects.add(writer);
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("休假.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var15 = response.getOutputStream();
            BufferedWriter var14 = new BufferedWriter(new OutputStreamWriter(var15));
            CsvWriterSettings var18 = new CsvWriterSettings();
            CsvWriter var17 = new CsvWriter(var14, var18);
            var17.writeHeaders(Global.breaktime_column);
            var17.writeRowsAndClose(objects);
            var15.flush();
            var15.close();
         } catch (Exception var11) {
            var11.printStackTrace();
         }
      } catch (Exception var12) {
         var12.printStackTrace();
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
