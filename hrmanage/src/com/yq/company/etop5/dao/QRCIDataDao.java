package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.QRCIData;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class QRCIDataDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCIData.executeBySql", sql);
   }

   public QRCIData findById(Integer id) throws SQLException {
      return (QRCIData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCIData.findById", id);
   }

   public QRCIData queryObjectBySql(String sql) throws SQLException {
      return (QRCIData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCIData.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.QRCIData.findBySql", sql);
      }

      return result;
   }

   public int save(QRCIData qrciData) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCIData.save", qrciData)).intValue();
   }

   public void update(QRCIData qrciData) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCIData.update", qrciData);
   }

   public void saveHistory(QRCIData qrciDataHistory) throws SQLException {
      this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCIData.saveHistory", qrciDataHistory);
   }
}
