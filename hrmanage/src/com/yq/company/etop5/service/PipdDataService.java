package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.PipdDataDao;
import com.yq.company.etop5.pojo.PipdData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PipdDataService {

   private String columns = " id,type,sub_type,report_date,reality_pipd_data,must_pipd_data,state,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_pipd_data";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private PipdDataDao pipdDataDao;


   public PipdData queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public PipdData queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.pipdDataDao.queryObjectBySql(sql);
   }

   public PipdData queryByReportDate(Date report_date, String type, String sub_type) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where report_date = \'" + this.sdf1.format(report_date) + "\' and type=\'" + type + "\' and sub_type=\'" + sub_type + "\' ";
      return this.pipdDataDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(PipdData pipdData) throws Exception {
      PipdData pd = this.queryByReportDate(pipdData.getReport_date(), pipdData.getType(), pipdData.getSub_type());
      boolean id = false;
      int id1;
      if(pd == null) {
         id1 = this.pipdDataDao.save(pipdData);
      } else {
         id1 = pd.getId().intValue();
         ReflectPOJO.copyObject(pd, pipdData);
         pd.setId(Integer.valueOf(id1));
         this.pipdDataDao.update(pd);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveList(List pipdDataList) throws Exception {
      if(pipdDataList != null && !pipdDataList.isEmpty()) {
         Iterator var3 = pipdDataList.iterator();

         while(var3.hasNext()) {
            PipdData pipdData = (PipdData)var3.next();
            this.save(pipdData);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(PipdData pipdData) throws Exception {
      this.pipdDataDao.update(pipdData);
   }

   public PipdDataDao getPipdDataDao() {
      return this.pipdDataDao;
   }

   public void setPipdDataDao(PipdDataDao pipdDataDao) {
      this.pipdDataDao = pipdDataDao;
   }

   public List findByCondition(PipdData pipdData, Page page) throws Exception {
      Object result = new ArrayList();
      if(pipdData != null) {
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
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(pipdData.getId() != null) {
            sql1.append(" and t.id =" + pipdData.getId() + " ");
         }

         if(!StringUtils.isEmpty(pipdData.getType())) {
            sql1.append(" and t.type =\'" + pipdData.getType() + "\' ");
         }

         if(!StringUtils.isEmpty(pipdData.getSub_type())) {
            sql1.append(" and t.sub_type =\'" + pipdData.getSub_type() + "\' ");
         }

         if(pipdData.getReport_date() != null) {
            sql1.append(" and t.report_date =\'" + this.sdf1.format(pipdData.getReport_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(pipdData.getStart_date())) {
            sql1.append(" and t.report_date >=\'" + pipdData.getStart_date() + "\' ");
         }

         if(!StringUtils.isEmpty(pipdData.getOver_date())) {
            sql1.append(" and t.report_date <=\'" + pipdData.getOver_date() + "\' ");
         }

         if(pipdData.getState() != null) {
            sql1.append(" and t.state =" + pipdData.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.pipdDataDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
