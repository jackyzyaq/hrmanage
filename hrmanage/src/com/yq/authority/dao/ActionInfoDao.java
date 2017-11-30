package com.yq.authority.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.authority.pojo.ActionInfo;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

@Repository
public class ActionInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void deleteById(Integer id) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.ActionInfo.deleteById", id);
   }

   public void deleteByIds(String ids) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.ActionInfo.deleteByIds", ids);
   }

   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.ActionInfo.executeBySql", sql);
   }

   public ActionInfo findById(Integer id) throws SQLException {
      return (ActionInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.ActionInfo.findById", id);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.authority.pojo.ActionInfo.findBySql", sql);
      }

      return result;
   }

   public List findByMenuIds(String menuIds) throws SQLException {
      List result = null;
      if(!StringUtils.isEmpty(menuIds)) {
         result = this.sqlMapClient.queryForList("com.yq.authority.pojo.ActionInfo.findByMenuIds", menuIds);
      }

      return result;
   }

   public void save(ActionInfo actionInfo) throws SQLException {
      this.sqlMapClient.insert("com.yq.authority.pojo.ActionInfo.save", actionInfo);
   }

   public void saveActionRole(Integer action_id, String role_id) throws SQLException {
      HashMap map = new HashMap();
      map.put("action_id", action_id);
      map.put("role_id", role_id);
      this.sqlMapClient.insert("com.yq.authority.pojo.ActionInfo.saveActionRole", map);
   }

   public void update(ActionInfo actionInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.ActionInfo.update", actionInfo);
   }

   public ActionInfo findByActionCode(String actionCode) throws SQLException {
      return (ActionInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.ActionInfo.findByActionCode", actionCode);
   }
}
