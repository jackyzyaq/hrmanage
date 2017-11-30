package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.EmployeeInfoHistory;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class EmployeeInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeInfo.executeBySql", sql);
   }

   public EmployeeInfo findById(Integer id) throws SQLException {
      return (EmployeeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeInfo.findById", id);
   }

   public EmployeeInfo queryObjectBySql(String sql) throws SQLException {
      return (EmployeeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.EmployeeInfo.findBySql", sql);
      }

      return result;
   }

   public void save(EmployeeInfo empInfo) throws SQLException {
      this.sqlMapClient.insert("com.yq.faurecia.pojo.EmployeeInfo.save", empInfo);
   }

   public void update(EmployeeInfo empInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeInfo.update", empInfo);
   }

   public EmployeeInfo findByEmpCode(String emp_code) throws SQLException {
      return (EmployeeInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeInfo.findByEmpCode", emp_code);
   }

   public void saveHistory(EmployeeInfoHistory empInfoHistory) throws SQLException {
      this.sqlMapClient.insert("com.yq.faurecia.pojo.EmployeeInfo.saveHistory", empInfoHistory);
   }

   public void saveHistoryChange(EmployeeInfoHistory empInfoHistory) throws SQLException {
      this.sqlMapClient.insert("com.yq.faurecia.pojo.EmployeeInfo.saveHistoryChange", empInfoHistory);
   }

   public List findHistoryBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.EmployeeInfo.findHistoryBySql", sql);
      }

      return result;
   }
}
