package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.QRCIDepartmentData;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class QRCIDepartmentDataDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCIDepartmentData.executeBySql", sql);
   }

   public QRCIDepartmentData findById(Integer id) throws SQLException {
      return (QRCIDepartmentData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCIDepartmentData.findById", id);
   }

   public QRCIDepartmentData queryObjectBySql(String sql) throws SQLException {
      return (QRCIDepartmentData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCIDepartmentData.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.QRCIDepartmentData.findBySql", sql);
      }

      return result;
   }

   public int save(QRCIDepartmentData qrciDataDepartmentData) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCIDepartmentData.save", qrciDataDepartmentData)).intValue();
   }

   public void update(QRCIDepartmentData qrciDataDepartmentData) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCIDepartmentData.update", qrciDataDepartmentData);
   }

   public void saveHistory(QRCIDepartmentData qrciDataDepartmentDataHistory) throws SQLException {
      this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCIDepartmentData.saveHistory", qrciDataDepartmentDataHistory);
   }
}
