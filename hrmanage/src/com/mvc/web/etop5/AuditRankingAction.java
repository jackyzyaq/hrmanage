package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.AuditRanking;
import com.yq.company.etop5.service.AuditRankingService;
import java.io.IOException;
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
@RequestMapping({"/common/auditranking/*"})
public class AuditRankingAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(AuditRankingAction.class);
   @Resource
   private UserInfoService userService;
   @Resource
   private AuditRankingService auditRankingService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, AuditRanking auditRanking, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.auditRankingService.findByCondition(auditRanking, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.auditRankingService.findByCondition(auditRanking, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            AuditRanking json = (AuditRanking)var9.next();
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

   @RequestMapping({"queryHeaderResult.do"})
   public void queryHeaderResult(Page page, AuditRanking auditRanking, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.auditRankingService.findHeaderByCondition(auditRanking, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.auditRankingService.findHeaderByCondition(auditRanking, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            AuditRanking json = (AuditRanking)var9.next();
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

   @RequestMapping({"auditRankingAdd.do"})
   public void auditRankingAdd(AuditRanking auditRanking, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         auditRanking.setOperater(Util.getOperator(user));
         this.auditRankingService.save(auditRanking);
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

   @RequestMapping({"auditRankingAddHeader.do"})
   public void auditRankingAddHeader(AuditRanking auditRanking, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         auditRanking.setType(Global.audit_ranking_type[0]);
         AuditRanking sr = this.auditRankingService.queryByHeaderType(auditRanking.getBegin_month(), auditRanking.getEnd_month());
         if(sr == null) {
            UserInfo user = Global.getUserObject(request);
            auditRanking.setOperater(Util.getOperator(user));
            this.auditRankingService.saveHeader(auditRanking);
         } else {
            auditRanking.setId(sr.getId());
            this.auditRankingService.updateHeader(auditRanking);
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

   public AuditRankingService getAuditRankingService() {
      return this.auditRankingService;
   }

   public void setAuditRankingService(AuditRankingService auditRankingService) {
      this.auditRankingService = auditRankingService;
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
