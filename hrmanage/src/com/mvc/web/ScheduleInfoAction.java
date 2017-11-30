package com.mvc.web;

import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.FlowInfo;
import com.yq.faurecia.pojo.FlowStep;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.pojo.ScheduleInfoHistory;
import com.yq.faurecia.service.ClassInfoService;
import com.yq.faurecia.service.FlowInfoService;
import com.yq.faurecia.service.FlowStepService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.ScheduleInfoService;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/scheduleInfo/*"})
public class ScheduleInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ScheduleInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private FlowInfoService flowInfoService;
   @Resource
   private FlowStepService flowStepService;
   @Resource
   private ClassInfoService classInfoService;
   @Resource
   private NationalHolidayService nationalHolidayService;


   @InitBinder
   protected void initBinder(WebDataBinder binder) {
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
   }

   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.scheduleInfoService.findCountByCondition(scheduleInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(scheduleInfo.getDept_ids())) {
            scheduleInfo.setDept_ids(deptIdsRole);
         }

         List result = this.scheduleInfoService.findByCondition(scheduleInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            ScheduleInfo json = (ScheduleInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'flow_type\':").append("\'" + Global.flow_type[0] + "\',");
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
   public void queryWOResult(Page page, ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"count");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.scheduleInfoService.findWOCountByCondition(scheduleInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(scheduleInfo.getDept_ids())) {
            scheduleInfo.setDept_ids(deptIdsRole);
         }

         List result = this.scheduleInfoService.findWOByCondition(scheduleInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            ScheduleInfo json = (ScheduleInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'dept_names\':").append("\'" + this.scheduleInfoService.getDeptNameByWO(json.getWo_number()) + "\',");
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

   @RequestMapping({"scheduleAdd.do"})
   public void scheduleAdd(ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         scheduleInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
         scheduleInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
         List flowInfoResult = this.flowInfoService.getFlowBy(scheduleInfo.getEmp_id().intValue(), Global.flow_type[0], 0);
         FlowInfo flowInfo = flowInfoResult != null && flowInfoResult.size() == 1?(FlowInfo)flowInfoResult.get(0):null;
         if(flowInfo == null) {
            e = "员工“" + scheduleInfo.getEmp_name() + "”" + "没找到对应的审批流，请联系HR!";
         } else {
            scheduleInfo.setFlow_id(flowInfo.getId());
            String step = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")[0];
            scheduleInfo.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(step.split(",")[1].split("\\|")[0])));
            if(scheduleInfo.getType().trim().equals(Global.schedule_type[0])) {
               ClassInfo classInfo = this.classInfoService.queryById(scheduleInfo.getClass_id().intValue());
               scheduleInfo.setClass_name(classInfo.getClass_name());
               scheduleInfo.setBegin_time(classInfo.getBegin_time());
               scheduleInfo.setEnd_time(classInfo.getEnd_time());
               scheduleInfo.setHours(classInfo.getHours());
               scheduleInfo.setMeals(classInfo.getMeals());
               scheduleInfo.setHave_meals(classInfo.getHave_meals());
               scheduleInfo.setOver_hour(classInfo.getOver_hour());
            }

            e = this.validate(scheduleInfo);
         }

         if(e.trim().equals("")) {
            this.scheduleInfoService.save(scheduleInfo);
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
      } catch (Exception var19) {
         var19.printStackTrace();
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
         } catch (IOException var18) {
            var18.printStackTrace();
         }

      }

   }

   @RequestMapping({"scheduleEdit.do"})
   public void scheduleEdit(ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String roleCodes = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         ScheduleInfo oti = this.scheduleInfoService.findById(scheduleInfo.getId());
         if(oti.getStatus().intValue() == Global.flow_check_status[2] && !Util.contains(roleCodes, Global.default_role[1], ",")) {
            e = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0 && !Util.contains(roleCodes, Global.default_role[1], ",")) {
            e = "此记录已经无效，不能操作";
         } else {
            if(e.trim().equals("")) {
               e = this.validate(scheduleInfo);
            }

            if(e.trim().equals("")) {
               if(scheduleInfo.getType().trim().equals(Global.schedule_type[0])) {
                  ClassInfo otih = this.classInfoService.queryById(scheduleInfo.getClass_id().intValue());
                  scheduleInfo.setClass_name(otih.getClass_name());
                  scheduleInfo.setBegin_time(otih.getBegin_time());
                  scheduleInfo.setEnd_time(otih.getEnd_time());
                  scheduleInfo.setHours(otih.getHours());
                  scheduleInfo.setMeals(otih.getMeals());
                  scheduleInfo.setHave_meals(otih.getHave_meals());
                  scheduleInfo.setOver_hour(otih.getOver_hour());
               }

               ReflectPOJO.alternateObject(scheduleInfo, oti);
               ScheduleInfoHistory otih1 = null;
               if(!Util.contains(roleCodes, Global.default_role[1], ",")) {
                  FlowStep fs = new FlowStep();
                  fs.setFlow_id(oti.getFlow_id());
                  fs.setHandle_id(oti.getId());
                  List fsList = this.flowStepService.findByCondition(fs, (Page)null);
                  if(fsList != null && fsList.size() > 0) {
                     if(scheduleInfo.getStatus().intValue() != Global.flow_check_status[0]) {
                        otih1 = new ScheduleInfoHistory();
                        ReflectPOJO.copyObject(otih1, oti);
                        otih1.setSchedule_info_id(oti.getId());
                     }

                     FlowInfo flowInfo = this.flowInfoService.findById(scheduleInfo.getFlow_id());
                     String step = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")[0];
                     scheduleInfo.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(step.split(",")[1].split("\\|")[0])));
                     scheduleInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
                     scheduleInfo.setCheck_emp_id((Integer)null);
                     scheduleInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
                     scheduleInfo.setCheck_remark((String)null);
                     scheduleInfo.setCheck_state_date((Date)null);
                  }
               }

               this.scheduleInfoService.update(scheduleInfo, (FlowStep)null, otih1);
            }
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

   @RequestMapping({"scheduleCheck.do"})
   public void scheduleCheck(ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      EmployeeInfo employeeInfo = (EmployeeInfo)request.getSession().getAttribute("employeeInfo");

      try {
         String e = "";
         ScheduleInfo oti = this.scheduleInfoService.findById(scheduleInfo.getId());
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
               if(scheduleInfo.getCheck_state().intValue() == Global.flow_check_state[2]) {
                  oti.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(steps[0].split(",")[1].split("\\|")[0])));
                  oti.setStatus(Integer.valueOf(Global.flow_check_status[0]));
               } else {
                  oti.setNext_check_emp_id(Integer.valueOf(next_check_emp_id));
               }

               oti.setCheck_emp_id(employeeInfo.getId());
               oti.setCheck_remark(scheduleInfo.getCheck_remark());
               oti.setCheck_state(scheduleInfo.getCheck_state());
               oti.setCheck_state_date(var28.getTime());
               fs.setState(scheduleInfo.getCheck_state());
               fs.setEmp_id(employeeInfo.getId());
               fs.setEmp_name(employeeInfo.getZh_name());
               fs.setRemark(scheduleInfo.getCheck_remark());
               fs.setState_date(var28.getTime());
               this.scheduleInfoService.update(oti, fs, (ScheduleInfoHistory)null);
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

   @RequestMapping({"scheduleInvalid.do"})
   public void scheduleInvalid(ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         String msg = "";
         ScheduleInfo oti = this.scheduleInfoService.findById(scheduleInfo.getId());
         if(e.indexOf(Global.default_role[1]) == -1 && oti.getStatus().intValue() == Global.flow_check_status[2]) {
            msg = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0) {
            msg = "此记录已经无效，不能操作";
         } else {
            scheduleInfo.setAvailable(Integer.valueOf(0));
            ReflectPOJO.alternateObject(scheduleInfo, oti);
            ScheduleInfoHistory otih = new ScheduleInfoHistory();
            ReflectPOJO.copyObject(otih, oti);
            otih.setSchedule_info_id(oti.getId());
            this.scheduleInfoService.update(scheduleInfo, (FlowStep)null, otih);
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

   private String validate(ScheduleInfo si) throws Exception {
      String msg = "";
      if(msg.trim().equals("") && si.getEmp_id() == null) {
         msg = "请选择员工！";
      }

      if(msg.trim().equals("")) {
         List count = this.nationalHolidayService.checkHrStatusDate("\'" + this.sdf.format(si.getBegin_date()) + "\'");
         if(count != null && count.size() != 0) {
            if(count.size() > 1) {
               msg = "联系HR，" + "\'" + this.sdf.format(si.getBegin_date()) + "\'" + "在HR日历中存在多条记录！";
            } else {
               String e = ((NationalHoliday)count.get(0)).getHoliday_name();
               if(e.equals(Global.holidays_name[2]) && si.getHours().doubleValue() < 8.0D) {
                  msg = "工作日排班不可低于8H";
               }
            }
         } else {
            msg = "联系HR，在HR日历中找不到日期类型！";
         }
      }

      if(msg.trim().equals("")) {
         int count1 = 0;

         try {
            ScheduleInfo e1;
            if(si.getId() != null && si.getId().intValue() > 0) {
               e1 = this.scheduleInfoService.findById(si.getId());
               if(e1.getBegin_date().getTime() != si.getBegin_date().getTime() || e1.getEnd_date().getTime() != si.getEnd_date().getTime()) {
                  ScheduleInfo tmpSI = new ScheduleInfo();
                  tmpSI.setNoId(si.getId());
                  tmpSI.setAvailable(Integer.valueOf(1));
                  tmpSI.setEmp_id(si.getEmp_id());
                  tmpSI.setTmp_date("\'" + this.sdf.format(si.getBegin_date()) + "\'");
                  count1 = this.scheduleInfoService.findCountByCondition(tmpSI);
               }
            } else {
               e1 = new ScheduleInfo();
               e1.setAvailable(Integer.valueOf(1));
               e1.setEmp_id(si.getEmp_id());
               e1.setTmp_date("\'" + this.sdf.format(si.getBegin_date()) + "\'");
               count1 = this.scheduleInfoService.findCountByCondition(e1);
            }
         } catch (Exception var6) {
            var6.printStackTrace();
         }

         if(count1 > 0) {
            msg = "员工“" + si.getEmp_name() + "”的排班日期不能重复提交！";
         }
      }

      return msg;
   }

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(ScheduleInfo scheduleInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(scheduleInfo.getDept_ids())) {
            scheduleInfo.setDept_ids(e);
         }

         List<?> result = this.scheduleInfoService.findByCondition(scheduleInfo, (Page)null);
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         ScheduleInfo csvWtriter;
         if(result != null && result.size() > 0) {
            Iterator e1 = result.iterator();

            while(e1.hasNext()) {
               csvWtriter = (ScheduleInfo)e1.next();
               byte writerSettings = 0;
               Object[] writer = new Object[Global.schedule_column.length];
               int var16 = writerSettings + 1;
               writer[writerSettings] = StringUtils.defaultString(csvWtriter.getDept_name(), "");
               writer[var16++] = StringUtils.defaultString(csvWtriter.getEmp_name(), "");
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getType(), "");
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getClass_name(), "");
               writer[var16++] = this.sdf.format(csvWtriter.getBegin_date()) + " " + csvWtriter.getBegin_time();
               writer[var16++] = this.sdf.format(csvWtriter.getEnd_date()) + " " + csvWtriter.getEnd_time();
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getMeals(), "");
               writer[var16++] = csvWtriter.getHave_meals() == null?"0":csvWtriter.getHave_meals();
               writer[var16++] = csvWtriter.getOver_hour() == null?"0":csvWtriter.getOver_hour();
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getRemark(), "");
               writer[var16++] = Global.flow_check_status_name[csvWtriter.getStatus().intValue()];
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getCheck_emp_name(), "");
               writer[var16++] = Global.flow_check_state_name[csvWtriter.getCheck_state().intValue()];
               writer[var16++] = csvWtriter.getCheck_state_date() == null?"":this.sdf1.format(csvWtriter.getCheck_state_date());
               writer[var16++] = StringUtils.defaultIfEmpty(csvWtriter.getUser_name(), "");
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
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("排班.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var15 = response.getOutputStream();
            BufferedWriter var14 = new BufferedWriter(new OutputStreamWriter(var15));
            CsvWriterSettings var18 = new CsvWriterSettings();
            CsvWriter var17 = new CsvWriter(var14, var18);
            var17.writeHeaders(Global.schedule_column);
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

   public ScheduleInfoService getScheduleInfoService() {
      return this.scheduleInfoService;
   }

   public void setScheduleInfoService(ScheduleInfoService scheduleInfoService) {
      this.scheduleInfoService = scheduleInfoService;
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
