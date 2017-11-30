package com.yq.company.etop5.service;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.SupervisorRankingDao;
import com.yq.company.etop5.pojo.SupervisorRanking;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SupervisorRankingService {

   private String columns = " id,dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name,supervisor,begin_month,end_month,kpi_1,kpi_2,kpi_3,kpi_4,kpi_5,kpi_6,over_all,operater,create_date,update_date ";
   private String columns_header = " id,type,begin_month,end_month,header_1,header_2,header_3,header_4,header_5,header_6,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_supervisor_monthly_ranking";
   private String defHeaderTable = "etop5.dbo.tb_supervisor_monthly_ranking_header";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private SupervisorRankingDao supervisorRankingDao;


   public SupervisorRanking queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public SupervisorRanking queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.supervisorRankingDao.queryObjectBySql(sql);
   }

   public SupervisorRanking queryByReportDate(int dept_id, Date begin_month, Date end_month) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where dept_id = " + dept_id + " and begin_month = \'" + this.sdf1.format(begin_month) + "\' and end_month = \'" + this.sdf1.format(end_month) + "\' ";
      return this.supervisorRankingDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(SupervisorRanking supervisorRanking) throws Exception {
      SupervisorRanking sr = this.queryByReportDate(supervisorRanking.getDept_id().intValue(), supervisorRanking.getBegin_month(), supervisorRanking.getEnd_month());
      boolean id = false;
      int id1;
      if(sr == null) {
         id1 = this.supervisorRankingDao.save(supervisorRanking);
      } else {
         id1 = sr.getId().intValue();
         ReflectPOJO.copyObject(sr, supervisorRanking);
         sr.setId(Integer.valueOf(id1));
         this.supervisorRankingDao.update(sr);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(SupervisorRanking supervisorRanking) throws Exception {
      this.supervisorRankingDao.update(supervisorRanking);
   }

   public SupervisorRankingDao getSupervisorRankingDao() {
      return this.supervisorRankingDao;
   }

   public void setSupervisorRankingDao(SupervisorRankingDao supervisorRankingDao) {
      this.supervisorRankingDao = supervisorRankingDao;
   }

   public List findLast3(Date begin_month, Date end_month) {
      String sql = "SELECT TOP 3 begin_month,end_month from " + this.defTable;
      if(begin_month != null && end_month != null) {
         sql = sql + " where begin_month <= \'" + this.sdf1.format(begin_month) + "\' and end_month <= \'" + this.sdf1.format(end_month) + "\' ";
      }

      sql = sql + " group by begin_month,end_month order by begin_month desc";
      List result = null;

      try {
         result = this.supervisorRankingDao.findBySql(sql.toString());
      } catch (SQLException var6) {
         var6.printStackTrace();
      }

      return result;
   }

   public List findByCondition(SupervisorRanking supervisorRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(supervisorRanking != null) {
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
            orderby = "  order by t.begin_month desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(supervisorRanking.getId() != null) {
            sql1.append(" and t.id =" + supervisorRanking.getId() + " ");
         }

         if(supervisorRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(supervisorRanking.getBegin_month()) + "\' ");
         }

         if(supervisorRanking.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(supervisorRanking.getEnd_month()) + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.supervisorRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public SupervisorRanking queryByHeaderType(Date beginMonth, Date endMonth) throws Exception {
      String sql = " select " + this.columns_header + " from " + this.defHeaderTable + " t " + " where type = \'" + Global.supervisor_ranking_type[0] + "\' and begin_month =\'" + this.sdf1.format(beginMonth) + "\'  and end_month = \'" + this.sdf1.format(endMonth) + "\'";
      return this.supervisorRankingDao.queryObjectBySql(sql);
   }

   public List findHeaderByCondition(SupervisorRanking supervisorRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(supervisorRanking != null) {
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
            orderby = "  order by t.begin_month desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns_header + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defHeaderTable + " t   ");
         sql1.append(" where 1=1 ");
         if(supervisorRanking.getId() != null) {
            sql1.append(" and t.id =" + supervisorRanking.getId() + " ");
         }

         if(supervisorRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(supervisorRanking.getBegin_month()) + "\' ");
         }

         if(supervisorRanking.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(supervisorRanking.getEnd_month()) + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.supervisorRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int saveHeader(SupervisorRanking supervisorRanking) throws Exception {
      int id = this.supervisorRankingDao.saveHeader(supervisorRanking);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateHeader(SupervisorRanking supervisorRanking) throws Exception {
      this.supervisorRankingDao.updateHeader(supervisorRanking);
   }
}
