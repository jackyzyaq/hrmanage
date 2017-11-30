package com.yq.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SysContent {

   private static ThreadLocal requestLocal = new ThreadLocal();
   private static ThreadLocal responseLocal = new ThreadLocal();


   public static HttpServletRequest getRequest() {
      return (HttpServletRequest)requestLocal.get();
   }

   public static void setRequest(HttpServletRequest request) {
      requestLocal.set(request);
   }

   public static HttpServletResponse getResponse() {
      return (HttpServletResponse)responseLocal.get();
   }

   public static void setResponse(HttpServletResponse response) {
      responseLocal.set(response);
   }

   public static HttpSession getSession() {
      return ((HttpServletRequest)requestLocal.get()).getSession();
   }
}
