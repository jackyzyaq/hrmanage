package com.yq.aop;

import com.util.Global;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.common.pojo.OperationRecord;
import com.yq.common.service.OperationRecordService;
import com.yq.filter.SysContent;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class SimpleAspect {

   @Resource
   private OperationRecordService operationRecordService;


   @Pointcut("execution(* com.yq.*.service.*Service*.*(..))")
   public void pointCut() {
      System.out.println("*************************************8");
   }

   @After("pointCut()")
   public void after(JoinPoint joinPoint) {}

   @Before("pointCut()")
   public void before(JoinPoint joinPoint) {}

   @AfterReturning(
      pointcut = "pointCut()",
      returning = "returnVal"
   )
   public void afterReturning(JoinPoint joinPoint, Object returnVal) {
      String method = joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName();
      String content = "";
      String objectName = "";
      if(Util.containsKeys(method.toUpperCase(), ",save,update,insert,add,edit".toUpperCase().split(",")) && method.indexOf("OperationRecord") == -1 && method.indexOf("Common") == -1) {
         try {
            Object[] e = joinPoint.getArgs();
            Object[] url = e;
            int ip = e.length;

            for(int user = 0; user < ip; ++user) {
               Object request = url[user];
               if(request != null) {
                  content = content + ReflectPOJO.toString(request) + ",";
                  objectName = objectName + request.getClass().getName() + ",";
               }
            }

            if(content.endsWith(",")) {
               content = content.substring(0, content.length() - 1);
            }

            if(objectName.endsWith(",")) {
               objectName = objectName.substring(0, objectName.length() - 1);
            }

            if(StringUtils.isEmpty(content)) {
               return;
            }

            HttpServletRequest var15 = SysContent.getRequest();
            UserInfo var16 = Global.getUserObject(var15);
            if(var15 != null && var16 != null) {
               String var17 = Util.getIpAddr(var15);
               Object var18 = Global.requestInfoMap.get(var17);
               if(var18 != null) {
                  String menu_name = "";
                  int menu_id = Integer.parseInt((String)StringUtils.defaultIfEmpty(var15.getParameter("menu_id"), "0"));
                  if(menu_id > 0) {
                     menu_name = Util.getMenuAllNameById(Integer.valueOf(menu_id), Global.menuInfoMap);
                  } else if(var18.toString().indexOf("updateLoginDate") > -1) {
                     menu_name = "登录";
                  } else if(var18.toString().indexOf("upload") > -1) {
                     menu_name = "上传文件";
                  }

                  OperationRecord or = new OperationRecord();
                  or.setUser_id(var16.getId());
                  or.setUser_name(var16.getZh_name());
                  or.setOperation_type(method);
                  or.setOperation_object(objectName);
                  or.setOperation_content(content);
                  or.setMenu_name(menu_name);
                  or.setUrl(var18.toString());
                  this.operationRecordService.save(or);
               }
            }
         } catch (Exception var14) {
            var14.printStackTrace();
         }
      }

   }

   @AfterThrowing(
      pointcut = "pointCut()",
      throwing = "error"
   )
   public void afterThrowing(JoinPoint jp, Throwable error) {
      System.out.println("error:" + error);
   }
}
