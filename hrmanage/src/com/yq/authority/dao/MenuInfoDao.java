package com.yq.authority.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.authority.pojo.MenuInfo;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class MenuInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void deleteById(Integer id) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.MenuInfo.deleteById", id);
   }

   public void deleteByIds(String ids) throws SQLException {
      this.sqlMapClient.delete("com.yq.authority.pojo.MenuInfo.deleteByIds", ids);
   }

   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.MenuInfo.executeBySql", sql);
   }

   public MenuInfo findById(Integer id) throws SQLException {
      return (MenuInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.MenuInfo.findById", id);
   }

   public MenuInfo queryObjectBySql(String sql) throws SQLException {
      return (MenuInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.MenuInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.authority.pojo.MenuInfo.findBySql", sql);
      }

      return result;
   }

   public int save(MenuInfo menuInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.authority.pojo.MenuInfo.save", menuInfo)).intValue();
   }

   public void update(MenuInfo menuInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.authority.pojo.MenuInfo.update", menuInfo);
   }

   public List findByParentId(Integer parent_id) throws SQLException {
      return this.sqlMapClient.queryForList("com.yq.authority.pojo.MenuInfo.findByParentId", parent_id);
   }

   public MenuInfo findByMenuCode(String menu_code) throws SQLException {
      return (MenuInfo)this.sqlMapClient.queryForObject("com.yq.authority.pojo.MenuInfo.findByMenuCode", menu_code);
   }

   public void saveMenuRole(Integer menu_id, Integer role_id) throws SQLException {
      HashMap map = new HashMap();
      map.put("menu_id", menu_id);
      map.put("role_id", role_id);
      this.sqlMapClient.insert("com.yq.authority.pojo.MenuInfo.saveMenuRole", map);
   }
}
