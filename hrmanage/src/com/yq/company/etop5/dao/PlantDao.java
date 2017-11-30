package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.Plant;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PlantDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.Plant.executeBySql", sql);
   }

   public Plant findById(Integer id) throws SQLException {
      return (Plant)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.Plant.findById", id);
   }

   public Plant queryObjectBySql(String sql) throws SQLException {
      return (Plant)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.Plant.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.Plant.findBySql", sql);
      }

      return result;
   }

   public int save(Plant plant) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.Plant.save", plant)).intValue();
   }

   public void update(Plant plant) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.Plant.update", plant);
   }
}
