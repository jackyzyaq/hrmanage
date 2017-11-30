package com.mvc.web;

import com.schedule.service.ScheduleJob;
import com.util.Page;
import com.yq.authority.pojo.MenuInfo;
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
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/authority/menuInfo/*"})
public class MenuInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(MenuInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private MenuInfoService menuInfoService;
   @Resource
   private RoleInfoService roleInfoService;
   @Resource
   private ScheduleJob scheduleJob;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, MenuInfo menuInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.menuInfoService.findByCondition(menuInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.menuInfoService.findByCondition(menuInfo, page);
         sb.append("\'rows\':[");
         int i = 0;

         for(Iterator var10 = result.iterator(); var10.hasNext(); ++i) {
            MenuInfo json = (MenuInfo)var10.next();
            sb.append("{");
            sb.append((new StringBuilder("\'id\':")).append("\"" + json.getId() + "\","));
            sb.append((new StringBuilder("\'parent_id\':")).append("\"" + json.getParent_id() + "\","));
            sb.append((new StringBuilder("\'parent_code\':")).append("\"" + (json.getParent_menu_code() == null?"":json.getParent_menu_code()) + "\","));
            sb.append((new StringBuilder("\'parent_name\':")).append("\"" + (json.getParent_menu_name() == null?"":json.getParent_menu_name()) + "\","));
            sb.append((new StringBuilder("\'menu_code\':")).append("\"" + (json.getMenu_code() == null?"":json.getMenu_code()) + "\","));
            sb.append((new StringBuilder("\'menu_name\':")).append("\"" + (json.getMenu_name() == null?"":json.getMenu_name()) + "\","));
            sb.append((new StringBuilder("\'_url\':")).append("\"" + (json.getUrl() == null?"":json.getUrl().toString()) + "\","));
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

   @RequestMapping({"menuAdd.do"})
   public void menuAdd(MenuInfo menuInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.menuInfoService.checkMenuCode(menuInfo.getMenu_code().trim())) {
            e = menuInfo.getMenu_code() + "菜单代码已存在！";
         } else {
            this.menuInfoService.save(menuInfo);
            this.scheduleJob.loadAllMenuInfo();
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

   @RequestMapping({"menuEdit.do"})
   public void menuEdit(MenuInfo menuInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         MenuInfo result = this.menuInfoService.queryById(menuInfo.getId().intValue(), (Integer)null);
         if(!result.getMenu_code().trim().equals(menuInfo.getMenu_code().trim()) && this.menuInfoService.checkMenuCode(menuInfo.getMenu_code().trim())) {
            e = menuInfo.getMenu_code() + "菜单代码已存在！";
         }

         if(e.trim().equals("")) {
            this.menuInfoService.update(menuInfo);
            this.scheduleJob.loadAllMenuInfo();
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

   @RequestMapping({"menuOrderSort.do"})
   public void menuOrderSort(MenuInfo menuInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(menuInfo.getIds() != null && menuInfo.getIds().length() > 0) {
            ArrayList menuInfos = new ArrayList();
            String[] ids = menuInfo.getIds().split(",");
            int i = 0;

            for(int l = ids.length; i < l; ++i) {
               MenuInfo mi = new MenuInfo();
               mi.setId(Integer.valueOf(Integer.parseInt(ids[i].split("<->")[0])));
               mi.setOrderNum(Integer.valueOf(Integer.parseInt(ids[i].split("<->")[1])));
               menuInfos.add(mi);
            }

            this.menuInfoService.update((List)menuInfos);
            e = "操作成功！";
         }

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
