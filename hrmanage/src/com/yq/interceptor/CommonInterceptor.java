package com.yq.interceptor;

import com.util.Global;
import com.util.Util;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class CommonInterceptor implements HandlerInterceptor {

   private static Logger log = LogManager.getLogger(CommonInterceptor.class.getName());


   public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
      boolean isTrue = this.validateRequest(request, response);
      return isTrue;
   }

   public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
      int menu_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
      if(menu_id > 0) {
         String ip = Util.getIpAddr(request);
         System.out.println("menu:" + Util.getMenuAllNameById(Integer.valueOf(menu_id), Global.menuInfoMap));
         System.out.println("ip:" + Global.requestInfoMap.get(ip));
      }

   }

   public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
      Global.requestInfoMap.remove(Util.getIpAddr(request));
   }

   protected String getGetParams(HttpServletRequest request, HttpServletResponse response) throws Exception {
      PrintWriter writer = response.getWriter();
      writer.println("GET " + request.getRequestURL() + " " + request.getQueryString());
      Map params = request.getParameterMap();
      String queryString = "";
      Iterator var7 = params.keySet().iterator();

      while(var7.hasNext()) {
         String key = (String)var7.next();
         String[] values = (String[])params.get(key);

         for(int i = 0; i < values.length; ++i) {
            String value = values[i];
            queryString = queryString + key + "=" + value + "&";
         }
      }

      return request.getRequestURL() + "?" + queryString.trim();
   }

   protected String getPostParams(HttpServletRequest request, HttpServletResponse response) throws Exception {
      Map params = request.getParameterMap();
      String queryString = "";
      Iterator var6 = params.keySet().iterator();

      while(var6.hasNext()) {
         String key = (String)var6.next();
         String[] values = (String[])params.get(key);

         for(int i = 0; i < values.length; ++i) {
            String value = values[i];
            queryString = queryString + key + "=" + value + "&";
         }
      }

      return request.getRequestURL() + "?" + queryString.trim();
   }

   public String getUrlAndParams(HttpServletRequest request, HttpServletResponse response) throws Exception {
      String url = null;
      String method = request.getMethod();
      if("GET".toUpperCase().equals(method.toUpperCase())) {
         url = this.getGetParams(request, response);
      } else if("POST".toUpperCase().equals(method.toUpperCase())) {
         url = this.getPostParams(request, response);
      }

      return url;
   }

   protected boolean validateRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
      boolean isTrue = true;
      String ip = Util.getIpAddr(request);
      String url = this.getUrlAndParams(request, response);
      Long time = Long.valueOf(Util.getTimeLong());
      if(Global.requestInfoMap.get(ip) == null) {
         ConcurrentHashMap ipMap = new ConcurrentHashMap();
         ipMap.put("url", url);
         ipMap.put("time", time);
         Global.requestInfoMap.put(ip, ipMap);
         log.info(ip + " - " + url);
      } else {
         Map ipMap1 = (Map)Global.requestInfoMap.get(ip);
         String oldUrl = (String)ipMap1.get("url");
         if(oldUrl != null && oldUrl.trim().equals(url.trim())) {
            isTrue = false;
            log.info(ip + " 重复请求拒绝，之前的请求还没有释放！（" + oldUrl + "）");
         }
      }

      return isTrue;
   }
}
