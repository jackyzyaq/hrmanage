package com.mvc.web;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.service.ClassInfoService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/classInfo/*"})
public class ClassInfoAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ClassInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private ClassInfoService classInfoService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ClassInfo classInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.classInfoService.findByCondition(classInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.classInfoService.findByCondition(classInfo, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            ClassInfo json = (ClassInfo)var9.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var12 = attrList.iterator();

            while(var12.hasNext()) {
               String attr = (String)var12.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)) + "\",");
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

   @RequestMapping({"classInfoAdd.do"})
   public void classInfoAdd(ClassInfo classInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.classInfoService.checkClassCode(classInfo.getClass_code().trim())) {
            e = classInfo.getClass_code() + "班次代码已存在！";
         } else {
            classInfo.setClass_name(classInfo.getClass_name() + (classInfo.getHours().doubleValue() + classInfo.getOver_hour().doubleValue()));
            this.classInfoService.save(classInfo);
            e = "操作成功！";
         }

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

   @RequestMapping({"classInfoEdit.do"})
   public void classInfoEdit(ClassInfo classInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         ClassInfo result = this.classInfoService.queryById(classInfo.getId().intValue(), (Integer)null);
         if(result.getClass_code().trim().equals(Global.class_code_default[0])) {
            e = classInfo.getClass_code() + "班次代码默认，不能修改！";
         } else if(!result.getClass_code().trim().equals(classInfo.getClass_code().trim()) && this.classInfoService.checkClassCode(classInfo.getClass_code().trim())) {
            e = classInfo.getClass_code() + "班次代码已存在！";
         }

         if(e.trim().equals("")) {
            classInfo.setClass_name(classInfo.getClass_name() + (classInfo.getHours().doubleValue() + classInfo.getOver_hour().doubleValue()));
            this.classInfoService.update(classInfo);
            e = "操作成功！";
         }

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
   public void autoComplete(String class_name, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         class_name = (String)StringUtils.defaultIfEmpty(class_name, "");
         HashMap e = new HashMap();
         e.put("class_name", class_name);
         List list = this.classInfoService.autoComplete(e);
         sb.append("[");
         if(list != null && list.size() > 0) {
            Iterator var8 = list.iterator();

            while(var8.hasNext()) {
               ClassInfo ci = (ClassInfo)var8.next();
               sb.append("{");
               sb.append((new StringBuilder("\"value\":")).append("\"" + Util.replaceD(ci.getClass_name()) + "\""));
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

   public ClassInfoService getClassInfoService() {
      return this.classInfoService;
   }

   public void setClassInfoService(ClassInfoService classInfoService) {
      this.classInfoService = classInfoService;
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
