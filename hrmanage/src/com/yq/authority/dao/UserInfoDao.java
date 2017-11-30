package com.yq.authority.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.authority.pojo.UserInfo;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Component;

@Component
public class UserInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public SqlMapClient getSqlMapClient() {
      return this.sqlMapClient;
   }

   public void setSqlMapClient(SqlMapClient sqlMapClient) {
      this.sqlMapClient = sqlMapClient;
   }

   public int save(UserInfo u) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.authority.pojo.UserInfo.save", u)).intValue();
   }

   public void saveUserRole(Integer user_id, Integer role_id) throws SQLException {
      HashMap map = new HashMap();
      map.put("user_id", user_id);
      map.put("role_id", role_id);
      this.sqlMapClient.insert("com.yq.authority.pojo.UserInfo.saveUserRole", map);
   }

   public void update(UserInfo u) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.UserInfo.update", u);
   }

   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.UserInfo.executeBySql", sql);
   }

   public UserInfo queryObjectBySql(String sql) throws SQLException {
      return (UserInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.UserInfo.queryBySql", sql);
   }

   public List queryListBySql(String sql) throws SQLException {
      return this.sqlMapClient.queryForList("com.yq.authority.pojo.UserInfo.queryBySql", sql);
   }
}
