package com.mvc.web;

import com.util.Page;
import com.yq.authority.pojo.ActionInfo;
import com.yq.authority.service.ActionInfoService;
import com.yq.authority.service.MenuInfoService;
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
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/authority/actionInfo/*"})
public class ActionInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ActionInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private MenuInfoService menuInfoService;
   @Resource
   private ActionInfoService actionInfoService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ActionInfo actionInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.actionInfoService.findByCondition(actionInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.actionInfoService.findByCondition(actionInfo, page);
         sb.append("\'rows\':[");
         int i = 0;

         for(Iterator var10 = result.iterator(); var10.hasNext(); ++i) {
            ActionInfo json = (ActionInfo)var10.next();
            sb.append("{");
            sb.append((new StringBuilder("\'id\':")).append("\"" + json.getId() + "\","));
            sb.append((new StringBuilder("\'action_name\':")).append("\"" + (json.getAction_name() == null?"":json.getAction_name()) + "\","));
            sb.append((new StringBuilder("\'action_code\':")).append("\"" + (json.getAction_code() == null?"":json.getAction_code()) + "\","));
            sb.append((new StringBuilder("\'action_menu_id\':")).append("\"" + json.getAction_menu_id() + "\","));
            sb.append((new StringBuilder("\'viewmode\':")).append("\"" + (json.getViewmode() == null?"":json.getViewmode()) + "\","));
            sb.append((new StringBuilder("\'action_menu_name\':")).append("\"" + (json.getAction_menu_name() == null?"":json.getAction_menu_name().toString()) + "\","));
            sb.append((new StringBuilder("\'action_menu_code\':")).append("\"" + (json.getAction_menu_code() == null?"":json.getAction_menu_code().toString()) + "\","));
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

   @RequestMapping({"actionAdd.do"})
   public void actionAdd(ActionInfo actionInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.actionInfoService.checkActionCode(actionInfo.getAction_code().trim())) {
            e = actionInfo.getAction_code() + "动作代码已存在！";
         } else {
            this.actionInfoService.save(actionInfo, (String[])null);
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

   @RequestMapping({"actionEdit.do"})
   public void actionEdit(ActionInfo actionInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         ActionInfo result = this.actionInfoService.findById(actionInfo.getId());
         if(!result.getAction_code().trim().equals(actionInfo.getAction_code().trim()) && this.actionInfoService.checkActionCode(actionInfo.getAction_code().trim())) {
            e = actionInfo.getAction_code() + "动作代码已存在！";
         }

         if(e.trim().equals("")) {
            this.actionInfoService.update(actionInfo);
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

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }

   public ActionInfoService getActionInfoService() {
      return this.actionInfoService;
   }

   public void setActionInfoService(ActionInfoService actionInfoService) {
      this.actionInfoService = actionInfoService;
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
