package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.util.Util;
import com.yq.common.dao.CommonDao;
import com.yq.faurecia.dao.FlowStepDao;
import com.yq.faurecia.dao.OverTimeInfoDao;
import com.yq.faurecia.pojo.FlowStep;
import com.yq.faurecia.pojo.OverTimeInfo;
import com.yq.faurecia.pojo.OverTimeInfoHistory;
import com.yq.faurecia.service.BreakTimeInfoService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OverTimeInfoService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   private String columns = " id,flow_id,wo_number, dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name, emp_id,(select zh_name from tb_employee_info where id=emp_id) emp_name, user_id,(select zh_name from tb_user_info where id=user_id) user_name, type,begin_date,end_date,over_hour,day_or_hour,year,remark,available, check_emp_id,(select zh_name from tb_employee_info where id=check_emp_id) check_emp_name, check_state,check_state_date,check_remark,next_check_emp_id,status,create_date,update_date ";
   @Resource
   private OverTimeInfoDao overTimeInfoDao;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private FlowStepDao flowStepDao;
   @Resource
   private CommonDao commonDao;


   public OverTimeInfo findById(Integer id) throws Exception {
      return this.overTimeInfoDao.findById(id);
   }

   public OverTimeInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public List queryByEmpIdAndClassDate(int emp_id, Date class_date, String type) throws Exception {
      if(emp_id != 0 && class_date != null) {
         String sql = " select " + this.columns + "   from tb_overtime_info t " + "  where available=1 and status=2 and emp_id=" + emp_id + " " + "    and begin_date >=\'" + this.sdf.format(class_date) + " 00:00:00\' " + "\t and begin_date <=\'" + this.sdf.format(class_date) + " 23:59:59\' " + (StringUtils.isEmpty(type)?"":"\t and type=\'" + type + "\'  ");
         return this.overTimeInfoDao.findBySql(sql);
      } else {
         return null;
      }
   }

   public List queryByWO(String wo_number) throws Exception {
      if(StringUtils.isEmpty(wo_number)) {
         return null;
      } else {
         String sql = " select " + this.columns + "   from tb_overtime_info t " + "  where available=1 and wo_number = \'" + wo_number + "\' ";
         return this.overTimeInfoDao.findBySql(sql);
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
                  OverTimeInfo name = (OverTimeInfo)var6.next();
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

   public OverTimeInfo queryById(int id, Integer available) throws Exception {
      String available_s = "";
      if(available != null) {
         available_s = " and available=" + available + " ";
      }

      String sql = " select " + this.columns + " from tb_overtime_info t " + " where id = " + id + available_s;
      return this.overTimeInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(OverTimeInfo overTimeInfo) throws Exception {
      this.overTimeInfoDao.save(overTimeInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(OverTimeInfo overTimeInfo, FlowStep fs, OverTimeInfoHistory overTimeInfoHistory) throws Exception {
      if(overTimeInfoHistory != null) {
         this.overTimeInfoDao.saveHistory(overTimeInfoHistory);
      }

      if(fs != null) {
         this.flowStepDao.save(fs);
      }

      this.overTimeInfoDao.update(overTimeInfo);
   }

   public OverTimeInfoDao getOverTimeInfoDao() {
      return this.overTimeInfoDao;
   }

   public void setOverTimeInfoDao(OverTimeInfoDao overTimeInfoDao) {
      this.overTimeInfoDao = overTimeInfoDao;
   }

   public List findByCondition(OverTimeInfo overTimeInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(overTimeInfo != null) {
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
         sql1.append(this.getSql(overTimeInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(overTimeInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + overTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(overTimeInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + overTimeInfo.getUser_name() + "%\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.overTimeInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findCountByCondition(OverTimeInfo overTimeInfo) throws Exception {
      int count = 0;
      if(overTimeInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(id) count from ( ");
         sql.append(this.getSql(overTimeInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(overTimeInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + overTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(overTimeInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + overTimeInfo.getUser_name() + "%\' ");
         }

         List map = this.commonDao.findBySQL(sql.toString());
         if(map != null && map.size() > 0) {
            count = ((Integer)((Map)map.get(0)).get("count")).intValue();
         }
      }

      return count;
   }

   public List findWOByCondition(OverTimeInfo overTimeInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(overTimeInfo != null) {
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
         sql1.append(" select wo_number,count(1) count,\'" + Global.flow_type[2] + "\' flow_type,min(begin_date) begin_date,max(end_date) end_date from ( ");
         sql1.append(this.getSql(overTimeInfo));
         sql1.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(overTimeInfo.getEmp_name())) {
            sql1.append(" and t.emp_name like \'%" + overTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(overTimeInfo.getUser_name())) {
            sql1.append(" and t.user_name like \'%" + overTimeInfo.getUser_name() + "%\' ");
         }

         sql1.append(" group by wo_number ");
         sql1.append(" ) t ");
         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.overTimeInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findWOCountByCondition(OverTimeInfo overTimeInfo) throws Exception {
      int count = 0;
      if(overTimeInfo != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select count(1) count from ( ");
         sql.append(" select wo_number from ( ");
         sql.append(this.getSql(overTimeInfo));
         sql.append(" ) t where 1=1 ");
         if(!StringUtils.isEmpty(overTimeInfo.getEmp_name())) {
            sql.append(" and t.emp_name like \'%" + overTimeInfo.getEmp_name() + "%\' ");
         }

         if(!StringUtils.isEmpty(overTimeInfo.getUser_name())) {
            sql.append(" and t.user_name like \'%" + overTimeInfo.getUser_name() + "%\' ");
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

   private String getSql(OverTimeInfo overTimeInfo) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " ");
      sql.append(" from tb_overtime_info t   ");
      sql.append(" where 1=1 ");
      if(!StringUtils.isEmpty(overTimeInfo.getType())) {
         sql.append(" and t.type = \'" + overTimeInfo.getType() + "\' ");
      }

      if(!StringUtils.isEmpty(overTimeInfo.getWo_number())) {
         sql.append(" and t.wo_number = \'" + overTimeInfo.getWo_number() + "\' ");
      }

      if(overTimeInfo.getAvailable() != null) {
         sql.append(" and t.available =" + overTimeInfo.getAvailable() + " ");
      }

      if(overTimeInfo.getCheck_state() != null) {
         sql.append(" and t.check_state =" + overTimeInfo.getCheck_state() + " ");
      }

      if(!StringUtils.isEmpty(overTimeInfo.getCheck_states())) {
         sql.append(" and t.check_state in(" + overTimeInfo.getCheck_states() + ") ");
      }

      if(overTimeInfo.getStatus() != null) {
         sql.append(" and t.status =" + overTimeInfo.getStatus() + " ");
      }

      if(overTimeInfo.getDept_id() != null) {
         sql.append(" and t.dept_id =" + overTimeInfo.getDept_id() + " ");
      }

      if(!StringUtils.isEmpty(overTimeInfo.getDept_ids())) {
         sql.append(" and t.dept_id in(" + overTimeInfo.getDept_ids() + ") ");
      }

      if(overTimeInfo.getNext_check_emp_id() != null) {
         sql.append(" and t.next_check_emp_id in(" + overTimeInfo.getNext_check_emp_id() + ") ");
      }

      if(overTimeInfo.getEmp_id() != null) {
         sql.append(" and t.emp_id in(" + overTimeInfo.getEmp_id() + ") ");
      }

      if(overTimeInfo.getUser_id() != null) {
         sql.append(" and t.user_id in(" + overTimeInfo.getUser_id() + ") ");
      }

      if(!StringUtils.isEmpty(overTimeInfo.getTmp_date())) {
         sql.append(" and (");
         String[] var6;
         int var5 = (var6 = overTimeInfo.getTmp_date().split(",")).length;

         for(int var4 = 0; var4 < var5; ++var4) {
            String date = var6[var4];
            if(date.trim().lastIndexOf(39) == -1) {
               date = "\'" + date.trim() + "\'";
            }

            sql.append(" (CONVERT(varchar(100), t.begin_date, 23) <= " + date + " and CONVERT(varchar(100), t.end_date, 23) >= " + date + ") or");
         }

         sql.delete(sql.length() - 2, sql.length());
         sql.append(" ) ");
      }

      if(overTimeInfo.getStart_date() != null) {
         sql.append(" and t.begin_date >= \'" + overTimeInfo.getStart_date() + " 00:00:00\'");
      }

      if(overTimeInfo.getOver_date() != null) {
         sql.append(" and t.end_date <= \'" + overTimeInfo.getOver_date() + " 23:59:59\'");
      }

      if(overTimeInfo.getBegin_date() != null && overTimeInfo.getEnd_date() != null) {
         sql.append(" and (");
         sql.append(" (t.begin_date <= \'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' and t.end_date > \'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' and t.end_date <= \'" + this.sdf1.format(overTimeInfo.getEnd_date()) + "\') or ");
         sql.append(" (\'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' <= t.begin_date and \'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' > t.end_date and \'" + this.sdf1.format(overTimeInfo.getEnd_date()) + "\' <= t.end_date) or ");
         sql.append(" (t.begin_date <= \'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' and t.end_date >= \'" + this.sdf1.format(overTimeInfo.getEnd_date()) + "\') or ");
         sql.append(" (\'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' <= t.begin_date and \'" + this.sdf1.format(overTimeInfo.getEnd_date()) + "\' >= t.end_date) or ");
         sql.append(" (\'" + this.sdf1.format(overTimeInfo.getBegin_date()) + "\' = t.begin_date and \'" + this.sdf1.format(overTimeInfo.getEnd_date()) + "\' = t.end_date) ");
         sql.append(" ) ");
      }

      return sql.toString();
   }

   public Map findStandardOverHour(int empId) throws Exception {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String time = Global.clear_over_mm_dd;
      Calendar c = Calendar.getInstance();
      StringBuffer sb = new StringBuffer("");
      int nowYear = c.get(1);
      sb.append(nowYear);
      if(c.getTime().getTime() <= sdf.parse(nowYear + "-" + time).getTime()) {
         c.add(1, -1);
         sb.append("," + c.get(1));
      }

      String sql = "select emp_id,year,sum(over_hour) over_hour from ( ";
      sql = sql + " select emp_id,year,over_hour from tb_employee_leave_2016  where emp_id = " + empId + "  and year in(" + sb.toString() + ") ";
      sql = sql + " union all  select emp_id,year,sum(over_hour) over_hour from tb_overtime_info  where available=1 and status=" + Global.flow_check_status[2] + " and type=\'" + Global.overtime_type[0] + "\' and emp_id = " + empId + "  and year in(" + sb.toString() + ") " + " group by emp_id,year ";
      sql = sql + " ) t group by emp_id,year ";
      List els = this.overTimeInfoDao.findBySql(sql);
      HashMap map = null;
      if(els != null && els.size() > 0) {
         map = new HashMap();
         Iterator year = els.iterator();

         while(year.hasNext()) {
            OverTimeInfo overMap = (OverTimeInfo)year.next();
            if(overMap.getOver_hour().doubleValue() > 0.0D) {
               map.put(overMap.getYear(), overMap);
            }
         }
      }

      ConcurrentHashMap overMap1 = new ConcurrentHashMap();
      if(map != null && map.size() > 0) {
         Iterator var12 = map.keySet().iterator();

         while(var12.hasNext()) {
            Integer year1 = (Integer)var12.next();
            OverTimeInfo el = (OverTimeInfo)map.get(year1);
            HashMap params = new HashMap();
            params.put("emp_id", String.valueOf(empId));
            params.put("year", "" + year1);
            params.put("type", Global.breaktime_type[0].split("\\|")[0]);
            double over_hours = this.breakTimeInfoService.getBreakHours(params);
            ConcurrentHashMap overSubMap = new ConcurrentHashMap();
            overSubMap.put("emp_id", Integer.valueOf(empId));
            overSubMap.put("year", year1);
            overSubMap.put("overtime_type", Global.overtime_type[0]);
            overSubMap.put("standard_over_hour", el.getOver_hour());
            overSubMap.put("over_hour", Double.valueOf(over_hours));
            overSubMap.put("surplus_over_hour", Double.valueOf(el.getOver_hour().doubleValue() - over_hours));
            overMap1.put(year1, overSubMap);
         }
      }

      map = null;
      els = null;
      return overMap1;
   }

   public Map findStandardOverHour(int empId, int year) throws Exception {
      Map overMap = this.findStandardOverHour(empId);
      return (Map)overMap.get(Integer.valueOf(year));
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateWoNumberForNull() throws Exception {
      String sql = " select " + this.columns + " from tb_overtime_info t " + " where wo_number is null or wo_number =\'\' ";
      List list = this.overTimeInfoDao.findBySql(sql);
      if(list != null && list.size() > 0) {
         Iterator var4 = list.iterator();

         while(var4.hasNext()) {
            OverTimeInfo si = (OverTimeInfo)var4.next();
            sql = "update tb_overtime_info set wo_number = \'" + Util.getNumber() + "\' where id=" + si.getId();
            this.commonDao.executeBySQL(sql);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveHistory(OverTimeInfoHistory overTimeInfoHistory) throws Exception {
      this.overTimeInfoDao.saveHistory(overTimeInfoHistory);
   }
}
