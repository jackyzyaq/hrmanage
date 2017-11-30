package com.mvc.web;

import com.util.Page;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.service.DepartmentInfoService;
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
@RequestMapping({"/common/departmentInfo/*"})
public class DepartmentInfoAction {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(DepartmentInfoAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private DepartmentInfoService departmentInfoService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, DepartmentInfo departmentInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.departmentInfoService.findByCondition(departmentInfo, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.departmentInfoService.findByCondition(departmentInfo, page);
         sb.append("\'rows\':[");
         int i = 0;

         for(Iterator var10 = result.iterator(); var10.hasNext(); ++i) {
            DepartmentInfo json = (DepartmentInfo)var10.next();
            sb.append("{");
            sb.append((new StringBuilder("\'id\':")).append("\"" + json.getId() + "\","));
            sb.append((new StringBuilder("\'parent_id\':")).append("\"" + json.getParent_id() + "\","));
            sb.append((new StringBuilder("\'parent_code\':")).append("\"" + (json.getParent_dept_code() == null?"":json.getParent_dept_code()) + "\","));
            sb.append((new StringBuilder("\'parent_name\':")).append("\"" + (json.getParent_dept_name() == null?"":json.getParent_dept_name()) + "\","));
            sb.append((new StringBuilder("\'dept_code\':")).append("\"" + (json.getDept_code() == null?"":json.getDept_code()) + "\","));
            sb.append((new StringBuilder("\'dept_name\':")).append("\"" + (json.getDept_name() == null?"":json.getDept_name()) + "\","));
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

   @RequestMapping({"deptAdd.do"})
   public void deptAdd(DepartmentInfo departmentInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(this.departmentInfoService.checkDeptCode(departmentInfo.getDept_code().trim())) {
            e = departmentInfo.getDept_code() + "部门代码已存在！";
         } else {
            this.departmentInfoService.save(departmentInfo);
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

   @RequestMapping({"deptEdit.do"})
   public void deptEdit(DepartmentInfo departmentInfo, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         DepartmentInfo result = this.departmentInfoService.queryById(departmentInfo.getId().intValue(), (Integer)null);
         if(!result.getDept_code().trim().equals(departmentInfo.getDept_code().trim()) && this.departmentInfoService.checkDeptCode(departmentInfo.getDept_code().trim())) {
            e = departmentInfo.getDept_code() + "部门代码已存在！";
         }

         if(e.trim().equals("")) {
            this.departmentInfoService.update(departmentInfo);
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

   public DepartmentInfoService getDepartmentInfoService() {
      return this.departmentInfoService;
   }

   public void setDepartmentInfoService(DepartmentInfoService departmentInfoService) {
      this.departmentInfoService = departmentInfoService;
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
