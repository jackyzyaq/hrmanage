package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.QRCIDepartmentData;
import com.yq.company.etop5.service.QRCIDepartmentDataService;
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
@RequestMapping({"/common/qrci_department/*"})
public class QRCIDepartmentDataAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(QRCIDepartmentDataAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private QRCIDepartmentDataService qrciDepartmentDataService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, QRCIDepartmentData qrciDepartmentData, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.qrciDepartmentDataService.findByCondition(qrciDepartmentData, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.qrciDepartmentDataService.findByCondition(qrciDepartmentData, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            QRCIDepartmentData json = (QRCIDepartmentData)var9.next();
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

   @RequestMapping({"qrciDepartmentDataAdd.do"})
   public void qrciDepartmentDataAdd(QRCIDepartmentData qrciDepartmentData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         QRCIDepartmentData pd = this.qrciDepartmentDataService.queryByQrciType(StringUtils.defaultString(qrciDepartmentData.getQrci_type(), ""));
         if(pd != null) {
            e = "QRCIDepartment TYPE已经存在！";
         } else {
            UserInfo user = Global.getUserObject(request);
            qrciDepartmentData.setOperater(Util.getOperator(user));
            qrciDepartmentData.setState(Integer.valueOf(1));
            this.qrciDepartmentDataService.save(qrciDepartmentData);
         }

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

   @RequestMapping({"qrciDepartmentDataEdit.do"})
   public void qrciDepartmentDataEdit(QRCIDepartmentData qrciDepartmentData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         qrciDepartmentData.setOperater(Util.getOperator(user));
         this.qrciDepartmentDataService.update(qrciDepartmentData);
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
   public void autoComplete(String qrciDepartment_type, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         qrciDepartment_type = (String)StringUtils.defaultIfEmpty(qrciDepartment_type, "");
         HashMap e = new HashMap();
         e.put("qrciDepartment_type", qrciDepartment_type);
         List list = this.qrciDepartmentDataService.autoComplete(e);
         sb.append("[");
         if(list != null && list.size() > 0) {
            Iterator var8 = list.iterator();

            while(var8.hasNext()) {
               QRCIDepartmentData ci = (QRCIDepartmentData)var8.next();
               sb.append("{");
               sb.append((new StringBuilder("\"value\":")).append("\"" + ci.getQrci_type() + "\","));
               sb.append((new StringBuilder("\"open_date\":")).append("\"" + ci.getOpen_date() + "\","));
               sb.append((new StringBuilder("\"yesterday_task_to_be_checked\":")).append("\"" + Util.convertToString(ci.getYesterday_task_to_be_checked()) + "\","));
               sb.append((new StringBuilder("\"task_for_next_day_future\":")).append("\"" + Util.convertToString(ci.getTask_for_next_day_future()) + "\""));
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

   public QRCIDepartmentDataService getQRCIDepartmentDataService() {
      return this.qrciDepartmentDataService;
   }

   public void setQRCIDepartmentDataService(QRCIDepartmentDataService qrciDepartmentDataService) {
      this.qrciDepartmentDataService = qrciDepartmentDataService;
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
