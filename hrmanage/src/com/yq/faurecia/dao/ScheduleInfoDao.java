package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.ScheduleInfo;
import com.yq.faurecia.pojo.ScheduleInfoHistory;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ScheduleInfo.executeBySql", sql);
   }

   public ScheduleInfo findById(Integer id) throws SQLException {
      return (ScheduleInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ScheduleInfo.findById", id);
   }

   public ScheduleInfo queryObjectBySql(String sql) throws SQLException {
      return (ScheduleInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ScheduleInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.ScheduleInfo.findBySql", sql);
      }

      return result;
   }

   public int save(ScheduleInfo scheduleInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.ScheduleInfo.save", scheduleInfo)).intValue();
   }

   public void update(ScheduleInfo scheduleInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ScheduleInfo.update", scheduleInfo);
   }

   public int saveHistory(ScheduleInfoHistory scheduleInfoHistory) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.ScheduleInfo.saveHistory", scheduleInfoHistory)).intValue();
   }
}
