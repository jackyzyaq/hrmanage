package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class CommonSqlMapDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(Object o, String sql) throws SQLException {
      this.sqlMapClient.update(o.getClass().getName() + ".executeBySql", sql);
   }

   public Object queryObjectBySql(Object o, String sql) throws SQLException {
      return this.sqlMapClient.queryForObject(o.getClass().getName() + ".findBySql", sql);
   }

   public List findBySql(Object o, String sql) throws SQLException {
      return this.sqlMapClient.queryForList(o.getClass().getName() + ".findBySql", sql);
   }

   public int save(Object o) throws SQLException {
      return ((Integer)this.sqlMapClient.insert(o.getClass().getName() + ".save", o)).intValue();
   }

   public void update(Object o) throws SQLException {
      this.sqlMapClient.update(o.getClass().getName() + ".update", o);
   }
}
