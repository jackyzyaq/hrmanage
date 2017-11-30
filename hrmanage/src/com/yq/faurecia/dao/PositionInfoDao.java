package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.PositionInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class PositionInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.PositionInfo.executeBySql", sql);
   }

   public PositionInfo findById(Integer id) throws SQLException {
      return (PositionInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.PositionInfo.findById", id);
   }

   public PositionInfo queryObjectBySql(String sql) throws SQLException {
      return (PositionInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.PositionInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.PositionInfo.findBySql", sql);
      }

      return result;
   }

   public int save(PositionInfo posInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.PositionInfo.save", posInfo)).intValue();
   }

   public void update(PositionInfo posInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.PositionInfo.update", posInfo);
   }

   public PositionInfo findByPosCode(String pos_code) throws SQLException {
      return (PositionInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.PositionInfo.findByPosCode", pos_code);
   }
}
