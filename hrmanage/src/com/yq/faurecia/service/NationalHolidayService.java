package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.NationalHolidayDao;
import com.yq.faurecia.pojo.NationalHoliday;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NationalHolidayService {

   private String columns = " id,holiday_name,holiday,state,remark,create_date,update_date ";
   @Resource
   private NationalHolidayDao nationalHolidayDao;


   public NationalHoliday queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public NationalHoliday queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_nationalholiday_info t " + " where id = " + id + state_s;
      return this.nationalHolidayDao.queryObjectBySql(sql);
   }

   public NationalHoliday queryByHoliday(Date date, Integer state) throws Exception {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_nationalholiday_info t " + " where holiday = \'" + sdf.format(date) + "\' " + state_s;
      return this.nationalHolidayDao.queryObjectBySql(sql);
   }

   public boolean isWorkDay(Date date) throws Exception {
      boolean isTrue = false;
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      List list = this.checkHrStatusDate("\'" + sdf.format(date) + "\'");
      if(list != null && list.size() != 0 && list.size() <= 1) {
         String holiday_name = ((NationalHoliday)list.get(0)).getHoliday_name();
         if(holiday_name.equals(Global.holidays_name[2])) {
            isTrue = true;
         }
      }

      return isTrue;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(String holiday_names, String holidays) throws Exception {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String[] names = holiday_names.split(",");
      String[] dates = holidays.split(",");
      int count = dates.length;

      for(int i = 0; i < count; ++i) {
         NationalHoliday nh = this.queryByHoliday(sdf.parse(dates[i]), (Integer)null);
         if(nh == null) {
            nh = new NationalHoliday();
            if(names[i].trim().equals("")) {
               nh.setState(Integer.valueOf(0));
               nh.setHoliday_name("");
            } else {
               nh.setState(Integer.valueOf(1));
               nh.setHoliday_name(names[i].trim());
            }

            nh.setHoliday(sdf.parse(dates[i]));
            this.nationalHolidayDao.save(nh);
         } else {
            if(names[i].trim().equals("")) {
               nh.setState(Integer.valueOf(0));
               nh.setHoliday_name("");
            } else {
               nh.setState(Integer.valueOf(1));
               nh.setHoliday_name(names[i].trim());
            }

            nh.setHoliday(sdf.parse(dates[i]));
            this.nationalHolidayDao.update(nh);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(NationalHoliday nationalHoliday) throws Exception {
      this.nationalHolidayDao.update(nationalHoliday);
   }

   public NationalHolidayDao getNationalHolidayDao() {
      return this.nationalHolidayDao;
   }

   public void setNationalHolidayDao(NationalHolidayDao nationalHolidayDao) {
      this.nationalHolidayDao = nationalHolidayDao;
   }

   public List findByCondition(Map map, Page page) throws Exception {
      Object result = new ArrayList();
      if(map != null && map.size() > 0) {
         String orderby = "";
         String rownumber = "";
         if(page != null && page.getTotalCount() > 0) {
            int sql = page.getPageSize();
            int fr = (page.getPageIndex() - 1) * sql;
            if(fr < 0) {
               fr = 0;
            }

            orderby = "  order by t." + page.getSidx() + " " + page.getSord() + " ";
            rownumber = " and  RowNumber > " + fr + " and RowNumber <=" + (fr + sql) + " ";
         } else {
            orderby = "  order by t.update_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from tb_nationalholiday_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty((CharSequence)map.get("holiday_name"))) {
            sql1.append(" and t.holiday_name = \'" + (String)map.get("holiday_name") + "\' ");
         }

         if(!StringUtils.isEmpty((CharSequence)map.get("begin_holiday"))) {
            sql1.append(" and t.holiday >=\'" + (String)map.get("begin_holiday") + "\' ");
         }

         if(!StringUtils.isEmpty((CharSequence)map.get("end_holiday"))) {
            sql1.append(" and t.holiday <=\'" + (String)map.get("end_holiday") + "\' ");
         }

         if(!StringUtils.isEmpty((CharSequence)map.get("tmpDate"))) {
            sql1.append(" and CONVERT(varchar(100), t.holiday, 23) in(" + (String)map.get("tmpDate") + ") ");
         }

         if(!StringUtils.isEmpty((CharSequence)map.get("state"))) {
            sql1.append(" and t.state =" + (String)map.get("state") + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.nationalHolidayDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public NationalHoliday findByHolidayName(String holiday_name) throws Exception {
      return this.nationalHolidayDao.findByHolidayName(holiday_name);
   }

   public List checkHrStatusDate(String tmpDate) throws Exception {
      List list = null;
      if(StringUtils.isEmpty(tmpDate)) {
         return list;
      } else {
         String sql = " select holiday_name from   tb_nationalholiday_info  t  where  state=1 and CONVERT(varchar(100), t.holiday, 23) in(" + tmpDate + ") " + " group by holiday_name";
         list = this.nationalHolidayDao.findBySql(sql);
         return list;
      }
   }
}
