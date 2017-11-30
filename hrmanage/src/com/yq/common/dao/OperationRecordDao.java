package com.yq.common.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.common.pojo.OperationRecord;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class OperationRecordDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public OperationRecord queryObjectBySql(String sql) throws SQLException {
      return (OperationRecord)this.sqlMapClient.queryForObject("com.yq.common.pojo.OperationRecord.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.common.pojo.OperationRecord.findBySql", sql);
      }

      return result;
   }

   public int save(OperationRecord operationRecord) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.common.pojo.OperationRecord.save", operationRecord)).intValue();
   }
}
