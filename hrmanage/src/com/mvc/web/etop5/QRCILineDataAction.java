package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.QRCILineData;
import com.yq.company.etop5.service.QRCILineDataService;
import com.yq.faurecia.pojo.DepartmentInfo;
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
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/qrci_line/*"})
public class QRCILineDataAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(QRCILineDataAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private QRCILineDataService qrciLineDataService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, QRCILineData qrciLineData, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.qrciLineDataService.findByCondition(qrciLineData, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.qrciLineDataService.findByCondition(qrciLineData, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            QRCILineData json = (QRCILineData)var9.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);

            String attr;
            for(Iterator var12 = attrList.iterator(); var12.hasNext(); sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)).replace(" 00:00:00", "") + "\",")) {
               attr = (String)var12.next();
               String[] standards_check;
               int i;
               if(attr.equals("number") && !StringUtils.isEmpty(json.getNumber())) {
                  standards_check = json.getNumber().split("\\|");

                  for(i = 1; i <= standards_check.length; ++i) {
                     sb.append("\'number" + i + "\':").append("\"" + standards_check[i - 1] + "\",");
                  }
               }

               if(attr.equals("problem_discription") && !StringUtils.isEmpty(json.getProblem_discription())) {
                  standards_check = json.getProblem_discription().split("\\|");

                  for(i = 1; i <= standards_check.length; ++i) {
                     sb.append("\'problem_discription_" + i + "\':").append("\"" + standards_check[i - 1] + "\",");
                  }
               }

               if(attr.equals("updates") && !StringUtils.isEmpty(json.getUpdates())) {
                  standards_check = json.getUpdates().split("\\|");

                  for(i = 1; i <= standards_check.length; ++i) {
                     sb.append("\'updates_" + i + "\':").append("\"" + standards_check[i - 1] + "\",");
                  }
               }

               if(attr.equals("standards_check") && !StringUtils.isEmpty(json.getStandards_check())) {
                  standards_check = json.getStandards_check().split("\\|");

                  for(i = 1; i <= standards_check.length; ++i) {
                     sb.append("\'standards_check_" + i + "\':").append("\"" + standards_check[i - 1] + "\",");
                  }
               }

               if(attr.equals("dept_id")) {
                  sb.append("\'dept_name\':").append("\"" + ((DepartmentInfo)Global.departmentInfoMap.get(json.getDept_id())).getDept_code() + "\",");
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
         JSONObject var17 = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");
         response.getWriter().println(var17.toString());
      } catch (JSONException var15) {
         var15.printStackTrace();
      } catch (Exception var16) {
         var16.printStackTrace();
      }

   }

   @RequestMapping({"qrciLineDataAdd.do"})
   public void qrciLineDataAdd(QRCILineData qrciLineData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         QRCILineData e = this.qrciLineDataService.queryById(qrciLineData.getId().intValue());
         if(e == null) {
            qrciLineData.setNumber(StringUtils.defaultIfEmpty(request.getParameter("number1"), "-") + "|" + this.qrciLineDataService.getNumber2(request.getParameter("number1")));
         } else if(e.getNumber().equals(StringUtils.defaultIfEmpty(request.getParameter("number1"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("number2"), "-"))) {
            qrciLineData.setNumber(e.getNumber());
         } else {
            qrciLineData.setNumber(StringUtils.defaultIfEmpty(request.getParameter("number1"), "-") + "|" + this.qrciLineDataService.getNumber2(request.getParameter("number1")));
         }

         qrciLineData.setProblem_discription(StringUtils.defaultIfEmpty(request.getParameter("problem_discription_1"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_2"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_3"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_4"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_5"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_6"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_7"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_8"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_9"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("problem_discription_10"), "-"));
         qrciLineData.setStandards_check(StringUtils.defaultIfEmpty(request.getParameter("standards_check_1"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_2"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_3"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_4"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_5"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_6"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_7"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_8"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("standards_check_9"), "-"));
         qrciLineData.setUpdates(StringUtils.defaultIfEmpty(request.getParameter("updates_1"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_2"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_3"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_4"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_5"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_6"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_7"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_8"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_9"), "-") + "|" + StringUtils.defaultIfEmpty(request.getParameter("updates_10"), "-"));
         String msg = "";
         UserInfo user = Global.getUserObject(request);
         qrciLineData.setCreate_user(Util.getOperator(user));
         qrciLineData.setUpdate_user(Util.getOperator(user));
         int id = this.qrciLineDataService.save(qrciLineData);
         msg = "操作成功！";
         sb.append("{");
         sb.append("\'id\':" + id + ",");
         sb.append("\'flag\':" + Global.FLAG[1] + ",");
         sb.append("\'msg\':\'" + msg + "\'");
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

   @RequestMapping({"qrciLineDataEdit.do"})
   public void qrciLineDataEdit(QRCILineData qrciLineData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         qrciLineData.setUpdate_user(Util.getOperator(user));
         this.qrciLineDataService.save(qrciLineData);
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

   @RequestMapping({"qrciLineDataExtAdd.do"})
   public void qrciLineDataExtAdd(QRCILineData qrciLineData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         qrciLineData.setCreate_user(Util.getOperator(user));
         qrciLineData.setUpdate_user(Util.getOperator(user));
         this.qrciLineDataService.saveExt(qrciLineData);
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

   @RequestMapping({"qrciLineDataExtEdit.do"})
   public void qrciLineDataExtEdit(QRCILineData qrciLineData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         qrciLineData.setUpdate_user(Util.getOperator(user));
         this.qrciLineDataService.saveExt(qrciLineData);
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

   @RequestMapping({"doSign.do"})
   public void doSign(String id, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         String[] emp_names = request.getParameter("emp_names").split("\\|");
         if(StringUtils.isEmpty(id)) {
            e = "请先选择一条进行签字！！";
         } else {
            QRCILineData lineData = this.qrciLineDataService.queryById(Integer.parseInt(id));
            if(lineData != null) {
               String[] var12 = emp_names;
               int var11 = emp_names.length;

               for(int var10 = 0; var10 < var11; ++var10) {
                  String s = var12[var10];
                  String name = "[" + s.split(":")[0] + "(" + s.split(":")[1] + ")" + "]";
                  if(StringUtils.defaultIfEmpty(lineData.getSigned_by_employee(), "").indexOf(name) == -1) {
                     lineData.setSigned_by_employee(lineData.getSigned_by_employee() + name);
                  }
               }

               this.qrciLineDataService.save(lineData);
               e = "操作成功！";
            } else {
               e = "查不到数据！";
            }
         }

         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var23) {
         var23.printStackTrace();
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
         } catch (IOException var22) {
            var22.printStackTrace();
         }

      }

   }

   @RequestMapping({"doDel.do"})
   public void doDel(String ids, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         if(StringUtils.isEmpty(ids)) {
            e = "请先选择一条进行！";
         } else {
            this.qrciLineDataService.delete(ids);
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

   public QRCILineDataService getQRCILineDataService() {
      return this.qrciLineDataService;
   }

   public void setQRCILineDataService(QRCILineDataService qrciLineDataService) {
      this.qrciLineDataService = qrciLineDataService;
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
