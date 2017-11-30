package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.ClassInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ClassInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ClassInfo.executeBySql", sql);
   }

   public ClassInfo findById(Integer id) throws SQLException {
      return (ClassInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ClassInfo.findById", id);
   }

   public ClassInfo queryObjectBySql(String sql) throws SQLException {
      return (ClassInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ClassInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.ClassInfo.findBySql", sql);
      }

      return result;
   }

   public int save(ClassInfo classInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.ClassInfo.save", classInfo)).intValue();
   }

   public void update(ClassInfo classInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ClassInfo.update", classInfo);
   }
}
