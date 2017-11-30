package com.yq.company.etop5.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.company.etop5.pojo.SupplierRanking;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class SupplierRankingDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupplierRanking.executeBySql", sql);
   }

   public SupplierRanking findById(Integer id) throws SQLException {
      return (SupplierRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.SupplierRanking.findById", id);
   }

   public SupplierRanking queryObjectBySql(String sql) throws SQLException {
      return (SupplierRanking)this.sqlMapClient.queryForObject("com.yq.company.etop5.pojo.SupplierRanking.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.company.etop5.pojo.SupplierRanking.findBySql", sql);
      }

      return result;
   }

   public int save(SupplierRanking supplierRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.SupplierRanking.save", supplierRanking)).intValue();
   }

   public void saveSupplier(String supplier) throws SQLException {
      this.sqlMapClient.insert("com.yq.company.etop5.pojo.SupplierRanking.saveSupplier", supplier);
   }

   public void update(SupplierRanking supplierRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupplierRanking.update", supplierRanking);
   }

   public int saveStatus(SupplierRanking supplierRanking) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.company.etop5.pojo.SupplierRanking.saveStatus", supplierRanking)).intValue();
   }

   public void updateStatus(SupplierRanking supplierRanking) throws SQLException {
      this.sqlMapClient.update("com.yq.company.etop5.pojo.SupplierRanking.updateStatus", supplierRanking);
   }
}
