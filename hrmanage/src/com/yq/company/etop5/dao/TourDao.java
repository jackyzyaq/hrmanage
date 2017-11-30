package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.Tour;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class TourDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.Tour.executeBySql", sql);
   }

   public Tour queryObjectBySql(String sql) throws SQLException {
      return (Tour)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.Tour.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.Tour.findBySql", sql);
      }

      return result;
   }

   public int save(Tour tour) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.Tour.save", tour)).intValue();
   }

   public void update(Tour tour) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.Tour.update", tour);
   }

   public int saveMap(Tour tour) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.Tour.saveMap", tour)).intValue();
   }

   public void updateMap(Tour tour) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.Tour.updateMap", tour);
   }
}
