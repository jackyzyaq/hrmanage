package com.mvc.web;

import com.util.MD5;
import com.util.Util;
import com.yq.authority.pojo.ActionInfo;
import com.yq.authority.pojo.MenuInfo;
import com.yq.authority.pojo.RoleInfo;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.ActionInfoService;
import com.yq.authority.service.MenuInfoService;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.UploadFile;
import com.yq.common.service.UploadFileService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.service.DepartmentInfoService;
import com.yq.faurecia.service.EmployeeInfoService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping({"/main/*"})
@SessionAttributes({"user", "employeeInfo", "deptSubIds", "deptIdsRole", "deptNamesRole", "photo", "userRole", "deptRole", "menuRole", "actionRole", "roleIds", "roleNames", "roleCodes"})
public class MainController {

   @Resource
   public UserInfoService userService;
   @Resource
   public UploadFileService uploadFileService;
   @Resource
   public RoleInfoService roleInfoService;
   @Resource
   public MenuInfoService menuInfoService;
   @Resource
   public ActionInfoService actionInfoService;
   @Resource
   public EmployeeInfoService employeeInfoService;
   @Resource
   public DepartmentInfoService departmentInfoService;


   @RequestMapping({"login.do"})
   public void login(String name, String pwd, String flag, HttpServletResponse response, ModelMap model) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = new UserInfo();
         if(StringUtils.defaultIfEmpty(name, "").equals("")) {
            e = "用户名不能空！";
         } else if(StringUtils.defaultIfEmpty(pwd, "").equals("")) {
            e = "密码不能空！";
         } else {
            user.setName(name.trim());
            user = this.userService.query(user);
            if(user == null) {
               e = "用户名错误！";
            } else if(!user.getPwd().equals(MD5.encrypt(pwd))) {
               e = "密码错误！";
            } else {
               UploadFile uf = this.uploadFileService.getUploadFileByUUId(user.getUpload_uuid());
               byte[] bs = new byte[0];
               if(uf != null) {
                  bs = uf.getSource();
               }

               ConcurrentHashMap roleInfoMap = new ConcurrentHashMap();
               List userRoleResult = this.roleInfoService.findRoleByUserId(user.getId());
               String roleIds = "";
               String roleNames = "";
               String roleCodes = "";
               Iterator deptIds;
               if(userRoleResult != null && !userRoleResult.isEmpty()) {
                  deptIds = userRoleResult.iterator();

                  while(deptIds.hasNext()) {
                     RoleInfo menuInfoMap = (RoleInfo)deptIds.next();
                     roleIds = roleIds + menuInfoMap.getId() + ",";
                     roleNames = roleNames + menuInfoMap.getRole_name() + ",";
                     roleCodes = roleCodes + menuInfoMap.getRole_code() + ",";
                     roleInfoMap.put(menuInfoMap.getId(), menuInfoMap);
                  }

                  roleIds = roleIds.substring(0, roleIds.length() - 1);
                  roleNames = roleNames.substring(0, roleNames.length() - 1);
                  roleCodes = roleCodes.substring(0, roleCodes.length() - 1);
                  userRoleResult = null;
               }

               LinkedHashMap menuInfoMap1 = new LinkedHashMap();
               Iterator deptIdsList;
               if(roleIds.length() > 0) {
                  List deptIds2 = this.menuInfoService.findByMenuRole(roleIds);
                  if(deptIds2 != null && !deptIds2.isEmpty()) {
                     deptIdsList = deptIds2.iterator();

                     while(deptIdsList.hasNext()) {
                        MenuInfo deptNames = (MenuInfo)deptIdsList.next();
                        menuInfoMap1.put(deptNames.getId(), deptNames);
                     }

                     deptIds = null;
                  }
               }

               String deptIds1 = "";
               String deptNames1 = "";
               ArrayList deptIdsList1 = new ArrayList();
               ArrayList deptNamesList = new ArrayList();
               LinkedHashMap deptInfoMap = new LinkedHashMap();
               DepartmentInfo emp_id;
               if(roleIds.length() > 0) {
                  List actionInfoMap = this.departmentInfoService.findByDeptRole(roleIds);
                  if(actionInfoMap != null && !actionInfoMap.isEmpty()) {
                     Iterator employeeInfo = actionInfoMap.iterator();

                     while(employeeInfo.hasNext()) {
                        emp_id = (DepartmentInfo)employeeInfo.next();
                        deptInfoMap.put(emp_id.getId(), emp_id);
                        deptIdsList1.add(emp_id.getId());
                        deptNamesList.add(emp_id.getDept_name());
                     }

                     deptIds1 = StringUtils.substringBetween(deptIdsList1.toString(), "[", "]");
                     deptNames1 = StringUtils.substringBetween(deptNamesList.toString(), "[", "]");
                     actionInfoMap = null;
                     deptIdsList = null;
                     deptNamesList = null;
                  }
               }

               ConcurrentHashMap actionInfoMap1 = new ConcurrentHashMap();
               if(roleIds.length() > 0) {
                  List emp_id1 = this.actionInfoService.findByActionRole(roleIds);
                  if(emp_id1 != null && !emp_id1.isEmpty()) {
                     Iterator ids = emp_id1.iterator();

                     while(ids.hasNext()) {
                        ActionInfo employeeInfo1 = (ActionInfo)ids.next();
                        actionInfoMap1.put(employeeInfo1.getId(), employeeInfo1);
                     }

                     emp_id = null;
                  }
               }

               try {
                  int emp_id2 = Integer.parseInt(user.getName());
                  EmployeeInfo employeeInfo2 = this.employeeInfoService.queryById(emp_id2);
                  if(employeeInfo2 != null) {
                     String ids1 = this.departmentInfoService.getSubIdsById(employeeInfo2.getDept_id(), (List)null);
                     model.addAttribute("deptSubIds", ids1);
                     model.addAttribute("employeeInfo", employeeInfo2);
                     if(StringUtils.isEmpty(deptIds1)) {
                        deptInfoMap.put(employeeInfo2.getDept_id(), this.departmentInfoService.queryById(employeeInfo2.getDept_id().intValue()));
                        deptIds1 = deptIds1 + employeeInfo2.getDept_id();
                        deptNames1 = deptNames1 + employeeInfo2.getDept_name();
                     } else if(!Util.contains(deptIds1.split(","), employeeInfo2.getDept_id().toString())) {
                        deptInfoMap.put(employeeInfo2.getDept_id(), this.departmentInfoService.queryById(employeeInfo2.getDept_id().intValue()));
                        deptIds1 = deptIds1 + "," + employeeInfo2.getDept_id();
                        deptNames1 = deptNames1 + "," + employeeInfo2.getDept_name();
                     }
                  }
               } catch (Exception var36) {
                  ;
               }

               model.addAttribute("photo", bs);
               model.addAttribute("user", user);
               model.addAttribute("userRole", roleInfoMap);
               model.addAttribute("roleIds", roleIds);
               model.addAttribute("roleNames", roleNames);
               model.addAttribute("roleCodes", roleCodes);
               model.addAttribute("menuRole", menuInfoMap1);
               model.addAttribute("deptRole", deptInfoMap);
               model.addAttribute("deptIdsRole", deptIds1);
               model.addAttribute("deptNamesRole", deptNames1);
               model.addAttribute("actionRole", actionInfoMap1);
            }
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var37) {
         var37.printStackTrace();
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
         } catch (IOException var35) {
            var35.printStackTrace();
         }

      }

   }

   @RequestMapping({"updateLoginDate.do"})
   public void updateLoginDate(HttpServletResponse response, ModelMap model) {
      StringBuffer sb = new StringBuffer();

      try {
         UserInfo e = (UserInfo)model.get("user");
         e.setLast_date(new Date());
         this.userService.update(e);
         sb.append("{");
         sb.append("\'msg\':\'操作成功！\'");
         sb.append("}");
      } catch (Exception var14) {
         var14.printStackTrace();
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
         } catch (IOException var13) {
            var13.printStackTrace();
         }

      }

   }

   @RequestMapping({"loginOut.do"})
   public String loginOut(HttpServletRequest request, ModelMap model) {
      model.remove("user");
      model.clear();
      request.getSession().removeAttribute("user");
      request.getSession().invalidate();
      return "/index";
   }

   @RequestMapping({"updatePass.do"})
   public void updatePass(String pwd, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
      StringBuffer sb = new StringBuffer("");

      try {
         UserInfo e = (UserInfo)model.get("user");
         e.setPwd(MD5.encrypt(pwd));
         this.userService.update(e);
         sb.append("{");
         sb.append("\'flag\':1");
         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.append("{");
         sb.append("\'flag\':0");
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

   @RequestMapping({"getNumber.do"})
   public void getNumber(String pwd, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
      StringBuffer sb = new StringBuffer("");

      try {
         sb.append("{");
         sb.append("\'flag\':1,");
         sb.append("\'number\':\'" + Util.getNumber() + "\'");
         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.append("{");
         sb.append("\'flag\':0,");
         sb.append("\'number\':\'\',");
         sb.append("\'msg\':\'没有获取到单号\'");
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

   @RequestMapping({"ProcessRequest.do"})
   public void ProcessRequest(HttpServletRequest request, HttpServletResponse response) {
      try {
         String e = StringUtils.defaultIfEmpty(request.getParameter("img"), "");
      } catch (Exception var12) {
         var12.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println("");
         } catch (IOException var11) {
            var11.printStackTrace();
         }

      }

   }
}
