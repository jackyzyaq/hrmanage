package com.yq.faurecia.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.faurecia.pojo.TimeSheet;
import com.yq.faurecia.pojo.TimeSheetDetail;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

@Repository
public class TimeSheetDao {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   public List findBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.TimeSheet.findBySql", sql);
      }

      return result;
   }

   public TimeSheet findTimeSheetBySql(String sql) throws SQLException {
      TimeSheet ts = (TimeSheet)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.TimeSheet.findBySql", sql);
      return ts;
   }

   public int save(TimeSheet timeSheet) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.TimeSheet.save", timeSheet)).intValue();
   }

   public int delTS(TimeSheet timeSheet) throws SQLException {
      return Integer.valueOf(this.sqlMapClient.update("com.yq.faurecia.pojo.TimeSheet.delTS", timeSheet)).intValue();
   }

   public List findDetailBySql(String sql) throws SQLException {
      List result = null;
      if(sql != null && !sql.trim().equals("")) {
         result = this.sqlMapClient.queryForList("com.yq.faurecia.pojo.TimeSheet.findDetailBySql", sql);
      }

      return result;
   }

   public TimeSheetDetail findTimeSheetDetailBySql(String sql) throws SQLException {
      TimeSheetDetail ts = (TimeSheetDetail)this.sqlMapClient.queryForObject("com.yq.faurecia.pojo.TimeSheet.findDetailBySql", sql);
      return ts;
   }

   public int saveDetail(TimeSheetDetail timeSheetDetail) throws SQLException {
      return ((Integer)this.sqlMapClient.insert("com.yq.faurecia.pojo.TimeSheet.saveDetail", timeSheetDetail)).intValue();
   }

   public int delDetail(TimeSheetDetail timeSheetDetail) throws SQLException {
      return Integer.valueOf(this.sqlMapClient.update("com.yq.faurecia.pojo.TimeSheet.delDetail", timeSheetDetail)).intValue();
   }
}
