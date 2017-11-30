package com.mvc.web;

import com.util.Page;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.pojo.PositionInfo;
import com.yq.faurecia.service.PositionInfoService;
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
@RequestMapping({"/common/positionInfo/*"})
public class PositionInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(PositionInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private PositionInfoService positionInfoService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, PositionInfo positionInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.positionInfoService.findByCondition(positionInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.positionInfoService.findByCondition(positionInfo, page);
         sb.append("\'rows\':[");
         int i = 0;

         for(Iterator var10 = result.iterator(); var10.hasNext(); ++i) {
            PositionInfo json = (PositionInfo)var10.next();
            sb.append("{");
            sb.append((new StringBuilder("\'id\':")).append("\"" + json.getId() + "\","));
            sb.append((new StringBuilder("\'pos_code\':")).append("\"" + (json.getPos_code() == null?"":json.getPos_code()) + "\","));
            sb.append((new StringBuilder("\'pos_name\':")).append("\"" + (json.getPos_name() == null?"":json.getPos_name()) + "\","));
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

   @RequestMapping({"posAdd.do"})
   public void posAdd(PositionInfo positionInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.positionInfoService.checkPosCode(positionInfo.getPos_code().trim())) {
            e = positionInfo.getPos_code() + "部门代码已存在！";
         } else {
            this.positionInfoService.save(positionInfo);
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

   @RequestMapping({"posEdit.do"})
   public void posEdit(PositionInfo positionInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         PositionInfo result = this.positionInfoService.queryById(positionInfo.getId().intValue(), (Integer)null);
         if(!result.getPos_code().trim().equals(positionInfo.getPos_code().trim()) && this.positionInfoService.checkPosCode(positionInfo.getPos_code().trim())) {
            e = positionInfo.getPos_code() + "部门代码已存在！";
         }

         if(e.trim().equals("")) {
            this.positionInfoService.update(positionInfo);
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

   public PositionInfoService getPositionInfoService() {
      return this.positionInfoService;
   }

   public void setPositionInfoService(PositionInfoService positionInfoService) {
      this.positionInfoService = positionInfoService;
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
