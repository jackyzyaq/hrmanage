package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.AuditRanking;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class AuditRankingDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.AuditRanking.executeBySql", sql);
   }

   public AuditRanking findById(Integer id) throws SQLException {
      return (AuditRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.AuditRanking.findById", id);
   }

   public AuditRanking queryObjectBySql(String sql) throws SQLException {
      return (AuditRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.AuditRanking.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.AuditRanking.findBySql", sql);
      }

      return result;
   }

   public int save(AuditRanking auditRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.AuditRanking.save", auditRanking)).intValue();
   }

   public void update(AuditRanking auditRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.AuditRanking.update", auditRanking);
   }

   public int saveHeader(AuditRanking auditRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.AuditRanking.saveHeader", auditRanking)).intValue();
   }

   public void updateHeader(AuditRanking auditRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.AuditRanking.updateHeader", auditRanking);
   }
}
