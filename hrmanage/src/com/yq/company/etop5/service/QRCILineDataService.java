package com.yq.company.etop5.service;

import com.util.Page;
import com.util.Util;
import com.yq.company.etop5.dao.QRCILineDataDao;
import com.yq.company.etop5.pojo.QRCILineData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("qrciLineDataService")
public class QRCILineDataService {

   private String columns = " id,number,opening_date,dept_id,problem_discription,standards_check,cause_analysis,updates,signed_by_employee,remark,is_close,is_re_happend,is_up,up_number,ext_1,ext_2,ext_3,ext_4,ext_5,create_user,update_user,create_date,update_date ";
   private String ext_columns = " id,qrci_line_id,action,handler,deadline,val_date,class_name,is_ok,create_user,update_user,create_date,update_date,ext_1,ext_2,ext_3,ext_4,ext_5 ";
   private String defTable = "etop5.dbo.tb_qrci_line_data";
   private String extTable = "etop5.dbo.tb_qrci_line_data_ext";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private QRCILineDataDao qrciLineDataDao;


   public QRCILineData queryById(int id) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      return this.qrciLineDataDao.queryObjectBySql(sql);
   }

   public QRCILineData queryExtById(int id) throws Exception {
      String sql = " select " + this.ext_columns + " from " + this.extTable + " t " + " where id = " + id;
      return this.qrciLineDataDao.queryObjectBySql(sql);
   }

   public List queryExtByQrciLineId(int qrciLineId) throws Exception {
      return this.queryExtByQrciLineId(qrciLineId, (String)null);
   }

   public List queryExtByQrciLineId(int qrciLineId, String handler) throws Exception {
      String sql = " select " + this.ext_columns + " from " + this.extTable + " t " + " where qrci_line_id = " + qrciLineId + (StringUtils.isEmpty(handler)?"":" and handler =\'" + handler + "\' ");
      return this.qrciLineDataDao.findBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(QRCILineData qrciLineData) throws Exception {
      QRCILineData pd = this.queryById(qrciLineData.getId().intValue());
      boolean id = false;
      int id1;
      if(pd != null) {
         this.qrciLineDataDao.update(qrciLineData);
         id1 = pd.getId().intValue();
      } else {
         id1 = this.qrciLineDataDao.save(qrciLineData);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveExt(QRCILineData qrciLineData) throws Exception {
      QRCILineData pd = this.queryExtById(qrciLineData.getId().intValue());
      if(pd != null) {
         this.qrciLineDataDao.updateExt(qrciLineData);
      } else {
         this.qrciLineDataDao.saveExt(qrciLineData);
      }

   }

   public QRCILineDataDao getQRCILineDataDao() {
      return this.qrciLineDataDao;
   }

   public void setQRCILineDataDao(QRCILineDataDao qrciLineDataDao) {
      this.qrciLineDataDao = qrciLineDataDao;
   }

   public List findByCondition(QRCILineData qrciLineData, Page page) throws Exception {
      Object result = new ArrayList();
      if(qrciLineData != null) {
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
            orderby = "  order by t.id asc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(qrciLineData.getId() != null) {
            sql1.append(" and t.id =" + qrciLineData.getId() + " ");
         }

         if(qrciLineData.getNumber() != null) {
            sql1.append(" and t.number like \'%" + qrciLineData.getNumber() + "%\' ");
         }

         if(qrciLineData.getOpening_date() != null) {
            sql1.append(" and t.opening_date =\'" + this.sdf.format(qrciLineData.getOpening_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(qrciLineData.getStart_date())) {
            sql1.append(" and t.opening_date >=\'" + qrciLineData.getStart_date() + "\' ");
         }

         if(!StringUtils.isEmpty(qrciLineData.getOver_date())) {
            sql1.append(" and t.opening_date <=\'" + qrciLineData.getOver_date() + "\' ");
         }

         if(qrciLineData.getDept_id() != null) {
            sql1.append(" and t.dept_id =" + qrciLineData.getDept_id() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.qrciLineDataDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void delete(String ids) throws Exception {
      String sql = " delete from " + this.defTable + " where id in(" + ids + ") ";
      this.qrciLineDataDao.executeBySql(sql);
      sql = "delete from " + this.extTable + " where qrci_line_id in(" + ids + ")";
      this.qrciLineDataDao.executeBySql(sql);
   }

   public String getNumber2(String number1) throws Exception {
      Calendar c = Calendar.getInstance();
      String number2 = String.valueOf(c.get(1)).substring(2, 4);
      int max = 0;
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where number like \'" + number1 + "|%\'";
      List list = this.qrciLineDataDao.findBySql(sql);
      if(list != null && !list.isEmpty()) {
         Iterator var8 = list.iterator();

         while(var8.hasNext()) {
            QRCILineData qld = (QRCILineData)var8.next();
            int n2 = Integer.parseInt(qld.getNumber().split("\\|")[1]);
            if(n2 > max) {
               max = n2;
            }
         }
      }

      return String.valueOf(max).length() >= 5?String.valueOf(max + 1):number2 + Util.alternateZero(max + 1, 3);
   }
}
