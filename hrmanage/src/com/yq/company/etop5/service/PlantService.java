package com.yq.company.etop5.service;

import com.util.Page;
import com.yq.company.etop5.dao.PlantDao;
import com.yq.company.etop5.pojo.Plant;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PlantService {

   private String columns = " id,begin_year,plant,upload_uuid,state,handler,level1,datepoint,ext_1,create_date,update_date,type,operater ";
   private String defTable = "etop5.dbo.tb_plant";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private PlantDao plantDao;


   public Plant queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public Plant queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.plantDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(Plant plant) throws Exception {
      boolean id = false;
      int id1;
      if(plant.getId() != null && plant.getId().intValue() > 0) {
         id1 = plant.getId().intValue();
         this.update(plant);
      } else {
         id1 = this.plantDao.save(plant);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(Plant plant) throws Exception {
      this.plantDao.update(plant);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void delete(String ids) throws Exception {
      String sql = " delete from " + this.defTable + " " + " where id in(" + ids + ")";
      this.plantDao.executeBySql(sql);
   }

   public PlantDao getPlantDao() {
      return this.plantDao;
   }

   public void setPlantDao(PlantDao plantDao) {
      this.plantDao = plantDao;
   }

   public List findByCondition(Plant plant, Page page) throws Exception {
      Object result = new ArrayList();
      if(plant != null) {
         String orderby = "";
         String rownumber = "";
         if(page != null && page.getTotalCount() > 0) {
            int sql = page.getPageSize();
            int fr = (page.getPageIndex() - 1) * sql;
            if(fr < 0) {
               fr = 0;
            }

            orderby = "  order by " + page.getSidx() + " " + page.getSord() + " ";
            rownumber = " and  RowNumber > " + fr + " and RowNumber <=" + (fr + sql) + " ";
         } else {
            orderby = "  order by t.update_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (order by t.id desc) AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(plant.getId() != null) {
            sql1.append(" and t.id =" + plant.getId() + " ");
         }

         if(plant.getBegin_year() != null) {
            sql1.append(" and t.begin_year =\'" + this.sdf.format(plant.getBegin_year()) + "\' ");
         }

         if(!StringUtils.isEmpty(plant.getType())) {
            sql1.append(" and t.type =\'" + plant.getType() + "\' ");
         }

         if(!StringUtils.isEmpty(plant.getLevel1())) {
            sql1.append(" and t.level1 =\'" + plant.getLevel1() + "\' ");
         }

         if(plant.getState() != null) {
            sql1.append(" and t.state =" + plant.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber + " " + orderby);
         result = this.plantDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
