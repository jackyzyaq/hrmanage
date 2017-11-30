package com.mvc.web;

import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import com.util.ExcelUtil;
import com.util.Global;
import com.util.IdCard;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.UploadFile;
import com.yq.common.service.CommonService;
import com.yq.common.service.UploadFileService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeCard;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.EmployeeInfoHistory;
import com.yq.faurecia.pojo.EmployeeLeave;
import com.yq.faurecia.pojo.HrStatus;
import com.yq.faurecia.pojo.PositionInfo;
import com.yq.faurecia.service.EmployeeCardService;
import com.yq.faurecia.service.EmployeeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.HrStatusService;
import com.yq.faurecia.service.OverTimeInfoService;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
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

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/employeeInfo/*"})
public class EmployeeInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(EmployeeInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   @Resource
   private UserInfoService userService;
   @Resource
   private CommonService commonService;
   @Resource
   private EmployeeInfoService employeeInfoService;
   @Resource
   private EmployeeCardService employeeCardService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private HrStatusService hrStatusService;
   @Resource
   private UploadFileService uploadFileService;


   @InitBinder
   protected void initBinder(WebDataBinder binder) {
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
   }

   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.employeeInfoService.findByCondition(employeeInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.employeeInfoService.findByCondition(employeeInfo, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            EmployeeInfo json = (EmployeeInfo)var9.next();
            String[] allDetpName = Util.getDeptAllNameById(json.getDept_id(), Global.departmentInfoMap).split(">>");
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var13 = attrList.iterator();

            while(var13.hasNext()) {
               String attr = (String)var13.next();
               if(attr.equals("id")) {
                  sb.append("\'" + attr + "\':").append("\"" + Util.alternateZero(json.getId().intValue()) + "\",");
               } else if(attr.equals("dept_name")) {
                  sb.append("\'" + attr + "\':").append("\"" + StringUtils.defaultString(allDetpName.length <= 3?allDetpName[allDetpName.length - 1]:allDetpName[allDetpName.length - 3], "").replace("\r", "").replace("\n", "") + "\",");
               } else if(attr.equals("project_name")) {
                  sb.append("\'" + attr + "\':").append("\"" + StringUtils.defaultString(allDetpName.length <= 3?allDetpName[allDetpName.length - 1]:allDetpName[allDetpName.length - 2], "").replace("\r", "").replace("\n", "") + "\",");
               } else if(attr.equals("gap_name")) {
                  sb.append("\'" + attr + "\':").append("\"" + StringUtils.defaultString(allDetpName[allDetpName.length - 1], "").replace("\r", "").replace("\n", "") + "\",");
               } else {
                  sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace("\r", "").replace("\n", "") + "\",");
               }
            }

            sb.append("\'leaderName\':").append("\"" + this.employeeInfoService.getLeaderNameByDeptId(json.getDept_id()) + "\"");
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

   @RequestMapping({"empAdd.do"})
   public void empAdd(EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         int id = employeeInfo.getId().intValue();
         employeeInfo.setEmp10(Integer.valueOf(id));
         String card = StringUtils.defaultString(request.getParameter("card"), "");
         if(this.employeeInfoService.queryById(id, (Integer)null) != null) {
            e = "编号：" + employeeInfo.getId() + "已存在！";
         } else if(this.employeeInfoService.checkEmpCode(employeeInfo.getEmp_code().trim())) {
            e = employeeInfo.getEmp_code() + "员工代码已存在！";
         } else if(!StringUtils.isEmpty(employeeInfo.getEmp09()) && this.employeeInfoService.checkEmpCarNum(employeeInfo.getEmp09().trim())) {
            e = employeeInfo.getEmp09() + "车牌号已存在！";
         } else if(card.trim().equals("")) {
            e = "IC卡不能为空！";
         } else if(this.employeeCardService.checkCard(card)) {
            e = card + "已存在！";
         } else if(Global.employeeZhNameSet.contains(employeeInfo.getZh_name())) {
            e = "‘" + employeeInfo.getZh_name() + "’已存在！";
         }

         if(e.trim().equals("")) {
            id = this.employeeInfoService.save(employeeInfo, card);
            employeeInfo.setId(Integer.valueOf(id));
            employeeInfo.setCard(card);
            employeeInfo.setDept_name(((DepartmentInfo)Global.departmentInfoMap.get(employeeInfo.getDept_id())).getDept_name());
            this.commonService.updateTimeSheet(employeeInfo, 1, (String)null);
            e = "操作成功！";
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'" + e + "\',");
            sb.append("\'id\':\'" + id + "\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'" + e + "\'");
            sb.append("}");
         }
      } catch (Exception var17) {
         var17.printStackTrace();
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
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"empEdit.do"})
   public void empEdit(EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = StringUtils.defaultString(request.getParameter("fromType"), "");
         String msg = "";
         EmployeeInfo result = this.employeeInfoService.queryById(employeeInfo.getId().intValue(), (Integer)null);
         if(!result.getEmp_code().trim().equals(employeeInfo.getEmp_code().trim()) && this.employeeInfoService.checkEmpCode(employeeInfo.getEmp_code().trim())) {
            msg = employeeInfo.getEmp_code() + "员工代码已存在！";
         }

         if(!StringUtils.isEmpty(employeeInfo.getEmp09()) && !((String)StringUtils.defaultIfEmpty(result.getEmp09(), "")).trim().equals(StringUtils.defaultIfEmpty(employeeInfo.getEmp09(), "")) && this.employeeInfoService.checkEmpCarNum(employeeInfo.getEmp09().trim())) {
            msg = employeeInfo.getEmp09() + "车牌号已存在！";
         }

         if(!StringUtils.isEmpty(employeeInfo.getZh_name()) && !((String)StringUtils.defaultIfEmpty(result.getZh_name(), "")).trim().equals(StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "")) && Global.employeeZhNameSet.contains(employeeInfo.getZh_name())) {
            msg = "‘" + employeeInfo.getZh_name() + "’已存在！";
         }

         if(msg.trim().equals("")) {
            String oldCar = result.getEmp09();
            employeeInfo = (EmployeeInfo)ReflectPOJO.alternateObject(employeeInfo, result);
            this.employeeInfoService.update(employeeInfo);
            employeeInfo.setCard(((EmployeeCard)Global.employeeCardMap.get(employeeInfo.getId())).getCard());
            if(!StringUtils.isEmpty(employeeInfo.getEmp09())) {
               this.commonService.updateTimeSheet(employeeInfo, 4, oldCar);
            }

            if(e.trim().equals("updateOver")) {
               this.commonService.updateTimeSheet(employeeInfo, 2, (String)null);
            }

            msg = "操作成功！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + msg + "\'");
         sb.append("}");
      } catch (Exception var18) {
         var18.printStackTrace();
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
         } catch (IOException var17) {
            var17.printStackTrace();
         }

      }

   }

   @RequestMapping({"editPhoto.do"})
   public void editPhoto(EmployeeInfo employeeInfo, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      String msg = "";
      String upload_uuid = "0";

      try {
         if(StringUtils.isEmpty(employeeInfo.getPhoto_upload_uuid())) {
            msg = "更新头象失败！";
         } else {
            EmployeeInfo e = this.employeeInfoService.queryById(employeeInfo.getId().intValue(), (Integer)null);
            employeeInfo = (EmployeeInfo)ReflectPOJO.alternateObject(employeeInfo, e);
            this.employeeInfoService.update(employeeInfo);
            msg = "操作成功！";
            upload_uuid = employeeInfo.getPhoto_upload_uuid();
         }

         sb.append("{");
         sb.append("\'msg\':\'" + msg + "\',");
         sb.append("\'upload_uuid\':\'" + upload_uuid + "\'");
         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'msg\':\'系统原因，请稍后再试！\',");
         sb.append("\'upload_uuid\':\'" + upload_uuid + "\'");
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

   @RequestMapping({"editCard.do"})
   public void editCard(EmployeeCard employeeCard, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      String msg = "";

      try {
         if(this.employeeCardService.checkCard(employeeCard.getCard())) {
            msg = employeeCard.getCard() + "已存在！";
         }

         if(msg.trim().equals("")) {
            this.employeeCardService.save(employeeCard);
            EmployeeInfo e = this.employeeInfoService.queryById(employeeCard.getEmp_id().intValue(), (Integer)null);
            e.setCard(employeeCard.getCard());
            this.commonService.updateTimeSheet(e, 3, (String)null);
            msg = "操作成功！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + msg + "\'");
         sb.append("}");
      } catch (Exception var15) {
         var15.printStackTrace();
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
         } catch (IOException var14) {
            var14.printStackTrace();
         }

      }

   }

   @RequestMapping({"editLeave.do"})
   public void editLeave(EmployeeLeave employeeLeave, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      String msg = "";

      try {
         EmployeeLeave e = this.employeeLeaveService.findByEmpIdAnyYear(employeeLeave.getEmp_id().intValue(), employeeLeave.getYear().intValue());
         if(e == null) {
            employeeLeave.setState(Integer.valueOf(1));
            this.employeeLeaveService.save(employeeLeave);
         } else {
            ReflectPOJO.alternateObject(employeeLeave, e);
            this.employeeLeaveService.updateByEmpIdAndYear(employeeLeave);
         }

         msg = "操作成功！";
         sb.append("{");
         sb.append("\'msg\':\'" + msg + "\'");
         sb.append("}");
      } catch (Exception var15) {
         var15.printStackTrace();
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
         } catch (IOException var14) {
            var14.printStackTrace();
         }

      }

   }

   @RequestMapping({"empLeaveYear.do"})
   public void empLeaveYear(Integer emp_id, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         emp_id = Integer.valueOf(emp_id == null?0:emp_id.intValue());
         Map elMap = this.employeeLeaveService.findStandardLeave(emp_id.intValue());
         if(elMap != null && elMap.size() > 0) {
            Iterator var8 = elMap.keySet().iterator();

            while(var8.hasNext()) {
               Integer year = (Integer)var8.next();
               Map elSubMap = (Map)elMap.get(year);
               if(elSubMap != null && elSubMap.size() > 0) {
                  e = e + "{";

                  String key;
                  Object o;
                  for(Iterator var11 = elSubMap.keySet().iterator(); var11.hasNext(); e = e + "\'" + key + "\':\'" + o.toString() + "\',") {
                     key = (String)var11.next();
                     o = elSubMap.get(key);
                  }

                  e = e.substring(0, e.length() - 1);
                  e = e + "},";
               }
            }

            e = e.substring(0, e.length() - 1);
         }

         sb.append("{\'rows\':[");
         sb.append(e);
         sb.append("]}");
      } catch (Exception var22) {
         var22.printStackTrace();
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
         } catch (IOException var21) {
            var21.printStackTrace();
         }

      }

   }

   @RequestMapping({"empOverYear.do"})
   public void empOverYear(Integer emp_id, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         emp_id = Integer.valueOf(emp_id == null?0:emp_id.intValue());
         Map elMap = this.overTimeInfoService.findStandardOverHour(emp_id.intValue());
         if(elMap != null && elMap.size() > 0) {
            Iterator var8 = elMap.keySet().iterator();

            while(var8.hasNext()) {
               Integer year = (Integer)var8.next();
               Map elSubMap = (Map)elMap.get(year);
               if(elSubMap != null && elSubMap.size() > 0) {
                  e = e + "{";

                  String key;
                  Object o;
                  for(Iterator var11 = elSubMap.keySet().iterator(); var11.hasNext(); e = e + "\'" + key + "\':\'" + o.toString() + "\',") {
                     key = (String)var11.next();
                     o = elSubMap.get(key);
                  }

                  e = e.substring(0, e.length() - 1);
                  e = e + "},";
               }
            }

            e = e.substring(0, e.length() - 1);
         }

         sb.append("{\'rows\':[");
         sb.append(e);
         sb.append("]}");
      } catch (Exception var22) {
         var22.printStackTrace();
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
         } catch (IOException var21) {
            var21.printStackTrace();
         }

      }

   }

   @RequestMapping({"autoComplete.do"})
   public void autoComplete(String emp_code, String dept_ids, String emp_name, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         dept_ids = (String)StringUtils.defaultIfEmpty(dept_ids, "0");
         emp_name = (String)StringUtils.defaultIfEmpty(emp_name, "");
         emp_code = (String)StringUtils.defaultIfEmpty(emp_code, "");
         HashMap e = new HashMap();
         e.put("dept_ids", dept_ids);
         e.put("emp_name", emp_name);
         e.put("emp_code", emp_code);
         List list = this.employeeInfoService.autoComplete(e);
         sb.append("[");
         if(list != null && list.size() > 0) {
            Iterator var10 = list.iterator();

            while(var10.hasNext()) {
               EmployeeInfo ci = (EmployeeInfo)var10.next();
               sb.append("{");
               sb.append((new StringBuilder("\"emp_id\":")).append("\"" + ci.getId() + "\","));
               sb.append((new StringBuilder("\"value\":")).append("\"" + ci.getZh_name() + "\","));
               sb.append((new StringBuilder("\"dept_name\":")).append("\"" + ci.getDept_name() + "\","));
               sb.append((new StringBuilder("\"state\":")).append("\"" + ci.getState() + "\","));
               sb.append((new StringBuilder("\"dept_id\":")).append("\"" + ci.getDept_id() + "\","));
               sb.append((new StringBuilder("\"emp_code\":")).append("\"" + ci.getEmp_code() + "\""));
               sb.append("},");
            }

            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]");
      } catch (Exception var19) {
         var19.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(sb.toString());
         } catch (IOException var18) {
            var18.printStackTrace();
         }

      }

   }

   @RequestMapping({"importEmp.do"})
   public void importEmp(String upload_uuid, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");
      String msg = "";

      try {
         if(StringUtils.isEmpty(upload_uuid)) {
            msg = "找不到上传文件，请重新上传！";
         } else {
            UploadFile e = this.uploadFileService.getUploadFileByUUId(upload_uuid);
            String filename = e.getFileName().replace("\\", "\\\\");
            System.out.println("*****解析XLSX文件 *****");
            ExcelUtil parser = new ExcelUtil(new File(filename));
            ArrayList empList = new ArrayList();
            msg = this.validateData(parser, empList).toString();
            System.out.println("*****解析XLSX文件 结束*****");
            if(msg.toString().equals("")) {
               EmployeeInfo var10;
               for(Iterator var11 = empList.iterator(); var11.hasNext(); var10 = (EmployeeInfo)var11.next()) {
                  ;
               }

               msg = "操作成功！";
            }
         }

         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
         sb.append("\'msg\':\'" + msg + "\'");
         sb.append("}");
      } catch (Exception var21) {
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
         var21.printStackTrace();
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

   @RequestMapping({"exportModelCsv.do"})
   public void exportModelCsv(HttpServletRequest request, HttpServletResponse response) {
      try {
         ArrayList<Object[]> e = new ArrayList<Object[]>();
         byte k = 0;
         Object[] ob = new Object[Global.employee_down_column.length];
         int var13 = k + 1;
         ob[k] = "1022";
         ob[var13++] = "FN000022";
         ob[var13++] = "22";
         ob[var13++] = "tonny";
         ob[var13++] = "办公室员工";
         ob[var13++] = "SH16A001";
         ob[var13++] = "_worker_";
         ob[var13++] = "PROJECT1";
         ob[var13++] = "GAP1";
         ob[var13++] = "M&P";
         ob[var13++] = "2016/3/27";
         ob[var13++] = "男";
         ob[var13++] = "320";
         ob[var13++] = "1";
         ob[var13++] = "2";
         ob[var13++] = "博士";
         ob[var13++] = "3";
         ob[var13++] = "4";
         ob[var13++] = "2016/3/28";
         ob[var13++] = "2";
         ob[var13++] = "试用期";
         ob[var13++] = "无";
         ob[var13++] = "是";
         ob[var13++] = "2016/4/1";
         ob[var13++] = "2016/4/2";
         ob[var13++] = "2016/4/19";
         ob[var13++] = "2016/4/20";
         ob[var13++] = "2016/4/21";
         ob[var13++] = "FRC";
         ob[var13++] = "2016/4/1";
         ob[var13++] = "0000000122";
         ob[var13++] = "MOD";
         ob[var13++] = "ULTD";
         ob[var13++] = "上海";
         ob[var13++] = "上海市******";
         ob[var13++] = "未婚";
         e.add(ob);
         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         BufferedWriter csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("员工信息模板.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream e1 = response.getOutputStream();
            csvWtriter = new BufferedWriter(new OutputStreamWriter(e1));
            CsvWriterSettings writerSettings = new CsvWriterSettings();
            CsvWriter writer = new CsvWriter(csvWtriter, writerSettings);
            writer.writeHeaders(Global.employee_down_column);
            writer.writeRowsAndClose(e);
            e1.flush();
            e1.close();
         } catch (Exception var10) {
            var10.printStackTrace();
         }
      } catch (Exception var11) {
         var11.printStackTrace();
      }

   }

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         HrStatus e = new HrStatus();
         e.setState(Integer.valueOf(1));
         Map hsMap = this.hrStatusService.find(e);
         List<?> result = this.employeeInfoService.findByCondition(employeeInfo, (Page)null);
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         if(result != null && result.size() > 0) {
            int csvWtriter = 0;
            Iterator writerSettings = result.iterator();

            while(writerSettings.hasNext()) {
               EmployeeInfo e1 = (EmployeeInfo)writerSettings.next();
               String[] writer = Util.getDeptAllNameById(e1.getDept_id(), Global.departmentInfoMap).split(">>");
               ++csvWtriter;
               byte k = 0;
               Object[] ob = new Object[Global.employee_column.length];
               int var21 = k + 1;
               ob[k] = String.valueOf(csvWtriter);
               ob[var21++] = StringUtils.defaultString(e1.getId().toString(), "");
               ob[var21++] = StringUtils.defaultString(e1.getEmp_code(), "");
               ob[var21++] = StringUtils.defaultString(e1.getZh_name(), "");
               ob[var21++] = StringUtils.defaultString(e1.getEn_name(), "");
               ob[var21++] = StringUtils.defaultString(writer.length <= 3?writer[writer.length - 1]:writer[writer.length - 3], "");
               ob[var21++] = StringUtils.defaultString(writer.length <= 3?writer[writer.length - 1]:writer[writer.length - 2], "");
               ob[var21++] = StringUtils.defaultString(writer[writer.length - 1], "");
               ob[var21++] = StringUtils.defaultString(e1.getPosition_name(), "");
               ob[var21++] = StringUtils.defaultString(((HrStatus)hsMap.get(e1.getHr_status_id())).getStatus_code());
               ob[var21++] = StringUtils.defaultString(e1.getEmp14(), "");
               ob[var21++] = "#" + StringUtils.defaultString(e1.getEmp15(), "") + "#";
               ob[var21++] = e1.getBirthday() == null?"":this.sdf.format(e1.getBirthday());
               ob[var21++] = StringUtils.defaultString(e1.getPhone(), "");
               ob[var21++] = "#" + StringUtils.defaultString(e1.getMobile(), "") + "#";
               ob[var21++] = StringUtils.defaultString(e1.getEducation(), "");
               ob[var21++] = StringUtils.defaultString(e1.getCollege(), "");
               ob[var21++] = StringUtils.defaultString(e1.getProfession(), "");
               ob[var21++] = e1.getGraduation_date() == null?"":this.sdf.format(e1.getGraduation_date());
               ob[var21++] = e1.getEmp06() == null?"":this.sdf.format(e1.getEmp06());
               ob[var21++] = e1.getEmp07() == null?"":this.sdf.format(e1.getEmp07());
               ob[var21++] = e1.getEmp08() == null?"":this.sdf.format(e1.getEmp08());
               ob[var21++] = e1.getTry_month() == null?"":e1.getTry_month().toString();
               ob[var21++] = StringUtils.defaultString(e1.getTry_state(), "");
               ob[var21++] = StringUtils.defaultString(Global.employee_state[e1.getState().intValue() - 1], "");
               ob[var21++] = StringUtils.defaultString(e1.getEmp01(), "");
               ob[var21++] = e1.getBegin_date() == null?"":this.sdf.format(e1.getBegin_date());
               ob[var21++] = e1.getEnd_date() == null?"":this.sdf.format(e1.getEnd_date());
               ob[var21++] = StringUtils.defaultString(e1.getType(), "");
               ob[var21++] = StringUtils.defaultString(e1.getEmp02(), "");
               ob[var21++] = e1.getEmp03() == null?"":this.sdf.format(e1.getEmp03());
               ob[var21++] = e1.getEmp04() == null?"":this.sdf.format(e1.getEmp04());
               ob[var21++] = StringUtils.defaultString(e1.getEmp05(), "");
               ob[var21++] = StringUtils.defaultString(e1.getLabor_type(), "");
               ob[var21++] = StringUtils.defaultString("#" + ((EmployeeCard)Global.employeeCardMap.get(e1.getId())).getCard() + "#", "");
               ob[var21++] = e1.getEmp23() == null?"":this.sdf.format(e1.getEmp23());
               ob[var21++] = StringUtils.defaultIfBlank(e1.getPims(), "");
               ob[var21++] = e1.getEmp16() == null?"":this.sdf.format(e1.getEmp16());
               ob[var21++] = StringUtils.defaultString(e1.getContract_type(), "");
               ob[var21++] = Integer.valueOf(IdCard.getAgeByIdCard(StringUtils.defaultString(e1.getEmp15(), "0")));
               ob[var21++] = StringUtils.defaultString(e1.getResidence(), "");
               ob[var21++] = StringUtils.defaultString(e1.getAddress(), "");
               ob[var21++] = StringUtils.defaultString(e1.getMarry_state(), "");
               ob[var21++] = StringUtils.defaultString(e1.getEmp12(), "");
               ob[var21++] = StringUtils.defaultString(e1.getEmp13(), "");
               objects.add(ob);
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         BufferedWriter var17 = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("员工信息.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var18 = response.getOutputStream();
            var17 = new BufferedWriter(new OutputStreamWriter(var18));
            CsvWriterSettings var20 = new CsvWriterSettings();
            CsvWriter var19 = new CsvWriter(var17, var20);
            var19.writeHeaders(Global.employee_column);
            var19.writeRowsAndClose(objects);
            var18.flush();
            var18.close();
         } catch (Exception var14) {
            var14.printStackTrace();
         }
      } catch (Exception var15) {
         var15.printStackTrace();
      }

   }

   @RequestMapping({"exportLeaveCsv.do"})
   public void exportLeaveCsv(EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         Calendar e = Calendar.getInstance();
         int nowYear = e.get(1);
         e.add(1, -1);
         int priYear = e.get(1);
         String annual_leave = Global.breaktime_type[2].split("\\|")[0];
         String company_leave = Global.breaktime_type[3].split("\\|")[0];
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         Iterator<?> e1 = Global.employeeInfoMap.keySet().iterator();

         Integer csvWtriter;
         while(e1.hasNext()) {
            csvWtriter = (Integer)e1.next();
            EmployeeInfo writerSettings = (EmployeeInfo)Global.employeeInfoMap.get(csvWtriter);
            double writer = this.employeeLeaveService.findTotalAnnualDays(csvWtriter.intValue(), nowYear) * 8.0D;
            double totalNowCompany = this.employeeLeaveService.findTotalCompanyDays(csvWtriter.intValue(), nowYear) * 8.0D;
            double breakNowAnnual = this.employeeLeaveService.findBreakHours(csvWtriter.intValue(), nowYear, annual_leave);
            double breakNowCompany = this.employeeLeaveService.findBreakHours(csvWtriter.intValue(), nowYear, company_leave);
            double totalPriAnnual = this.employeeLeaveService.findTotalAnnualDays(csvWtriter.intValue(), priYear) * 8.0D;
            double totalPriCompany = this.employeeLeaveService.findTotalCompanyDays(csvWtriter.intValue(), priYear) * 8.0D;
            double breakPriAnnual = this.employeeLeaveService.findBreakHours(csvWtriter.intValue(), priYear, annual_leave);
            double breakPriCompany = this.employeeLeaveService.findBreakHours(csvWtriter.intValue(), priYear, company_leave);
            byte k = 0;
            Object[] ob = new Object[Global.employee_leave_column.length];
            int var39 = k + 1;
            ob[k] = Util.alternateZero(writerSettings.getId().intValue());
            ob[var39++] = StringUtils.defaultString(writerSettings.getEmp_code(), "");
            ob[var39++] = StringUtils.defaultString(writerSettings.getZh_name(), "");
            ob[var39++] = writerSettings.getState().intValue() == 1?"在职":"非在职";
            ob[var39++] = Integer.valueOf(nowYear);
            ob[var39++] = Double.valueOf(writer - breakNowAnnual < 0.0D?0.0D:writer - breakNowAnnual);
            ob[var39++] = Double.valueOf(totalNowCompany - breakNowCompany < 0.0D?0.0D:totalNowCompany - breakNowCompany);
            objects.add(ob);
            k = 0;
            Object[] ob1 = new Object[Global.employee_leave_column.length];
            var39 = k + 1;
            ob1[k] = Util.alternateZero(writerSettings.getId().intValue());
            ob1[var39++] = StringUtils.defaultString(writerSettings.getEmp_code(), "");
            ob1[var39++] = StringUtils.defaultString(writerSettings.getZh_name(), "");
            ob1[var39++] = writerSettings.getState().intValue() == 1?"在职":"非在职";
            ob1[var39++] = Integer.valueOf(priYear);
            ob1[var39++] = Double.valueOf(totalPriAnnual - breakPriAnnual < 0.0D?0.0D:totalPriAnnual - breakPriAnnual);
            ob1[var39++] = Double.valueOf(totalPriCompany - breakPriCompany < 0.0D?0.0D:totalPriCompany - breakPriCompany);
            objects.add(ob1);
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("员工剩余年假.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var35 = response.getOutputStream();
            BufferedWriter var36 = new BufferedWriter(new OutputStreamWriter(var35));
            CsvWriterSettings var37 = new CsvWriterSettings();
            CsvWriter var38 = new CsvWriter(var36, var37);
            var38.writeHeaders(Global.employee_leave_column);
            var38.writeRowsAndClose(objects);
            var35.flush();
            var35.close();
         } catch (Exception var32) {
            var32.printStackTrace();
         }
      } catch (Exception var33) {
         var33.printStackTrace();
      }

   }

   @RequestMapping({"exportOverCsv.do"})
   public void exportOverCsv(EmployeeInfo employeeInfo, HttpServletRequest request, HttpServletResponse response) {
      try {
         boolean e = false;
         ArrayList<Object[]> objects = new ArrayList<Object[]>();
         Iterator<?> e1 = Global.employeeInfoMap.keySet().iterator();

         Integer csvWtriter;
         while(e1.hasNext()) {
            csvWtriter = (Integer)e1.next();
            EmployeeInfo writerSettings = (EmployeeInfo)Global.employeeInfoMap.get(csvWtriter);
            Map writer = this.overTimeInfoService.findStandardOverHour(writerSettings.getId().intValue());
            if(writer != null && writer.size() > 0) {
               Iterator var11 = writer.keySet().iterator();

               while(var11.hasNext()) {
                  Integer year = (Integer)var11.next();
                  Map el = (Map)writer.get(year);
                  byte k = 0;
                  Object[] ob = new Object[Global.employee_over_column.length];
                  int var22 = k + 1;
                  ob[k] = Util.alternateZero(writerSettings.getId().intValue());
                  ob[var22++] = StringUtils.defaultString(writerSettings.getEmp_code(), "");
                  ob[var22++] = StringUtils.defaultString(writerSettings.getZh_name(), "");
                  ob[var22++] = writerSettings.getState().intValue() == 1?"在职":"非在职";
                  ob[var22++] = year;
                  ob[var22++] = el.get("surplus_over_hour").toString();
                  objects.add(ob);
               }
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("员工剩余加班.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var19 = response.getOutputStream();
            BufferedWriter var18 = new BufferedWriter(new OutputStreamWriter(var19));
            CsvWriterSettings var20 = new CsvWriterSettings();
            CsvWriter var21 = new CsvWriter(var18, var20);
            var21.writeHeaders(Global.employee_over_column);
            var21.writeRowsAndClose(objects);
            var19.flush();
            var19.close();
         } catch (Exception var15) {
            var15.printStackTrace();
         }
      } catch (Exception var16) {
         var16.printStackTrace();
      }

   }

   @RequestMapping({"exportHistoryChangeCsv.do"})
   public void exportHistoryChangeCsv(int emp_id, String history_type, HttpServletRequest request, HttpServletResponse response) {
      String[] history_col = new String[]{"姓名", "类型", "变更前", "变更后", "有效日期"};

      try {
         List<?> e = this.employeeInfoService.findHistoryChangeByEmpId(emp_id, history_type);
         boolean i = false;
         ArrayList<Object[]> objects = new ArrayList();
         Iterator e1 = e.iterator();

         EmployeeInfoHistory csvWtriter;
         while(e1.hasNext()) {
            csvWtriter = (EmployeeInfoHistory)e1.next();
            byte writerSettings = 0;
            Object[] writer = new Object[history_col.length];
            int var17 = writerSettings + 1;
            writer[writerSettings] = ((EmployeeInfo)Global.employeeInfoMap.get(csvWtriter.getEmp_id())).getZh_name();
            writer[var17++] = StringUtils.defaultString(csvWtriter.getHistory_type(), "");
            writer[var17++] = StringUtils.defaultString(csvWtriter.getBefore_change(), "");
            writer[var17++] = StringUtils.defaultString(csvWtriter.getAfter_change(), "");
            writer[var17++] = this.sdf.format(csvWtriter.getCreate_date());
            objects.add(writer);
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("变更记录.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var18 = response.getOutputStream();
            BufferedWriter var16 = new BufferedWriter(new OutputStreamWriter(var18));
            CsvWriterSettings var20 = new CsvWriterSettings();
            CsvWriter var19 = new CsvWriter(var16, var20);
            var19.writeHeaders(history_col);
            var19.writeRowsAndClose(objects);
            var18.flush();
            var18.close();
         } catch (Exception var13) {
            var13.printStackTrace();
         }
      } catch (Exception var14) {
         var14.printStackTrace();
      }

   }

   private StringBuffer validateData(ExcelUtil parser, List empList) throws Exception {
      if(empList == null) {
         new ArrayList();
      }

      StringBuffer message = new StringBuffer("");
      List datas = parser.getDatasInSheet(0);
      if(datas != null && datas.size() > 0) {
         int count = Global.employee_down_column.length;
         int rows = datas.size();

         int row;
         List list;
         int k;
         for(row = 0; row < rows && message.toString().trim().equals(""); ++row) {
            list = (List)datas.get(row);
            if(list.size() != count) {
               message.append("第" + (row + 1) + "行格式不对或有空值！");
               break;
            }

            Object id;
            if(row == 0) {
               for(k = 0; k < count; ++k) {
                  id = list.get(k);
                  if(!Util.convertToString(id).equals(Global.employee_down_column[k])) {
                     message.append("第" + (row + 1) + "行文本内容格式不对！");
                     break;
                  }
               }
            } else {
               for(k = 0; k < count; ++k) {
                  id = list.get(k);
                  if(!Global.employee_down_column[k].equals("薪资月份") && (id == null || Util.convertToString(id).equals(""))) {
                     message.append(Global.employee_down_column[k] + "不能为空！");
                     break;
                  }
               }
            }
         }

         if(message.toString().trim().equals("")) {
            for(row = 1; row < rows; ++row) {
               list = (List)datas.get(row);
               byte var47 = 0;
               String var48 = list.get(var47).toString().trim();
               k = var47 + 1;
               String emp_code = list.get(k).toString().trim();
               ++k;
               String zh_name = list.get(k).toString().trim();
               ++k;
               String en_name = list.get(k).toString().trim();
               ++k;
               String type = list.get(k).toString().trim();
               ++k;
               String dept_code = list.get(k).toString().trim();
               ++k;
               String position_code = list.get(k).toString().trim();
               ++k;
               String project_code = list.get(k).toString().trim();
               ++k;
               String gap_code = list.get(k).toString().trim();
               ++k;
               String hrstatus_code = list.get(k).toString().trim();
               ++k;
               Date birthday = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               String emp14 = list.get(k).toString().trim();
               ++k;
               String emp15 = list.get(k).toString().trim();
               ++k;
               String phone = list.get(k).toString().trim();
               ++k;
               String mobile = list.get(k).toString().trim();
               ++k;
               String education = list.get(k).toString().trim();
               ++k;
               String college = list.get(k).toString().trim();
               ++k;
               String profession = list.get(k).toString().trim();
               ++k;
               Date graduation_date = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               Integer try_month = Integer.valueOf(Integer.parseInt(list.get(k).toString().replace(".0", "")));
               ++k;
               String try_state = list.get(k).toString().trim();
               ++k;
               String emp09 = list.get(k).toString().trim().replace("无", "");
               ++k;
               String is_login_str = list.get(k).toString().trim();
               ++k;
               Date begin_date = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               Date end_date = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               Date emp06 = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               Date emp07 = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               Date emp08 = this.sdf.parse(list.get(k).toString().trim());
               ++k;
               String emp01 = list.get(k).toString().trim();
               ++k;
               Date emp04 = StringUtils.isEmpty((String)list.get(k))?null:this.sdf.parse(list.get(k).toString().trim());
               ++k;
               String icCard = list.get(k).toString().trim();
               ++k;
               String labor_type = list.get(k).toString().trim();
               ++k;
               String contractType = list.get(k).toString().trim();
               ++k;
               String residence = list.get(k).toString().trim();
               ++k;
               String address = list.get(k).toString().trim();
               ++k;
               String marryState = list.get(k).toString().trim();
               ++k;
               var48 = var48.indexOf(".") > -1?var48.substring(0, var48.indexOf(".")):var48;
               emp_code = (new BigDecimal(emp_code)).toPlainString();
               emp_code = emp_code.indexOf(".") > -1?emp_code.substring(0, emp_code.indexOf(".")):emp_code;
               emp_code = emp_code.equals("0")?var48:emp_code;
               icCard = (new BigDecimal(icCard)).toPlainString();
               icCard = icCard.indexOf(".") > -1?icCard.substring(0, icCard.indexOf(".")):icCard;
               if(Global.employeeInfoMap.get(var48) != null) {
                  message.append(Global.employee_down_column[0] + "‘" + var48 + "’" + "已经存在！");
                  break;
               }

               if(Global.employeeCodeMap.get(emp_code.trim()) != null) {
                  message.append(Global.employee_down_column[1] + "‘" + emp_code + "’" + "已经存在！");
                  break;
               }

               if(Global.employeeZhNameSet.contains(zh_name.trim())) {
                  message.append(Global.employee_down_column[2] + "‘" + zh_name + "’" + "已经存在！");
                  break;
               }

               if(!Util.contains(Global.employee_type, type)) {
                  message.append(Global.employee_down_column[4] + "‘" + type + "’" + "内容不正确！");
                  break;
               }

               if(Global.departmentCodeMap.get(dept_code.trim()) == null) {
                  message.append(Global.employee_down_column[5] + "‘" + dept_code + "’" + "没有找到！");
                  break;
               }

               if(Global.positionCodeMap.get(position_code.trim()) == null) {
                  message.append(Global.employee_down_column[6] + "‘" + position_code + "’" + "没有找到！");
                  break;
               }

               if(Global.hrStatusCodeMap.get(hrstatus_code.trim()) == null) {
                  message.append(Global.employee_down_column[9] + "‘" + hrstatus_code + "’" + "没有找到！");
                  break;
               }

               if(!Util.contains(Global.sex, emp14)) {
                  message.append(Global.employee_down_column[11] + "‘" + emp14 + "’" + "内容不正确！");
                  break;
               }

               if(!Util.contains(Global.education, education)) {
                  message.append(Global.employee_down_column[15] + "‘" + education + "’" + "内容不正确！");
                  break;
               }

               if(!Util.contains(Global.try_state, try_state)) {
                  message.append(Global.employee_down_column[20] + "‘" + try_state + "’" + "内容不正确！");
                  break;
               }

               if(!StringUtils.isEmpty(emp09) && Global.employeeCarMap.get(emp09) != null) {
                  message.append(Global.employee_down_column[21] + "‘" + emp09 + "’" + "已经存在！");
                  break;
               }

               if(!Util.contains(Global.is_login, is_login_str)) {
                  message.append(Global.employee_down_column[22] + "‘" + is_login_str + "’" + "内容不正确！");
                  break;
               }

               if(begin_date.getTime() > end_date.getTime()) {
                  message.append(Global.employee_down_column[23] + "必须小于等于" + Global.employee_down_column[24] + "！");
                  break;
               }

               if(emp06.getTime() > emp07.getTime() || emp07.getTime() > emp08.getTime()) {
                  message.append(Global.employee_down_column[25] + "必须小于等于" + Global.employee_down_column[26] + "必须小于等于" + Global.employee_down_column[27] + "！");
                  break;
               }

               if(Global.icCardMap.get(icCard) != null) {
                  message.append(Global.employee_down_column[30] + "‘" + icCard + "’" + "已经存在！");
                  break;
               }

               if(!Util.contains(Global.marry_state, marryState)) {
                  message.append(Global.employee_down_column[35] + "‘" + marryState + "’" + "内容不正确！");
                  break;
               }

               if(message.toString().trim().equals("")) {
                  EmployeeInfo ei = new EmployeeInfo();
                  ei.setId(Integer.valueOf(Integer.parseInt(var48.indexOf(".") > -1?var48.substring(0, var48.indexOf(".")):var48)));
                  ei.setEmp10(Integer.valueOf(Integer.parseInt(var48.indexOf(".") > -1?var48.substring(0, var48.indexOf(".")):var48)));
                  ei.setEmp_code(emp_code);
                  ei.setZh_name(zh_name);
                  ei.setEn_name(en_name);
                  ei.setType(type);
                  ei.setDept_id(((DepartmentInfo)Global.departmentCodeMap.get(dept_code)).getId());
                  ei.setPosition_id(((PositionInfo)Global.positionCodeMap.get(position_code)).getId());
                  ei.setProject_id(Integer.valueOf(0));
                  ei.setGap_id(Integer.valueOf(0));
                  ei.setHr_status_id((Integer)Global.hrStatusCodeMap.get(hrstatus_code));
                  ei.setBirthday(birthday);
                  ei.setEmp14(emp14);
                  ei.setEmp15(emp15);
                  ei.setPhone(phone);
                  ei.setMobile(mobile);
                  ei.setEducation(education);
                  ei.setCollege(college);
                  ei.setProfession(profession);
                  ei.setGraduation_date(graduation_date);
                  ei.setTry_month(try_month);
                  ei.setTry_state(try_state);
                  ei.setEmp09(emp09);
                  ei.setIs_login(Integer.valueOf(is_login_str.equals(Global.is_login[0])?1:0));
                  ei.setBegin_date(begin_date);
                  ei.setEnd_date(end_date);
                  ei.setEmp06(emp06);
                  ei.setEmp07(emp07);
                  ei.setEmp08(emp08);
                  ei.setEmp01(emp01);
                  ei.setEmp04(emp04);
                  ei.setCard(icCard);
                  ei.setLabor_type(labor_type);
                  ei.setState(Integer.valueOf(1));
                  ei.setContract_type(contractType);
                  ei.setResidence(residence);
                  ei.setAddress(address);
                  ei.setMarry_state(marryState);
                  this.employeeInfoService.save(ei, ei.getCard());
                  ei.setCard(ei.getCard());
                  ei.setDept_name(((DepartmentInfo)Global.departmentInfoMap.get(ei.getDept_id())).getDept_name());
                  this.commonService.updateTimeSheet(ei, 1, (String)null);
               }
            }
         }
      } else {
         message.append("没有数据！");
      }

      return message;
   }

   public EmployeeInfoService getEmployeeInfoService() {
      return this.employeeInfoService;
   }

   public void setEmployeeInfoService(EmployeeInfoService employeeInfoService) {
      this.employeeInfoService = employeeInfoService;
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
