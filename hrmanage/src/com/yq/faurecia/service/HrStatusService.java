package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.HrStatusDao;
import com.yq.faurecia.pojo.HrStatus;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class HrStatusService {

   private String columns = " \tid,status_code,state,create_date ";
   @Resource
   private HrStatusDao hrStatusDao;


   public HrStatus queryByStatuscode(String status_code) throws Exception {
      String sql = " select " + this.columns + " from tb_hr_status where state=1 and status_code=\'" + status_code + "\'";
      return this.hrStatusDao.queryObjectBySql(sql);
   }

   public HrStatus queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public HrStatus queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_hr_status t " + " where id = " + id + state_s;
      return this.hrStatusDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(HrStatus hrStatus) throws Exception {
      return this.hrStatusDao.save(hrStatus);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(HrStatus hrStatus) throws Exception {
      this.hrStatusDao.update(hrStatus);
   }

   public HrStatusDao getHrStatusDao() {
      return this.hrStatusDao;
   }

   public void setHrStatusDao(HrStatusDao hrStatusDao) {
      this.hrStatusDao = hrStatusDao;
   }

   public Map find(HrStatus hrStatus) throws Exception {
      List list = this.findByCondition(hrStatus, (Page)null);
      HashMap map = new HashMap();
      if(list != null && list.size() > 0) {
         Iterator var5 = list.iterator();

         while(var5.hasNext()) {
            HrStatus hs = (HrStatus)var5.next();
            map.put(hs.getId(), hs);
         }

         list.clear();
         list = null;
      }

      return map;
   }

   public List findByCondition(HrStatus hrStatus, Page page) throws Exception {
      Object result = new ArrayList();
      if(hrStatus != null) {
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
         sql1.append(" from tb_hr_status t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(hrStatus.getStatus_code())) {
            sql1.append(" and t.status_code = \'" + hrStatus.getStatus_code() + "\' ");
         }

         if(hrStatus.getState() != null) {
            sql1.append(" and t.state =" + hrStatus.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.hrStatusDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public boolean checkStatus_code(String status_code) throws Exception {
      boolean isTrue = false;
      HrStatus hrStatus = new HrStatus();
      hrStatus.setStatus_code(status_code);
      List mis = this.findByCondition(hrStatus, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
