package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.PipdPrioritiesManagement;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PipdPrioritiesManagementDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdPrioritiesManagement.executeBySql", sql);
   }

   public PipdPrioritiesManagement findById(Integer id) throws SQLException {
      return (PipdPrioritiesManagement)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdPrioritiesManagement.findById", id);
   }

   public PipdPrioritiesManagement queryObjectBySql(String sql) throws SQLException {
      return (PipdPrioritiesManagement)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdPrioritiesManagement.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.PipdPrioritiesManagement.findBySql", sql);
      }

      return result;
   }

   public int save(PipdPrioritiesManagement pipdPrioritiesManagement) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.PipdPrioritiesManagement.save", pipdPrioritiesManagement)).intValue();
   }

   public void update(PipdPrioritiesManagement pipdPrioritiesManagement) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdPrioritiesManagement.update", pipdPrioritiesManagement);
   }
}
