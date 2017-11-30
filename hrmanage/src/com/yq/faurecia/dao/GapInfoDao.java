package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.GapInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class GapInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.GapInfo.executeBySql", sql);
   }

   public GapInfo findById(Integer id) throws SQLException {
      return (GapInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.GapInfo.findById", id);
   }

   public GapInfo queryObjectBySql(String sql) throws SQLException {
      return (GapInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.GapInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.GapInfo.findBySql", sql);
      }

      return result;
   }

   public int save(GapInfo gapInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.GapInfo.save", gapInfo)).intValue();
   }

   public void update(GapInfo gapInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.GapInfo.update", gapInfo);
   }

   public GapInfo findByGapCode(String gap_code) throws SQLException {
      return (GapInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.GapInfo.findByPosCode", gap_code);
   }
}
