package com.yq.company.etop5.service;

import com.util.Page;
import com.yq.company.etop5.dao.ManagementScheduleDao;
import com.yq.company.etop5.pojo.ManagementSchedule;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ManagementScheduleService {

   private String columns = " id,tb_name,tb_schedule_date,tb_status_am,tb_status_pm,tb_backup,create_date,update_date,tb_create_user,tb_update_user,state ";
   private String defTable = "etop5.dbo.tb_management_schedule";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private ManagementScheduleDao managementScheduleDao;


   public ManagementSchedule queryByNameAndDate(String name, Date date) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where tb_name = \'" + name + "\' and tb_schedule_date = \'" + this.sdf.format(date) + "\' ";
      return this.managementScheduleDao.queryObjectBySql(sql);
   }

   public ManagementSchedule queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public ManagementSchedule queryById(int id, Integer state) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      sql = sql + (state != null?" and state=" + state:"");
      return this.managementScheduleDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(ManagementSchedule managementSchedule) throws Exception {
      int id = 0;
      ManagementSchedule tTmp = this.queryByNameAndDate(managementSchedule.getTb_name(), managementSchedule.getTb_schedule_date());
      if(tTmp == null) {
         managementSchedule.setState(Integer.valueOf(1));
         id = this.managementScheduleDao.save(managementSchedule);
      } else {
         managementSchedule.setId(tTmp.getId());
         managementSchedule.setState(Integer.valueOf(1));
         this.managementScheduleDao.update(managementSchedule);
      }

      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ManagementSchedule managementSchedule) throws Exception {
      this.managementScheduleDao.update(managementSchedule);
   }

   public ManagementScheduleDao getManagementScheduleDao() {
      return this.managementScheduleDao;
   }

   public void setManagementScheduleDao(ManagementScheduleDao managementScheduleDao) {
      this.managementScheduleDao = managementScheduleDao;
   }

   public List findByCondition(ManagementSchedule managementSchedule, Page page) throws Exception {
      Object result = new ArrayList();
      if(managementSchedule != null) {
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
         if(managementSchedule.getId() != null) {
            sql1.append(" and t.id =" + managementSchedule.getId() + " ");
         }

         if(managementSchedule.getState() != null) {
            sql1.append(" and t.state =" + managementSchedule.getState() + " ");
         }

         if(managementSchedule.getTb_schedule_date() != null) {
            sql1.append(" and t.tb_schedule_date = \'" + this.sdf.format(managementSchedule.getTb_schedule_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(managementSchedule.getSpecialStr())) {
            sql1.append(" and t." + managementSchedule.getSpecialStr().trim() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.managementScheduleDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List queryNameByCondition() throws Exception {
      return this.managementScheduleDao.findBySql(this.getColGroupBySql("tb_name", ""));
   }

   private String getColGroupBySql(String param, String paramVal) {
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
