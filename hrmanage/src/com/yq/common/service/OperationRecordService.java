package com.yq.common.service;

import com.util.Page;
import com.yq.common.dao.OperationRecordDao;
import com.yq.common.pojo.OperationRecord;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OperationRecordService {

   private String columns = " id,user_id,user_name,menu_name,url,object_id,operation_type,operation_object,operation_content,create_date ";
   @Resource
   private OperationRecordDao operationRecordDao;


   public OperationRecord queryById(int id) throws Exception {
      String sql = " select " + this.columns + " from tb_operation_record t " + " where id = " + id;
      return this.operationRecordDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(OperationRecord operationRecord) throws Exception {
      return this.operationRecordDao.save(operationRecord);
   }

   public OperationRecordDao getOperationRecordDao() {
      return this.operationRecordDao;
   }

   public void setOperationRecordDao(OperationRecordDao operationRecordDao) {
      this.operationRecordDao = operationRecordDao;
   }

   public List findByCondition(OperationRecord operationRecord, Page page) throws Exception {
      Object result = new ArrayList();
      if(operationRecord != null) {
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
            orderby = "  order by t.create_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from tb_operation_record t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(operationRecord.getOperation_content())) {
            sql1.append(" and t.operation_content like \'%" + operationRecord.getOperation_content() + "%\' ");
         }

         if(operationRecord.getObject_id() != null) {
            sql1.append(" and t.object_id =" + operationRecord.getObject_id() + " ");
         }

         if(!StringUtils.isEmpty(operationRecord.getOperation_object())) {
            sql1.append(" and t.operation_object = \'" + operationRecord.getOperation_object() + "\' ");
         }

         if(!StringUtils.isEmpty(operationRecord.getOperation_type())) {
            sql1.append(" and t.operation_type = \'" + operationRecord.getOperation_type() + "\' ");
         }

         if(operationRecord.getUser_id() != null) {
            sql1.append(" and t.user_id =" + operationRecord.getUser_id() + " ");
         }

         if(!StringUtils.isEmpty(operationRecord.getUser_name())) {
            sql1.append(" and t.user_name =\'" + operationRecord.getUser_name() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.operationRecordDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
