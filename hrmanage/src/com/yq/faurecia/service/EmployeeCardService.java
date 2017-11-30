package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.EmployeeCardDao;
import com.yq.faurecia.pojo.EmployeeCard;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EmployeeCardService {

   private String columns = " \tid,emp_id,card,state,remark,create_date,update_date ";
   @Resource
   private EmployeeCardDao employeeCardDao;


   public EmployeeCard queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public EmployeeCard queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_employee_card t " + " where id = " + id + state_s;
      return this.employeeCardDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(EmployeeCard employeeCard) throws Exception {
      EmployeeCard result = this.findByEmpId(employeeCard.getEmp_id());
      if(result != null) {
         result.setState(Integer.valueOf(0));
         this.employeeCardDao.update(result);
      }

      employeeCard.setState(Integer.valueOf(1));
      int id = this.employeeCardDao.save(employeeCard);
      employeeCard.setId(Integer.valueOf(id));
      Global.loadData(employeeCard);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(EmployeeCard employeeCard) throws Exception {
      this.employeeCardDao.update(employeeCard);
      Global.loadData(employeeCard);
   }

   public EmployeeCardDao getEmployeeCardDao() {
      return this.employeeCardDao;
   }

   public void setEmployeeCardDao(EmployeeCardDao employeeCardDao) {
      this.employeeCardDao = employeeCardDao;
   }

   public List findByCondition(EmployeeCard employeeCard, Page page) throws Exception {
      Object result = new ArrayList();
      if(employeeCard != null) {
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
         sql1.append(" from tb_employee_card t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(employeeCard.getCard())) {
            sql1.append(" and t.card = \'" + employeeCard.getCard() + "\' ");
         }

         if(employeeCard.getEmp_id() != null) {
            sql1.append(" and t.emp_id in(" + employeeCard.getEmp_id() + ") ");
         }

         if(employeeCard.getState() != null) {
            sql1.append(" and t.state =" + employeeCard.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.employeeCardDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public EmployeeCard findByEmpId(Integer empId) throws Exception {
      List list = this.findByEmpId(empId, Integer.valueOf(1));
      return list != null && !list.isEmpty()?(EmployeeCard)list.get(0):null;
   }

   public List findByEmpId(Integer empId, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_employee_card t " + " where emp_id = \'" + empId + "\' " + state_s;
      return this.employeeCardDao.findBySql(sql);
   }

   public boolean checkCard(String card) throws Exception {
      boolean isTrue = false;
      EmployeeCard employeeCard = new EmployeeCard();
      employeeCard.setCard(card);
      List mis = this.findByCondition(employeeCard, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
