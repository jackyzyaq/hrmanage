package com.yq.company.etop5.service;

import com.util.Page;
import com.yq.company.etop5.dao.PlantScheduleDao;
import com.yq.company.etop5.pojo.PlantSchedule;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PlantScheduleService {

   private String columns = " id,begin_date,end_date,title,operater,state,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_plant_schedule";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private PlantScheduleDao plantScheduleDao;


   public PlantSchedule queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public PlantSchedule queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.plantScheduleDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(PlantSchedule plantSchedule) throws Exception {
      int id = this.plantScheduleDao.save(plantSchedule);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(PlantSchedule plantSchedule) throws Exception {
      this.plantScheduleDao.update(plantSchedule);
   }

   public PlantScheduleDao getPlantScheduleDao() {
      return this.plantScheduleDao;
   }

   public void setPlantScheduleDao(PlantScheduleDao plantScheduleDao) {
      this.plantScheduleDao = plantScheduleDao;
   }

   public List findByCondition(PlantSchedule plantSchedule, Page page) throws Exception {
      Object result = new ArrayList();
      if(plantSchedule != null) {
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
         if(plantSchedule.getId() != null) {
            sql1.append(" and t.id =" + plantSchedule.getId() + " ");
         }

         if(plantSchedule.getBegin_date() != null) {
            sql1.append(" and t.begin_date >=\'" + this.sdf.format(plantSchedule.getBegin_date()) + "\' ");
         }

         if(plantSchedule.getEnd_date() != null) {
            sql1.append(" and t.end_date <=\'" + this.sdf.format(plantSchedule.getEnd_date()) + "\' ");
         }

         if(plantSchedule.getState() != null) {
            sql1.append(" and t.state =" + plantSchedule.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.plantScheduleDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
