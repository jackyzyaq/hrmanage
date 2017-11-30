package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.PipdReport;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PipdReportDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdReport.executeBySql", sql);
   }

   public PipdReport findById(Integer id) throws SQLException {
      return (PipdReport)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdReport.findById", id);
   }

   public PipdReport queryObjectBySql(String sql) throws SQLException {
      return (PipdReport)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdReport.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.PipdReport.findBySql", sql);
      }

      return result;
   }

   public int save(PipdReport pipdReport) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.PipdReport.save", pipdReport)).intValue();
   }

   public void update(PipdReport pipdReport) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdReport.update", pipdReport);
   }
}
