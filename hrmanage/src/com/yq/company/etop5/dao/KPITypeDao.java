package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.KPIType;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class KPITypeDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.KPIType.executeBySql", sql);
   }

   public KPIType queryObjectBySql(String sql) throws SQLException {
      return (KPIType)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.KPIType.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.KPIType.findBySql", sql);
      }

      return result;
   }

   public int save(KPIType kpiType) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.KPIType.save", kpiType)).intValue();
   }

   public void update(KPIType kpiType) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.KPIType.update", kpiType);
   }
}
