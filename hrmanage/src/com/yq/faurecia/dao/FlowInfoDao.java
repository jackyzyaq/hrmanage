package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.FlowInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class FlowInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.FlowInfo.executeBySql", sql);
   }

   public FlowInfo findById(Integer id) throws SQLException {
      return (FlowInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.FlowInfo.findById", id);
   }

   public FlowInfo queryObjectBySql(String sql) throws SQLException {
      return (FlowInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.FlowInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.FlowInfo.findBySql", sql);
      }

      return result;
   }

   public int save(FlowInfo flowInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.FlowInfo.save", flowInfo)).intValue();
   }

   public void update(FlowInfo flowInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.FlowInfo.update", flowInfo);
   }

   public FlowInfo findByFlowCode(String flow_code) throws SQLException {
      return (FlowInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.FlowInfo.findByFlowCode", flow_code);
   }
}
