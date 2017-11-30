package com.mvc.web;

import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.pojo.AnnualLeave;
import com.yq.faurecia.pojo.HrStatus;
import com.yq.faurecia.service.AnnualLeaveService;
import com.yq.faurecia.service.HrStatusService;
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
@RequestMapping({"/common/annualLeave/*"})
public class AnnualLeaveAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(AnnualLeaveAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private AnnualLeaveService annualLeaveService;
   @Resource
   private HrStatusService hrStatusService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, AnnualLeave annualLeave, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.annualLeaveService.findByCondition(annualLeave, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.annualLeaveService.findByCondition(annualLeave, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            AnnualLeave json = (AnnualLeave)var9.next();
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

   @RequestMapping({"leaveAdd.do"})
   public void leaveAdd(AnnualLeave annualLeave, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         annualLeave.setLeave03(Integer.valueOf(annualLeave.getLeave01().intValue() + annualLeave.getLeave02().intValue()));
         String e = "";
         HrStatus hrStatus = this.hrStatusService.queryByStatuscode(annualLeave.getStatus_code().trim());
         if(hrStatus == null) {
            this.annualLeaveService.save(annualLeave, hrStatus);
            e = "操作成功！";
         } else if(this.annualLeaveService.check(hrStatus.getId().intValue(), annualLeave.getWork_down().intValue(), annualLeave.getWork_up().intValue())) {
            e = "编码与社会工龄 已存在！";
         } else {
            this.annualLeaveService.save(annualLeave, hrStatus);
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

   @RequestMapping({"leaveEdit.do"})
   public void leaveEdit(AnnualLeave annualLeave, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         annualLeave.setLeave03(Integer.valueOf(annualLeave.getLeave01().intValue() + annualLeave.getLeave02().intValue()));
         String e = "";
         HrStatus hrStatus = this.hrStatusService.queryByStatuscode(annualLeave.getStatus_code().trim());
         if(hrStatus != null && hrStatus.getId().intValue() != annualLeave.getHr_status_id().intValue() && this.annualLeaveService.check(hrStatus.getId().intValue(), annualLeave.getWork_down().intValue(), annualLeave.getWork_up().intValue())) {
            e = "编码与社会工龄 已存在！";
         }

         if(e.length() == 0) {
            this.annualLeaveService.update(annualLeave, hrStatus);
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

   public AnnualLeaveService getAnnualLeaveService() {
      return this.annualLeaveService;
   }

   public void setAnnualLeaveService(AnnualLeaveService annualLeaveService) {
      this.annualLeaveService = annualLeaveService;
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
