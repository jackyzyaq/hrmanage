package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.QRCIDataDao;
import com.yq.company.etop5.pojo.QRCIData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("qrciDataService")
public class QRCIDataService {

   private String columns = " id,qrci_type,open_date,problem_descripion,yesterday_task_to_be_checked,task_for_next_day_future,respensible,d3_24_Hour,d6_10_Day,d8_60_Day,pfmea,cp,lls,plant_manager,lls1,lls_transversalization,lls_daily_tracking_30_days,lls1_pic,lls_transversalization_pic,lls_daily_tracking_30_days_pic,state,operater,create_date,update_date ";
   private String history_columns = " id,qrci_type,yesterday_task_to_be_checked,create_date ";
   private String defTable = "etop5.dbo.tb_qrci_data";
   private String historyTable = "etop5.dbo.tb_qrci_data_history";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private QRCIDataDao qrciDataDao;


   public QRCIData queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public QRCIData queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.qrciDataDao.queryObjectBySql(sql);
   }

   public QRCIData queryByQrciType(String qiciType) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where qrci_type = \'" + qiciType + "\'";
      return this.qrciDataDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(QRCIData qrciData) throws Exception {
      return this.qrciDataDao.save(qrciData);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveList(List qrciDataList) throws Exception {
      if(qrciDataList != null && !qrciDataList.isEmpty()) {
         Iterator var3 = qrciDataList.iterator();

         while(var3.hasNext()) {
            QRCIData qrciData = (QRCIData)var3.next();
            this.save(qrciData);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(QRCIData qrciData) throws Exception {
      QRCIData pd = this.queryByQrciType(StringUtils.defaultString(qrciData.getQrci_type(), ""));
      if(!((String)StringUtils.defaultIfEmpty(pd.getTask_for_next_day_future(), "")).equals(StringUtils.defaultIfEmpty(qrciData.getTask_for_next_day_future(), ""))) {
         qrciData.setYesterday_task_to_be_checked((String)StringUtils.defaultIfEmpty(pd.getTask_for_next_day_future(), ""));
         this.qrciDataDao.saveHistory(qrciData);
      }

      ReflectPOJO.alternateObject(qrciData, pd);
      this.qrciDataDao.update(qrciData);
   }

   public QRCIDataDao getQRCIDataDao() {
      return this.qrciDataDao;
   }

   public void setQRCIDataDao(QRCIDataDao qrciDataDao) {
      this.qrciDataDao = qrciDataDao;
   }

   public List findByCondition(QRCIData qrciData, Page page) throws Exception {
      Object result = new ArrayList();
      if(qrciData != null) {
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
            orderby = "  order by t.open_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(qrciData.getId() != null) {
            sql1.append(" and t.id =" + qrciData.getId() + " ");
         }

         if(qrciData.getState() != null) {
            sql1.append(" and t.state =" + qrciData.getState() + " ");
         }

         if(!StringUtils.isEmpty(qrciData.getQrci_type())) {
            sql1.append(" and t.qrci_type like \'%" + qrciData.getQrci_type() + "%\' ");
         }

         if(!StringUtils.isEmpty(qrciData.getOperater())) {
            sql1.append(" and t.operater like \'%" + qrciData.getOperater() + "%\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.qrciDataDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findHistory(String qrci_type) throws Exception {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.history_columns + "  ");
      sql.append(" from " + this.historyTable + " t   ");
      sql.append(" where 1=1 ");
      if(!StringUtils.isEmpty(qrci_type)) {
         sql.append(" and t.qrci_type =\'" + qrci_type + "\' ");
      }

      sql.append(" order by create_date desc ");
      return this.qrciDataDao.findBySql(sql.toString());
   }

   public List autoComplete(Map params) throws Exception {
      List result = null;
      if(params != null && params.size() > 0) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from (");
         sql.append(" select " + this.columns + ",ROW_NUMBER() OVER (order by t.id desc) AS RowNumber ");
         sql.append(" from " + this.defTable + " t   ");
         sql.append(" where t.state=1 ");
         if(!StringUtils.isEmpty((CharSequence)params.get("qrci_type"))) {
            sql.append(" and t.qrci_type like \'%" + (String)params.get("qrci_type") + "%\' ");
         }

         sql.append(" ) t where RowNumber > 0 and RowNumber <=20 ");
         result = this.qrciDataDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
