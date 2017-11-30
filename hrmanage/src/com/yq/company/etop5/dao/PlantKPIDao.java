package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.PlantKPI;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PlantKPIDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PlantKPI.executeBySql", sql);
   }

   public PlantKPI queryObjectBySql(String sql) throws SQLException {
      return (PlantKPI)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PlantKPI.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.PlantKPI.findBySql", sql);
      }

      return result;
   }

   public int save(PlantKPI plantKPI) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.PlantKPI.save", plantKPI)).intValue();
   }

   public void update(PlantKPI plantKPI) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PlantKPI.update", plantKPI);
   }
}
