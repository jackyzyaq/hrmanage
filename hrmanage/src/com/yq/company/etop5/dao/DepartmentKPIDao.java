package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.DepartmentKPI;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class DepartmentKPIDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.DepartmentKPI.executeBySql", sql);
   }

   public DepartmentKPI queryObjectBySql(String sql) throws SQLException {
      return (DepartmentKPI)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.DepartmentKPI.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.DepartmentKPI.findBySql", sql);
      }

      return result;
   }

   public int save(DepartmentKPI departmentKPI) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.DepartmentKPI.save", departmentKPI)).intValue();
   }

   public void update(DepartmentKPI departmentKPI) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.DepartmentKPI.update", departmentKPI);
   }
}
