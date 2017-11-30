package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.LeaveTypeDao;
import com.yq.faurecia.pojo.LeaveType;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LeaveTypeService {

   private String columns = " id,type_code,type_name,state,remark,create_date,update_date ";
   @Resource
   private LeaveTypeDao leaveTypeDao;


   public LeaveType findById(Integer id) throws Exception {
      return this.leaveTypeDao.findById(id);
   }

   public LeaveType queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public LeaveType queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_leave_type t " + " where id = " + id + state_s;
      return this.leaveTypeDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(LeaveType leaveType) throws Exception {
      return this.leaveTypeDao.save(leaveType);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(LeaveType leaveType) throws Exception {
      this.leaveTypeDao.update(leaveType);
   }

   public LeaveTypeDao getLeaveTypeDao() {
      return this.leaveTypeDao;
   }

   public void setLeaveTypeDao(LeaveTypeDao leaveTypeDao) {
      this.leaveTypeDao = leaveTypeDao;
   }

   public List findByCondition(LeaveType leaveType, Page page) throws Exception {
      Object result = new ArrayList();
      if(leaveType != null) {
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
         sql1.append(" from tb_leave_type t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(leaveType.getType_code())) {
            sql1.append(" and t.type_code = \'" + leaveType.getType_code() + "\' ");
         }

         if(!StringUtils.isEmpty(leaveType.getType_name())) {
            sql1.append(" and t.type_name like \'%" + leaveType.getType_name() + "%\' ");
         }

         if(leaveType.getState() != null) {
            sql1.append(" and t.state =" + leaveType.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.leaveTypeDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public LeaveType findByTypeCode(String type_code) throws Exception {
      return this.leaveTypeDao.findByTypeCode(type_code);
   }

   public boolean checkTypeCode(String type_code) throws Exception {
      boolean isTrue = false;
      LeaveType leaveType = new LeaveType();
      leaveType.setType_code(type_code);
      List mis = this.findByCondition(leaveType, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
