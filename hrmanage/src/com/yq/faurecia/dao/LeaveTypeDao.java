package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.LeaveType;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class LeaveTypeDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.LeaveType.executeBySql", sql);
   }

   public LeaveType findById(Integer id) throws SQLException {
      return (LeaveType)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.LeaveType.findById", id);
   }

   public LeaveType queryObjectBySql(String sql) throws SQLException {
      return (LeaveType)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.LeaveType.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.LeaveType.findBySql", sql);
      }

      return result;
   }

   public int save(LeaveType leaveType) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.LeaveType.save", leaveType)).intValue();
   }

   public void update(LeaveType leaveType) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.LeaveType.update", leaveType);
   }

   public LeaveType findByTypeCode(String type_code) throws SQLException {
      return (LeaveType)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.LeaveType.findByTypeCode", type_code);
   }
}
