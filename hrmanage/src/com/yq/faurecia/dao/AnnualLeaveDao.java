package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.AnnualLeave;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class AnnualLeaveDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.AnnualLeave.executeBySql", sql);
   }

   public AnnualLeave queryObjectBySql(String sql) throws SQLException {
      return (AnnualLeave)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.AnnualLeave.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.AnnualLeave.findBySql", sql);
      }

      return result;
   }

   public int save(AnnualLeave annualLeave) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.AnnualLeave.save", annualLeave)).intValue();
   }

   public void update(AnnualLeave annualLeave) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.AnnualLeave.update", annualLeave);
   }
}
