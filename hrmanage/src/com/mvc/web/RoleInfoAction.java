package com.mvc.web;

import com.util.Global;
import com.util.Page;
import com.util.Util;
import com.yq.authority.pojo.RoleInfo;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import java.io.IOException;
import java.text.SimpleDateFormat;
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
@RequestMapping({"/authority/roleInfo/*"})
public class RoleInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(RoleInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, RoleInfo roleInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.roleInfoService.findByCondition(roleInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.roleInfoService.findByCondition(roleInfo, page);
         sb.append("\'rows\':[");
         int i = 0;

         for(Iterator var10 = result.iterator(); var10.hasNext(); ++i) {
            RoleInfo json = (RoleInfo)var10.next();
            sb.append("{");
            sb.append((new StringBuilder("\'id\':")).append("\"" + json.getId() + "\","));
            sb.append((new StringBuilder("\'role_code\':")).append("\"" + json.getRole_code() + "\","));
            sb.append((new StringBuilder("\'role_name\':")).append("\"" + json.getRole_name() + "\","));
            sb.append((new StringBuilder("\'parent_code\':")).append("\"" + (json.getParent_code() == null?"":json.getParent_code().toString()) + "\","));
            sb.append((new StringBuilder("\'parent_name\':")).append("\"" + (json.getParent_name() == null?"":json.getParent_name().toString()) + "\","));
            sb.append((new StringBuilder("\'description\':")).append("\"" + (json.getDescription() == null?"":json.getDescription().toString()) + "\","));
            sb.append((new StringBuilder("\'state\':")).append("\"" + (json.getState() == null?"":json.getState()) + "\","));
            sb.append((new StringBuilder("\'create_date\':")).append("\"" + (json.getCreate_date() == null?"":this.sdf.format(json.getCreate_date())) + "\","));
            sb.append((new StringBuilder("\'update_date\':")).append("\"" + (json.getUpdate_date() == null?"":this.sdf.format(json.getUpdate_date())) + "\""));
            sb.append("}");
            if(i + 1 != result.size()) {
               sb.append(",");
            }
         }

         sb.append("]}");
         JSONObject var13 = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");
         response.getWriter().println(var13.toString());
      } catch (JSONException var11) {
         var11.printStackTrace();
      } catch (Exception var12) {
         var12.printStackTrace();
      }

   }

   @RequestMapping({"roleAdd.do"})
   public void roleAdd(RoleInfo roleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.roleInfoService.checkRoleCode(roleInfo.getRole_code().trim())) {
            e = roleInfo.getRole_code() + "角色代码已存在！";
         } else {
            this.roleInfoService.save(roleInfo);
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

   @RequestMapping({"roleEdit.do"})
   public void roleEdit(RoleInfo roleInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         RoleInfo result = this.roleInfoService.queryById(roleInfo.getId().intValue(), (Integer)null);
         if(!result.getRole_code().trim().equals(roleInfo.getRole_code().trim()) && this.roleInfoService.checkRoleCode(roleInfo.getRole_code().trim())) {
            e = roleInfo.getRole_code() + "角色代码已存在！";
         }

         if(Util.contains(Global.default_role, result.getRole_code())) {
            e = roleInfo.getRole_name() + "是默认角色，不能修改！";
         }

         if(e.trim().equals("")) {
            this.roleInfoService.update(roleInfo);
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

   @RequestMapping({"roleAuthorityMenu.do"})
   public void roleAuthorityMenu(HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String ids = StringUtils.defaultIfEmpty(request.getParameter("parent_id"), "");
         Integer role_id = Integer.valueOf(StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id")));
         this.roleInfoService.saveRoleaAuthorityMenu(ids.split(","), role_id);
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

   @RequestMapping({"roleAuthorityUser.do"})
   public void roleAuthorityUser(HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String ids = StringUtils.defaultIfEmpty(request.getParameter("parent_id"), "");
         Integer role_id = Integer.valueOf(StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id")));
         this.roleInfoService.saveRoleaAuthorityUser(ids.split(","), role_id);
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

   @RequestMapping({"roleAuthorityDept.do"})
   public void roleAuthorityDept(HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String ids = StringUtils.defaultIfEmpty(request.getParameter("parent_id"), "");
         Integer role_id = Integer.valueOf(StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id")));
         this.roleInfoService.saveRoleaAuthorityDept(ids.split(","), role_id);
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

   public RoleInfoService getRoleInfoService() {
      return this.roleInfoService;
   }

   public void setRoleInfoService(RoleInfoService roleInfoService) {
      this.roleInfoService = roleInfoService;
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
}
