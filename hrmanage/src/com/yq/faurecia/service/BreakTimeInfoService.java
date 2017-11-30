package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.util.Util;
import com.yq.common.dao.CommonDao;
import com.yq.faurecia.dao.BreakTimeInfoDao;
import com.yq.faurecia.dao.FlowStepDao;
import com.yq.faurecia.pojo.BreakTimeInfo;
import com.yq.faurecia.pojo.BreakTimeInfoHistory;
import com.yq.faurecia.pojo.FlowStep;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BreakTimeInfoService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   private String columns = " id,flow_id,wo_number, dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name, emp_id,(select zh_name from tb_employee_info where id=emp_id) emp_name, user_id,(select zh_name from tb_user_info where id=user_id) user_name, class_id,schedule_id,class_date,break_hour,year, type,begin_date,end_date,remark,available, check_emp_id,(select zh_name from tb_employee_info where id=check_emp_id) check_emp_name, check_state,check_state_date,check_remark,next_check_emp_id,status,upload_uuid,create_date,update_date ";
   @Resource
   private BreakTimeInfoDao breakTimeInfoDao;
   @Resource
   private FlowStepDao flowStepDao;
   @Resource
   private CommonDao commonDao;


   public BreakTimeInfo findById(Integer id) throws Exception {
      return this.breakTimeInfoDao.findById(id);
   }

   public BreakTimeInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public List queryByEmpIdAndClassDate(int emp_id, Date class_date) throws Exception {
      return this.queryByEmpIdAndClassDate(emp_id, class_date, (String)null, Integer.valueOf(2));
   }

   public List queryByEmpIdAndClassDate(int emp_id, Date class_date, String type, Integer state) throws Exception {
      if(emp_id != 0 && class_date != null) {
         String sql = " select " + this.columns + "   from tb_breaktime_info t " + "  where available=1 and class_date =\'" + this.sdf.format(class_date) + "\' and emp_id=" + emp_id + " " + "    " + (state == null?"":" and status=" + state + " ") + " " + "    " + (StringUtils.isEmpty(type)?"":"  and type in(" + type + ")  ") + "  ";
         return this.breakTimeInfoDao.findBySql(sql);
      } else {
         return null;
      }
   }

   public List queryByWO(String wo_number) throws Exception {
      if(StringUtils.isEmpty(wo_number)) {
         return null;
      } else {
         String sql = " select " + this.columns + "   from tb_breaktime_info t " + "  where available=1 and wo_number = \'" + wo_number + "\' ";
         return this.breakTimeInfoDao.findBySql(sql);
      }
   }

   public String getDeptNameByWO(String wo_number) {
      if(StringUtils.isEmpty(wo_number)) {
         return "";
      } else {
         List tmpBTI = null;
         String deptNames = "";

         try {
            HashSet e = new HashSet();
            tmpBTI = this.queryByWO(wo_number);
            if(tmpBTI != null && tmpBTI.size() > 0) {
               Iterator var6 = tmpBTI.iterator();

               while(var6.hasNext()) {
                  BreakTimeInfo name = (BreakTimeInfo)var6.next();
                  e.add(name.getDept_name());
               }

               String name1;
               for(var6 = e.iterator(); var6.hasNext(); deptNames = deptNames + name1 + ",") {
                  name1 = (String)var6.next();
               }

               e = null;
               tmpBTI = null;
               deptNames = deptNames.substring(0, deptNames.length() - 1);
            }
         } catch (Exception var7) {
            deptNames = "";
            var7.printStackTrace();
         }

         return deptNames;
      }
   }

   public BreakTimeInfo queryById(int id, Integer available) throws Exception {
      String available_s = "";
      if(available != null) {
         available_s = " and available=" + available + " ";
      }

      String sql = " select " + this.columns + " from tb_breaktime_info t " + " where id = " + id + available_s;
      return this.breakTimeInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(BreakTimeInfo breakTimeInfo) throws Exception {
      this.breakTimeInfoDao.save(breakTimeInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(BreakTimeInfo breakTimeInfo, FlowStep fs, BreakTimeInfoHistory breakTimeInfoHistory) throws Exception {
      if(breakTimeInfoHistory != null) {
         this.breakTimeInfoDao.saveHistory(breakTimeInfoHistory);
      }

      if(fs != null) {
         this.flowStepDao.save(fs);
      }

      this.breakTimeInfoDao.update(breakTimeInfo);
   }

   public BreakTimeInfoDao getBreakTimeInfoDao() {
      return this.breakTimeInfoDao;
   }

   public void setBreakTimeInfoDao(BreakTimeInfoDao breakTimeInfoDao) {
      this.breakTimeInfoDao = breakTimeInfoDao;
   }

   public List findByCondition(BreakTimeInfo breakTimeInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(breakTimeInfo != null) {
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
         sql1.append(" select * from ( ");
         sql1.append("select *,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber from ( ");
         sql1.append(this.getSql(breakTimeInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(breakTimeInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + breakTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(breakTimeInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + breakTimeInfo.getUser_name() + "%\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.breakTimeInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findCountByCondition(BreakTimeInfo breakTimeInfo) throws Exception {
      int count = 0;
      if(breakTimeInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(id) count from ( ");
         sql.append(this.getSql(breakTimeInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(breakTimeInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + breakTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(breakTimeInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + breakTimeInfo.getUser_name() + "%\' ");
         }

         List map = this.commonDao.findBySQL(sql.toString());
         if(map != null && map.size() > 0) {
            count = ((Integer)((Map)map.get(0)).get("count")).intValue();
         }
      }

      return count;
   }

   public List findWOByCondition(BreakTimeInfo breakTimeInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(breakTimeInfo != null) {
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
            orderby = "  order by t.count desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append(" select * from ( ");
         sql1.append(" select *,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber from ( ");
         sql1.append(" select wo_number,count(1) count,\'" + Global.flow_type[1] + "\' flow_type,min(begin_date) begin_date,max(end_date) end_date from ( ");
         sql1.append(this.getSql(breakTimeInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(breakTimeInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + breakTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(breakTimeInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + breakTimeInfo.getUser_name() + "%\' ");
         }

         sql1.append(" group by wo_number ");
         sql1.append(" ) t ");
         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.breakTimeInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findWOCountByCondition(BreakTimeInfo breakTimeInfo) throws Exception {
      int count = 0;
      if(breakTimeInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(1) count from ( ");
         sql.append(" select wo_number from ( ");
         sql.append(this.getSql(breakTimeInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(breakTimeInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + breakTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(breakTimeInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + breakTimeInfo.getUser_name() + "%\' ");
         }

         sql.append("  group by wo_number ");
         sql.append(" ) t");
         List map = this.commonDao.findBySQL(sql.toString());
         if(map != null && map.size() > 0) {
            count = ((Integer)((Map)map.get(0)).get("count")).intValue();
         }
      }

      return count;
   }

   private String getSql(BreakTimeInfo breakTimeInfo) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " ");
      sql.append(" from tb_breaktime_info t   ");
      sql.append(" where 1=1 ");
      if(!StringUtils.isEmpty(breakTimeInfo.getType())) {
         sql.append(" and t.type = \'" + breakTimeInfo.getType() + "\' ");
      }

      if(!StringUtils.isEmpty(breakTimeInfo.getWo_number())) {
         sql.append(" and t.wo_number = \'" + breakTimeInfo.getWo_number() + "\' ");
      }

      if(breakTimeInfo.getBreak_hour() != null) {
         sql.append(" and t.break_hour = " + breakTimeInfo.getBreak_hour() + " ");
      }

      if(breakTimeInfo.getAvailable() != null) {
         sql.append(" and t.available =" + breakTimeInfo.getAvailable() + " ");
      }

      if(breakTimeInfo.getCheck_state() != null) {
         sql.append(" and t.check_state =" + breakTimeInfo.getCheck_state() + " ");
      }

      if(!StringUtils.isEmpty(breakTimeInfo.getCheck_states())) {
         sql.append(" and t.check_state in(" + breakTimeInfo.getCheck_states() + ") ");
      }

      if(breakTimeInfo.getStatus() != null) {
         sql.append(" and t.status =" + breakTimeInfo.getStatus() + " ");
      }

      if(breakTimeInfo.getYear() != null) {
         sql.append(" and t.year =" + breakTimeInfo.getYear() + " ");
      }

      if(breakTimeInfo.getDept_id() != null) {
         sql.append(" and t.dept_id =" + breakTimeInfo.getDept_id() + " ");
      }

      if(!StringUtils.isEmpty(breakTimeInfo.getDept_ids())) {
         sql.append(" and t.dept_id in(" + breakTimeInfo.getDept_ids() + ") ");
      }

      if(breakTimeInfo.getNext_check_emp_id() != null) {
         sql.append(" and t.next_check_emp_id in(" + breakTimeInfo.getNext_check_emp_id() + ") ");
      }

      if(breakTimeInfo.getEmp_id() != null) {
         sql.append(" and t.emp_id in(" + breakTimeInfo.getEmp_id() + ") ");
      }

      if(breakTimeInfo.getUser_id() != null) {
         sql.append(" and t.user_id in(" + breakTimeInfo.getUser_id() + ") ");
      }

      if(breakTimeInfo.getClass_date() != null) {
         sql.append(" and CONVERT(varchar(100), t.class_date, 23) = \'" + this.sdf.format(breakTimeInfo.getClass_date()) + "\' ");
      }

      if(breakTimeInfo.getStart_date() != null) {
         sql.append(" and t.begin_date >= \'" + breakTimeInfo.getStart_date() + " 00:00:00\'");
      }

      if(breakTimeInfo.getOver_date() != null) {
         sql.append(" and t.end_date <= \'" + breakTimeInfo.getOver_date() + " 23:59:59\'");
      }

      if(breakTimeInfo.getBegin_date() != null && breakTimeInfo.getEnd_date() != null) {
         sql.append(" and (");
         sql.append(" (t.begin_date <= \'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' and t.end_date > \'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' and t.end_date <= \'" + this.sdf1.format(breakTimeInfo.getEnd_date()) + "\') or ");
         sql.append(" (\'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' <= t.begin_date and \'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' > t.end_date and \'" + this.sdf1.format(breakTimeInfo.getEnd_date()) + "\' <= t.end_date) or ");
         sql.append(" (t.begin_date <= \'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' and t.end_date >= \'" + this.sdf1.format(breakTimeInfo.getEnd_date()) + "\') or ");
         sql.append(" (\'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' <= t.begin_date and \'" + this.sdf1.format(breakTimeInfo.getEnd_date()) + "\' >= t.end_date) or ");
         sql.append(" (\'" + this.sdf1.format(breakTimeInfo.getBegin_date()) + "\' = t.begin_date and \'" + this.sdf1.format(breakTimeInfo.getEnd_date()) + "\' = t.end_date) ");
         sql.append(" ) ");
      }

      return sql.toString();
   }

   public double getBreakHours(Map params) throws Exception {
      Double days = Double.valueOf(0.0D);
      if(params != null && params.size() > 0 && !StringUtils.isEmpty((CharSequence)params.get("emp_id"))) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select sum(break_hour*1.0) hours  ");
         sql.append(" from   tb_breaktime_info ");
         sql.append(" where  available=1 ");
         sql.append(" and emp_id=" + (String)params.get("emp_id") + " ");
         if(!StringUtils.isEmpty((CharSequence)params.get("type"))) {
            if(!((String)params.get("type")).equals(Global.breaktime_type[2].split("\\|")[0]) && !((String)params.get("type")).equals(Global.breaktime_type[3].split("\\|")[0]) && !((String)params.get("type")).equals(Global.breaktime_type[0].split("\\|")[0])) {
               if(!StringUtils.isEmpty((CharSequence)params.get("year"))) {
                  sql.append(" and class_date >=\'" + (String)params.get("year") + "-01-01 00:00:00\' ");
                  sql.append(" and class_date <=\'" + (String)params.get("year") + "-12-31 23:59:59\' ");
               }
            } else if(!StringUtils.isEmpty((CharSequence)params.get("year"))) {
               sql.append(" and year=" + (String)params.get("year") + " ");
            }

            sql.append(" and type=\'" + (String)params.get("type") + "\' ");
         }

         List result = this.commonDao.findBySQL(sql.toString());
         if(result != null && result.size() > 0 && ((Map)result.get(0)).get("hours") != null) {
            days = Double.valueOf(((Double)((Map)result.get(0)).get("hours")).doubleValue());
            if(days == null) {
               days = Double.valueOf(0.0D);
            }
         }
      }

      return days.doubleValue();
   }

   public Map getBreakTimeTypeAndHours(Map leaveMap, Map overMap) {
      TreeMap breakContent = new TreeMap();
      String breakTimeName = null;
      double hours = 0.0D;
      Integer year;
      Iterator var8;
      if(leaveMap != null && leaveMap.size() > 0) {
         var8 = leaveMap.keySet().iterator();

         while(var8.hasNext()) {
            year = (Integer)var8.next();
            breakTimeName = (String)((Map)leaveMap.get(year)).get("annual_leave_name");
            if(!StringUtils.isEmpty(breakTimeName)) {
               hours = ((Double)((Map)leaveMap.get(year)).get("surplus_annual_leave")).doubleValue();
               if(hours > 0.0D) {
                  if(!breakContent.containsKey(breakTimeName)) {
                     breakContent.put(breakTimeName, new TreeMap());
                  }

                  ((Map)breakContent.get(breakTimeName)).put(year, Double.valueOf(hours));
               }
            }
         }
      }

      if(overMap != null && overMap.size() > 0) {
         var8 = overMap.keySet().iterator();

         while(var8.hasNext()) {
            year = (Integer)var8.next();
            breakTimeName = (String)((Map)overMap.get(year)).get("overtime_type");
            if(breakTimeName.equals(Global.overtime_type[0])) {
               breakTimeName = Global.breaktime_type[0].split("\\|")[0];
            }

            if(!StringUtils.isEmpty(breakTimeName)) {
               hours = ((Double)((Map)overMap.get(year)).get("surplus_over_hour")).doubleValue();
               if(hours > 0.0D) {
                  if(!breakContent.containsKey(breakTimeName)) {
                     breakContent.put(breakTimeName, new HashMap());
                  }

                  ((Map)breakContent.get(breakTimeName)).put(year, Double.valueOf(hours));
               }
            }
         }
      }

      if(breakContent.isEmpty() && leaveMap != null && leaveMap.size() > 0) {
         var8 = leaveMap.keySet().iterator();

         while(var8.hasNext()) {
            year = (Integer)var8.next();
            breakTimeName = (String)((Map)leaveMap.get(year)).get("company_leave_name");
            if(!StringUtils.isEmpty(breakTimeName)) {
               hours = ((Double)((Map)leaveMap.get(year)).get("surplus_company_leave")).doubleValue();
               if(hours > 0.0D) {
                  if(!breakContent.containsKey(breakTimeName)) {
                     breakContent.put(breakTimeName, new HashMap());
                  }

                  ((Map)breakContent.get(breakTimeName)).put(year, Double.valueOf(hours));
               }
            }
         }
      }

      leaveMap = null;
      overMap = null;
      return breakContent;
   }

   public String getLineBreakTimeTypeAndHours(Map leaveMap, int year) {
      String breakTimeName = "";
      double hours = 0.0D;
      if(leaveMap != null && leaveMap.size() > 0 && leaveMap.get(Integer.valueOf(year)) != null) {
         breakTimeName = (String)((Map)leaveMap.get(Integer.valueOf(year))).get("annual_leave_name");
         if(breakTimeName != null) {
            hours = ((Double)((Map)leaveMap.get(Integer.valueOf(year))).get("surplus_annual_leave")).doubleValue();
            if(hours > 0.0D) {
               return year + "|" + breakTimeName + "|" + hours;
            }
         }
      }

      if(leaveMap != null && leaveMap.size() > 0 && leaveMap.get(Integer.valueOf(year)) != null) {
         breakTimeName = (String)((Map)leaveMap.get(Integer.valueOf(year))).get("company_leave_name");
         if(breakTimeName != null) {
            hours = ((Double)((Map)leaveMap.get(Integer.valueOf(year))).get("surplus_company_leave")).doubleValue();
            if(hours > 0.0D) {
               return year + "|" + breakTimeName + "|" + hours;
            }
         }
      }

      return null;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateWoNumberForNull() throws Exception {
      String sql = " select " + this.columns + " from tb_breaktime_info t " + " where wo_number is null or wo_number =\'\' ";
      List list = this.breakTimeInfoDao.findBySql(sql);
      if(list != null && list.size() > 0) {
         Iterator var4 = list.iterator();

         while(var4.hasNext()) {
            BreakTimeInfo si = (BreakTimeInfo)var4.next();
            sql = "update tb_breaktime_info set wo_number = \'" + Util.getNumber() + "\' where id=" + si.getId();
            this.commonDao.executeBySQL(sql);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveHistory(BreakTimeInfoHistory breakTimeInfoHistory) throws Exception {
      this.breakTimeInfoDao.saveHistory(breakTimeInfoHistory);
   }
}
