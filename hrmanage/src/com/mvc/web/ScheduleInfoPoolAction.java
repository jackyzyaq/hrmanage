package com.mvc.web;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.ScheduleInfoPool;
import com.yq.faurecia.service.ClassInfoService;
import com.yq.faurecia.service.ScheduleInfoPoolService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
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
@RequestMapping({"/common/scheduleInfoPool/*"})
public class ScheduleInfoPoolAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ScheduleInfoPoolAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private ScheduleInfoPoolService scheduleInfoPoolService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private ClassInfoService classInfoService;


   @InitBinder
   protected void initBinder(WebDataBinder binder) {
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
   }

   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ScheduleInfoPool scheduleInfoPool, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         if(!StringUtils.isEmpty(scheduleInfoPool.getTmp_date())) {
            scheduleInfoPool.setTmp_date("\'" + scheduleInfoPool.getTmp_date() + "\'");
         }

         int e = this.scheduleInfoPoolService.findPoolCountByCondition(scheduleInfoPool);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(scheduleInfoPool.getDept_ids())) {
            scheduleInfoPool.setDept_ids(deptIdsRole);
         }

         List result = this.scheduleInfoPoolService.findPoolByCondition(scheduleInfoPool, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            ScheduleInfoPool json = (ScheduleInfoPool)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
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
   public void queryWOResult(Page page, ScheduleInfoPool scheduleInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"count");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         int e = this.scheduleInfoPoolService.findWOCountByCondition(scheduleInfo);
         page.setTotalCount(e);
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         String deptIdsRole = (String)request.getSession().getAttribute("deptIdsRole");
         if(StringUtils.isEmpty(scheduleInfo.getDept_ids())) {
            scheduleInfo.setDept_ids(deptIdsRole);
         }

         List result = this.scheduleInfoPoolService.findWOByCondition(scheduleInfo, page);
         sb.append("\'rows\':[");
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            ScheduleInfoPool json = (ScheduleInfoPool)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            sb.append("\'dept_names\':").append("\'" + this.scheduleInfoPoolService.getDeptNameByWO(json.getWo_number()) + "\',");
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

   @RequestMapping({"schedulePoolAdd.do"})
   public void schedulePoolAdd(ScheduleInfoPool scheduleInfoPool, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         Calendar c = Calendar.getInstance();
         c.set(11, 7);
         c.set(12, 0);
         c.set(13, 0);
         if(scheduleInfoPool.getType().trim().equals(Global.schedule_type[0])) {
            ClassInfo classInfo = this.classInfoService.queryById(scheduleInfoPool.getClass_id().intValue());
            scheduleInfoPool.setClass_name(classInfo.getClass_name());
            scheduleInfoPool.setBegin_time(classInfo.getBegin_time());
            scheduleInfoPool.setEnd_time(classInfo.getEnd_time());
            scheduleInfoPool.setHours(classInfo.getHours());
            scheduleInfoPool.setMeals(classInfo.getMeals());
            scheduleInfoPool.setHave_meals(classInfo.getHave_meals());
            scheduleInfoPool.setOver_hour(classInfo.getOver_hour());
         }

         e = this.validate(scheduleInfoPool);
         if(e.trim().equals("")) {
            this.scheduleInfoPoolService.savePool(scheduleInfoPool);
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

   @RequestMapping({"schedulePoolEdit.do"})
   public void schedulePoolEdit(ScheduleInfoPool scheduleInfoPool, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         ScheduleInfoPool oti = this.scheduleInfoPoolService.queryPoolById(scheduleInfoPool.getId().intValue());
         if(oti.getAvailable().intValue() == 0) {
            e = "此记录已经无效，不能操作";
         } else {
            if(scheduleInfoPool.getType().trim().equals(Global.schedule_type[0])) {
               ClassInfo classInfo = this.classInfoService.queryById(scheduleInfoPool.getClass_id().intValue());
               scheduleInfoPool.setClass_name(classInfo.getClass_name());
               scheduleInfoPool.setBegin_time(classInfo.getBegin_time());
               scheduleInfoPool.setEnd_time(classInfo.getEnd_time());
               scheduleInfoPool.setHours(classInfo.getHours());
               scheduleInfoPool.setMeals(classInfo.getMeals());
               scheduleInfoPool.setHave_meals(classInfo.getHave_meals());
               scheduleInfoPool.setOver_hour(classInfo.getOver_hour());
            }

            e = this.validate(scheduleInfoPool);
         }

         if(e.trim().equals("")) {
            ReflectPOJO.alternateObject(scheduleInfoPool, oti);
            this.scheduleInfoPoolService.updatePool(scheduleInfoPool);
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

   @RequestMapping({"schedulePoolInvalid.do"})
   public void schedulePoolInvalid(ScheduleInfoPool scheduleInfoPool, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         ScheduleInfoPool oti = this.scheduleInfoPoolService.queryPoolById(scheduleInfoPool.getId().intValue());
         if(oti.getAvailable().intValue() == 0) {
            e = "此记录已经无效，不能操作";
         } else {
            scheduleInfoPool.setAvailable(Integer.valueOf(0));
            ReflectPOJO.alternateObject(scheduleInfoPool, oti);
            this.scheduleInfoPoolService.updatePool(scheduleInfoPool);
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

   private String validate(ScheduleInfoPool sip) throws Exception {
      String msg = "";
      if(msg.trim().equals("") && sip.getEmp_id() == null) {
         msg = "请选择员工！";
      }

      if(msg.trim().equals("")) {
         int count = 0;

         try {
            ScheduleInfoPool e;
            if(sip.getId() != null && sip.getId().intValue() > 0) {
               e = this.scheduleInfoPoolService.queryPoolById(sip.getId().intValue());
               if(e.getBegin_date().getTime() != sip.getBegin_date().getTime() || e.getEnd_date().getTime() != sip.getEnd_date().getTime()) {
                  ScheduleInfoPool tmpSI = new ScheduleInfoPool();
                  tmpSI.setAvailable(Integer.valueOf(1));
                  tmpSI.setEmp_id(sip.getEmp_id());
                  tmpSI.setTmp_date("\'" + this.sdf.format(sip.getBegin_date()) + "\'");
                  count = this.scheduleInfoPoolService.findPoolCountByCondition(tmpSI);
               }
            } else {
               e = new ScheduleInfoPool();
               e.setAvailable(Integer.valueOf(1));
               e.setEmp_id(sip.getEmp_id());
               e.setTmp_date("\'" + this.sdf.format(sip.getBegin_date()) + "\'");
               count = this.scheduleInfoPoolService.findPoolCountByCondition(e);
            }
         } catch (Exception var6) {
            var6.printStackTrace();
         }

         if(count > 0) {
            msg = "员工“" + sip.getEmp_name() + "”的排班日期不能重复提交！";
         }
      }

      return msg;
   }

   public ScheduleInfoPoolService getScheduleInfoPoolService() {
      return this.scheduleInfoPoolService;
   }

   public void setScheduleInfoPoolService(ScheduleInfoPoolService scheduleInfoPoolService) {
      this.scheduleInfoPoolService = scheduleInfoPoolService;
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
