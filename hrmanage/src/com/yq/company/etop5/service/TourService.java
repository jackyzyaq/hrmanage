package com.yq.company.etop5.service;

import com.util.Page;
import com.yq.company.etop5.dao.TourDao;
import com.yq.company.etop5.pojo.Tour;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TourService {

   private String columns = " id,dept_id,time,zone,input_kpi,criteria_standard_situation,linked_output_kpi,visual_tools,check_current_situation,up_rule_y,up_rule_o,up_rule_r,reaction_rule_y,reaction_rule_o,reaction_rule_r,ext_1,ext_2,ext_3,ext_4,ext_5,ext_6,ext_7,ext_8,ext_9,ext_10,operater,dept_id_1,emp_id_1,expect_time_1,dept_id_2,emp_id_2,expect_time_2,dept_id_3,emp_id_3,expect_time_3,state,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_tour_info";
   private String columns_map = " id,dept_id,map_upload,create_date,update_date ";
   private String defMapTable = "etop5.dbo.tb_tour_map";
   private String defOrderBy = " order by  CHARINDEX(dept_name,\'plant,工厂经理,uap1,uap2,pcl,Quality,FM\') ";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private TourDao tourDao;


   public Tour queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public Tour queryById(int id, Integer state) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      sql = sql + (state != null?" and state=" + state:"");
      return this.tourDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(Tour tour) throws Exception {
      int id = 0;
      tour.setId(Integer.valueOf(tour.getId() == null?0:tour.getId().intValue()));
      Tour tTmp = this.queryById(tour.getId().intValue());
      if(tTmp == null) {
         tour.setState(Integer.valueOf(1));
         id = this.tourDao.save(tour);
      } else {
         tour.setState(Integer.valueOf(1));
         this.tourDao.update(tour);
      }

      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(Tour tour) throws Exception {
      this.tourDao.update(tour);
   }

   public TourDao getTourDao() {
      return this.tourDao;
   }

   public void setTourDao(TourDao tourDao) {
      this.tourDao = tourDao;
   }

   public List findByCondition(Tour tour, Page page) throws Exception {
      Object result = new ArrayList();
      if(tour != null) {
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
         if(tour.getId() != null) {
            sql1.append(" and t.id =" + tour.getId() + " ");
         }

         if(tour.getState() != null) {
            sql1.append(" and t.state =" + tour.getState() + " ");
         }

         if(tour.getDept_id() != null) {
            sql1.append(" and t.dept_id =" + tour.getDept_id() + " ");
         }

         if(!StringUtils.isEmpty(tour.getExt_1())) {
            sql1.append(" and t.ext_1 =\'" + tour.getExt_1().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(tour.getExt_2())) {
            sql1.append(" and t.ext_2 =\'" + tour.getExt_2().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(tour.getSpecialStr())) {
            sql1.append(" and " + tour.getSpecialStr().trim() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.tourDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public Tour queryMap(int deptId) throws Exception {
      String sql = " select " + this.columns_map + " from " + this.defMapTable + " t " + " where dept_id = " + deptId;
      return this.tourDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveMap(Tour tour) throws Exception {
      if(this.queryMap(tour.getDept_id().intValue()) == null) {
         this.tourDao.saveMap(tour);
      } else {
         this.tourDao.updateMap(tour);
      }

   }
}
