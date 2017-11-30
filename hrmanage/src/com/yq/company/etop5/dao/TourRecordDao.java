package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.TourRecord;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class TourRecordDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public TourRecord queryObjectBySql(String sql) throws SQLException {
      return (TourRecord)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.TourRecord.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.TourRecord.findBySql", sql);
      }

      return result;
   }

   public int save(TourRecord tourRecord) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.TourRecord.save", tourRecord)).intValue();
   }

   public void update(TourRecord tourRecord) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.TourRecord.update", tourRecord);
   }

   public int save24(TourRecord tourRecord) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.TourRecord.save24", tourRecord)).intValue();
   }

   public void update24(TourRecord tourRecord) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.TourRecord.update24", tourRecord);
   }
}
