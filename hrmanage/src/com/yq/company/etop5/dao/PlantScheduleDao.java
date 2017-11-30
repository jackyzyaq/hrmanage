package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.PlantSchedule;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PlantScheduleDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PlantSchedule.executeBySql", sql);
   }

   public PlantSchedule findById(Integer id) throws SQLException {
      return (PlantSchedule)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PlantSchedule.findById", id);
   }

   public PlantSchedule queryObjectBySql(String sql) throws SQLException {
      return (PlantSchedule)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PlantSchedule.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.PlantSchedule.findBySql", sql);
      }

      return result;
   }

   public int save(PlantSchedule plantSchedule) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.PlantSchedule.save", plantSchedule)).intValue();
   }

   public void update(PlantSchedule plantSchedule) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PlantSchedule.update", plantSchedule);
   }
}
