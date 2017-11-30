package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.common.dao.CommonDao;
import com.yq.faurecia.dao.TimeSheetDao;
import com.yq.faurecia.pojo.TimeSheet;
import com.yq.faurecia.pojo.TimeSheetDetail;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("timeSheetService")
public class TimeSheetService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   private String columns = " id, emp_id,card_id, inner_date,type,ip,source,operater,create_date ";
   private String columns_detail = " id,emp_id,class_date,class_name,class_begin_date,class_end_date,ts_begin_date,ts_end_date,arrive_work_hours,breaktime_type,breaktime_begin_date,breaktime_end_date,absence_hours,hour50,ot1_hours,ot2_hours,ot3_hours,deficit_hours,shift1_number,shift2_number,abnormal_cause,ts_number,tb_01,tb_02,class_type,should_work_hours,over_hour,shift3_number,create_date,update_date ";
   private String columns_detail_sum = " emp_id,sum(arrive_work_hours) arrive_work_hours,sum(absence_hours) absence_hours,sum(hour50) hour50,sum(ot1_hours) ot1_hours,sum(ot2_hours) ot2_hours,sum(ot3_hours) ot3_hours,sum(deficit_hours) deficit_hours,sum(shift1_number) shift1_number,sum(shift2_number) shift2_number,sum(ts_number) ts_number,sum(tb_01) tb_01,sum(tb_02) tb_02 ";
   @Resource
   private TimeSheetDao timeSheetDao;
   @Resource
   private CommonDao commonDao;


   public TimeSheetDao getTimeSheetDao() {
      return this.timeSheetDao;
   }

   public void setTimeSheetDao(TimeSheetDao timeSheetDao) {
      this.timeSheetDao = timeSheetDao;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int insertTimeSheet(TimeSheet ts) throws Exception {
      String inner_date = this.sdf.format(ts.getInner_date());
      inner_date = inner_date.substring(0, inner_date.lastIndexOf(":")) + ":00";
      ts.setInner_date(this.sdf.parse(inner_date));
      String delSql = "delete from tb_time_sheet where emp_id=" + ts.getEmp_id() + " and card_id=" + ts.getCard_id() + " and CONVERT(varchar(100), inner_date, 20)=\'" + this.sdf.format(ts.getInner_date()) + "\' and type=\'" + ts.getType() + "\'";
      this.commonDao.executeBySQL(delSql);
      return this.timeSheetDao.save(ts);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int delTimeSheet(TimeSheet ts) throws Exception {
      return this.timeSheetDao.delTS(ts);
   }

   public List queryByEmpId(int emp_id, Date schedule_begin_date, Date schedule_end_date, int range, String timesheet_type) throws Exception {
      if(emp_id != 0 && schedule_begin_date != null && schedule_end_date != null) {
         Date range_schedule_begin_date = null;
         Date range_schedule_end_date = null;
         Calendar c = Calendar.getInstance();
         c.setTime(schedule_begin_date);
         c.add(12, -range);
         range_schedule_begin_date = c.getTime();
         c.setTime(schedule_end_date);
         c.add(12, range);
         range_schedule_end_date = c.getTime();
         String sql = " select " + this.columns + "   from tb_time_sheet t " + "  where emp_id=" + emp_id + " " + (StringUtils.isEmpty(timesheet_type)?"":" and type in(" + timesheet_type + ") ") + "    and inner_date >=\'" + this.sdf.format(range_schedule_begin_date) + "\'  " + " \t and inner_date <=\'" + this.sdf.format(range_schedule_end_date) + "\' ";
         return this.timeSheetDao.findBySql(sql);
      } else {
         return null;
      }
   }

   private String getSql(TimeSheet timeSheet) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select t." + this.columns.replace(",", ",t.") + ",tei.zh_name emp_name,tec.card, tdi.id dept_id,tdi.dept_name");
      sql.append(" from tb_time_sheet t,tb_employee_info tei,tb_employee_card tec,tb_department_info tdi  ");
      sql.append(" where 1=1 and t.emp_id=tei.id and t.card_id = tec.id and tei.dept_id=tdi.id ");
      if(!StringUtils.isEmpty(timeSheet.getEmp_name())) {
         sql.append(" and tei.zh_name like \'%" + timeSheet.getEmp_name() + "%\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getDept_ids())) {
         sql.append(" and tdi.id in(" + timeSheet.getDept_ids() + ") ");
      }

      if(!StringUtils.isEmpty(timeSheet.getType())) {
         sql.append(" and t.type =\'" + timeSheet.getType() + "\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getSource())) {
         sql.append(" and t.source =\'" + timeSheet.getSource() + "\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getBegin_date())) {
         sql.append(" and t.inner_date >= \'" + timeSheet.getBegin_date() + " 00:00:00\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getEnd_date())) {
         sql.append(" and t.inner_date <= \'" + timeSheet.getEnd_date() + " 23:59:59\' ");
      }

      return sql.toString();
   }

   public List findByCondition(TimeSheet timeSheet, Page page) throws Exception {
      Object result = new ArrayList();
      if(timeSheet != null) {
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
            orderby = "  order by t.inner_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select t.* from ( ");
         sql1.append(" select " + this.columns + ",card,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber from (");
         sql1.append(this.getSql(timeSheet));
         sql1.append(" ) t ");
         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.timeSheetDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findCountByCondition(TimeSheet timeSheet) throws SQLException {
      StringBuffer sql = new StringBuffer("");
      int count = 0;
      sql.append("select count(t.id) count from ( ");
      sql.append(this.getSql(timeSheet));
      sql.append(" ) t ");
      TimeSheet ts = this.timeSheetDao.findTimeSheetBySql(sql.toString());
      if(ts != null) {
         count = ts.getCount();
      }

      return count;
   }

   public List findTotalMealsByCondition(TimeSheet timeSheet) throws Exception {
      Object result = new ArrayList();
      if(timeSheet != null) {
         timeSheet.setType(Global.timesheet_type[2]);
         StringBuffer sql = new StringBuffer("");
         sql.append("select t.source,count(1) count from ( ");
         sql.append(this.getSql(timeSheet));
         sql.append(" ) t group by source ");
         result = this.timeSheetDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int insertTimeSheetDetail(TimeSheetDetail tsd) throws Exception {
      int count = 0;
      if(tsd != null && tsd.getEmp_id() != null && tsd.getClass_date() != null) {
         this.timeSheetDao.delDetail(tsd);
         count = this.timeSheetDao.saveDetail(tsd);
      }

      return count;
   }

   public List findDetailByCondition(TimeSheetDetail timeSheet, Page page) throws Exception {
      Object result = new ArrayList();
      if(timeSheet != null) {
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
            orderby = "  order by t.class_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select t.* from ( ");
         sql1.append(" select " + this.columns_detail + ",ROW_NUMBER() OVER (" + orderby + ") AS RowNumber from (");
         sql1.append(this.getDetailSql(timeSheet));
         sql1.append(" ) t");
         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.timeSheetDao.findDetailBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findDetailSumByCondition(TimeSheetDetail timeSheet) throws Exception {
      Object result = new ArrayList();
      if(timeSheet != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns_detail_sum + " from (");
         sql.append(this.getDetailSql(timeSheet));
         sql.append(" ) t   group by t.emp_id ");
         result = this.timeSheetDao.findDetailBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public int findDetailCountByCondition(TimeSheetDetail timeSheet) throws SQLException {
      StringBuffer sql = new StringBuffer("");
      int count = 0;
      sql.append("select count(t.id) count from ( ");
      sql.append(this.getDetailSql(timeSheet));
      sql.append(" ) t ");
      TimeSheetDetail ts = this.timeSheetDao.findTimeSheetDetailBySql(sql.toString());
      if(ts != null && ts.getCount() != null) {
         count = ts.getCount().intValue();
      }

      return count;
   }

   private String getDetailSql(TimeSheetDetail timeSheet) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select t." + this.columns_detail.replace(",", ",t.") + " ");
      sql.append(" from tb_time_sheet_detail t,tb_employee_info tei,tb_department_info tdi  ");
      sql.append(" where 1=1 and t.emp_id=tei.id and tei.dept_id=tdi.id ");
      if(!StringUtils.isEmpty(timeSheet.getEmp_name())) {
         sql.append(" and tei.zh_name like \'%" + timeSheet.getEmp_name() + "%\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getDept_ids())) {
         sql.append(" and tdi.id in(" + timeSheet.getDept_ids() + ") ");
      }

      if(!StringUtils.isEmpty(timeSheet.getBegin_date())) {
         sql.append(" and t.class_date >= \'" + timeSheet.getBegin_date() + "\' ");
      }

      if(!StringUtils.isEmpty(timeSheet.getEnd_date())) {
         sql.append(" and t.class_date <= \'" + timeSheet.getEnd_date() + "\' ");
      }

      return sql.toString();
   }
}
