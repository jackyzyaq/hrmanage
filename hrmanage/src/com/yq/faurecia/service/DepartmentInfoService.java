package com.yq.faurecia.service;

import com.util.Global;
import com.util.Page;
import com.yq.faurecia.dao.DepartmentInfoDao;
import com.yq.faurecia.pojo.DepartmentInfo;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DepartmentInfoService {

   private String columns = "id,          parent_id,(select count(id) from tb_department_info where parent_id=t.id) node_count,         (select dept_code from tb_department_info where id=t.parent_id) parent_dept_code,           (select dept_name from tb_department_info where id=t.parent_id) parent_dept_name,         dept_code,dept_name,create_date,update_date,description,state ";
   @Resource
   private DepartmentInfoDao departmentInfoDao;


   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteById(Integer id) throws Exception {
      this.departmentInfoDao.deleteById(id);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteByIds(String ids) throws Exception {
      this.departmentInfoDao.deleteByIds(ids);
   }

   public DepartmentInfo findById(Integer id) throws Exception {
      return this.departmentInfoDao.findById(id);
   }

   public DepartmentInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public DepartmentInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      String sql = " select " + this.columns + " from tb_department_info t " + " where id = " + id + state_s;
      return this.departmentInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(DepartmentInfo departmentInfo) throws Exception {
      int id = this.departmentInfoDao.save(departmentInfo);
      departmentInfo.setId(Integer.valueOf(id));
      Global.loadData(departmentInfo);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(DepartmentInfo departmentInfo) throws Exception {
      this.departmentInfoDao.update(departmentInfo);
      Global.loadData(departmentInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(List departmentInfos) throws Exception {
      if(departmentInfos != null && departmentInfos.size() > 0) {
         String sql = null;
         Iterator var4 = departmentInfos.iterator();

         while(var4.hasNext()) {
            DepartmentInfo mi = (DepartmentInfo)var4.next();
            if(mi.getId() != null) {
               sql = " update tb_department_info  \t\t\t\t\t   set \tupdate_date=getdate() \t\t";
               if(mi.getParent_id() != null) {
                  sql = sql + " ,parent_id=" + mi.getParent_id();
               }

               if(!StringUtils.isEmpty(mi.getDept_code())) {
                  sql = sql + " ,dept_code=" + mi.getDept_code();
               }

               if(!StringUtils.isEmpty(mi.getDept_name())) {
                  sql = sql + " ,dept_name=" + mi.getDept_name();
               }

               if(!StringUtils.isEmpty(mi.getDescription())) {
                  sql = sql + " ,description=" + mi.getDescription();
               }

               if(mi.getState() != null) {
                  sql = sql + " ,state=" + mi.getState();
               }

               sql = sql + " where id = " + mi.getId() + " \t\t\t\t\t\t";
               this.departmentInfoDao.executeBySql(sql);
               Global.loadData(mi);
            }
         }
      }

   }

   public DepartmentInfoDao getDepartmentInfoDao() {
      return this.departmentInfoDao;
   }

   public void setDepartmentInfoDao(DepartmentInfoDao departmentInfoDao) {
      this.departmentInfoDao = departmentInfoDao;
   }

   public List findByCondition(DepartmentInfo departmentInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(departmentInfo != null) {
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
         sql1.append(" from tb_department_info t   ");
         sql1.append(" where 1=1 ");
         if(departmentInfo.getDept_code() != null && !departmentInfo.getDept_code().equals("")) {
            sql1.append(" and t.dept_code = \'" + departmentInfo.getDept_code() + "\' ");
         }

         if(departmentInfo.getDept_name() != null && !departmentInfo.getDept_name().equals("")) {
            sql1.append(" and t.dept_name like \'%" + departmentInfo.getDept_name() + "%\' ");
         }

         if(departmentInfo.getParent_id() != null) {
            sql1.append(" and t.parent_id =" + departmentInfo.getParent_id() + " ");
         }

         if(departmentInfo.getState() != null) {
            sql1.append(" and t.state =" + departmentInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         if(departmentInfo.getParent_dept_name() != null && !departmentInfo.getParent_dept_name().equals("")) {
            sql1.append(" and t.parent_dept_name like \'%" + departmentInfo.getParent_dept_name() + "%\' ");
         }

         result = this.departmentInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findDeptAndEmp(String empids) throws Exception {
      StringBuffer sql = new StringBuffer();
      if(StringUtils.isEmpty(empids)) {
         sql.append(" select t1.id,dept_name,parent_id,1 node_count from dbo.tb_department_info t1 ");
         sql.append(" where t1.state=1  ");
         sql.append(" union all  ");
      }

      sql.append(" select (0-id) id,(\'\'+(select dept_name from tb_department_info where state=1 and t2.dept_id=id)+\'|\'+(select pos_code from tb_position_info where state=1 and t2.position_id=id)+\'|\'+t2.zh_name+\'|\'+convert(varchar,t2.dept_id)+\'|\'+convert(varchar,t2.id)+\'\') dept_name,t2.dept_id parent_id,0 node_count from dbo.tb_employee_info t2 ");
      sql.append(" where t2.state=1 ");
      if(!StringUtils.isEmpty(empids)) {
         sql.append(" and t2.id in(" + empids + ") ");
         sql.append("order by CHARINDEX(CONVERT(varchar(10),t2.id),\',,," + empids + ",\') ");
      }

      List result = this.departmentInfoDao.findBySql(sql.toString());
      return (List)(result == null?new ArrayList():result);
   }

   public List findByParentId(Integer parent_id) throws Exception {
      return this.departmentInfoDao.findByParentId(parent_id);
   }

   public DepartmentInfo findByDeptCode(String dept_code) throws Exception {
      return this.departmentInfoDao.findByDeptCode(dept_code);
   }

   public boolean checkDeptCode(String dept_code) throws Exception {
      boolean isTrue = false;
      DepartmentInfo departmentInfo = new DepartmentInfo();
      departmentInfo.setDept_code(dept_code);
      List mis = this.findByCondition(departmentInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public List findByDeptRole(Integer role_id) throws Exception {
      Object result = new ArrayList();
      if(role_id != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from ( ");
         sql.append(" select t." + this.columns + " ");
         sql.append(" from tb_department_info t,tb_department_role t1     ");
         sql.append(" where t.id=t1.dept_id and t.state = 1 and t1.role_id=" + role_id);
         sql.append(" ) t");
         result = this.departmentInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findByDeptRole(String role_ids) throws Exception {
      Object result = new ArrayList();
      if(role_ids != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("\t  select  t." + this.columns + " ");
         sql.append("        from tb_department_info t                  ");
         sql.append("       where t.id in(         ");
         sql.append("\t\t\t                 select t.id           ");
         sql.append("                               from tb_department_info t,tb_department_role t1           ");
         sql.append("\t                          where t.id=t1.dept_id and t1.role_id in(" + role_ids + ")         ");
         sql.append("        )    ");
         result = this.departmentInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveDeptRole(String[] ids, Integer role_id) throws Exception {
      if(ids != null && ids.length > 0) {
         String sql = "delete from tb_department_role where role_id = " + role_id;
         this.departmentInfoDao.executeBySql(sql);
         String[] var7 = ids;
         int var6 = ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String dept_id = var7[var5];
            if(dept_id != null && !dept_id.equals("")) {
               this.departmentInfoDao.saveDeptRole(Integer.valueOf(Integer.parseInt(dept_id)), role_id);
            }
         }
      }

   }

   public String getDeptAllNameById(Integer id) throws Exception {
      DepartmentInfo am = this.findById(id);

      String allName;
      for(allName = am.getDept_name() == null?"":am.getDept_name(); am != null; allName = am.getDept_name() + " >> " + allName) {
         am = this.findById(am.getParent_id());
         if(am == null) {
            break;
         }
      }

      return allName;
   }

   public String getSubIdsById(Integer id, List ids) throws Exception {
      if(ids == null) {
         ids = new ArrayList();
      }

      ((List)ids).add(id);
      List list = this.findByParentId(id);
      if(list != null && list.size() > 0) {
         Iterator var5 = list.iterator();

         while(var5.hasNext()) {
            DepartmentInfo di = (DepartmentInfo)var5.next();
            this.getSubIdsById(di.getId(), (List)ids);
         }
      }

      return ((List)ids).isEmpty()?null:StringUtils.substringBetween(ids.toString(), "[", "]");
   }

   public void getSubDeptById(Integer id, List list) throws Exception {
      if(list == null) {
         list = new ArrayList();
      }

      ((List)list).add(this.queryById(id.intValue()));
      List tmpList = this.findByParentId(id);
      if(tmpList != null && tmpList.size() > 0) {
         Iterator var5 = tmpList.iterator();

         while(var5.hasNext()) {
            DepartmentInfo di = (DepartmentInfo)var5.next();
            this.getSubDeptById(di.getId(), (List)list);
         }
      }

   }
}
