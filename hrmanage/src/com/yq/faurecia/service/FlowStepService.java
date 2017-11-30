package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.FlowStepDao;
import com.yq.faurecia.pojo.FlowStep;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FlowStepService {

   private String columns = " id,flow_id,handle_id,state,state_date,emp_id,emp_name,remark,create_date ";
   @Resource
   private FlowStepDao flowStepDao;


   public FlowStep queryById(int id) throws Exception {
      String sql = " select " + this.columns + " from tb_flow_step t " + " where id = " + id;
      return this.flowStepDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(FlowStep flowStep) throws Exception {
      return this.flowStepDao.save(flowStep);
   }

   public FlowStepDao getFlowStepDao() {
      return this.flowStepDao;
   }

   public void setFlowStepDao(FlowStepDao flowStepDao) {
      this.flowStepDao = flowStepDao;
   }

   public List findByCondition(FlowStep flowStep, Page page) throws Exception {
      Object result = new ArrayList();
      if(flowStep != null) {
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
         sql1.append(" from tb_flow_step t   ");
         sql1.append(" where 1=1 ");
         if(flowStep.getHandle_id() != null) {
            sql1.append(" and t.handle_id = " + flowStep.getHandle_id() + " ");
         }

         if(flowStep.getFlow_id() != null) {
            sql1.append(" and t.flow_id = " + flowStep.getFlow_id() + " ");
         }

         if(!StringUtils.isEmpty(flowStep.getEmp_name())) {
            sql1.append(" and t.emp_name = \'" + flowStep.getEmp_name() + "\' ");
         }

         if(flowStep.getEmp_id() != null) {
            sql1.append(" and t.emp_id = " + flowStep.getEmp_id() + " ");
         }

         if(flowStep.getState() != null) {
            sql1.append(" and t.state =" + flowStep.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.flowStepDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
