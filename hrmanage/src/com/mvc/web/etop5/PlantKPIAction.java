package com.mvc.web.etop5;

import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.PlantKPI;
import com.yq.company.etop5.service.PlantKPIService;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/plantKPI/*"})
public class PlantKPIAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(PlantKPIAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
   @Resource
   private UserInfoService userService;
   @Resource
   private PlantKPIService plantKPIService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, PlantKPI plantKPI, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"kpi_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.plantKPIService.findByCondition(plantKPI, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.plantKPIService.findByCondition(plantKPI, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            PlantKPI json = (PlantKPI)var9.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var12 = attrList.iterator();

            while(var12.hasNext()) {
               String attr = (String)var12.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace(" 00:00:00", "") + "\",");
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

   @RequestMapping({"plantKPIAdd.do"})
   public void plantKPIAdd(PlantKPI plantKPI, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         plantKPI.setOperater(Util.getOperator(user));
         if(plantKPI.getIs_auto_cum().intValue() == 1) {
            Calendar actual = Calendar.getInstance();
            actual.setTime(plantKPI.getKpi_date());
            if(actual.get(5) == 1) {
               plantKPI.setCum(plantKPI.getActual());
            } else {
               actual.add(5, -1);
               PlantKPI pkTmp = this.plantKPIService.queryByType(actual.getTime(), plantKPI.getKpi_type(), plantKPI.getDept_name(), plantKPI.getExt_1(), plantKPI.getExt_2());
               plantKPI.setCum(Double.valueOf((pkTmp != null && pkTmp.getCum() != null?pkTmp.getCum().doubleValue():0.0D) + plantKPI.getActual().doubleValue()));
            }
         } else {
            plantKPI.getIs_auto_cum().intValue();
         }

         double actual1 = plantKPI.getActual().doubleValue();
         double cum = plantKPI.getCum().doubleValue();
         if(plantKPI.getExt_3().equals("正向")) {
            if((plantKPI.getTarget_flag().intValue() == 1?cum:actual1) >= plantKPI.getTarget().doubleValue()) {
               plantKPI.setHealth_png(request.getContextPath() + "/images/" + Global.plant_kpi_health[0] + ".png");
            } else {
               plantKPI.setHealth_png(request.getContextPath() + "/images/" + Global.plant_kpi_health[1] + ".png");
            }
         } else if(plantKPI.getExt_3().equals("反向")) {
            if((plantKPI.getTarget_flag().intValue() == 1?cum:actual1) <= plantKPI.getTarget().doubleValue()) {
               plantKPI.setHealth_png(request.getContextPath() + "/images/" + Global.plant_kpi_health[0] + ".png");
            } else {
               plantKPI.setHealth_png(request.getContextPath() + "/images/" + Global.plant_kpi_health[1] + ".png");
            }
         }

         this.plantKPIService.save(plantKPI);
         e = "操作成功！";
         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var20) {
         var20.printStackTrace();
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
         } catch (IOException var19) {
            var19.printStackTrace();
         }

      }

   }

   @RequestMapping({"plantKPITargetAdd.do"})
   public void plantKPITargetAdd(String kpi_month, PlantKPI plantKPI, String target_start, String target_end, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         double target = 0.0D;
         boolean target_flag = false;
         boolean maxDay = false;
         if(!StringUtils.isEmpty(kpi_month) && !StringUtils.isEmpty(target_start) && !StringUtils.isEmpty(target_end) && Util.isNumeric(target_start) && Util.isNumeric(target_end)) {
            int var27 = Util.getMaxDay(Integer.parseInt(kpi_month.split("-")[0]), Integer.parseInt(kpi_month.split("-")[1]));
            UserInfo user = Global.getUserObject(request);

            for(int i = 1; i <= var27; ++i) {
               byte var26;
               if(target_start.equals(target_end)) {
                  target = Double.parseDouble(target_start);
                  var26 = 0;
                  plantKPI.setTarget(Double.valueOf(target));
               } else {
                  if(i == 1) {
                     target = Double.parseDouble(target_start);
                  } else if(i == var27) {
                     target = Double.parseDouble(target_end);
                  } else {
                     target += Util.formatDouble1(Math.abs(Double.parseDouble(target_end) - Double.parseDouble(target_start)) / (double)var27);
                  }

                  var26 = 1;
                  if(!StringUtils.isEmpty(plantKPI.getExt_9()) && plantKPI.getExt_9().equals("1")) {
                     if(Math.ceil(target) > Double.parseDouble(target_end)) {
                        plantKPI.setTarget(Double.valueOf(Double.parseDouble(target_end)));
                     } else {
                        plantKPI.setTarget(Double.valueOf(Math.ceil(target)));
                     }
                  } else {
                     plantKPI.setTarget(Double.valueOf(target));
                  }
               }

               plantKPI.setKpi_date(this.sdf.parse(kpi_month + "-" + i));
               plantKPI.setTarget_flag(Integer.valueOf(var26));
               plantKPI.setActual(Double.valueOf(0.0D));
               plantKPI.setCum(Double.valueOf(0.0D));
               plantKPI.setTitle("-");
               plantKPI.setHealth_png("-");
               plantKPI.setRemark("");
               plantKPI.setOperater(Util.getOperator(user));
               this.plantKPIService.save(plantKPI);
            }

            e = "操作成功！";
         } else {
            e = "有空值或格式不对";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var24) {
         var24.printStackTrace();
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
         } catch (IOException var23) {
            var23.printStackTrace();
         }

      }

   }

   public static void main(String[] args) {
      System.out.println(Math.ceil(0.111D));
   }

   @RequestMapping({"validKPITarget.do"})
   public void validKPITarget(String kpi_month, String kpi_type, String dept_name, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.plantKPIService.queryByType(this.sdf.parse(kpi_month + "-01"), kpi_type, dept_name) != null) {
            e = kpi_month + "-01" + "|" + kpi_type + "|" + dept_name + "，已在存在！";
         } else {
            e = "";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var17) {
         var17.printStackTrace();
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
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"plantKPIEdit.do"})
   public void plantKPIEdit(PlantKPI plantKPI, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         plantKPI.setOperater(Util.getOperator(user));
         this.plantKPIService.update(plantKPI);
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

   @RequestMapping({"autoComplete.do"})
   public void autoComplete(String kpi_type, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         kpi_type = (String)StringUtils.defaultIfEmpty(kpi_type, "");
         HashMap e = new HashMap();
         e.put("kpi_type", kpi_type);
         List list = this.plantKPIService.autoComplete(e);
         sb.append("[");
         if(list != null && !list.isEmpty()) {
            Iterator var8 = list.iterator();

            while(var8.hasNext()) {
               PlantKPI ci = (PlantKPI)var8.next();
               sb.append("{");
               sb.append((new StringBuilder("\"value\":")).append("\"" + ci.getKpi_type() + "\""));
               sb.append("},");
            }

            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]");
      } catch (Exception var17) {
         var17.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(sb.toString());
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"autoCompleteDept.do"})
   public void autoCompleteDept(String dept_name, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         dept_name = (String)StringUtils.defaultIfEmpty(dept_name, "");
         HashMap e = new HashMap();
         e.put("dept_name", dept_name);
         List list = this.plantKPIService.autoComplete(e);
         sb.append("[");
         if(list != null && !list.isEmpty()) {
            Iterator var8 = list.iterator();

            while(var8.hasNext()) {
               PlantKPI ci = (PlantKPI)var8.next();
               sb.append("{");
               sb.append((new StringBuilder("\"value\":")).append("\"" + ci.getDept_name() + "\""));
               sb.append("},");
            }

            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]");
      } catch (Exception var17) {
         var17.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(sb.toString());
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"exportCsv.do"})
   public void exportCsv(PlantKPI plantKPI, HttpServletRequest request, HttpServletResponse response) {
      try {
         List e = this.plantKPIService.findByCondition(plantKPI, (Page)null);
         ArrayList<Object[]> objects = new ArrayList();
         PlantKPI csvWtriter;
         Object[] writer;
         if(e != null && e.size() > 0) {
            for(Iterator e1 = e.iterator(); e1.hasNext(); objects.add(writer)) {
               csvWtriter = (PlantKPI)e1.next();
               byte writerSettings = 0;
               writer = new Object[Global.plant_kpi_column.length + 2];
               int var19 = writerSettings + 1;
               writer[writerSettings] = StringUtils.defaultString(csvWtriter.getDept_name(), "");
               writer[var19++] = csvWtriter.getKpi_date() == null?"":this.sdf.format(csvWtriter.getKpi_date());
               writer[var19++] = StringUtils.defaultString(csvWtriter.getKpi_type(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_1(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_2(), "");
               writer[var19++] = csvWtriter.getTarget() == null?"":csvWtriter.getTarget().toString();
               writer[var19++] = csvWtriter.getActual() == null?"":csvWtriter.getActual().toString();
               writer[var19++] = csvWtriter.getCum() == null?"":csvWtriter.getCum().toString();
               writer[var19++] = Util.convertToString(csvWtriter.getExt_8());
               writer[var19++] = Util.convertToString(csvWtriter.getExt_3());
               writer[var19++] = Util.convertToString(csvWtriter.getHealth_png()).indexOf(Global.plant_kpi_health[0]) > -1?"OK":(Util.convertToString(csvWtriter.getHealth_png()).indexOf(Global.plant_kpi_health[1]) > -1?"NOK":"");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_4(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_5(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_6(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_7(), "");
               writer[var19++] = StringUtils.defaultString(csvWtriter.getOperater(), "");
               if(StringUtils.isEmpty(csvWtriter.getExt_10())) {
                  writer[var19++] = StringUtils.defaultString(csvWtriter.getExt_10(), "");
               } else {
                  String[] var13;
                  int var12 = (var13 = csvWtriter.getExt_10().split(">>")).length;

                  for(int var11 = 0; var11 < var12; ++var11) {
                     String s = var13[var11];
                     writer[var19++] = StringUtils.defaultString(s, "");
                  }
               }
            }
         }

         response.reset();
         response.setHeader("Set-Cookie", "fileDownload=true; path=/");
         response.setContentType("application/csv;charset=UTF-8");
         csvWtriter = null;

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("KPI.csv".getBytes("utf-8"), "ISO8859_1") + "\"");
            ServletOutputStream var18 = response.getOutputStream();
            BufferedWriter var17 = new BufferedWriter(new OutputStreamWriter(var18));
            CsvWriterSettings var21 = new CsvWriterSettings();
            CsvWriter var20 = new CsvWriter(var17, var21);
            var20.writeHeaders(Global.plant_kpi_column);
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

   public PlantKPIService getPlantKPIService() {
      return this.plantKPIService;
   }

   public void setPlantKPIService(PlantKPIService plantKPIService) {
      this.plantKPIService = plantKPIService;
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
}
