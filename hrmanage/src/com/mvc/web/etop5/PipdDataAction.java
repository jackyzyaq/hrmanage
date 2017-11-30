package com.mvc.web.etop5;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.RoleInfoService;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.company.etop5.pojo.PipdData;
import com.yq.company.etop5.service.PipdDataService;
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
@RequestMapping({"/common/pipd/*"})
public class PipdDataAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(PipdDataAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private UserInfoService userService;
   @Resource
   private PipdDataService pipdDataService;
   @Resource
   private RoleInfoService roleInfoService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, PipdData pipdData, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.pipdDataService.findByCondition(pipdData, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.pipdDataService.findByCondition(pipdData, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            PipdData json = (PipdData)var9.next();
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

   @RequestMapping({"pipdDataAdd.do"})
   public void pipdDataAdd(PipdData pipdData, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         pipdData.setOperater(Util.getOperator(user));
         pipdData.setState(Integer.valueOf(1));
         String[] type = StringUtils.defaultIfEmpty(request.getParameter("type1"), "").split("\\|");
         String[] reality_pipd_data = StringUtils.defaultIfEmpty(request.getParameter("reality_pipd_data1"), "").split("\\|");
         String[] must_pipd_data = StringUtils.defaultIfEmpty(request.getParameter("must_pipd_data1"), "").split("\\|");
         if(type != null && reality_pipd_data != null && must_pipd_data != null && type.length == reality_pipd_data.length && reality_pipd_data.length == must_pipd_data.length) {
            ArrayList pipdDataList = new ArrayList();

            for(int i = 0; i < type.length; ++i) {
               PipdData pd = new PipdData();
               ReflectPOJO.alternateObject(pd, pipdData);
               pd.setType(type[i]);
               pd.setReality_pipd_data(Double.valueOf(reality_pipd_data[i]));
               pd.setMust_pipd_data(Double.valueOf(must_pipd_data[i]));
               pipdDataList.add(pd);
            }

            this.pipdDataService.saveList(pipdDataList);
            e = "操作成功！";
         } else if(!StringUtils.isEmpty(pipdData.getType()) && pipdData.getReality_pipd_data() != null && pipdData.getMust_pipd_data() != null) {
            this.pipdDataService.save(pipdData);
            e = "操作成功！";
         } else {
            e = "数据错误！";
         }

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

   public PipdDataService getPipdDataService() {
      return this.pipdDataService;
   }

   public void setPipdDataService(PipdDataService pipdDataService) {
      this.pipdDataService = pipdDataService;
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
