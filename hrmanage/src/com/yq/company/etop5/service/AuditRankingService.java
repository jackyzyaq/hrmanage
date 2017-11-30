package com.yq.company.etop5.service;

import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.AuditRankingDao;
import com.yq.company.etop5.pojo.AuditRanking;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuditRankingService {

   private String columns_header = " id,type,begin_month,end_month,header_1,header_2,header_3,header_4,operater,create_date,update_date ";
   private String defHeaderTable = "etop5.dbo.tb_audit_ranking_header";
   private String columns = " id,dept_id,(select dept_name from tb_department_info where id=dept_id) dept_name,gl,begin_month,end_month,kpi_1,kpi_2,kpi_3,kpi_4,over_all,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_audit_ranking";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private AuditRankingDao auditRankingDao;


   public AuditRanking queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public AuditRanking queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.auditRankingDao.queryObjectBySql(sql);
   }

   public AuditRanking queryByReportDate(int dept_id, Date begin_month, Date end_month) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where dept_id = " + dept_id + " and begin_month = \'" + this.sdf1.format(begin_month) + "\' and end_month = \'" + this.sdf1.format(end_month) + "\' ";
      return this.auditRankingDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(AuditRanking auditRanking) throws Exception {
      AuditRanking sr = this.queryByReportDate(auditRanking.getDept_id().intValue(), auditRanking.getBegin_month(), auditRanking.getEnd_month());
      boolean id = false;
      int id1;
      if(sr == null) {
         id1 = this.auditRankingDao.save(auditRanking);
      } else {
         id1 = sr.getId().intValue();
         ReflectPOJO.copyObject(sr, auditRanking);
         sr.setId(Integer.valueOf(id1));
         this.auditRankingDao.update(sr);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(AuditRanking auditRanking) throws Exception {
      this.auditRankingDao.update(auditRanking);
   }

   public AuditRankingDao getAuditRankingDao() {
      return this.auditRankingDao;
   }

   public void setAuditRankingDao(AuditRankingDao auditRankingDao) {
      this.auditRankingDao = auditRankingDao;
   }

   public List findByCondition(AuditRanking auditRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(auditRanking != null) {
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
         if(auditRanking.getId() != null) {
            sql1.append(" and t.id =" + auditRanking.getId() + " ");
         }

         if(auditRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(auditRanking.getBegin_month()) + "\' ");
         }

         if(auditRanking.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(auditRanking.getEnd_month()) + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.auditRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public AuditRanking queryByHeaderType(Date beginMonth, Date endMonth) throws Exception {
      String sql = " select " + this.columns_header + " from " + this.defHeaderTable + " t " + " where type = \'" + Global.audit_ranking_type[0] + "\' and begin_month =\'" + this.sdf1.format(beginMonth) + "\'  and end_month = \'" + this.sdf1.format(endMonth) + "\'";
      return this.auditRankingDao.queryObjectBySql(sql);
   }

   public List findHeaderByCondition(AuditRanking auditRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(auditRanking != null) {
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
         if(auditRanking.getId() != null) {
            sql1.append(" and t.id =" + auditRanking.getId() + " ");
         }

         if(auditRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(auditRanking.getBegin_month()) + "\' ");
         }

         if(auditRanking.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(auditRanking.getEnd_month()) + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.auditRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int saveHeader(AuditRanking auditRanking) throws Exception {
      int id = this.auditRankingDao.saveHeader(auditRanking);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateHeader(AuditRanking auditRanking) throws Exception {
      this.auditRankingDao.updateHeader(auditRanking);
   }
}
