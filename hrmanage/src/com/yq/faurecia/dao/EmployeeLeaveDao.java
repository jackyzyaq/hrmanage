package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.EmployeeLeave;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class EmployeeLeaveDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeLeave.executeBySql", sql);
   }

   public EmployeeLeave findById(Integer id) throws SQLException {
      return (EmployeeLeave)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeLeave.findById", id);
   }

   public EmployeeLeave queryObjectBySql(String sql) throws SQLException {
      return (EmployeeLeave)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeLeave.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.EmployeeLeave.findBySql", sql);
      }

      return result;
   }

   public int save(EmployeeLeave empLeave) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.EmployeeLeave.save", empLeave)).intValue();
   }

   public void update(EmployeeLeave empLeave) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeLeave.update", empLeave);
   }

   public void updateByEmpIdAndYear(EmployeeLeave empLeave) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeLeave.updateByEmpIdAndYear", empLeave);
   }
}
