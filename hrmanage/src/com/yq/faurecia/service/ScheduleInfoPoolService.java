package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.common.dao.CommonDao;
import com.yq.faurecia.dao.ScheduleInfoPoolDao;
import com.yq.faurecia.pojo.ScheduleInfoPool;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
public class ScheduleInfoPoolService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private String columns = " id, wo_number,dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name, emp_id,(select zh_name from tb_employee_info where id=emp_id) emp_name, user_id,(select zh_name from tb_user_info where id=user_id) user_name, class_name,class_id,begin_time,end_time,type,hours,have_meals,meals,over_hour,begin_date,end_date,remark,available, create_date,update_date ";
   @Resource
   private ScheduleInfoPoolDao scheduleInfoPoolDao;
   @Resource
   private CommonDao commonDao;


   public ScheduleInfoPool queryPoolById(int id) throws Exception {
      return this.queryPoolById(id, Integer.valueOf(1));
   }

   public ScheduleInfoPool queryPoolById(int id, Integer available) throws Exception {
      String available_s = "";
      if(available != null) {
         available_s = " and available=" + available + " ";
      }

      String sql = " select " + this.columns + " from tb_schedule_info_pool t " + " where id = " + id + available_s;
      return this.scheduleInfoPoolDao.queryObjectPoolBySql(sql);
   }

   public List queryByWO(String wo_number) throws Exception {
      if(StringUtils.isEmpty(wo_number)) {
         return null;
      } else {
         String sql = " select " + this.columns + "   from tb_schedule_info_pool t " + "  where available=1 and wo_number = \'" + wo_number + "\' ";
         return this.scheduleInfoPoolDao.findPoolBySql(sql);
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
                  ScheduleInfoPool name = (ScheduleInfoPool)var6.next();
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

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void savePool(ScheduleInfoPool scheduleInfo) throws Exception {
      if(!StringUtils.isEmpty(scheduleInfo.getEmp_ids())) {
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         Calendar c = Calendar.getInstance();
         long diff_days = Util.getDaySub(scheduleInfo.getBegin_date(), scheduleInfo.getEnd_date());
         c.setTime(scheduleInfo.getBegin_date());

         for(int i = 0; (long)i < diff_days; ++i) {
            ScheduleInfoPool si = new ScheduleInfoPool();
            ReflectPOJO.alternateObject(si, scheduleInfo);
            si.setBegin_date(c.getTime());
            Date begin_date = si.getBegin_date();
            String begin_time = si.getBegin_time();
            double over_hour = si.getOver_hour().doubleValue();
            double hours = si.getHours().doubleValue();
            int have_meals = si.getHave_meals().intValue();
            Date b_begin_date = Util.parseDateStr(sdf.format(begin_date) + " " + begin_time);
            Date b_end_date = new Date(b_begin_date.getTime() + Util.getTimeInMillis(over_hour, "h") + Util.getTimeInMillis(hours, "h") + Util.getTimeInMillis((double)have_meals, "m"));
            si.setEnd_date(sdf.parse(sdf.format(b_end_date)));
            this.scheduleInfoPoolDao.savePool(si);
            c.add(5, 1);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updatePool(ScheduleInfoPool scheduleInfo) throws Exception {
      this.scheduleInfoPoolDao.updatePool(scheduleInfo);
   }

   public ScheduleInfoPoolDao getScheduleInfoPoolDao() {
      return this.scheduleInfoPoolDao;
   }

   public void setScheduleInfoPoolDao(ScheduleInfoPoolDao scheduleInfoPoolDao) {
      this.scheduleInfoPoolDao = scheduleInfoPoolDao;
   }

   public List findPoolByCondition(ScheduleInfoPool scheduleInfo, Page page) throws Exception {
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
         result = this.scheduleInfoPoolDao.findPoolBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findPoolCountByCondition(ScheduleInfoPool scheduleInfo) throws Exception {
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

   public List findWOByCondition(ScheduleInfoPool scheduleInfo, Page page) throws Exception {
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
         result = this.scheduleInfoPoolDao.findPoolBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findWOCountByCondition(ScheduleInfoPool scheduleInfo) throws Exception {
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

   private String getSql(ScheduleInfoPool scheduleInfo) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " ");
      sql.append(" from tb_schedule_info_pool t   ");
      sql.append(" where 1=1 ");
      if(!StringUtils.isEmpty(scheduleInfo.getType())) {
         sql.append(" and t.type = \'" + scheduleInfo.getType() + "\' ");
      }

      if(!StringUtils.isEmpty(scheduleInfo.getWo_number())) {
         sql.append(" and t.wo_number in(\'" + scheduleInfo.getWo_number().replace("\'", "").replace(",", "\',\'") + "\'" + ") ");
      }

      if(scheduleInfo.getAvailable() != null) {
         sql.append(" and t.available =" + scheduleInfo.getAvailable() + " ");
      }

      if(scheduleInfo.getId() != null) {
         sql.append(" and t.id =" + scheduleInfo.getId() + " ");
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

      if(scheduleInfo.getEmp_id() != null) {
         sql.append(" and t.emp_id in(" + scheduleInfo.getEmp_id() + ") ");
      }

      if(scheduleInfo.getBegin_date() != null) {
         sql.append(" and t.begin_date >= \'" + this.sdf.format(scheduleInfo.getBegin_date()) + " 00:00:00\'");
      }

      if(scheduleInfo.getEnd_date() != null) {
         sql.append(" and t.end_date <= \'" + this.sdf.format(scheduleInfo.getEnd_date()) + " 23:59:59\'");
      }

      if(scheduleInfo.getTmp_date() != null) {
         sql.append(" and CONVERT(varchar(100), t.begin_date, 23) in(" + scheduleInfo.getTmp_date() + ") ");
      }

      return sql.toString();
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateWoNumberForNull() throws Exception {
      String sql = " select " + this.columns + " from tb_schedule_info_pool t " + " where wo_number is null or wo_number =\'\' ";
      List list = this.scheduleInfoPoolDao.findPoolBySql(sql);
      if(list != null && list.size() > 0) {
         Iterator var4 = list.iterator();

         while(var4.hasNext()) {
            ScheduleInfoPool si = (ScheduleInfoPool)var4.next();
            sql = "update tb_schedule_info_pool set wo_number = \'" + Util.getNumber() + "\' where id=" + si.getId();
            this.commonDao.executeBySQL(sql);
         }
      }

   }
}
