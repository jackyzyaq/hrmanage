package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.SupervisorRanking;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class SupervisorRankingDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupervisorRanking.executeBySql", sql);
   }

   public SupervisorRanking findById(Integer id) throws SQLException {
      return (SupervisorRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.SupervisorRanking.findById", id);
   }

   public SupervisorRanking queryObjectBySql(String sql) throws SQLException {
      return (SupervisorRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.SupervisorRanking.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.SupervisorRanking.findBySql", sql);
      }

      return result;
   }

   public int save(SupervisorRanking supervisorRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.SupervisorRanking.save", supervisorRanking)).intValue();
   }

   public void update(SupervisorRanking supervisorRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupervisorRanking.update", supervisorRanking);
   }

   public int saveHeader(SupervisorRanking supervisorRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.SupervisorRanking.saveHeader", supervisorRanking)).intValue();
   }

   public void updateHeader(SupervisorRanking supervisorRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupervisorRanking.updateHeader", supervisorRanking);
   }
}
