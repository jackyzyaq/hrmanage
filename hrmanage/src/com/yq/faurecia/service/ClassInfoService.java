package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.ClassInfoDao;
import com.yq.faurecia.pojo.ClassInfo;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ClassInfoService {

   private String columns = " id,class_code,class_name,begin_time,end_time,hours,meals,have_meals,over_hour,state,remark,create_date,update_date ";
   @Resource
   private ClassInfoDao classInfoDao;


   public ClassInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public ClassInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_class_info t " + " where id = " + id + state_s;
      return this.classInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(ClassInfo classInfo) throws Exception {
      return this.classInfoDao.save(classInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ClassInfo classInfo) throws Exception {
      this.classInfoDao.update(classInfo);
   }

   public ClassInfoDao getClassInfoDao() {
      return this.classInfoDao;
   }

   public void setClassInfoDao(ClassInfoDao classInfoDao) {
      this.classInfoDao = classInfoDao;
   }

   public List findByCondition(ClassInfo classInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(classInfo != null) {
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
         sql1.append(" from tb_class_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(classInfo.getClass_code())) {
            sql1.append(" and t.class_code = \'" + classInfo.getClass_code() + "\' ");
         }

         if(!StringUtils.isEmpty(classInfo.getClass_name())) {
            sql1.append(" and t.class_name = \'" + classInfo.getClass_name() + "\' ");
         }

         if(classInfo.getId() != null) {
            sql1.append(" and t.id =" + classInfo.getId() + " ");
         }

         if(classInfo.getState() != null) {
            sql1.append(" and t.state =" + classInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.classInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public ClassInfo findByClassCode(String classCode) throws Exception {
      String sql = " select " + this.columns + " from tb_class_info t " + " where state=1 and class_code = \'" + classCode + "\' ";
      return this.classInfoDao.queryObjectBySql(sql);
   }

   public boolean checkClassCode(String classCode) throws Exception {
      boolean isTrue = false;
      ClassInfo classInfo = new ClassInfo();
      classInfo.setClass_code(classCode);
      List mis = this.findByCondition(classInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public List autoComplete(Map params) throws Exception {
      List result = null;
      if(params != null && params.size() > 0) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from (");
         sql.append(" select class_name,ROW_NUMBER() OVER (order by t.class_name) AS RowNumber ");
         sql.append(" from tb_class_info t   ");
         sql.append(" where t.state=1 ");
         if(!StringUtils.isEmpty((CharSequence)params.get("class_name"))) {
            sql.append(" and t.class_name like \'%" + (String)params.get("class_name") + "%\' ");
         }

         if(!StringUtils.isEmpty((CharSequence)params.get("class_code"))) {
            sql.append(" and t.class_code in(" + (String)params.get("class_code") + ") ");
         }

         sql.append(" group by class_name) t where RowNumber > 0 and RowNumber <=10 ");
         result = this.classInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
