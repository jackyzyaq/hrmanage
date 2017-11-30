package com.yq.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;

@Aspect
public class AspectTest {

   @Around("execution(* com.util.*.service.*.*(..))")
   public void aspect(ProceedingJoinPoint jp) throws Throwable {
      System.out.println(jp.getTarget().getClass().getName() + "." + ((MethodSignature)jp.getSignature()).getMethod().getName() + " Start。。。。。");
      Object[] params = jp.getArgs();
      StringBuffer msg = new StringBuffer();
      msg.append("params：");
      Object[] var7 = params;
      int var6 = params.length;

      Object rtn;
      for(int var5 = 0; var5 < var6; ++var5) {
         rtn = var7[var5];
         msg.append(rtn + ",");
      }

      System.out.println(msg.toString());
      rtn = jp.proceed(jp.getArgs());
      System.out.println(jp.getTarget().getClass().getName() + "." + ((MethodSignature)jp.getSignature()).getMethod().getName() + " end。。。。。return:" + rtn);
   }
}
