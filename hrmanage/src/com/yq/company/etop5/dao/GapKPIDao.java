package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.GapKPI;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class GapKPIDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.GapKPI.executeBySql", sql);
   }

   public GapKPI queryObjectBySql(String sql) throws SQLException {
      return (GapKPI)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.GapKPI.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.GapKPI.findBySql", sql);
      }

      return result;
   }

   public int save(GapKPI gapKPI) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.GapKPI.save", gapKPI)).intValue();
   }

   public void update(GapKPI gapKPI) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.GapKPI.update", gapKPI);
   }
}
