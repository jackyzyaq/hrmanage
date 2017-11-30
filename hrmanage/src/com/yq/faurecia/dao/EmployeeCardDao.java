package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.EmployeeCard;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class EmployeeCardDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeCard.executeBySql", sql);
   }

   public EmployeeCard findById(Integer id) throws SQLException {
      return (EmployeeCard)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeCard.findById", id);
   }

   public EmployeeCard queryObjectBySql(String sql) throws SQLException {
      return (EmployeeCard)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.EmployeeCard.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.EmployeeCard.findBySql", sql);
      }

      return result;
   }

   public int save(EmployeeCard empCard) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.EmployeeCard.save", empCard)).intValue();
   }

   public void update(EmployeeCard empCard) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.EmployeeCard.update", empCard);
   }
}
