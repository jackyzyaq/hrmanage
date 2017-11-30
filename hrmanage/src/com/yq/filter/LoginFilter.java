package com.yq.filter;

import com.yq.authority.pojo.UserInfo;
import com.yq.filter.SysContent;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;

public class LoginFilter implements Filter {

   private String redirectURL;
   String[] filterPackages = null;
   String[] noFilterPackages = null;
   boolean directLogin = false;


   public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
      HttpServletRequest request = (HttpServletRequest)servletRequest;
      HttpServletResponse response = (HttpServletResponse)servletResponse;
      SysContent.setRequest((HttpServletRequest)servletRequest);
      SysContent.setResponse((HttpServletResponse)servletResponse);
      boolean isCheck = this.isCheckURI(request);
      String servletPath;
      if(isCheck) {
         if(!this.checkFilter(request, response)) {
            servletPath = request.getRequestURI();
            if(servletPath != null && (servletPath.indexOf(".jsp") > -1 || servletPath.indexOf(".html") > -1 || servletPath.indexOf(".htm") > -1 || servletPath.indexOf(".action") > -1 || servletPath.indexOf(".do") > -1)) {
               if(request.getQueryString() != null) {
                  servletPath = servletPath + '?';
                  servletPath = servletPath + request.getQueryString();
               }

               request.getSession().setAttribute("newPath", servletPath);
            }

            response.sendRedirect(request.getContextPath() + this.redirectURL);
            return;
         }

         filterChain.doFilter(servletRequest, servletResponse);
      } else if(this.checkFilter(request, response)) {
         servletPath = request.getServletPath();
         if(servletPath.indexOf(request.getContextPath() + "/index.jsp") >= 0) {
            response.sendRedirect(request.getContextPath() + "/portal/portal_index.jsp");
         } else {
            filterChain.doFilter(servletRequest, servletResponse);
         }
      } else {
         filterChain.doFilter(servletRequest, servletResponse);
      }

   }

   private boolean isCheckURI(HttpServletRequest request) {
      String servletPath = null;
      servletPath = request.getServletPath();
      String[] var6 = this.noFilterPackages;
      int var5 = this.noFilterPackages.length;

      String filter;
      int var4;
      for(var4 = 0; var4 < var5; ++var4) {
         filter = var6[var4];
         if(servletPath.indexOf(filter.trim()) >= 0) {
            return false;
         }
      }

      if(this.filterPackages == null) {
         return true;
      } else {
         var6 = this.filterPackages;
         var5 = this.filterPackages.length;

         for(var4 = 0; var4 < var5; ++var4) {
            filter = var6[var4];
            if(servletPath.indexOf(filter.trim()) >= 0) {
               return true;
            }
         }

         return false;
      }
   }

   @RequestMapping
   private boolean checkFilter(HttpServletRequest request, HttpServletResponse response) throws IOException {
      UserInfo user = (UserInfo)request.getSession().getAttribute("user");
      return user == null?false:user.getId() != null && user.getId().intValue() != 0;
   }

   public void destroy() {
      System.out.println("filter destroy");
   }

   public void init(FilterConfig filterConfig) throws ServletException {
      this.redirectURL = filterConfig.getInitParameter("redirectURL");
      String filterStrs = filterConfig.getInitParameter("filterPackages");
      String noFilterStrs = filterConfig.getInitParameter("noFilterPackages");
      if(filterStrs != null) {
         if(filterStrs.equals("/*")) {
            this.filterPackages = null;
         } else {
            this.filterPackages = filterStrs.split(";");
         }
      }

      if(noFilterStrs != null) {
         if(noFilterStrs.equals("/*")) {
            this.noFilterPackages = null;
         } else {
            this.noFilterPackages = noFilterStrs.split(";");
         }
      }

   }

   public String getRedirectURL() {
      return this.redirectURL;
   }

   public void setRedirectURL(String redirectURL) {
      this.redirectURL = redirectURL;
   }
}
