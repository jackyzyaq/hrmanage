package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.QRCILineData;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class QRCILineDataDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCILineData.executeBySql", sql);
   }

   public QRCILineData findById(Integer id) throws SQLException {
      return (QRCILineData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCILineData.findById", id);
   }

   public QRCILineData queryObjectBySql(String sql) throws SQLException {
      return (QRCILineData)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.QRCILineData.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.QRCILineData.findBySql", sql);
      }

      return result;
   }

   public int save(QRCILineData qrciDataLineData) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCILineData.save", qrciDataLineData)).intValue();
   }

   public void update(QRCILineData qrciDataLineData) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.QRCILineData.update", qrciDataLineData);
   }

   public int saveExt(QRCILineData qrciDataLineData) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCILineData.saveExt", qrciDataLineData)).intValue();
   }

   public void updateExt(QRCILineData qrciDataLineData) throws SQLException {
      this.sqlMapClient.insert("com.yq.company.etop5.pojo.QRCILineData.updateExt", qrciDataLineData);
   }
}
