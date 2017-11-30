package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.PositionInfoDao;
import com.yq.faurecia.pojo.PositionInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PositionInfoService {

   private String columns = " id,pos_code,pos_name,state,create_date,update_date,pos01,pos02,pos03,pos04,pos05 ";
   @Resource
   private PositionInfoDao positionInfoDao;


   public PositionInfo findById(Integer id) throws Exception {
      return this.positionInfoDao.findById(id);
   }

   public PositionInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public PositionInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_position_info t " + " where id = " + id + state_s;
      return this.positionInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(PositionInfo positionInfo) throws Exception {
      int id = this.positionInfoDao.save(positionInfo);
      positionInfo.setId(Integer.valueOf(id));
      Global.loadData(positionInfo);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(PositionInfo positionInfo) throws Exception {
      this.positionInfoDao.update(positionInfo);
      Global.loadData(positionInfo);
   }

   public PositionInfoDao getPositionInfoDao() {
      return this.positionInfoDao;
   }

   public void setPositionInfoDao(PositionInfoDao positionInfoDao) {
      this.positionInfoDao = positionInfoDao;
   }

   public List findByCondition(PositionInfo positionInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(positionInfo != null) {
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
         sql1.append(" from tb_position_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(positionInfo.getPos_code())) {
            sql1.append(" and t.pos_code = \'" + positionInfo.getPos_code() + "\' ");
         }

         if(!StringUtils.isEmpty(positionInfo.getPos_name())) {
            sql1.append(" and t.pos_name = \'" + positionInfo.getPos_name() + "\' ");
         }

         if(positionInfo.getState() != null) {
            sql1.append(" and t.state =" + positionInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.positionInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public PositionInfo findByPosCode(String pos_code) throws Exception {
      return this.positionInfoDao.findByPosCode(pos_code);
   }

   public boolean checkPosCode(String pos_code) throws Exception {
      boolean isTrue = false;
      PositionInfo positionInfo = new PositionInfo();
      positionInfo.setPos_code(pos_code);
      List mis = this.findByCondition(positionInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
