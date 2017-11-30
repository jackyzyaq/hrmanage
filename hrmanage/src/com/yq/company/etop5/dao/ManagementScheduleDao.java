package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.ManagementSchedule;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ManagementScheduleDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.ManagementSchedule.executeBySql", sql);
   }

   public ManagementSchedule queryObjectBySql(String sql) throws SQLException {
      return (ManagementSchedule)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.ManagementSchedule.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.ManagementSchedule.findBySql", sql);
      }

      return result;
   }

   public int save(ManagementSchedule managementSchedule) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.ManagementSchedule.save", managementSchedule)).intValue();
   }

   public void update(ManagementSchedule managementSchedule) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.ManagementSchedule.update", managementSchedule);
   }
}
