package com.mvc.web;

import com.util.MD5;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.MenuInfoService;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/authority/userInfo/*"})
public class UserInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(UserInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private MenuInfoService menuInfoService;
   @Resource
   private UserInfoService userInfoService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.userInfoService.findByCondition(userInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.userInfoService.findByCondition(userInfo, page);
         sb.append("\'rows\':[");
         boolean i = false;
         Iterator var10 = result.iterator();

         while(var10.hasNext()) {
            UserInfo json = (UserInfo)var10.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var13 = attrList.iterator();

            while(var13.hasNext()) {
               String attr = (String)var13.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)) + "\",");
            }

            if(attrList.size() > 0) {
               sb.deleteCharAt(sb.length() - 1);
            }

            attrList = null;
            sb.append("},");
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

   @RequestMapping({"userAdd.do"})
   public void userAdd(UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.userInfoService.checkUserName(userInfo.getName().trim())) {
            e = userInfo.getName() + "用户名已存在！";
         } else {
            userInfo.setPwd(MD5.encrypt(userInfo.getPwd()));
            this.userInfoService.save(userInfo, userInfo.getRole_ids().split(","));
            e = "操作成功！";
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
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

   @RequestMapping({"userEdit.do"})
   public void userEdit(UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo result = this.userInfoService.queryById(userInfo.getId().intValue(), (Integer)null);
         if(!result.getName().trim().equals(userInfo.getName().trim()) && this.userInfoService.checkUserName(userInfo.getName().trim())) {
            e = userInfo.getName() + "用户名已存在！";
         }

         if(e.trim().equals("")) {
            userInfo = (UserInfo)ReflectPOJO.alternateObject(userInfo, result);
            String[] role_ids = userInfo.getRole_ids() == null?null:userInfo.getRole_ids().split(",");
            this.userInfoService.update(userInfo, role_ids);
            e = "操作成功！";
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

   @RequestMapping({"userPwdEdid.do"})
   public void userPwdEdid(UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         userInfo.setPwd(MD5.encrypt(userInfo.getPwd()));
         UserInfo result = this.userInfoService.queryById(userInfo.getId().intValue(), (Integer)null);
         userInfo = (UserInfo)ReflectPOJO.alternateObject(userInfo, result);
         this.userInfoService.update(userInfo, (String[])null);
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

   @RequestMapping({"userPhotoEdid.do"})
   public void userPhotoEdid(UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();
      String msg = "";
      String upload_uuid = "0";

      try {
         if(StringUtils.isEmpty(userInfo.getUpload_uuid())) {
            msg = "更新头象失败！";
         } else {
            UserInfo e = this.userInfoService.queryById(userInfo.getId().intValue(), (Integer)null);
            userInfo = (UserInfo)ReflectPOJO.alternateObject(userInfo, e);
            this.userInfoService.update(userInfo, (String[])null);
            msg = "操作成功！";
            upload_uuid = userInfo.getUpload_uuid();
         }

         sb.append("{");
         sb.append("\'msg\':\'" + msg + "\',");
         sb.append("\'upload_uuid\':\'" + upload_uuid + "\'");
         sb.append("}");
      } catch (Exception var17) {
         var17.printStackTrace();
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
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"userRoleEdid.do"})
   public void userRoleEdid(UserInfo userInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo result = this.userInfoService.queryById(userInfo.getId().intValue(), (Integer)null);
         userInfo = (UserInfo)ReflectPOJO.alternateObject(userInfo, result);
         String[] role_ids = userInfo.getRole_ids() == null?null:userInfo.getRole_ids().split(",");
         this.userInfoService.update(userInfo, role_ids);
         e = "操作成功！";
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

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }

   public UserInfoService getUserInfoService() {
      return this.userInfoService;
   }

   public void setUserInfoService(UserInfoService userInfoService) {
      this.userInfoService = userInfoService;
   }

   public MenuInfoService getMenuInfoService() {
      return this.menuInfoService;
   }

   public void setMenuInfoService(MenuInfoService menuInfoService) {
      this.menuInfoService = menuInfoService;
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

   public RoleInfoService getRoleInfoService() {
      return this.roleInfoService;
   }

   public void setRoleInfoService(RoleInfoService roleInfoService) {
      this.roleInfoService = roleInfoService;
   }
}
