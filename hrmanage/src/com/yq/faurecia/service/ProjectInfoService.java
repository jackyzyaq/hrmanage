package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.ProjectInfoDao;
import com.yq.faurecia.pojo.ProjectInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProjectInfoService {

   private String columns = " id,project_code,project_name,state,remark,create_date,update_date ";
   @Resource
   private ProjectInfoDao projectInfoDao;


   public ProjectInfo findById(Integer id) throws Exception {
      return this.projectInfoDao.findById(id);
   }

   public ProjectInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public ProjectInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_project_info t " + " where id = " + id + state_s;
      return this.projectInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(ProjectInfo projectInfo) throws Exception {
      return this.projectInfoDao.save(projectInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ProjectInfo projectInfo) throws Exception {
      this.projectInfoDao.update(projectInfo);
   }

   public ProjectInfoDao getProjectInfoDao() {
      return this.projectInfoDao;
   }

   public void setProjectInfoDao(ProjectInfoDao projectInfoDao) {
      this.projectInfoDao = projectInfoDao;
   }

   public List findByCondition(ProjectInfo projectInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(projectInfo != null) {
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
         sql1.append(" from tb_project_info t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(projectInfo.getProject_code())) {
            sql1.append(" and t.project_code = \'" + projectInfo.getProject_code() + "\' ");
         }

         if(!StringUtils.isEmpty(projectInfo.getProject_name())) {
            sql1.append(" and t.project_name like \'%" + projectInfo.getProject_name() + "%\' ");
         }

         if(projectInfo.getState() != null) {
            sql1.append(" and t.state =" + projectInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.projectInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public ProjectInfo findByProjectCode(String project_code) throws Exception {
      return this.projectInfoDao.findByProjectCode(project_code);
   }

   public boolean checkProjectCode(String project_code) throws Exception {
      boolean isTrue = false;
      ProjectInfo projectInfo = new ProjectInfo();
      projectInfo.setProject_code(project_code);
      List mis = this.findByCondition(projectInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }
}
