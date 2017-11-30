package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.FlowInfoDao;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.FlowInfo;
import com.yq.faurecia.service.DepartmentInfoService;
import com.yq.faurecia.service.EmployeeInfoService;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FlowInfoService {

   private String columns = " id,flow_code,flow_name,state,days_down,days_up,step_info,remark,create_date,update_date ";
   @Resource
   private FlowInfoDao flowInfoDao;
   @Resource
   private EmployeeInfoService employeeInfoService;
   @Resource
   private DepartmentInfoService departmentInfoService;


   public FlowInfo findById(Integer id) throws Exception {
      return this.flowInfoDao.findById(id);
   }

   public FlowInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public FlowInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_flow_info t " + " where id = " + id + state_s;
      return this.flowInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(FlowInfo flowInfo) throws Exception {
      return this.flowInfoDao.save(flowInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(FlowInfo flowInfo) throws Exception {
      this.flowInfoDao.update(flowInfo);
   }

   public FlowInfoDao getFlowInfoDao() {
      return this.flowInfoDao;
   }

   public void setFlowInfoDao(FlowInfoDao flowInfoDao) {
      this.flowInfoDao = flowInfoDao;
   }

   public List findByCondition(FlowInfo flowInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(flowInfo != null) {
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
         sql1.append(" from tb_flow_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(flowInfo.getFlow_name())) {
            sql1.append(" and t.flow_name = \'" + flowInfo.getFlow_name() + "\' ");
         }

         if(flowInfo.getDays_down() != null) {
            sql1.append(" and t.days_down =" + flowInfo.getDays_down() + " ");
         }

         if(flowInfo.getDays_up() != null) {
            sql1.append(" and t.days_up =" + flowInfo.getDays_up() + " ");
         }

         if(flowInfo.getDays() != null) {
            sql1.append(" and " + flowInfo.getDays() + " >= t.days_down  ");
            sql1.append(" and " + flowInfo.getDays() + " < t.days_up ");
         }

         if(flowInfo.getState() != null) {
            sql1.append(" and t.state =" + flowInfo.getState() + " ");
         }

         if(!StringUtils.isEmpty(flowInfo.getFlow_code())) {
            sql1.append(" and t.flow_code = \'" + flowInfo.getFlow_code() + "\' ");
         }

         if(!StringUtils.isEmpty(flowInfo.getStep_info())) {
            sql1.append(" and t.step_info like \'%" + flowInfo.getStep_info() + "%\' ");
         }

         if(!StringUtils.isEmpty(flowInfo.getSpecialStr())) {
            sql1.append(flowInfo.getSpecialStr());
         }

         if(flowInfo.getState() != null) {
            sql1.append(" and t.state =" + flowInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.flowInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public FlowInfo findByFlowCode(String flow_code) throws Exception {
      return this.flowInfoDao.findByFlowCode(flow_code);
   }

   public boolean checkFlowCode(String flow_code) throws Exception {
      boolean isTrue = false;
      FlowInfo flowInfo = new FlowInfo();
      flowInfo.setFlow_code(flow_code);
      List mis = this.findByCondition(flowInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public int getFlowIdByList(List list) {
      int flow_id = 0;
      if(list != null && list.size() == 1) {
         flow_id = ((FlowInfo)list.get(0)).getId().intValue();
      }

      return flow_id;
   }

   public List getFlowBy(int emp_id, String flow_type, int days) {
      ArrayList flowInfoResult = null;

      try {
         EmployeeInfo e = this.employeeInfoService.queryById(emp_id);
         if(e != null && e.getId().intValue() > 0) {
            String allID = this.employeeInfoService.getLeaderAllIDByDeptId(e.getDept_id(), e.getId().toString());
            if(!StringUtils.isEmpty(allID)) {
               String[] empArr = allID.split(">>");
               if(empArr.length > 1) {
                  flowInfoResult = new ArrayList();
                  FlowInfo fi = new FlowInfo();
                  String tmpS = " and (";
                  String[] var13;
                  int var12 = (var13 = empArr[empArr.length - 2].trim().split(",")).length;

                  for(int var11 = 0; var11 < var12; ++var11) {
                     String s = var13[var11];
                     tmpS = tmpS + " t.step_info like \'%" + "[[]1," + s.trim() + "|" + "%\' or";
                  }

                  tmpS = tmpS.substring(0, tmpS.lastIndexOf("or"));
                  tmpS = tmpS + " ) ";
                  fi.setSpecialStr(tmpS);
                  fi.setFlow_name(flow_type);
                  if(flow_type.equals(Global.flow_type[1])) {
                     fi.setDays(Integer.valueOf(days));
                  }

                  fi.setState(Integer.valueOf(1));
                  flowInfoResult.addAll(this.findByCondition(fi, (Page)null));
               }
            }
         }
      } catch (Exception var14) {
         var14.printStackTrace();
      }

      return flowInfoResult;
   }
}
