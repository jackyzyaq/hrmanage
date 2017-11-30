package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.GapInfoDao;
import com.yq.faurecia.pojo.GapInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GapInfoService {

   private String columns = " id,gap_code,gap_name,state,remark,create_date,update_date ";
   @Resource
   private GapInfoDao gapInfoDao;


   public GapInfo findById(Integer id) throws Exception {
      return this.gapInfoDao.findById(id);
   }

   public GapInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public GapInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_gap_info t " + " where id = " + id + state_s;
      return this.gapInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(GapInfo gapInfo) throws Exception {
      return this.gapInfoDao.save(gapInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(GapInfo gapInfo) throws Exception {
      this.gapInfoDao.update(gapInfo);
   }

   public GapInfoDao getGapInfoDao() {
      return this.gapInfoDao;
   }

   public void setGapInfoDao(GapInfoDao gapInfoDao) {
      this.gapInfoDao = gapInfoDao;
   }

   public List findByCondition(GapInfo gapInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(gapInfo != null) {
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
         sql1.append(" from tb_gap_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(gapInfo.getGap_code())) {
            sql1.append(" and t.gap_code = \'" + gapInfo.getGap_code() + "\' ");
         }

         if(!StringUtils.isEmpty(gapInfo.getGap_name())) {
            sql1.append(" and t.gap_name like \'%" + gapInfo.getGap_name() + "%\' ");
         }

         if(gapInfo.getState() != null) {
            sql1.append(" and t.state =" + gapInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.gapInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public GapInfo findByGapCode(String gap_code) throws Exception {
      return this.gapInfoDao.findByGapCode(gap_code);
   }

   public boolean checkGapCode(String gap_code) throws Exception {
      boolean isTrue = false;
      GapInfo gapInfo = new GapInfo();
      gapInfo.setGap_code(gap_code);
      List mis = this.findByCondition(gapInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
