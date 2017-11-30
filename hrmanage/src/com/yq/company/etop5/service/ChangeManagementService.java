package com.yq.company.etop5.service;

import com.util.Page;
import com.util.Util;
import com.yq.company.etop5.dao.ChangeManagementDao;
import com.yq.company.etop5.pojo.ChangeManagement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ChangeManagementService {

   private String columns = " id,report_date,dept_id,emp_id,type,ext_1,ext_2,ext_3,ext_4,ext_5_1,ext_5_1_date,ext_5_2,ext_5_2_date,ext_5_3,ext_5_3_date,ext_5_4,ext_5_4_date,ext_5_5,ext_5_5_date,state,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_change_management";
   private SimpleDateFormat sdfA = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdfB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private ChangeManagementDao change_managementDao;


   public ChangeManagement queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public ChangeManagement queryById(int id, Integer state) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      sql = sql + (state != null?" and state=" + state:"");
      return this.change_managementDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(ChangeManagement change_management) throws Exception {
      int id = 0;
      change_management.setId(Integer.valueOf(change_management.getId() == null?0:change_management.getId().intValue()));
      ChangeManagement tTmp = this.queryById(change_management.getId().intValue());
      if(tTmp == null) {
         change_management.setState(Integer.valueOf(1));
         id = this.change_managementDao.save(change_management);
      } else {
         change_management.setState(Integer.valueOf(1));
         this.change_managementDao.update(change_management);
      }

      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ChangeManagement change_management) throws Exception {
      this.change_managementDao.update(change_management);
   }

   public ChangeManagementDao getChangeManagementDao() {
      return this.change_managementDao;
   }

   public void setChangeManagementDao(ChangeManagementDao change_managementDao) {
      this.change_managementDao = change_managementDao;
   }

   public List findByCondition(ChangeManagement change_management, Page page) throws Exception {
      Object result = new ArrayList();
      if(change_management != null) {
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
            orderby = "  order by t.id asc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(change_management.getId() != null) {
            sql1.append(" and t.id =" + change_management.getId() + " ");
         }

         if(change_management.getEmp_id() != null) {
            sql1.append(" and t.emp_id =" + change_management.getEmp_id() + " ");
         }

         if(change_management.getState() != null) {
            sql1.append(" and t.state =" + change_management.getState() + " ");
         }

         if(change_management.getDept_id() != null) {
            sql1.append(" and t.dept_id =" + change_management.getDept_id() + " ");
         }

         if(!StringUtils.isEmpty(change_management.getExt_1())) {
            sql1.append(" and t.ext_1 =\'" + change_management.getExt_1().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(change_management.getExt_2())) {
            sql1.append(" and t.ext_2 =\'" + change_management.getExt_2().trim() + "\' ");
         }

         if(change_management.getReport_date() != null) {
            sql1.append(" and t.report_date =\'" + Util.convertToString(change_management.getReport_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(change_management.getStart_date())) {
            sql1.append(" and t.report_date >=\'" + change_management.getStart_date() + "\' ");
         }

         if(!StringUtils.isEmpty(change_management.getOver_date())) {
            sql1.append(" and t.report_date <=\'" + change_management.getOver_date() + "\' ");
         }

         if(!StringUtils.isEmpty(change_management.getType())) {
            sql1.append(" and t.type=\'" + change_management.getType().trim() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.change_managementDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List queryExt4() throws Exception {
      return this.change_managementDao.findBySql(this.getParamSql("ext_4", "") + "  ");
   }

   private String getParamSql(String param, String paramVal) {
      if(StringUtils.isEmpty(param)) {
         return "";
      } else {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + param + ",ROW_NUMBER() OVER (order by t." + param + ") AS RowNumber ");
         sql.append(" from " + this.defTable + " t   ");
         sql.append(" where 1=1 ");
         sql.append(" and t." + param + " like \'%" + StringUtils.defaultString(paramVal, "") + "%\' ");
         sql.append(" group by t." + param + " ");
         return sql.toString();
      }
   }
}
