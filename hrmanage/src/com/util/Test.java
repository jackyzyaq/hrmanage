package com.util;

import com.util.Page;
import com.util.ServiceUtils;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.service.EmployeeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.OverTimeInfoService;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Test {

   public void test(List t) {
      if(t == null) {
         new ArrayList();
      }

      ArrayList t1 = new ArrayList();
      t1.add("112");
   }

   public static void main(String[] args) throws Exception {
      EmployeeLeaveService employeeLeaveService = (EmployeeLeaveService)ServiceUtils.getService("employeeLeaveService");
      EmployeeInfoService employeeInfoService = (EmployeeInfoService)ServiceUtils.getService("employeeInfoService");
      OverTimeInfoService overTimeInfoService = (OverTimeInfoService)ServiceUtils.getService("overTimeInfoService");
      EmployeeInfo employeeInfo = new EmployeeInfo();
      employeeInfo.setState(Integer.valueOf(1));
      List eis = employeeInfoService.findByCondition(employeeInfo, (Page)null);
      Iterator var7 = eis.iterator();

      EmployeeInfo ei;
      Map elMap;
      Integer year;
      Iterator var10;
      Map el;
      while(var7.hasNext()) {
         ei = (EmployeeInfo)var7.next();
         elMap = employeeLeaveService.findStandardLeave(ei.getId().intValue());
         if(elMap != null && elMap.size() > 0) {
            var10 = elMap.keySet().iterator();

            while(var10.hasNext()) {
               year = (Integer)var10.next();
               el = (Map)elMap.get(year);
               System.out.println(ei.getZh_name() + "\t" + year + "\t" + el.get("annual_leave_name").toString() + "\t" + el.get("surplus_annual_leave").toString() + "\t" + el.get("company_leave_name").toString() + "\t" + el.get("surplus_company_leave").toString() + "\t");
            }
         }
      }

      System.out.println("-----------------------------加班----------------------------------------");
      var7 = eis.iterator();

      while(var7.hasNext()) {
         ei = (EmployeeInfo)var7.next();
         elMap = overTimeInfoService.findStandardOverHour(ei.getId().intValue());
         if(elMap != null && elMap.size() > 0) {
            var10 = elMap.keySet().iterator();

            while(var10.hasNext()) {
               year = (Integer)var10.next();
               el = (Map)elMap.get(year);
               System.out.println(ei.getZh_name() + "\t" + year + "\t" + el.get("overtime_type").toString() + "\t" + el.get("surplus_over_hour").toString() + "\t");
            }
         }
      }

   }
}
