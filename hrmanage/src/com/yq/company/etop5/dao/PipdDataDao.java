package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.PipdData;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PipdDataDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdData.executeBySql", sql);
   }

   public PipdData findById(Integer id) throws SQLException {
      return (PipdData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdData.findById", id);
   }

   public PipdData queryObjectBySql(String sql) throws SQLException {
      return (PipdData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.PipdData.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.PipdData.findBySql", sql);
      }

      return result;
   }

   public int save(PipdData pipdData) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.PipdData.save", pipdData)).intValue();
   }

   public void update(PipdData pipdData) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.PipdData.update", pipdData);
   }
}
