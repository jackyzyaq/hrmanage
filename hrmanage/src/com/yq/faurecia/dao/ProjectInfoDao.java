package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.ProjectInfo;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class ProjectInfoDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ProjectInfo.executeBySql", sql);
   }

   public ProjectInfo findById(Integer id) throws SQLException {
      return (ProjectInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ProjectInfo.findById", id);
   }

   public ProjectInfo queryObjectBySql(String sql) throws SQLException {
      return (ProjectInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ProjectInfo.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.ProjectInfo.findBySql", sql);
      }

      return result;
   }

   public int save(ProjectInfo projectInfo) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.ProjectInfo.save", projectInfo)).intValue();
   }

   public void update(ProjectInfo projectInfo) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.ProjectInfo.update", projectInfo);
   }

   public ProjectInfo findByProjectCode(String project_code) throws SQLException {
      return (ProjectInfo)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.ProjectInfo.findByPosCode", project_code);
   }
}
