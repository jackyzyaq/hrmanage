package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.ChangeManagement;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ChangeManagementDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.ChangeManagement.executeBySql", sql);
   }

   public ChangeManagement queryObjectBySql(String sql) throws SQLException {
      return (ChangeManagement)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.ChangeManagement.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.ChangeManagement.findBySql", sql);
      }

      return result;
   }

   public int save(ChangeManagement change_management) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.ChangeManagement.save", change_management)).intValue();
   }

   public void update(ChangeManagement change_management) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.ChangeManagement.update", change_management);
   }
}
