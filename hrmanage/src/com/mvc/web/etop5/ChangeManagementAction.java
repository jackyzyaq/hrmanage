package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.ChangeManagement;
import com.yq.company.etop5.service.ChangeManagementService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
@RequestMapping({"/common/change_management/*"})
public class ChangeManagementAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ChangeManagementAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
   @Resource
   private UserInfoService userService;
   @Resource
   private ChangeManagementService change_managementService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, ChangeManagement change_management, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"report_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.change_managementService.findByCondition(change_management, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.change_managementService.findByCondition(change_management, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            ChangeManagement json = (ChangeManagement)var9.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);

            String attr;
            for(Iterator var12 = attrList.iterator(); var12.hasNext(); sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace(" 00:00:00", "") + "\",")) {
               attr = (String)var12.next();
               if(attr.equals("emp_id")) {
                  sb.append("\'emp_name\':").append("\"" + ((EmployeeInfo)Global.employeeInfoMap.get(json.getEmp_id())).getZh_name() + "\",");
               }

               if(attr.equals("dept_id")) {
                  sb.append("\'dept_name\':").append("\"" + ((DepartmentInfo)Global.departmentInfoMap.get(json.getDept_id())).getDept_name() + "\",");
               }
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

   @RequestMapping({"change_managementAdd.do"})
   public void change_managementAdd(ChangeManagement change_management, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         change_management.setOperater(Util.getOperator(user));
         this.change_managementService.save(change_management);
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

   @RequestMapping({"change_managementEdit.do"})
   public void change_managementEdit(ChangeManagement change_management, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         change_management.setOperater(Util.getOperator(user));
         this.change_managementService.update(change_management);
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

   @RequestMapping({"doChangeManagementState.do"})
   public void doChangeManagementState(String ids, Integer state, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         if(!StringUtils.isEmpty(ids)) {
            String[] var11;
            int var10 = (var11 = ids.split(",")).length;

            for(int var9 = 0; var9 < var10; ++var9) {
               String id = var11[var9];
               ChangeManagement change_management = this.change_managementService.queryById(Integer.parseInt(id));
               if(change_management != null) {
                  change_management.setOperater(Util.getOperator(user));
                  change_management.setState(state);
                  this.change_managementService.update(change_management);
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

   @RequestMapping({"doChangeManagementSign.do"})
   public void doChangeManagementSign(String id, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         String[] emp_names = request.getParameter("emp_names").split("\\|");
         if(StringUtils.isEmpty(id)) {
            e = "请先选择一条进行签字！！";
         } else {
            ChangeManagement change_management = this.change_managementService.queryById(Integer.parseInt(id));
            if(change_management != null) {
               if(!StringUtils.isEmpty(change_management.getExt_5_1()) && !StringUtils.isEmpty(change_management.getExt_5_2()) && !StringUtils.isEmpty(change_management.getExt_5_3()) && !StringUtils.isEmpty(change_management.getExt_5_4()) && !StringUtils.isEmpty(change_management.getExt_5_5())) {
                  e = "已签过！";
               } else {
                  if(StringUtils.isEmpty(change_management.getExt_5_1())) {
                     change_management.setExt_5_1(emp_names[0].split(":")[0] + "(" + emp_names[0].split(":")[1] + ")");
                     change_management.setExt_5_1_date(new Date());
                  }

                  if(StringUtils.isEmpty(change_management.getExt_5_2())) {
                     change_management.setExt_5_2(emp_names[1].split(":")[0] + "(" + emp_names[1].split(":")[1] + ")");
                     change_management.setExt_5_2_date(new Date());
                  }

                  if(StringUtils.isEmpty(change_management.getExt_5_3())) {
                     change_management.setExt_5_3(emp_names[2].split(":")[0] + "(" + emp_names[2].split(":")[1] + ")");
                     change_management.setExt_5_3_date(new Date());
                  }

                  if(StringUtils.isEmpty(change_management.getExt_5_4())) {
                     change_management.setExt_5_4(emp_names[3].split(":")[0] + "(" + emp_names[3].split(":")[1] + ")");
                     change_management.setExt_5_4_date(new Date());
                  }

                  if(StringUtils.isEmpty(change_management.getExt_5_5())) {
                     change_management.setExt_5_5(emp_names[4].split(":")[0] + "(" + emp_names[4].split(":")[1] + ")");
                     change_management.setExt_5_5_date(new Date());
                  }

                  if(e.equals("")) {
                     change_management.setOperater(Util.getOperator(user));
                     this.change_managementService.update(change_management);
                     e = "操作成功！";
                  }
               }
            } else {
               e = "查不到数据！";
            }
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var18) {
         var18.printStackTrace();
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
         } catch (IOException var17) {
            var17.printStackTrace();
         }

      }

   }

   public ChangeManagementService getChangeManagementService() {
      return this.change_managementService;
   }

   public void setChangeManagementService(ChangeManagementService change_managementService) {
      this.change_managementService = change_managementService;
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
