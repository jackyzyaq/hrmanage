package com.mvc.web.common_web;

import com.util.Global;
import com.yq.common.pojo.Common;
import com.yq.common.service.CommonService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/commonWeb/*"})
public class CommonAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(CommonAction.class);
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private CommonService commonService;


   @RequestMapping({"mealsEdit.do"})
   public void mealsEdit(HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         String meals_name = StringUtils.defaultIfEmpty(request.getParameter("meals_name"), "");
         String begin_time = StringUtils.defaultIfEmpty(request.getParameter("begin_time"), "");
         String end_time = StringUtils.defaultIfEmpty(request.getParameter("end_time"), "");
         if(!StringUtils.isEmpty(meals_name) && !StringUtils.isEmpty(begin_time) && !StringUtils.isEmpty(end_time)) {
            this.commonService.updateMeals(meals_name, begin_time, end_time);
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
            sb.append("\'msg\':\'操作成功！\'");
            sb.append("}");
         } else {
            sb.append("{");
            sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
            sb.append("\'msg\':\'栏位不能有空！\'");
            sb.append("}");
         }
      } catch (Exception var17) {
         var17.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
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

   public SimpleDateFormat getSdf() {
      return this.sdf;
   }

   public void setSdf(SimpleDateFormat sdf) {
      this.sdf = sdf;
   }

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }
}
