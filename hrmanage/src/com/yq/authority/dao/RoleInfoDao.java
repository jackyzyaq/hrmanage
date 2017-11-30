package com.yq.authority.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.authority.pojo.RoleInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class RoleInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void deleteById(Integer id) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.RoleInfo.deleteById", id);
   }

   public void deleteByIds(String ids) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.RoleInfo.deleteByIds", ids);
   }

   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.RoleInfo.executeBySql", sql);
   }

   public RoleInfo findById(Integer id) throws SQLException {
      return (RoleInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.RoleInfo.findById", id);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.authority.pojo.RoleInfo.findBySql", sql);
      }

      return result;
   }

   public RoleInfo queryObjectBySql(String sql) throws SQLException {
      return (RoleInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.RoleInfo.findBySql", sql);
   }

   public void save(RoleInfo roleInfo) throws SQLException {
      this.sqlMapClient.insert("com.yq.authority.pojo.RoleInfo.save", roleInfo);
   }

   public void update(RoleInfo roleInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.RoleInfo.update", roleInfo);
   }

   public RoleInfo findByRoleCode(String roleCode) throws SQLException {
      return (RoleInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.RoleInfo.findByRoleCode", roleCode);
   }
}
