package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.DepartmentInfo;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class DepartmentInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void deleteById(Integer id) throws SQLException {
      this.sqlMapClient.delete("com.yq.faurecia.pojo.DepartmentInfo.deleteById", id);
   }

   public void deleteByIds(String ids) throws SQLException {
      this.sqlMapClient.delete("com.yq.faurecia.pojo.DepartmentInfo.deleteByIds", ids);
   }

   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.DepartmentInfo.executeBySql", sql);
   }

   public DepartmentInfo findById(Integer id) throws SQLException {
      return (DepartmentInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.DepartmentInfo.findById", id);
   }

   public DepartmentInfo queryObjectBySql(String sql) throws SQLException {
      return (DepartmentInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.DepartmentInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.DepartmentInfo.findBySql", sql);
      }

      return result;
   }

   public int save(DepartmentInfo deptInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.DepartmentInfo.save", deptInfo)).intValue();
   }

   public void update(DepartmentInfo deptInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.DepartmentInfo.update", deptInfo);
   }

   public List findByParentId(Integer parent_id) throws SQLException {
      return this.sqlMapClient.queryForList("com.yq.faurecia.pojo.DepartmentInfo.findByParentId", parent_id);
   }

   public DepartmentInfo findByDeptCode(String dept_code) throws SQLException {
      return (DepartmentInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.DepartmentInfo.findByDeptCode", dept_code);
   }

   public void saveDeptRole(Integer dept_id, Integer role_id) throws SQLException {
      HashMap map = new HashMap();
      map.put("dept_id", dept_id);
      map.put("role_id", role_id);
      this.sqlMapClient.insert("com.yq.faurecia.pojo.DepartmentInfo.saveDeptRole", map);
   }
}
