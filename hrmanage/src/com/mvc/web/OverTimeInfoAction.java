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
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.FlowInfo;
import com.yq.faurecia.pojo.FlowStep;
import com.yq.faurecia.pojo.NationalHoliday;
import com.yq.faurecia.pojo.OverTimeInfo;
import com.yq.faurecia.pojo.OverTimeInfoHistory;
import com.yq.faurecia.service.FlowInfoService;
import com.yq.faurecia.service.FlowStepService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.OverTimeInfoService;

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
@RequestMapping({"/common/overTimeInfo/*"})
public class OverTimeInfoAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(OverTimeInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private FlowInfoService flowInfoService;
   @Resource
   private FlowStepService flowStepService;
   @Resource
   private NationalHolidayService nationalHolidayService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(overTimeInfo.getDept_ids())) {
            overTimeInfo.setDept_ids(e);
         }

         int resultCount = this.overTimeInfoService.findCountByCondition(overTimeInfo);
         page.setTotalCount(resultCount);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.overTimeInfoService.findByCondition(overTimeInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            OverTimeInfo json = (OverTimeInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'flow_type\':").append("\'" + Global.flow_type[2] + "\',");
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
   public void queryWOResult(Page page, OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"count");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.overTimeInfoService.findCountByCondition(overTimeInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(overTimeInfo.getDept_ids())) {
            overTimeInfo.setDept_ids(deptIdsRole);
         }

         List result = this.overTimeInfoService.findWOByCondition(overTimeInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            OverTimeInfo json = (OverTimeInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'dept_names\':").append("\'" + this.overTimeInfoService.getDeptNameByWO(json.getWo_number()) + "\',");
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

   @RequestMapping({"overTimeAdd.do"})
   public void overTimeAdd(OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         overTimeInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
         overTimeInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
         Map e = this.validate(overTimeInfo);
         String msg = e.get("msg") == null?"":e.get("msg").toString();
         if(msg.trim().equals("")) {
            FlowInfo flowInfo = (FlowInfo)e.get("flowInfo");
            String step = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")[0];
            overTimeInfo.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(step.split(",")[1].split("\\|")[0])));
            overTimeInfo.setAvailable(Integer.valueOf(1));
            overTimeInfo.setYear(Integer.valueOf(Integer.parseInt(this.sdf.format(overTimeInfo.getBegin_date()).substring(0, 4))));
            this.overTimeInfoService.save(overTimeInfo);
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

   @RequestMapping({"overTimeEdit.do"})
   public void overTimeEdit(OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String roleCodes = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         OverTimeInfo oti = this.overTimeInfoService.findById(overTimeInfo.getId());
         if(oti.getStatus().intValue() == Global.flow_check_status[2] && !Util.contains(roleCodes, Global.default_role[1], ",")) {
            e = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0 && !Util.contains(roleCodes, Global.default_role[1], ",")) {
            e = "此记录已经无效，不能操作";
         } else {
            ReflectPOJO.alternateObject(overTimeInfo, oti);
            Map mapValidate = this.validate(overTimeInfo);
            e = StringUtils.defaultIfEmpty((String)mapValidate.get("msg"), "");
            if(e.trim().equals("")) {
               OverTimeInfoHistory otih = null;
               if(!Util.contains(roleCodes, Global.default_role[1], ",")) {
                  FlowStep fs = new FlowStep();
                  fs.setFlow_id(oti.getFlow_id());
                  fs.setHandle_id(oti.getId());
                  List fsList = this.flowStepService.findByCondition(fs, (Page)null);
                  if(fsList != null && fsList.size() > 0) {
                     if(overTimeInfo.getStatus().intValue() != Global.flow_check_status[0]) {
                        otih = new OverTimeInfoHistory();
                        ReflectPOJO.copyObject(otih, oti);
                        otih.setOvertime_info_id(oti.getId());
                     }

                     FlowInfo flowInfo = this.flowInfoService.findById(overTimeInfo.getFlow_id());
                     String step = StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")[0];
                     overTimeInfo.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(step.split(",")[1].split("\\|")[0])));
                     overTimeInfo.setStatus(Integer.valueOf(Global.flow_check_status[0]));
                     overTimeInfo.setCheck_emp_id((Integer)null);
                     overTimeInfo.setCheck_state(Integer.valueOf(Global.flow_check_state[0]));
                     overTimeInfo.setCheck_remark((String)null);
                     overTimeInfo.setCheck_state_date((Date)null);
                  }
               }

               overTimeInfo.setYear(Integer.valueOf(Integer.parseInt(this.sdf.format(overTimeInfo.getBegin_date()).substring(0, 4))));
               this.overTimeInfoService.update(overTimeInfo, (FlowStep)null, otih);
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

   @RequestMapping({"overTimeCheck.do"})
   public void overTimeCheck(OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      EmployeeInfo employeeInfo = (EmployeeInfo)request.getSession().getAttribute("employeeInfo");

      try {
         String e = "";
         OverTimeInfo oti = this.overTimeInfoService.findById(overTimeInfo.getId());
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
               if(overTimeInfo.getCheck_state().intValue() == Global.flow_check_state[2]) {
                  oti.setNext_check_emp_id(Integer.valueOf(Integer.parseInt(steps[0].split(",")[1].split("\\|")[0])));
                  oti.setStatus(Integer.valueOf(Global.flow_check_status[0]));
               } else {
                  oti.setNext_check_emp_id(Integer.valueOf(next_check_emp_id));
               }

               oti.setCheck_emp_id(employeeInfo.getId());
               oti.setCheck_remark(overTimeInfo.getCheck_remark());
               oti.setCheck_state(overTimeInfo.getCheck_state());
               oti.setCheck_state_date(var28.getTime());
               fs.setState(overTimeInfo.getCheck_state());
               fs.setEmp_id(employeeInfo.getId());
               fs.setEmp_name(employeeInfo.getZh_name());
               fs.setRemark(overTimeInfo.getCheck_remark());
               fs.setState_date(var28.getTime());
               this.overTimeInfoService.update(oti, fs, (OverTimeInfoHistory)null);
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

   @RequestMapping({"overTimeInvalid.do"})
   public void overTimeInvalid(OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = StringUtils.defaultIfEmpty((String)request.getSession().getAttribute("roleCodes"), "");
         String msg = "";
         OverTimeInfo oti = this.overTimeInfoService.findById(overTimeInfo.getId());
         if(e.indexOf(Global.default_role[1]) == -1 && oti.getStatus().intValue() == Global.flow_check_status[2]) {
            msg = Global.flow_check_status_name[2];
         } else if(oti.getAvailable().intValue() == 0) {
            msg = "此记录已经无效，不能操作";
         } else {
            overTimeInfo.setAvailable(Integer.valueOf(0));
            ReflectPOJO.alternateObject(overTimeInfo, oti);
            OverTimeInfoHistory otih = new OverTimeInfoHistory();
            ReflectPOJO.alternateObject(otih, oti);
            otih.setOvertime_info_id(oti.getId());
            this.overTimeInfoService.update(overTimeInfo, (FlowStep)null, otih);
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

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(OverTimeInfo overTimeInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(overTimeInfo.getDept_ids())) {
            overTimeInfo.setDept_ids(e);
         }

         List<?> result = this.overTimeInfoService.findByCondition(overTimeInfo, (Page)null);
         ArrayList<Object[]> objects = new ArrayList();
         OverTimeInfo csvWtriter;
         if(result != null && result.size() > 0) {
            Iterator e1 = result.iterator();

            while(e1.hasNext()) {
               csvWtriter = (OverTimeInfo)e1.next();
               byte writerSettings = 0;
               Object[] writer = new Object[Global.overtime_column.length];
               int var16 = writerSettings + 1;
               writer[writerSettings] = StringUtils.defaultString(csvWtriter.getDept_name(), "");
               writer[var16++] = StringUtils.defaultString(csvWtriter.getEmp_name(), "");
               writer[var16++] = this.sdf1.format(csvWtriter.getBegin_date());
               writer[var16++] = this.sdf1.format(csvWtriter.getEnd_date());
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
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("加班.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var15 = response.getOutputStream();
            BufferedWriter var14 = new BufferedWriter(new OutputStreamWriter(var15));
            CsvWriterSettings var18 = new CsvWriterSettings();
            CsvWriter var17 = new CsvWriter(var14, var18);
            var17.writeHeaders(Global.overtime_column);
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

   private Map validate(OverTimeInfo oti) throws Exception {
      Calendar c = Calendar.getInstance();
      c.setTime(oti.getBegin_date());
      long diff_days = Util.getDaySub(oti.getBegin_date(), oti.getEnd_date());
      String tmpDate = "";

      for(int mapValidate = 0; (long)mapValidate < diff_days; ++mapValidate) {
         tmpDate = tmpDate + "\'" + this.sdf.format(c.getTime()) + "\',";
         c.add(5, 1);
      }

      tmpDate = tmpDate.substring(0, tmpDate.length() - 1);
      HashMap var22 = new HashMap();
      String msg = "";
      if(msg.trim().equals("")) {
         FlowInfo list = this.flowInfoService.findById(oti.getFlow_id());
         if(list == null) {
            msg = "没找到对应的审批流，请联系HR!";
         } else {
            var22.put("flowInfo", list);
         }
      }

      if(msg.trim().equals("")) {
         OverTimeInfo var24 = new OverTimeInfo();
         var24.setAvailable(Integer.valueOf(1));
         var24.setEmp_id(oti.getEmp_id());
         var24.setBegin_date(oti.getBegin_date());
         var24.setEnd_date(oti.getEnd_date());
         int ci = 0;

         try {
            List holiday_name = this.overTimeInfoService.findByCondition(var24, (Page)null);
            Iterator oti_end_time = holiday_name.iterator();

            while(oti_end_time.hasNext()) {
               OverTimeInfo oti_begin_time = (OverTimeInfo)oti_end_time.next();
               if(oti.getId() == null || oti.getId().intValue() <= 0 || oti.getId().intValue() != oti_begin_time.getId().intValue()) {
                  ++ci;
               }
            }
         } catch (Exception var21) {
            var21.printStackTrace();
         }

         if(ci > 0) {
            msg = this.sdf1.format(oti.getBegin_date()) + "~" + this.sdf1.format(oti.getEnd_date()) + "加班日期不能重复提交！！";
         }
      }

      if(msg.trim().equals("") && !this.sdf.format(oti.getBegin_date()).equals(this.sdf.format(oti.getEnd_date())) && !this.sdf1.format(oti.getEnd_date()).split(" ")[1].equals("00:00:00")) {
         msg = "结束时间：" + this.sdf1.format(oti.getEnd_date()) + "超过0点！";
      }

      if(msg.trim().equals("")) {
         List var23 = this.nationalHolidayService.checkHrStatusDate(tmpDate);
         if(var23 != null && var23.size() != 0) {
            ClassInfo var25 = (ClassInfo)Global.classInfoMap.get(Global.class_code_default[0]);
            String var27 = ((NationalHoliday)var23.get(0)).getHoliday_name();
            if(var27.equals(Global.holidays_name[2])) {
               String var26 = this.sdf1.format(oti.getBegin_date()).split(" ")[1];
               String var28 = this.sdf1.format(oti.getEnd_date()).split(" ")[1];
               var28 = var28.equals("00:00:00")?"23:59:59":var28;
               long oti_begin_hms = Util.getTimeInMillis((double)Integer.parseInt(var26.split(":")[0]), "h") + Util.getTimeInMillis((double)Integer.parseInt(var26.split(":")[1]), "m") + Util.getTimeInMillis((double)Integer.parseInt(var26.split(":")[2]), "s");
               long oti_end_hms = Util.getTimeInMillis((double)Integer.parseInt(var28.split(":")[0]), "h") + Util.getTimeInMillis((double)Integer.parseInt(var28.split(":")[1]), "m") + Util.getTimeInMillis((double)Integer.parseInt(var28.split(":")[2]), "s");
               long b_begin_hms = Util.getTimeInMillis((double)Integer.parseInt(var25.getBegin_time().split(":")[0]), "h") + Util.getTimeInMillis((double)Integer.parseInt(var25.getBegin_time().split(":")[1]), "m") + Util.getTimeInMillis((double)Integer.parseInt(var25.getBegin_time().split(":")[2]), "s");
               long b_end_hms = Util.getTimeInMillis((double)Integer.parseInt(var25.getEnd_time().split(":")[0]), "h") + Util.getTimeInMillis((double)Integer.parseInt(var25.getEnd_time().split(":")[1]), "m") + Util.getTimeInMillis((double)Integer.parseInt(var25.getEnd_time().split(":")[2]), "s");
               if(oti_begin_hms > b_begin_hms && oti_begin_hms < b_end_hms || oti_end_hms > b_begin_hms && oti_end_hms < b_end_hms) {
                  msg = Global.holidays_name[2] + "加班有效时间段在" + var25.getEnd_time() + "到第二天的" + var25.getBegin_time() + "点之间!";
               }
            } else if(oti.getType().trim().equals(Global.overtime_type[1]) && !var27.trim().equals(Global.holidays_name[0])) {
               msg = "您选择的是“" + Global.overtime_type[1] + "”，但日期不是“" + Global.holidays_name[0] + "”！";
            }
         } else {
            msg = "联系HR，在HR日历中找不到日期类型！";
         }
      }

      var22.put("msg", msg);
      return var22;
   }

   public OverTimeInfoService getOverTimeInfoService() {
      return this.overTimeInfoService;
   }

   public void setOverTimeInfoService(OverTimeInfoService overTimeInfoService) {
      this.overTimeInfoService = overTimeInfoService;
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
