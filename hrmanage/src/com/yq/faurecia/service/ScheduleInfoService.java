package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.common.dao.CommonDao;
import com.yq.faurecia.dao.FlowStepDao;
import com.yq.faurecia.dao.ScheduleInfoDao;
import com.yq.faurecia.pojo.ClassInfo;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.FlowStep;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.pojo.ScheduleInfoHistory;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ScheduleInfoService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   private String columns = " id,wo_number,flow_id, dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name, emp_id,(select zh_name from tb_employee_info where id=emp_id) emp_name, user_id,(select zh_name from tb_user_info where id=user_id) user_name, class_name,class_id,begin_time,end_time,type,hours,have_meals,meals,over_hour,begin_date,end_date,remark,available, check_emp_id,(select zh_name from tb_employee_info where id=check_emp_id) check_emp_name, check_state,check_state_date,check_remark,next_check_emp_id,status,create_date,update_date ";
   @Resource
   private ScheduleInfoDao scheduleInfoDao;
   @Resource
   private FlowStepDao flowStepDao;
   @Resource
   private CommonDao commonDao;


   public ScheduleInfo findById(Integer id) throws Exception {
      return this.scheduleInfoDao.findById(id);
   }

   public ScheduleInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public ScheduleInfo queryById(int id, Integer available) throws Exception {
      String available_s = "";
      if(available != null) {
         available_s = " and available=" + available + " ";
      }

      String sql = " select " + this.columns + " from tb_schedule_info t " + " where id = " + id + available_s;
      return this.scheduleInfoDao.queryObjectBySql(sql);
   }

   public ScheduleInfo queryByEmpId(int emp_id, Date class_date) throws Exception {
      if(emp_id != 0 && class_date != null) {
         String sql = " select " + this.columns + " from tb_schedule_info t " + " where available=1 and status=2 and emp_id=" + emp_id + " and begin_date =\'" + this.sdf.format(class_date) + "\' ";
         return this.scheduleInfoDao.queryObjectBySql(sql);
      } else {
         return null;
      }
   }

   public List queryByWO(String wo_number) throws Exception {
      if(StringUtils.isEmpty(wo_number)) {
         return null;
      } else {
         String sql = " select " + this.columns + "   from tb_schedule_info t " + "  where available=1 and wo_number = \'" + wo_number + "\' ";
         return this.scheduleInfoDao.findBySql(sql);
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
                  ScheduleInfo name = (ScheduleInfo)var6.next();
                  e.add("【" + StringUtils.defaultString(name.getDept_name(), "") + "\t|\t" + StringUtils.defaultString(name.getClass_name(), "") + "】");
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

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(ScheduleInfo scheduleInfo) throws Exception {
      if(!StringUtils.isEmpty(scheduleInfo.getEmp_ids())) {
         ScheduleInfo si = new ScheduleInfo();
         ReflectPOJO.alternateObject(si, scheduleInfo);
         Date begin_date = si.getBegin_date();
         String begin_time = si.getBegin_time();
         double over_hour = si.getOver_hour().doubleValue();
         double hours = si.getHours().doubleValue();
         int have_meals = si.getHave_meals().intValue();
         Date b_begin_date = Util.parseDateStr(this.sdf.format(begin_date) + " " + begin_time);
         Date b_end_date = new Date(b_begin_date.getTime() + Util.getTimeInMillis(over_hour, "h") + Util.getTimeInMillis(hours, "h") + Util.getTimeInMillis((double)have_meals, "m"));
         si.setEnd_date(this.sdf.parse(this.sdf.format(b_end_date)));
         this.scheduleInfoDao.save(si);
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ScheduleInfo scheduleInfo, FlowStep fs, ScheduleInfoHistory scheduleInfoHistory) throws Exception {
      if(scheduleInfoHistory != null) {
         this.scheduleInfoDao.saveHistory(scheduleInfoHistory);
      }

      if(fs != null) {
         this.flowStepDao.save(fs);
      }

      this.scheduleInfoDao.update(scheduleInfo);
   }

   public ScheduleInfoDao getScheduleInfoDao() {
      return this.scheduleInfoDao;
   }

   public void setScheduleInfoDao(ScheduleInfoDao scheduleInfoDao) {
      this.scheduleInfoDao = scheduleInfoDao;
   }

   public List findByCondition(ScheduleInfo scheduleInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(scheduleInfo != null) {
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
         sql1.append(this.getSql(scheduleInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(scheduleInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + scheduleInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(scheduleInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + scheduleInfo.getUser_name() + "%\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.scheduleInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findCountByCondition(ScheduleInfo scheduleInfo) throws Exception {
      int count = 0;
      if(scheduleInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(id) count from ( ");
         sql.append(this.getSql(scheduleInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(scheduleInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + scheduleInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(scheduleInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + scheduleInfo.getUser_name() + "%\' ");
         }

         List map = this.commonDao.findBySQL(sql.toString());
         if(map != null && map.size() > 0) {
            count = ((Integer)((Map)map.get(0)).get("count")).intValue();
         }
      }

      return count;
   }

   public List findWOByCondition(ScheduleInfo scheduleInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(scheduleInfo != null) {
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
         sql1.append(" select wo_number,count(1) count,\'" + Global.flow_type[0] + "\' flow_type,min(CONVERT(datetime, CONVERT(varchar(100), begin_date, 23)+\' \'+begin_time, 120)) begin_date,max(CONVERT(datetime, CONVERT(varchar(100), end_date, 23)+\' \'+end_time, 120)) end_date from ( ");
         sql1.append(this.getSql(scheduleInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(scheduleInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + scheduleInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(scheduleInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + scheduleInfo.getUser_name() + "%\' ");
         }

         sql1.append(" group by wo_number ");
         sql1.append(" ) t ");
         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.scheduleInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findWOCountByCondition(ScheduleInfo scheduleInfo) throws Exception {
      int count = 0;
      if(scheduleInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(1) count from ( ");
         sql.append(" select wo_number from ( ");
         sql.append(this.getSql(scheduleInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(scheduleInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + scheduleInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(scheduleInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + scheduleInfo.getUser_name() + "%\' ");
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

   public ScheduleInfo findDateByEmpId(int emp_id, Date date) throws Exception {
      if(emp_id != 0 && date != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns + " ");
         sql.append(" from tb_schedule_info t   ");
         sql.append(" where t.available = 1 and emp_id=" + emp_id);
         sql.append(" and \'" + this.sdf.format(date) + " 00:00:00\' <= t.begin_date");
         sql.append(" and \'" + this.sdf.format(date) + " 23:59:59\' >= t.begin_date");
         List result = this.scheduleInfoDao.findBySql(sql.toString());
         return result != null && !result.isEmpty() && result.size() == 1?(ScheduleInfo)result.get(0):null;
      } else {
         return null;
      }
   }

   public ScheduleInfo findContainsDateByEmpId(int emp_id, Date date) throws Exception {
      if(emp_id != 0 && date != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns + " ");
         sql.append(" from tb_schedule_info t   ");
         sql.append(" where t.available = 1 and emp_id=" + emp_id);
         sql.append(" and Convert(datetime,CONVERT(varchar(100), t.begin_date, 23)+\' \'+t.begin_time,20) <= \'" + this.sdf1.format(date) + "\'");
         sql.append(" and Convert(datetime,CONVERT(varchar(100), t.end_date, 23)+\' \'+t.end_time,20) >= \'" + this.sdf1.format(date) + "\'");
         List result = this.scheduleInfoDao.findBySql(sql.toString());
         return result != null && !result.isEmpty() && result.size() == 1?(ScheduleInfo)result.get(0):null;
      } else {
         return null;
      }
   }

   public List findByMap(Map map) throws Exception {
      Object result = new ArrayList();
      if(map != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(this.getSqlByMap(map));
         result = this.scheduleInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   private String getSql(ScheduleInfo scheduleInfo) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " ");
      sql.append(" from tb_schedule_info t   ");
      sql.append(" where 1=1 ");
      if(!StringUtils.isEmpty(scheduleInfo.getType())) {
         sql.append(" and t.type = \'" + scheduleInfo.getType() + "\' ");
      }

      if(!StringUtils.isEmpty(scheduleInfo.getWo_number())) {
         sql.append(" and t.wo_number = \'" + scheduleInfo.getWo_number() + "\' ");
      }

      if(scheduleInfo.getAvailable() != null) {
         sql.append(" and t.available =" + scheduleInfo.getAvailable() + " ");
      }

      if(scheduleInfo.getId() != null) {
         sql.append(" and t.id =" + scheduleInfo.getId() + " ");
      }

      if(scheduleInfo.getNoId() != null) {
         sql.append(" and t.id not in(" + scheduleInfo.getNoId() + ") ");
      }

      if(scheduleInfo.getCheck_state() != null) {
         sql.append(" and t.check_state =" + scheduleInfo.getCheck_state() + " ");
      }

      if(!StringUtils.isEmpty(scheduleInfo.getCheck_states())) {
         sql.append(" and t.check_state in(" + scheduleInfo.getCheck_states() + ") ");
      }

      if(scheduleInfo.getStatus() != null) {
         sql.append(" and t.status =" + scheduleInfo.getStatus() + " ");
      }

      if(scheduleInfo.getClass_id() != null) {
         sql.append(" and t.class_id =" + scheduleInfo.getClass_id() + " ");
      }

      if(scheduleInfo.getDept_id() != null) {
         sql.append(" and t.dept_id =" + scheduleInfo.getDept_id() + " ");
      }

      if(!StringUtils.isEmpty(scheduleInfo.getDept_ids())) {
         sql.append(" and t.dept_id in(" + scheduleInfo.getDept_ids() + ") ");
      }

      if(scheduleInfo.getNext_check_emp_id() != null) {
         sql.append(" and t.next_check_emp_id in(" + scheduleInfo.getNext_check_emp_id() + ") ");
      }

      if(scheduleInfo.getEmp_id() != null) {
         sql.append(" and t.emp_id in(" + scheduleInfo.getEmp_id() + ") ");
      }

      if(scheduleInfo.getUser_id() != null) {
         sql.append(" and t.user_id in(" + scheduleInfo.getUser_id() + ") ");
      }

      if(scheduleInfo.getBegin_date() != null) {
         sql.append(" and t.begin_date >= \'" + this.sdf.format(scheduleInfo.getBegin_date()) + " 00:00:00\'");
      }

      if(scheduleInfo.getEnd_date() != null) {
         sql.append(" and t.end_date <= \'" + this.sdf.format(scheduleInfo.getEnd_date()) + " 23:59:59\'");
      }

      if(scheduleInfo.getStart_date() != null) {
         sql.append(" and t.begin_date >= \'" + scheduleInfo.getStart_date() + " 00:00:00\'");
      }

      if(scheduleInfo.getOver_date() != null) {
         sql.append(" and t.end_date <= \'" + scheduleInfo.getOver_date() + " 23:59:59\'");
      }

      if(!StringUtils.isEmpty(scheduleInfo.getTmp_date())) {
         if(scheduleInfo.getTmp_date().trim().lastIndexOf(39) == -1) {
            scheduleInfo.setTmp_date("\'" + scheduleInfo.getTmp_date() + "\'");
         }

         sql.append(" and CONVERT(varchar(100), t.begin_date, 23) in(" + scheduleInfo.getTmp_date() + ") ");
      }

      return sql.toString();
   }

   private String getSqlByMap(Map map) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " ");
      sql.append(" from tb_schedule_info t   ");
      sql.append(" where t.available = 1 ");
      if(!StringUtils.isEmpty((CharSequence)map.get("class_date"))) {
         sql.append(" and t.begin_date = \'" + (String)map.get("class_date") + "\' ");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("begin_date"))) {
         sql.append(" and \'" + (String)map.get("begin_date") + "\' >= Convert(datetime,CONVERT(varchar(100), t.begin_date, 23)+\' \'+begin_time,20)  ");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("end_date"))) {
         sql.append(" and \'" + (String)map.get("end_date") + "\' <= Convert(datetime,CONVERT(varchar(100), t.end_date, 23)+\' \'+end_time,20)  ");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("start_date"))) {
         sql.append(" and t.begin_date <= \'" + (String)map.get("start_date") + "\'");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("over_date"))) {
         sql.append(" and t.end_date >= \'" + (String)map.get("over_date") + "\'");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("emp_id"))) {
         sql.append(" and t.emp_id = " + (String)map.get("emp_id") + " ");
      }

      if(!StringUtils.isEmpty((CharSequence)map.get("class_id"))) {
         sql.append(" and t.class_id = " + (String)map.get("class_id") + " ");
      }

      return sql.toString();
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateWoNumberForNull() throws Exception {
      String sql = " select " + this.columns + " from tb_schedule_info t " + " where wo_number is null or wo_number =\'\' ";
      List list = this.scheduleInfoDao.findBySql(sql);
      if(list != null && list.size() > 0) {
         Iterator var4 = list.iterator();

         while(var4.hasNext()) {
            ScheduleInfo si = (ScheduleInfo)var4.next();
            sql = "update tb_schedule_info set wo_number = \'" + Util.getNumber() + "\' where id=" + si.getId();
            this.commonDao.executeBySQL(sql);
         }
      }

   }

   public ScheduleInfo getOfficeClassInfo(Date class_date) {
      if(class_date == null) {
         return null;
      } else {
         try {
            class_date = this.sdf.parse(this.sdf.format(class_date));
         } catch (ParseException var4) {
            var4.printStackTrace();
            return null;
         }

         ClassInfo ci = (ClassInfo)Global.classInfoMap.get(Global.class_code_default[0]);
         ScheduleInfo scheduleInfo = new ScheduleInfo();
         scheduleInfo.setId(Integer.valueOf(0));
         scheduleInfo.setClass_id(ci.getId());
         scheduleInfo.setType(Global.schedule_type[0]);
         scheduleInfo.setClass_name(ci.getClass_name());
         scheduleInfo.setHours(ci.getHours());
         scheduleInfo.setOver_hour(ci.getOver_hour());
         scheduleInfo.setMeals(ci.getMeals());
         scheduleInfo.setHave_meals(ci.getHave_meals());
         scheduleInfo.setBegin_date(class_date);
         scheduleInfo.setEnd_date(class_date);
         scheduleInfo.setBegin_time(ci.getBegin_time());
         scheduleInfo.setEnd_time(ci.getEnd_time());
         return scheduleInfo;
      }
   }

   public ScheduleInfo findSchedule(int emp_id, Date date) throws Exception {
      return ((EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id))).getType().equals(Global.employee_type[0])?(this.sdf1.format(date).indexOf("00:00:00") > -1?this.findDateByEmpId(emp_id, date):this.findContainsDateByEmpId(emp_id, date)):(((EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id))).getType().equals(Global.employee_type[1])?this.getOfficeClassInfo(date):null);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveHistory(ScheduleInfoHistory scheduleInfoHistory) throws Exception {
      this.scheduleInfoDao.saveHistory(scheduleInfoHistory);
   }
}
