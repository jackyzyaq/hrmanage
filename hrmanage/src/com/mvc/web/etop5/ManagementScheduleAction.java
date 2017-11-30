package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.ManagementSchedule;
import com.yq.company.etop5.service.ManagementScheduleService;
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
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/managementSchedule/*"})
public class ManagementScheduleAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ManagementScheduleAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
   @Resource
   private UserInfoService userService;
   @Resource
   private ManagementScheduleService managementScheduleService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ManagementSchedule managementSchedule, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.managementScheduleService.findByCondition(managementSchedule, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.managementScheduleService.findByCondition(managementSchedule, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            ManagementSchedule json = (ManagementSchedule)var9.next();
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

   @RequestMapping({"managementScheduleAdd.do"})
   public void managementScheduleAdd(ManagementSchedule managementSchedule, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         managementSchedule.setTb_create_user(Util.getOperator(user));
         managementSchedule.setTb_update_user(Util.getOperator(user));
         this.managementScheduleService.save(managementSchedule);
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

   @RequestMapping({"managementScheduleEdit.do"})
   public void managementScheduleEdit(ManagementSchedule managementSchedule, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         managementSchedule.setTb_update_user(Util.getOperator(user));
         this.managementScheduleService.update(managementSchedule);
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

   @RequestMapping({"doManagementScheduleState.do"})
   public void doManagementScheduleState(String ids, Integer state, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         if(!StringUtils.isEmpty(ids)) {
            String[] var11;
            int var10 = (var11 = ids.split(",")).length;

            for(int var9 = 0; var9 < var10; ++var9) {
               String id = var11[var9];
               ManagementSchedule managementSchedule = this.managementScheduleService.queryById(Integer.parseInt(id));
               if(managementSchedule != null) {
                  managementSchedule.setTb_update_user(Util.getOperator(user));
                  managementSchedule.setState(state);
                  this.managementScheduleService.update(managementSchedule);
               }
            }
         }

         e = "操作成功！";
         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
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

   public ManagementScheduleService getManagementScheduleService() {
      return this.managementScheduleService;
   }

   public void setManagementScheduleService(ManagementScheduleService managementScheduleService) {
      this.managementScheduleService = managementScheduleService;
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
