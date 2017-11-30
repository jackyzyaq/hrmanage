package com.mvc.web;

import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.common.service.CommonService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeCard;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.TimeSheet;
import com.yq.faurecia.pojo.TimeSheetDetail;
import com.yq.faurecia.service.TimeSheetService;

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
@RequestMapping({"/common/timeSheet/*"})
public class TimeSheetAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(TimeSheetAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private TimeSheetService timeSheetService;
   @Resource
   private CommonService commonService;


   @InitBinder
   protected void initBinder(WebDataBinder binder) {
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
   }

   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, TimeSheet timeSheet, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"inner_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(timeSheet.getDept_ids())) {
            timeSheet.setDept_ids(e);
         }

         int resultCount = this.timeSheetService.findCountByCondition(timeSheet);
         page.setTotalCount(resultCount);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.timeSheetService.findByCondition(timeSheet, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            TimeSheet json = (TimeSheet)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var13 = attrList.iterator();

            while(var13.hasNext()) {
               String attr = (String)var13.next();
               if(attr.equals("emp_id")) {
                  sb.append("\'emp_id\':").append("\"" + Util.alternateZero(json.getEmp_id().intValue()) + "\",");
               } else if(attr.equals("emp_name")) {
                  sb.append("\'emp_name\':").append("\"" + ((EmployeeInfo)Global.employeeInfoMap.get(json.getEmp_id())).getZh_name() + "\",");
               } else if(attr.equals("card")) {
                  sb.append("\'card\':").append("\"" + json.getCard() + "\",");
               } else if(attr.equals("dept_name")) {
                  sb.append("\'dept_name\':").append("\"" + ((DepartmentInfo)Global.departmentInfoMap.get(((EmployeeInfo)Global.employeeInfoMap.get(json.getEmp_id())).getDept_id())).getDept_name() + "\",");
               } else {
                  sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace("\r", "；").replace("\n", "") + "\",");
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

   @RequestMapping({"queryMealsResult.do"})
   public void queryMealsResult(Page page, TimeSheet timeSheet, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"inner_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = Global.meals.length;
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.timeSheetService.findTotalMealsByCondition(timeSheet);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            TimeSheet json = (TimeSheet)var9.next();
            sb.append("{");
            sb.append("\'count\':").append("\"" + json.getCount() + "\",");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var12 = attrList.iterator();

            while(var12.hasNext()) {
               String attr = (String)var12.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace("\r", "；").replace("\n", "") + "\",");
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
      } catch (JSONException var13) {
         var13.printStackTrace();
      } catch (Exception var14) {
         var14.printStackTrace();
      }

   }

   @RequestMapping({"queryDetailResult.do"})
   public void queryDetailResult(Page page, TimeSheetDetail timeSheetDetail, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"class_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         String e = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(timeSheetDetail.getDept_ids())) {
            timeSheetDetail.setDept_ids(e);
         }

         int resultCount = this.timeSheetService.findDetailCountByCondition(timeSheetDetail);
         page.setTotalCount(resultCount);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.timeSheetService.findDetailByCondition(timeSheetDetail, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            TimeSheetDetail json = (TimeSheetDetail)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var13 = attrList.iterator();

            while(var13.hasNext()) {
               String attr = (String)var13.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace("\r", "；").replace("\n", "") + "\",");
            }

            sb.append("\'emp_name\':").append("\"" + ((EmployeeInfo)Global.employeeInfoMap.get(json.getEmp_id())).getZh_name() + "\",");
            sb.append("\'dept_name\':").append("\"" + ((DepartmentInfo)Global.departmentInfoMap.get(((EmployeeInfo)Global.employeeInfoMap.get(json.getEmp_id())).getDept_id())).getDept_name() + "\",");
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

   @RequestMapping({"addEmpTimeSheet.do"})
   public void addEmpTimeSheet(HttpServletRequest request, HttpServletResponse response) throws Exception {
      StringBuffer sb = new StringBuffer("");

      try {
         String e = "";
         int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
         String class_date = StringUtils.defaultIfEmpty(request.getParameter("class_date"), "");
         String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
         EmployeeInfo ei = (EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id));
         if(class_date.equals("")) {
            e = "考勤日期不能空！";
         } else if(ei == null) {
            e = "找不到您所选的员工！";
         } else if(type.equals("")) {
            e = "考勤类型不能为空！";
         } else {
            UserInfo user = Global.getUserObject(request);
            EmployeeCard ec = (EmployeeCard)Global.employeeCardMap.get(Integer.valueOf(emp_id));
            TimeSheet timeSheet = new TimeSheet();
            timeSheet.setType(type);
            timeSheet.setEmp_id(Integer.valueOf(emp_id));
            timeSheet.setCard_id(ec.getId());
            timeSheet.setInner_date(this.sdf1.parse(class_date));
            timeSheet.setOperater(Util.getOperator(user));
            timeSheet.setSource(Global.timesheet_source[2]);
            this.timeSheetService.insertTimeSheet(timeSheet);
            e = "操作成功！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
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

   @RequestMapping({"delEmpTimeSheet.do"})
   public void delEmpTimeSheet(HttpServletRequest request, HttpServletResponse response) throws Exception {
      StringBuffer sb = new StringBuffer("");

      try {
         String e = "";
         String ids = StringUtils.defaultIfEmpty(request.getParameter("ids"), "0");
         if(ids.equals("0")) {
            e = "请至少选择一条考勤！";
         }

         if(e.trim().equals("")) {
            TimeSheet ts = new TimeSheet();
            ts.setIds(ids);
            this.timeSheetService.delTimeSheet(ts);
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

   @RequestMapping({"runEmpTimeSheet.do"})
   public void runEmpTimeSheet(HttpServletRequest request, HttpServletResponse response) throws Exception {
      StringBuffer sb = new StringBuffer("");

      try {
         String e = "";
         String start_date = StringUtils.defaultIfEmpty(request.getParameter("start_date"), "");
         String over_date = StringUtils.defaultIfEmpty(request.getParameter("over_date"), "");
         String emp_ids = StringUtils.defaultIfEmpty(request.getParameter("emp_ids"), "");
         if(!start_date.equals("") && !over_date.equals("")) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(this.sdf.parse(start_date));

            for(int i = 0; (long)i < Util.getDaySub(start_date, over_date); ++i) {
               String[] var13;
               int var12 = (var13 = emp_ids.split(",")).length;

               for(int var11 = 0; var11 < var12; ++var11) {
                  String emp_id = var13[var11];
                  this.commonService.runEmpTimeSheet(cal.getTime(), Integer.valueOf(emp_id).intValue(), Global.getUserObject(request));
               }

               cal.add(5, 1);
            }

            e = "操作成功！";
         } else {
            e = "考勤日期不能空！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var23) {
         var23.printStackTrace();
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
         } catch (IOException var22) {
            var22.printStackTrace();
         }

      }

   }

   @RequestMapping({"runEmpTimeSheetDetail.do"})
   public void runEmpTimeSheetDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
      StringBuffer sb = new StringBuffer("");

      try {
         String e = "";
         String start_date = StringUtils.defaultIfEmpty(request.getParameter("start_date"), "");
         String over_date = StringUtils.defaultIfEmpty(request.getParameter("over_date"), "");
         String emp_ids = StringUtils.defaultIfEmpty(request.getParameter("emp_ids"), "");
         int range = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("range"), String.valueOf(500)));
         if(!start_date.equals("") && !over_date.equals("")) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(this.sdf.parse(start_date));

            for(int i = 0; (long)i < Util.getDaySub(start_date, over_date); ++i) {
               String[] var14;
               int var13 = (var14 = emp_ids.split(",")).length;

               for(int var12 = 0; var12 < var13; ++var12) {
                  String emp_id = var14[var12];
                  EmployeeInfo ei = (EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id));
                  if(ei != null) {
                     this.commonService.innerTimeSheetDetail(this.commonService.runTimeSheetDetail(ei, cal.getTime(), range));
                  }
               }

               cal.add(5, 1);
            }

            e = "操作成功！";
         } else {
            e = "归属日期不能空！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var25) {
         var25.printStackTrace();
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
         } catch (IOException var24) {
            var24.printStackTrace();
         }

      }

   }

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(TimeSheet timeSheet, HttpServletRequest request, HttpServletResponse response) {
      try {
         List<?> e = this.timeSheetService.findByCondition(timeSheet, (Page)null);
         ArrayList<Object[]> objects = new ArrayList();
         TimeSheet csvWtriter;
         if(e != null && e.size() > 0) {
            Iterator e1 = e.iterator();

            while(e1.hasNext()) {
               csvWtriter = (TimeSheet)e1.next();
               byte writerSettings = 0;
               Object[] writer = new Object[Global.timesheet_column.length];
               int var15 = writerSettings + 1;
               writer[writerSettings] = StringUtils.defaultString(((EmployeeInfo)Global.employeeInfoMap.get(csvWtriter.getEmp_id())).getZh_name(), "");
               writer[var15++] = StringUtils.defaultString(((DepartmentInfo)Global.departmentInfoMap.get(((EmployeeInfo)Global.employeeInfoMap.get(csvWtriter.getEmp_id())).getDept_id())).getDept_name(), "");
               writer[var15++] = StringUtils.defaultIfEmpty(csvWtriter.getType(), "");
               writer[var15++] = StringUtils.defaultIfEmpty(csvWtriter.getIp(), "");
               writer[var15++] = this.sdf1.format(csvWtriter.getInner_date());
               writer[var15++] = csvWtriter.getCreate_date() == null?"":this.sdf1.format(csvWtriter.getCreate_date());
               objects.add(writer);
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("考勤.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var14 = response.getOutputStream();
            BufferedWriter var13 = new BufferedWriter(new OutputStreamWriter(var14));
            CsvWriterSettings var17 = new CsvWriterSettings();
            CsvWriter var16 = new CsvWriter(var13, var17);
            var16.writeHeaders(Global.timesheet_column);
            var16.writeRowsAndClose(objects);
            var14.flush();
            var14.close();
         } catch (Exception var10) {
            var10.printStackTrace();
         }
      } catch (Exception var11) {
         var11.printStackTrace();
      }

   }

   @RequestMapping({"exportDetailCsv.do"})
   public void exportDetailCsv(TimeSheetDetail timeSheetDetail, HttpServletRequest request, HttpServletResponse response) {
      try {
         Calendar e = Calendar.getInstance();
         List<?> result = this.timeSheetService.findDetailByCondition(timeSheetDetail, (Page)null);
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         if(timeSheetDetail.getBegin_date() != null && result != null && result.size() > 0) {
            int csvWtriter = 0;
            Iterator writerSettings = result.iterator();

            while(writerSettings.hasNext()) {
               TimeSheetDetail e1 = (TimeSheetDetail)writerSettings.next();
               EmployeeInfo writer = (EmployeeInfo)Global.employeeInfoMap.get(e1.getEmp_id());
               if(writer.getState().intValue() == 1 || writer.getEmp04() == null || this.sdf.parse(timeSheetDetail.getBegin_date().substring(0, timeSheetDetail.getBegin_date().lastIndexOf("-")) + "-01").getTime() <= writer.getEmp04().getTime() && this.sdf.parse(timeSheetDetail.getEnd_date().substring(0, timeSheetDetail.getEnd_date().lastIndexOf("-")) + "-01").getTime() >= writer.getEmp04().getTime()) {
                  e.setTime(e1.getClass_date());
                  int week = e.get(7);
                  ++csvWtriter;
                  byte k = 0;
                  Object[] ob = new Object[Global.timesheet_detail_column.length];
                  int var21 = k + 1;
                  ob[k] = Integer.valueOf(csvWtriter);
                  ob[var21++] = StringUtils.defaultString(writer.getEmp_code(), "");
                  ob[var21++] = StringUtils.defaultString(writer.getZh_name(), "");
                  ob[var21++] = StringUtils.defaultString(writer.getType(), "");
                  ob[var21++] = StringUtils.defaultString(((DepartmentInfo)Global.departmentInfoMap.get(writer.getDept_id())).getDept_name(), "");
                  ob[var21++] = this.sdf.format(e1.getClass_date());
                  ob[var21++] = Integer.valueOf(week == 1?7:week - 1);
                  ob[var21++] = StringUtils.defaultString(e1.getClass_name(), "");
                  ob[var21++] = e1.getClass_begin_date() == null?"":this.sdf1.format(e1.getClass_begin_date());
                  ob[var21++] = e1.getClass_end_date() == null?"":this.sdf1.format(e1.getClass_end_date());
                  ob[var21++] = e1.getTs_begin_date() == null?"":this.sdf1.format(e1.getTs_begin_date());
                  ob[var21++] = e1.getTs_end_date() == null?"":this.sdf1.format(e1.getTs_end_date());
                  ob[var21++] = Double.valueOf(e1.getShould_work_hours() == null?0.0D:e1.getShould_work_hours().doubleValue());
                  ob[var21++] = Double.valueOf(e1.getArrive_work_hours() == null?0.0D:e1.getArrive_work_hours().doubleValue());
                  ob[var21++] = Double.valueOf(e1.getAbsence_hours() == null?0.0D:e1.getAbsence_hours().doubleValue());
                  ob[var21++] = Double.valueOf(e1.getOt1_hours() == null?0.0D:e1.getOt1_hours().doubleValue());
                  ob[var21++] = Double.valueOf(e1.getOt2_hours() == null?0.0D:e1.getOt2_hours().doubleValue());
                  ob[var21++] = Double.valueOf(e1.getOt3_hours() == null?0.0D:e1.getOt3_hours().doubleValue());
                  ob[var21++] = (e1.getShift2_number() != null && e1.getShift2_number().doubleValue() != 0.0D?e1.getShift2_number() + "个中班":"") + (e1.getShift3_number() != null && e1.getShift3_number().doubleValue() != 0.0D?"," + e1.getShift3_number() + "个夜班":"");
                  ob[var21++] = StringUtils.defaultIfEmpty(e1.getAbnormal_cause(), "");
                  ob[var21++] = e1.getTs_number() == null?"":e1.getTs_number();
                  ob[var21++] = e1.getTb_01() == null?"":e1.getTb_01();
                  ob[var21++] = e1.getTb_02() == null?"":e1.getTb_02();
                  objects.add(ob);
               }
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         BufferedWriter var17 = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("考勤详表.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var18 = response.getOutputStream();
            var17 = new BufferedWriter(new OutputStreamWriter(var18));
            CsvWriterSettings var19 = new CsvWriterSettings();
            CsvWriter var20 = new CsvWriter(var17, var19);
            var20.writeHeaders(Global.timesheet_detail_column);
            var20.writeRowsAndClose(objects);
            var18.flush();
            var18.close();
         } catch (Exception var14) {
            var14.printStackTrace();
         }
      } catch (Exception var15) {
         var15.printStackTrace();
      }

   }

   @RequestMapping({"exportDetailSumCsv.do"})
   public void exportDetailSumCsv(TimeSheetDetail timeSheetDetail, HttpServletRequest request, HttpServletResponse response) {
      try {
         List<?> e = this.timeSheetService.findDetailSumByCondition(timeSheetDetail);
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         if(e != null && e.size() > 0) {
            int csvWtriter = 0;
            Iterator writerSettings = e.iterator();

            while(writerSettings.hasNext()) {
               TimeSheetDetail e1 = (TimeSheetDetail)writerSettings.next();
               EmployeeInfo writer = (EmployeeInfo)Global.employeeInfoMap.get(e1.getEmp_id());
               if(writer.getState().intValue() == 1 || writer.getEmp04() == null || this.sdf.parse(timeSheetDetail.getBegin_date().substring(0, timeSheetDetail.getBegin_date().lastIndexOf("-")) + "-01").getTime() <= writer.getEmp04().getTime() && this.sdf.parse(timeSheetDetail.getEnd_date().substring(0, timeSheetDetail.getEnd_date().lastIndexOf("-")) + "-01").getTime() >= writer.getEmp04().getTime()) {
                  ++csvWtriter;
                  byte k = 0;
                  Object[] ob = new Object[Global.timesheet_detail_sum_column.length];
                  int var27 = k + 1;
                  ob[k] = Integer.valueOf(csvWtriter);
                  ob[var27++] = StringUtils.defaultString(writer.getEmp_code(), "");
                  ob[var27++] = StringUtils.defaultString(writer.getZh_name(), "");
                  ob[var27++] = StringUtils.defaultString(writer.getType(), "");
                  ob[var27++] = StringUtils.defaultString(((DepartmentInfo)Global.departmentInfoMap.get(writer.getDept_id())).getDept_name(), "");
                  double ot1_hours = e1.getOt1_hours() == null?0.0D:e1.getOt1_hours().doubleValue();
                  double ot2_hours = e1.getOt2_hours() == null?0.0D:e1.getOt2_hours().doubleValue();
                  double ot3_hours = e1.getOt3_hours() == null?0.0D:e1.getOt3_hours().doubleValue();
                  double hour50 = e1.getHour50() == null?0.0D:e1.getHour50().doubleValue();
                  ot1_hours -= Math.abs(hour50);
                  if(50.0D > ot1_hours) {
                     if(ot2_hours >= 50.0D - ot1_hours) {
                        ot2_hours -= 50.0D - ot1_hours;
                        ot1_hours = 50.0D;
                     } else {
                        ot1_hours += ot2_hours;
                        ot2_hours = 0.0D;
                     }
                  }

                  ob[var27++] = Double.valueOf(ot1_hours);
                  ob[var27++] = Double.valueOf(ot2_hours);
                  ob[var27++] = Double.valueOf(ot3_hours);
                  ob[var27++] = e1.getShift2_number() == null?"":e1.getShift2_number();
                  ob[var27++] = e1.getShift3_number() == null?"":e1.getShift3_number();
                  ob[var27++] = e1.getTb_01() == null?"":e1.getTb_01();
                  ob[var27++] = e1.getTb_02() == null?"":e1.getTb_02();
                  objects.add(ob);
               }
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         BufferedWriter var23 = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String(("考勤详表(" + timeSheetDetail.getBegin_date() + "~~~" + timeSheetDetail.getEnd_date() + ").csv").getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var24 = response.getOutputStream();
            var23 = new BufferedWriter(new OutputStreamWriter(var24));
            CsvWriterSettings var25 = new CsvWriterSettings();
            CsvWriter var26 = new CsvWriter(var23, var25);
            var26.writeHeaders(Global.timesheet_detail_sum_column);
            var26.writeRowsAndClose(objects);
            var24.flush();
            var24.close();
         } catch (Exception var20) {
            var20.printStackTrace();
         }
      } catch (Exception var21) {
         var21.printStackTrace();
      }

   }

   public TimeSheetService getTimeSheetService() {
      return this.timeSheetService;
   }

   public void setTimeSheetService(TimeSheetService timeSheetService) {
      this.timeSheetService = timeSheetService;
   }

   public SimpleDateFormat getSdf() {
      return this.sdf;
   }

   public void setSdf(SimpleDateFormat sdf) {
      this.sdf = sdf;
   }

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }
}
