package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.HrStatus;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class HrStatusDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.HrStatus.executeBySql", sql);
   }

   public HrStatus queryObjectBySql(String sql) throws SQLException {
      return (HrStatus)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.HrStatus.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.HrStatus.findBySql", sql);
      }

      return result;
   }

   public int save(HrStatus hrStatus) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.HrStatus.save", hrStatus)).intValue();
   }

   public void update(HrStatus hrStatus) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.HrStatus.update", hrStatus);
   }
}
