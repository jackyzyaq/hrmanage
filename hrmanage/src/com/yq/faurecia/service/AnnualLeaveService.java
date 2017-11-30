package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.AnnualLeaveDao;
import com.yq.faurecia.dao.HrStatusDao;
import com.yq.faurecia.pojo.AnnualLeave;
import com.yq.faurecia.pojo.HrStatus;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AnnualLeaveService {

   private String columns = " \tid,hr_status_id,(select t.status_code from tb_hr_status t where t.state=1 and t.id=hr_status_id) status_code,\tstate,work_up,work_down,remark,create_date,update_date,leave01,leave02,leave03,leave04,leave05,leave06,leave07,leave08,leave09,leave10 ";
   @Resource
   private AnnualLeaveDao annualLeaveDao;
   @Resource
   private HrStatusDao hrStatusDao;


   public AnnualLeave queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public AnnualLeave queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_annual_leave t " + " where id = " + id + state_s;
      return this.annualLeaveDao.queryObjectBySql(sql);
   }

   public List queryHrStatus() throws Exception {
      String sql = " select hr_status_id,(select t.status_code from tb_hr_status t where t.state=1 and t.id=hr_status_id) status_code  from tb_annual_leave t  where state = 1  group by hr_status_id ";
      return this.annualLeaveDao.findBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(AnnualLeave annualLeave, HrStatus hrStatus) throws Exception {
      boolean hr_status_id = false;
      int hr_status_id1;
      if(hrStatus == null) {
         hrStatus = new HrStatus();
         hrStatus.setStatus_code(annualLeave.getStatus_code());
         hrStatus.setState(Integer.valueOf(1));
         hr_status_id1 = this.hrStatusDao.save(hrStatus);
      } else {
         hr_status_id1 = hrStatus.getId().intValue();
      }

      annualLeave.setHr_status_id(Integer.valueOf(hr_status_id1));
      int id = this.annualLeaveDao.save(annualLeave);
      annualLeave.setId(Integer.valueOf(id));
      Global.loadData(annualLeave);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(AnnualLeave annualLeave, HrStatus hrStatus) throws Exception {
      boolean hr_status_id = false;
      int hr_status_id1;
      if(hrStatus == null) {
         hrStatus = new HrStatus();
         hrStatus.setStatus_code(annualLeave.getStatus_code());
         hrStatus.setState(Integer.valueOf(1));
         hr_status_id1 = this.hrStatusDao.save(hrStatus);
      } else {
         hr_status_id1 = hrStatus.getId().intValue();
      }

      annualLeave.setHr_status_id(Integer.valueOf(hr_status_id1));
      this.annualLeaveDao.update(annualLeave);
      Global.loadData(annualLeave);
   }

   public AnnualLeaveDao getAnnualLeaveDao() {
      return this.annualLeaveDao;
   }

   public void setAnnualLeaveDao(AnnualLeaveDao annualLeaveDao) {
      this.annualLeaveDao = annualLeaveDao;
   }

   public List findByCondition(AnnualLeave annualLeave, Page page) throws Exception {
      Object result = new ArrayList();
      if(annualLeave != null) {
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
         sql1.append(" from tb_annual_leave t   ");
         sql1.append(" where 1=1 ");
         if(annualLeave.getHr_status_id() != null) {
            sql1.append(" and t.hr_status_id = " + annualLeave.getHr_status_id() + " ");
         }

         if(annualLeave.getState() != null) {
            sql1.append(" and t.state =" + annualLeave.getState() + " ");
         }

         if(annualLeave.getWork_down() != null) {
            sql1.append(" and t.work_down =" + annualLeave.getWork_down() + " ");
         }

         if(annualLeave.getWork_up() != null) {
            sql1.append(" and t.work_up =" + annualLeave.getWork_up() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.annualLeaveDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public boolean check(int hr_status_id, int work_down, int work_up) throws Exception {
      boolean isTrue = false;
      AnnualLeave annualLeave = new AnnualLeave();
      annualLeave.setHr_status_id(Integer.valueOf(hr_status_id));
      annualLeave.setWork_up(Integer.valueOf(work_up));
      annualLeave.setWork_down(Integer.valueOf(work_down));
      List mis = this.findByCondition(annualLeave, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
