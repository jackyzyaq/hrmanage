package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.PipdReportDao;
import com.yq.company.etop5.pojo.PipdReport;
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
public class PipdReportService {

   private String columns = " id,type,sub_type,begin_month,end_month,upload_uuid_pic,upload_uuid,state,operater,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_pipd_report";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private PipdReportDao pipdReportDao;


   public PipdReport queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public PipdReport queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.pipdReportDao.queryObjectBySql(sql);
   }

   public PipdReport queryByReportDate(Date begin_month, Date end_month, String type, String sub_type) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where begin_month = \'" + this.sdf1.format(begin_month) + "\' and end_month = \'" + this.sdf1.format(end_month) + "\' and type=\'" + type + "\' and sub_type=\'" + sub_type + "\' ";
      return this.pipdReportDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(PipdReport pipdReport) throws Exception {
      PipdReport pd = this.queryByReportDate(pipdReport.getBegin_month(), pipdReport.getEnd_month(), pipdReport.getType(), pipdReport.getSub_type());
      boolean id = false;
      int id1;
      if(pd == null) {
         id1 = this.pipdReportDao.save(pipdReport);
      } else {
         id1 = pd.getId().intValue();
         ReflectPOJO.copyObject(pd, pipdReport);
         pd.setId(Integer.valueOf(id1));
         this.pipdReportDao.update(pd);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveList(List pipdReportList) throws Exception {
      if(pipdReportList != null && !pipdReportList.isEmpty()) {
         Iterator var3 = pipdReportList.iterator();

         while(var3.hasNext()) {
            PipdReport pipdReport = (PipdReport)var3.next();
            this.save(pipdReport);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(PipdReport pipdReport) throws Exception {
      this.pipdReportDao.update(pipdReport);
   }

   public PipdReportDao getPipdReportDao() {
      return this.pipdReportDao;
   }

   public void setPipdReportDao(PipdReportDao pipdReportDao) {
      this.pipdReportDao = pipdReportDao;
   }

   public List findByCondition(PipdReport pipdReport, Page page) throws Exception {
      Object result = new ArrayList();
      if(pipdReport != null) {
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
            orderby = "  order by t.begin_month desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(pipdReport.getId() != null) {
            sql1.append(" and t.id =" + pipdReport.getId() + " ");
         }

         if(!StringUtils.isEmpty(pipdReport.getType())) {
            sql1.append(" and t.type =\'" + pipdReport.getType() + "\' ");
         }

         if(!StringUtils.isEmpty(pipdReport.getSub_type())) {
            sql1.append(" and t.sub_type =\'" + pipdReport.getSub_type() + "\' ");
         }

         if(pipdReport.getBegin_month() != null) {
            sql1.append(" and t.begin_month =\'" + this.sdf1.format(pipdReport.getBegin_month()) + "\' ");
         }

         if(pipdReport.getEnd_month() != null) {
            sql1.append(" and t.end_month =\'" + this.sdf1.format(pipdReport.getEnd_month()) + "\' ");
         }

         if(pipdReport.getState() != null) {
            sql1.append(" and t.state =" + pipdReport.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.pipdReportDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public PipdReport queryBest() throws Exception {
      String sql = "select * from ( select " + this.columns + ",ROW_NUMBER() OVER (order by t.begin_month desc) AS RowNumber" + " from " + this.defTable + " t " + " where state=1  " + " ) t where RowNumber = 1";
      return this.pipdReportDao.queryObjectBySql(sql);
   }
}
