package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.FlowStep;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class FlowStepDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public FlowStep queryObjectBySql(String sql) throws SQLException {
      return (FlowStep)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.FlowStep.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.FlowStep.findBySql", sql);
      }

      return result;
   }

   public int save(FlowStep flowStep) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.FlowStep.save", flowStep)).intValue();
   }
}
