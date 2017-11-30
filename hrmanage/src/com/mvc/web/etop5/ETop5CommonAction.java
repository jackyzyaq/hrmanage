package com.mvc.web.etop5;

import com.util.MD5;
import com.yq.common.pojo.Common;
import com.yq.common.service.CommonService;
import java.io.IOException;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/etop5/*"})
public class ETop5CommonAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(ETop5CommonAction.class);
   @Resource
   private CommonService commonService;


   @RequestMapping({"valPwd.do"})
   public void valPwd(HttpServletRequest request, HttpServletResponse response) throws Exception {
      String pwd = StringUtils.defaultIfEmpty(request.getParameter("etop5_pwd"), "");
      StringBuffer sb = new StringBuffer();

      try {
         sb.append("{");
         String e = "select * from etop5.dbo.tb_pwd where pwd=\'" + MD5.encrypt(pwd) + "\'";
         List list = this.commonService.findBySql(e);
         if(list != null && !list.isEmpty()) {
            sb.append("\'flag\':1");
         } else {
            sb.append("\'flag\':0");
         }

         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.delete(0, sb.toString().length());
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

   @RequestMapping({"rePwd.do"})
   public void rePwd(HttpServletRequest request, HttpServletResponse response) throws Exception {
      String pwd = StringUtils.defaultIfEmpty(request.getParameter("pwd"), "");
      StringBuffer sb = new StringBuffer();

      try {
         sb.append("{");
         String e = "update etop5.dbo.tb_pwd set pwd=\'" + MD5.encrypt(pwd) + "\'";
         this.commonService.operate(e, (Object[])null);
         sb.append("\'flag\':1");
         sb.append("}");
      } catch (Exception var15) {
         var15.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'flag\':0");
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

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }
}
