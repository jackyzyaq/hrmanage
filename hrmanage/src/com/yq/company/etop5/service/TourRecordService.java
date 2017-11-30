package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.TourRecordDao;
import com.yq.company.etop5.pojo.TourRecord;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TourRecordService {

   private String columns = " id,tour_info_id,report_date,number,dept_name,emp_name,status,status_date,respones,ext_1,ext_2,ext_3,ext_4,ext_5,ext_6,ext_7,ext_8,ext_9,ext_10,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_tour_record";
   private String columns24 = " id,tour_info_id,report_date,datepart(hour,report_date) hour,unit,data24,ext_1,ext_2,ext_3,ext_4,ext_5,operater,create_date,update_date ";
   private String def24Table = "etop5.dbo.tb_tour_24hour";
   private String defOrderBy = " order by  CHARINDEX(dept_name,\'plant,工厂经理,uap1,uap2,pcl,Quality,FM\') ";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private TourRecordDao tourRecordDao;


   public TourRecord queryObject(Date report_date, int number, int tour_info_id) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where report_date = \'" + this.sdf.format(report_date) + "\' " + "   and number = " + number + " " + "   and tour_info_id = " + tour_info_id;
      return this.tourRecordDao.queryObjectBySql(sql);
   }

   public TourRecord queryById(int id) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      return this.tourRecordDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(TourRecord tourRecord) throws Exception {
      boolean id = false;
      TourRecord tTmp = this.queryObject(tourRecord.getReport_date(), tourRecord.getNumber().intValue(), tourRecord.getTour_info_id().intValue());
      int id1;
      if(tTmp == null) {
         id1 = this.tourRecordDao.save(tourRecord);
      } else {
         id1 = tTmp.getId().intValue();
         tourRecord.setId(Integer.valueOf(id1));
         ReflectPOJO.copyObject(tTmp, tourRecord);
         this.tourRecordDao.update(tTmp);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(TourRecord tourRecord) throws Exception {
      this.tourRecordDao.update(tourRecord);
   }

   public TourRecordDao getTourRecordDao() {
      return this.tourRecordDao;
   }

   public void setTourRecordDao(TourRecordDao tourRecordDao) {
      this.tourRecordDao = tourRecordDao;
   }

   public List findByCondition(TourRecord tourRecord, Page page) throws Exception {
      Object result = new ArrayList();
      if(tourRecord != null) {
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
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(tourRecord.getId() != null) {
            sql1.append(" and t.id =" + tourRecord.getId() + " ");
         }

         if(tourRecord.getTour_info_id() != null) {
            sql1.append(" and t.tour_info_id =" + tourRecord.getTour_info_id() + " ");
         }

         if(tourRecord.getNumber() != null) {
            sql1.append(" and t.number =" + tourRecord.getNumber() + " ");
         }

         if(tourRecord.getReport_date() != null) {
            sql1.append(" and t.report_date = \'" + this.sdf.format(tourRecord.getReport_date()) + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.tourRecordDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findMonthOrDayForList(TourRecord tr) throws Exception {
      StringBuffer sql = new StringBuffer();
      sql.append(" select Month(report_date) month,count(1) count from ( ");
      sql.append("\tselect report_date,ext_1 from " + this.defTable + " ");
      sql.append("     where tour_info_id=" + tr.getTour_info_id() + " and ext_1 = \'" + tr.getExt_1() + "\'  ");
      sql.append("       and report_date >= \'" + tr.getStart_date() + "\' and report_date <= \'" + tr.getOver_date() + "\' ");
      sql.append("     group by report_date,ext_1 ");
      sql.append(" ) t group by Month(report_date) ");
      return this.tourRecordDao.findBySql(sql.toString());
   }

   public TourRecord query24Hour(int tour_info_id, Date report_date) throws Exception {
      String sql = " select " + this.columns24 + " from " + this.def24Table + " t " + " where tour_info_id = " + tour_info_id + " and report_date=\'" + this.sdf1.format(report_date) + "\'";
      return this.tourRecordDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save24(TourRecord tourRecord) throws Exception {
      int id = 0;
      TourRecord tTmp = this.query24Hour(tourRecord.getTour_info_id().intValue(), tourRecord.getReport_date());
      if(tTmp == null) {
         id = this.tourRecordDao.save24(tourRecord);
      } else {
         this.tourRecordDao.update24(tourRecord);
      }

      return id;
   }

   public List find24HourByCondition(TourRecord tourRecord, Page page) throws Exception {
      Object result = new ArrayList();
      if(tourRecord != null) {
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
            orderby = "  order by t.report_date asc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns24 + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.def24Table + " t   ");
         sql1.append(" where 1=1 ");
         if(tourRecord.getId() != null) {
            sql1.append(" and t.id =" + tourRecord.getId() + " ");
         }

         if(tourRecord.getTour_info_id() != null) {
            sql1.append(" and t.tour_info_id =" + tourRecord.getTour_info_id() + " ");
         }

         if(tourRecord.getStart_date() != null) {
            sql1.append(" and t.report_date >= \'" + tourRecord.getStart_date() + "\' ");
         }

         if(tourRecord.getOver_date() != null) {
            sql1.append(" and t.report_date <= \'" + tourRecord.getOver_date() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.tourRecordDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
