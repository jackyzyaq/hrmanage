package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.OverTimeInfo;
import com.yq.faurecia.pojo.OverTimeInfoHistory;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class OverTimeInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.OverTimeInfo.executeBySql", sql);
   }

   public OverTimeInfo findById(Integer id) throws SQLException {
      return (OverTimeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.OverTimeInfo.findById", id);
   }

   public OverTimeInfo queryObjectBySql(String sql) throws SQLException {
      return (OverTimeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.OverTimeInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.OverTimeInfo.findBySql", sql);
      }

      return result;
   }

   public int save(OverTimeInfo overTimeInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.OverTimeInfo.save", overTimeInfo)).intValue();
   }

   public void update(OverTimeInfo overTimeInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.OverTimeInfo.update", overTimeInfo);
   }

   public int saveHistory(OverTimeInfoHistory overTimeInfoHistory) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.OverTimeInfo.saveHistory", overTimeInfoHistory)).intValue();
   }
}
