package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.SupplierRankingDao;
import com.yq.company.etop5.pojo.SupplierRanking;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SupplierRankingService {

   private String columns_status = " id,supplier,type,begin_month,kpi_1,operater,create_date,update_date ";
   private String defStatusTable = "etop5.dbo.tb_supplier_ranking_status";
   private String columns = " id,supplier,begin_month,kpi_1,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_supplier_ranking";
   private String supplier_columns = " id,supplier,create_date ";
   private String supplierTable = "etop5.dbo.tb_supplier";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private SupplierRankingDao supplierRankingDao;


   public SupplierRanking queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public SupplierRanking queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.supplierRankingDao.queryObjectBySql(sql);
   }

   public SupplierRanking queryByReportDate(String supplier, Date begin_month) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where supplier = \'" + supplier + "\' and begin_month = \'" + this.sdf1.format(begin_month) + "\' ";
      return this.supplierRankingDao.queryObjectBySql(sql);
   }

   public SupplierRanking querySupplier(String supplier) throws Exception {
      String sql = " select " + this.supplier_columns + " from " + this.supplierTable + " t " + " where supplier = \'" + supplier + "\' ";
      return this.supplierRankingDao.queryObjectBySql(sql);
   }

   public SupplierRanking queryMaxBeginMonth() throws Exception {
      String sql = " select max(begin_month) begin_month  from " + this.defTable + " t ";
      return this.supplierRankingDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(SupplierRanking supplierRanking) throws Exception {
      SupplierRanking s = this.querySupplier(supplierRanking.getSupplier());
      if(s == null) {
         this.saveSupplier(supplierRanking.getSupplier());
      }

      SupplierRanking sr = this.queryByReportDate(supplierRanking.getSupplier(), supplierRanking.getBegin_month());
      boolean id = false;
      int id1;
      if(sr == null) {
         id1 = this.supplierRankingDao.save(supplierRanking);
      } else {
         id1 = sr.getId().intValue();
         ReflectPOJO.copyObject(sr, supplierRanking);
         sr.setId(Integer.valueOf(id1));
         this.supplierRankingDao.update(sr);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(SupplierRanking supplierRanking) throws Exception {
      this.supplierRankingDao.update(supplierRanking);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveSupplier(String supplier) throws Exception {
      this.supplierRankingDao.saveSupplier(supplier);
   }

   public SupplierRankingDao getSupplierRankingDao() {
      return this.supplierRankingDao;
   }

   public void setSupplierRankingDao(SupplierRankingDao supplierRankingDao) {
      this.supplierRankingDao = supplierRankingDao;
   }

   public List findByCondition(SupplierRanking supplierRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(supplierRanking != null) {
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
         if(supplierRanking.getId() != null) {
            sql1.append(" and t.id =" + supplierRanking.getId() + " ");
         }

         if(supplierRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(supplierRanking.getBegin_month()) + "\' ");
         }

         if(supplierRanking.getId() != null) {
            sql1.append(" and t.supplier =\'" + supplierRanking.getSupplier() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.supplierRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findSupplierByCondition(SupplierRanking supplierRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(supplierRanking != null) {
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
            orderby = "  order by create_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.supplier_columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.supplierTable + " t   ");
         sql1.append(" where 1=1 ");
         if(supplierRanking.getId() != null) {
            sql1.append(" and t.supplier =\'" + supplierRanking.getSupplier() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.supplierRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findSupplierAllYearSum(int year) throws Exception {
      String sql = "select supplier,avg(kpi_1) kpi_1 from " + this.defTable + " " + "\twhere begin_month >=\'" + year + "-01-01\' and begin_month<=\'" + year + "-12-31\' " + "\tgroup by supplier " + "\torder by kpi_1 desc";
      return this.supplierRankingDao.findBySql(sql.toString());
   }

   public List findSupplierMaxMonthSum() throws Exception {
      String sql = "select supplier,kpi_1 from " + this.defTable + " " + "\twhere begin_month in(select max(begin_month) from " + this.defTable + ") " + "\tgroup by supplier,kpi_1 " + "\torder by kpi_1 desc";
      return this.supplierRankingDao.findBySql(sql.toString());
   }

   public List autoComplete(Map params) throws Exception {
      List result = null;
      if(params != null && params.size() > 0) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from (");
         sql.append(" select " + this.supplier_columns + ",ROW_NUMBER() OVER (order by t.id) AS RowNumber ");
         sql.append(" from " + this.supplierTable + " t   ");
         sql.append(" where 1=1 ");
         if(!StringUtils.isEmpty((CharSequence)params.get("supplier"))) {
            sql.append(" and t.supplier like \'%" + (String)params.get("supplier") + "%\' ");
         }

         sql.append(" ) t where RowNumber > 0 and RowNumber <=10 ");
         result = this.supplierRankingDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public SupplierRanking queryStatusByType(String type, Date beginMonth) throws Exception {
      String sql = " select " + this.columns_status + " from " + this.defStatusTable + " t " + " where type = \'" + type + "\' and begin_month =\'" + this.sdf1.format(beginMonth) + "\' ";
      return this.supplierRankingDao.queryObjectBySql(sql);
   }

   public List queryStatusListByType(String type, Date beginMonth) throws Exception {
      String sql = " select " + this.columns_status + " from " + this.defStatusTable + " t " + " where type = \'" + type + "\' and begin_month =\'" + this.sdf1.format(beginMonth) + "\' ";
      return this.supplierRankingDao.findBySql(sql);
   }

   public List findStatusByCondition(SupplierRanking supplierRanking, Page page) throws Exception {
      Object result = new ArrayList();
      if(supplierRanking != null) {
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
         sql1.append(" select " + this.columns_status + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defStatusTable + " t   ");
         sql1.append(" where 1=1 ");
         if(supplierRanking.getId() != null) {
            sql1.append(" and t.id =" + supplierRanking.getId() + " ");
         }

         if(supplierRanking.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(supplierRanking.getBegin_month()) + "\' ");
         }

         if(StringUtils.isEmpty(supplierRanking.getType())) {
            sql1.append(" and t.type =\'" + supplierRanking.getType() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.supplierRankingDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int saveStatus(SupplierRanking supplierRanking) throws Exception {
      SupplierRanking s = this.queryStatusByType(supplierRanking.getType(), supplierRanking.getBegin_month());
      boolean id = false;
      int id1;
      if(s == null) {
         id1 = this.supplierRankingDao.saveStatus(supplierRanking);
      } else {
         id1 = s.getId().intValue();
         supplierRanking.setId(Integer.valueOf(id1));
         this.supplierRankingDao.updateStatus(supplierRanking);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateStatus(SupplierRanking supplierRanking) throws Exception {
      this.supplierRankingDao.updateStatus(supplierRanking);
   }
}
