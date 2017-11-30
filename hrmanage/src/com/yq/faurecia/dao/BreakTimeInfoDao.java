package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.BreakTimeInfo;
import com.yq.faurecia.pojo.BreakTimeInfoHistory;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class BreakTimeInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.BreakTimeInfo.executeBySql", sql);
   }

   public BreakTimeInfo findById(Integer id) throws SQLException {
      return (BreakTimeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.BreakTimeInfo.findById", id);
   }

   public BreakTimeInfo queryObjectBySql(String sql) throws SQLException {
      return (BreakTimeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.BreakTimeInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.BreakTimeInfo.findBySql", sql);
      }

      return result;
   }

   public int save(BreakTimeInfo breakTimeInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.BreakTimeInfo.save", breakTimeInfo)).intValue();
   }

   public void update(BreakTimeInfo breakTimeInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.BreakTimeInfo.update", breakTimeInfo);
   }

   public int saveHistory(BreakTimeInfoHistory breakTimeInfoHistory) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.BreakTimeInfo.saveHistory", breakTimeInfoHistory)).intValue();
   }
}
