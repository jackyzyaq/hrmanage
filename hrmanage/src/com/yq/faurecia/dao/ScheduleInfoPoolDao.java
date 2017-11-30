package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.ScheduleInfoPool;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleInfoPoolDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public ScheduleInfoPool queryObjectPoolBySql(String sql) throws SQLException {
      return (ScheduleInfoPool)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ScheduleInfoPool.findBySql", sql);
   }

   public List findPoolBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.ScheduleInfoPool.findBySql", sql);
      }

      return result;
   }

   public int savePool(ScheduleInfoPool scheduleInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.ScheduleInfoPool.savePool", scheduleInfo)).intValue();
   }

   public void updatePool(ScheduleInfoPool scheduleInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ScheduleInfoPool.updatePool", scheduleInfo);
   }
}
