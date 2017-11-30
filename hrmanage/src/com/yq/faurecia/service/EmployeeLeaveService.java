package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.EmployeeLeaveDao;
import com.yq.faurecia.pojo.EmployeeLeave;
import com.yq.faurecia.service.BreakTimeInfoService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EmployeeLeaveService {

   private String columns = " \tid,emp_id,year,state,annualDays,companyDays,totalDays,create_date,update_date ";
   @Resource
   private EmployeeLeaveDao employeeLeaveDao;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;


   public EmployeeLeave queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public EmployeeLeave queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_employee_leave t " + " where id = " + id + state_s;
      return this.employeeLeaveDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(EmployeeLeave employeeLeave) throws Exception {
      EmployeeLeave result = this.findByEmpIdAnyYear(employeeLeave.getEmp_id().intValue(), employeeLeave.getYear().intValue());
      int id = 0;
      if(result == null) {
         employeeLeave.setState(Integer.valueOf(1));
         id = this.employeeLeaveDao.save(employeeLeave);
      }

      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(EmployeeLeave employeeLeave) throws Exception {
      this.employeeLeaveDao.update(employeeLeave);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateByEmpIdAndYear(EmployeeLeave employeeLeave) throws Exception {
      this.employeeLeaveDao.updateByEmpIdAndYear(employeeLeave);
   }

   public EmployeeLeaveDao getEmployeeLeaveDao() {
      return this.employeeLeaveDao;
   }

   public void setEmployeeLeaveDao(EmployeeLeaveDao employeeLeaveDao) {
      this.employeeLeaveDao = employeeLeaveDao;
   }

   public List findByCondition(EmployeeLeave employeeLeave, Page page) throws Exception {
      Object result = new ArrayList();
      if(employeeLeave != null) {
         String orderby = "";
         String rownumber = "";
         if(page != null && page.getTotalCount() > 0) {
            int sql = page.getPageSize();
            int fr = (page.getPageIndex() - 1) * sql;
            if(fr < 0) {
               fr = 0;
            }

            orderby = "  order by t." + page.getSidx() + " " + page.getSord() + " ";
            rownumber = " and  RowNumber > " + fr + " and RowNumber <=" + (fr + sql) + " ";
         } else {
            orderby = "  order by t.update_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from tb_employee_leave t   ");
         sql1.append(" where 1=1 ");
         if(employeeLeave.getYear() != null) {
            sql1.append(" and t.year = " + employeeLeave.getYear() + " ");
         }

         if(employeeLeave.getEmp_id() != null) {
            sql1.append(" and t.emp_id in(" + employeeLeave.getEmp_id() + ") ");
         }

         if(employeeLeave.getState() != null) {
            sql1.append(" and t.state =" + employeeLeave.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.employeeLeaveDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public EmployeeLeave findByEmpIdAnyYear(int empId, int year) throws Exception {
      String sql = " select " + this.columns + " from tb_employee_leave t " + " where state=1 and emp_id = " + empId + " and year = " + year + " ";
      return this.employeeLeaveDao.queryObjectBySql(sql);
   }

   public Map findStandardLeave(int empId) throws Exception {
      List annualDays = this.findAnnualDays(empId);
      List companyDays = this.findCompanyDays(empId);
      HashMap map = new HashMap();
      EmployeeLeave leaveMap;
      Iterator year;
      if(annualDays != null && !annualDays.isEmpty()) {
         year = annualDays.iterator();

         while(year.hasNext()) {
            leaveMap = (EmployeeLeave)year.next();
            if(leaveMap.getAnnualDays().doubleValue() > 0.0D) {
               if(map.containsKey(leaveMap.getYear())) {
                  leaveMap.setCompanyDays(Double.valueOf(((EmployeeLeave)map.get(leaveMap.getYear())).getCompanyDays().doubleValue() + leaveMap.getCompanyDays().doubleValue()));
                  leaveMap.setAnnualDays(Double.valueOf(((EmployeeLeave)map.get(leaveMap.getYear())).getAnnualDays().doubleValue() + leaveMap.getAnnualDays().doubleValue()));
               }

               map.put(leaveMap.getYear(), leaveMap);
            }
         }
      }

      if(companyDays != null && !companyDays.isEmpty()) {
         year = companyDays.iterator();

         while(year.hasNext()) {
            leaveMap = (EmployeeLeave)year.next();
            if(leaveMap.getCompanyDays().doubleValue() > 0.0D) {
               if(map.containsKey(leaveMap.getYear())) {
                  leaveMap.setCompanyDays(Double.valueOf(((EmployeeLeave)map.get(leaveMap.getYear())).getCompanyDays().doubleValue() + leaveMap.getCompanyDays().doubleValue()));
                  leaveMap.setAnnualDays(Double.valueOf(((EmployeeLeave)map.get(leaveMap.getYear())).getAnnualDays().doubleValue() + leaveMap.getAnnualDays().doubleValue()));
               }

               map.put(leaveMap.getYear(), leaveMap);
            }
         }
      }

      ConcurrentHashMap leaveMap1 = new ConcurrentHashMap();
      if(map != null && map.size() > 0) {
         Iterator var7 = map.keySet().iterator();

         while(var7.hasNext()) {
            Integer year1 = (Integer)var7.next();
            EmployeeLeave el = (EmployeeLeave)map.get(year1);
            String annual_leave = Global.breaktime_type[2].split("\\|")[0];
            String company_leave = Global.breaktime_type[3].split("\\|")[0];
            double annual_hours = this.findBreakHours(empId, year1.intValue(), annual_leave);
            double company_hours = this.findBreakHours(empId, year1.intValue(), company_leave);
            ConcurrentHashMap leaveSubMap = new ConcurrentHashMap();
            leaveSubMap.put("emp_id", Integer.valueOf(empId));
            leaveSubMap.put("year", year1);
            leaveSubMap.put("annual_leave_name", annual_leave);
            leaveSubMap.put("standard_annual_leave", Double.valueOf(el.getAnnualDays().doubleValue() * 8.0D));
            leaveSubMap.put("annual_leave", Double.valueOf(annual_hours));
            leaveSubMap.put("surplus_annual_leave", Double.valueOf(el.getAnnualDays().doubleValue() * 8.0D - annual_hours));
            leaveSubMap.put("company_leave_name", company_leave);
            leaveSubMap.put("standard_company_leave", Double.valueOf(el.getCompanyDays().doubleValue() * 8.0D));
            leaveSubMap.put("company_leave", Double.valueOf(company_hours));
            leaveSubMap.put("surplus_company_leave", Double.valueOf(el.getCompanyDays().doubleValue() * 8.0D - company_hours));
            leaveMap1.put(year1, leaveSubMap);
         }
      }

      map = null;
      annualDays = null;
      companyDays = null;
      return leaveMap1;
   }

   public Map findStandardLeave(int empId, int year) throws Exception {
      Map leaveMap = this.findStandardLeave(empId);
      return (Map)leaveMap.get(Integer.valueOf(year));
   }

   private List findAnnualDays(int empId) throws Exception {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String time = Global.clear_annual_leave_mm_dd;
      Calendar c = Calendar.getInstance();
      Date now = c.getTime();
      StringBuffer sb = new StringBuffer("");
      int nowYear = c.get(1);
      sb.append(nowYear);
      String sql = " select emp_id,year,annual_days annualDays,0 companyDays from tb_employee_leave_2016  where emp_id = " + empId + " ";
      ArrayList tmpList = new ArrayList();
      if(this.employeeLeaveDao.findBySql(sql) != null) {
         if(nowYear == 2016) {
            tmpList.add(new EmployeeLeave(empId, 2016, this.findTotalAnnualDays(empId, 2016), 0.0D));
         } else if(sdf.parse(sdf.format(now)).getTime() <= sdf.parse("2017-" + time).getTime()) {
            tmpList.add(new EmployeeLeave(empId, 2016, this.findTotalAnnualDays(empId, 2016), 0.0D));
            tmpList.add(new EmployeeLeave(empId, 2017, this.findTotalAnnualDays(empId, 2017), 0.0D));
         } else {
            tmpList.add(new EmployeeLeave(empId, nowYear, this.findTotalAnnualDays(empId, nowYear), 0.0D));
            if(c.getTime().getTime() <= sdf.parse(nowYear + "-" + time).getTime()) {
               c.add(1, -1);
               tmpList.add(new EmployeeLeave(empId, c.get(1), this.findTotalAnnualDays(empId, c.get(1)), 0.0D));
            }
         }
      } else {
         tmpList.add(new EmployeeLeave(empId, nowYear, this.findTotalAnnualDays(empId, nowYear), 0.0D));
         if(c.getTime().getTime() <= sdf.parse(nowYear + "-" + time).getTime()) {
            c.add(1, -1);
            tmpList.add(new EmployeeLeave(empId, c.get(1), this.findTotalAnnualDays(empId, c.get(1)), 0.0D));
         }
      }

      return tmpList;
   }

   private List findCompanyDays(int empId) throws Exception {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String time = Global.clear_company_leave_mm_dd;
      Calendar c = Calendar.getInstance();
      Date now = c.getTime();
      StringBuffer sb = new StringBuffer("");
      int nowYear = c.get(1);
      sb.append(nowYear);
      String sql = "";
      sql = " select emp_id,year,0 annualDays,company_days companyDays from tb_employee_leave_2016  where emp_id = " + empId + " ";
      ArrayList tmpList = new ArrayList();
      if(this.employeeLeaveDao.findBySql(sql) != null) {
         if(nowYear == 2016) {
            tmpList.add(new EmployeeLeave(empId, 2016, 0.0D, this.findTotalCompanyDays(empId, 2016)));
         } else if(sdf.parse(sdf.format(now)).getTime() <= sdf.parse("2017-" + time).getTime()) {
            tmpList.add(new EmployeeLeave(empId, 2016, 0.0D, this.findTotalCompanyDays(empId, 2016)));
            tmpList.add(new EmployeeLeave(empId, 2017, 0.0D, this.findTotalCompanyDays(empId, 2017)));
         } else {
            tmpList.add(new EmployeeLeave(empId, nowYear, 0.0D, this.findTotalCompanyDays(empId, nowYear)));
            if(c.getTime().getTime() <= sdf.parse(nowYear + "-" + time).getTime()) {
               c.add(1, -1);
               tmpList.add(new EmployeeLeave(empId, c.get(1), 0.0D, this.findTotalCompanyDays(empId, c.get(1))));
            }
         }
      } else {
         tmpList.add(new EmployeeLeave(empId, nowYear, 0.0D, this.findTotalCompanyDays(empId, nowYear)));
         if(c.getTime().getTime() <= sdf.parse(nowYear + "-" + time).getTime()) {
            c.add(1, -1);
            tmpList.add(new EmployeeLeave(empId, c.get(1), 0.0D, this.findTotalCompanyDays(empId, c.get(1))));
         }
      }

      return tmpList;
   }

   public double findTotalAnnualDays(int empId, int year) throws Exception {
      String sql = "";
      if(year == 2016) {
         sql = " select ISNULL(sum(annual_days),0) annualDays from tb_employee_leave_2016  where emp_id = " + empId + " ";
      } else {
         sql = " select ISNULL(sum(annualDays),0) annualDays from tb_employee_leave  where state=1 and emp_id = " + empId + " and year in(" + year + ") ";
      }

      List tList = this.employeeLeaveDao.findBySql(sql);
      return tList != null && !tList.isEmpty()?((EmployeeLeave)tList.get(0)).getAnnualDays().doubleValue():0.0D;
   }

   public double findTotalCompanyDays(int empId, int year) throws Exception {
      String sql = "";
      if(year == 2016) {
         sql = " select ISNULL(sum(company_days),0) companyDays from tb_employee_leave_2016  where emp_id = " + empId + " ";
      } else {
         sql = " select ISNULL(sum(companyDays),0) companyDays from tb_employee_leave  where state=1 and emp_id = " + empId + " and year in(" + year + ") ";
      }

      List tList = this.employeeLeaveDao.findBySql(sql);
      return tList != null && !tList.isEmpty()?((EmployeeLeave)tList.get(0)).getCompanyDays().doubleValue():0.0D;
   }

   public double findBreakHours(int empId, int year, String breaktime_type) throws Exception {
      HashMap params = new HashMap();
      params.put("emp_id", String.valueOf(empId));
      params.put("year", String.valueOf(year));
      params.put("type", breaktime_type);
      return this.breakTimeInfoService.getBreakHours(params);
   }
}
