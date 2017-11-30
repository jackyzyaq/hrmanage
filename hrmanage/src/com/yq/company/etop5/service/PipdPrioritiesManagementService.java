package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.PipdPrioritiesManagementDao;
import com.yq.company.etop5.pojo.PipdPrioritiesManagement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PipdPrioritiesManagementService {

   private String columns = " id,type,begin_month,end_month,kpi_v1,kpi_v2,kpi_v3,kpi_v4,kpi_v5,kpi_v6,kpi_v7,kpi_v8,kpi_v9,kpi_v10,kpi_v11,state,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_pipd_priorities_management";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private PipdPrioritiesManagementDao pipdPrioritiesManagementDao;


   public PipdPrioritiesManagement queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public PipdPrioritiesManagement queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.pipdPrioritiesManagementDao.queryObjectBySql(sql);
   }

   public PipdPrioritiesManagement queryByReportDate(Date begin_month, Date end_month, String type) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where begin_month = \'" + this.sdf1.format(begin_month) + "\' and end_month = \'" + this.sdf1.format(end_month) + "\' and type=\'" + type + "\' ";
      return this.pipdPrioritiesManagementDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(PipdPrioritiesManagement pipdPrioritiesManagement) throws Exception {
      PipdPrioritiesManagement pd = this.queryByReportDate(pipdPrioritiesManagement.getBegin_month(), pipdPrioritiesManagement.getEnd_month(), pipdPrioritiesManagement.getType());
      boolean id = false;
      int id1;
      if(pd == null) {
         id1 = this.pipdPrioritiesManagementDao.save(pipdPrioritiesManagement);
      } else {
         id1 = pd.getId().intValue();
         ReflectPOJO.copyObject(pd, pipdPrioritiesManagement);
         pd.setId(Integer.valueOf(id1));
         this.pipdPrioritiesManagementDao.update(pd);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveList(List pipdPrioritiesManagementList) throws Exception {
      if(pipdPrioritiesManagementList != null && !pipdPrioritiesManagementList.isEmpty()) {
         Iterator var3 = pipdPrioritiesManagementList.iterator();

         while(var3.hasNext()) {
            PipdPrioritiesManagement pipdPrioritiesManagement = (PipdPrioritiesManagement)var3.next();
            this.save(pipdPrioritiesManagement);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(PipdPrioritiesManagement pipdPrioritiesManagement) throws Exception {
      this.pipdPrioritiesManagementDao.update(pipdPrioritiesManagement);
   }

   public PipdPrioritiesManagementDao getPipdPrioritiesManagementDao() {
      return this.pipdPrioritiesManagementDao;
   }

   public void setPipdPrioritiesManagementDao(PipdPrioritiesManagementDao pipdPrioritiesManagementDao) {
      this.pipdPrioritiesManagementDao = pipdPrioritiesManagementDao;
   }

   public List findByCondition(PipdPrioritiesManagement pipdPrioritiesManagement, Page page) throws Exception {
      Object result = new ArrayList();
      if(pipdPrioritiesManagement != null) {
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
         if(pipdPrioritiesManagement.getId() != null) {
            sql1.append(" and t.id =" + pipdPrioritiesManagement.getId() + " ");
         }

         if(!StringUtils.isEmpty(pipdPrioritiesManagement.getType())) {
            sql1.append(" and t.type =\'" + pipdPrioritiesManagement.getType() + "\' ");
         }

         if(pipdPrioritiesManagement.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(pipdPrioritiesManagement.getBegin_month()) + "\' ");
         }

         if(pipdPrioritiesManagement.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(pipdPrioritiesManagement.getEnd_month()) + "\' ");
         }

         if(pipdPrioritiesManagement.getState() != null) {
            sql1.append(" and t.state =" + pipdPrioritiesManagement.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.pipdPrioritiesManagementDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
