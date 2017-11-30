package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.NationalHoliday;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class NationalHolidayDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public void executeBySql(String sql) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.NationalHoliday.executeBySql", sql);
   }

   public NationalHoliday findById(Integer id) throws SQLException {
      return (NationalHoliday)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.NationalHoliday.findById", id);
   }

   public NationalHoliday queryObjectBySql(String sql) throws SQLException {
      return (NationalHoliday)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.NationalHoliday.findBySql", sql);
   }

   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.NationalHoliday.findBySql", sql);
      }

      return result;
   }

   public int save(NationalHoliday nationalHoliday) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.NationalHoliday.save", nationalHoliday)).intValue();
   }

   public void update(NationalHoliday nationalHoliday) throws SQLException {
      this.sqlMapClient.update("com.yq.faurecia.pojo.NationalHoliday.update", nationalHoliday);
   }

   public NationalHoliday findByHolidayName(String holiday_name) throws SQLException {
      return (NationalHoliday)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.NationalHoliday.findByHolidayName", holiday_name);
   }
}
