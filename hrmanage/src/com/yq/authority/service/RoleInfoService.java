package com.yq.authority.service;

import com.util.Page;
import com.yq.authority.dao.RoleInfoDao;
import com.yq.authority.pojo.RoleInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RoleInfoService {

   @Resource
   private RoleInfoDao roleInfoDao;


   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteById(Integer id) throws Exception {
      this.roleInfoDao.deleteById(id);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void executeBySql(String sql) throws Exception {}

   public RoleInfo findById(Integer id) throws Exception {
      return this.roleInfoDao.findById(id);
   }

   public RoleInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public RoleInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      String sql = "select t.id,t.role_code,t.role_name,    t.parent_id,   (select tt.role_code from tb_role_info tt where tt.id=t.parent_id) parent_code,   (select tt.role_name from tb_role_info tt where tt.id=t.parent_id) parent_name,   t.description,t.create_date,update_date,state   from tb_role_info t   where id = " + id + state_s;
      return this.roleInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(RoleInfo roleInfo) throws Exception {
      this.roleInfoDao.save(roleInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(RoleInfo roleInfo) throws Exception {
      this.roleInfoDao.update(roleInfo);
   }

   public RoleInfoDao getRoleInfoDao() {
      return this.roleInfoDao;
   }

   public void setRoleInfoDao(RoleInfoDao roleInfoDao) {
      this.roleInfoDao = roleInfoDao;
   }

   public boolean checkRoleCode(String role_code) throws Exception {
      boolean isTrue = false;
      RoleInfo role = new RoleInfo();
      role.setRole_code(role_code);
      List roles = this.findByCondition(role, (Page)null);
      if(roles != null && roles.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveRoleaAuthorityMenu(String[] ids, Integer role_id) throws Exception {
      if(ids != null && ids.length > 0) {
         String sql = "delete from tb_menu_role where role_id = " + role_id;
         this.roleInfoDao.executeBySql(sql);
         String[] var7 = ids;
         int var6 = ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String menu_id = var7[var5];
            if(menu_id != null && !menu_id.equals("")) {
               sql = "insert into tb_menu_role (menu_id,role_id) values (" + Integer.parseInt(menu_id) + "," + role_id + ")";
               this.roleInfoDao.executeBySql(sql);
            }
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveRoleaAuthorityUser(String[] ids, Integer role_id) throws Exception {
      if(ids != null && ids.length > 0) {
         String sql = "delete from tb_user_role where role_id = " + role_id;
         this.roleInfoDao.executeBySql(sql);
         String[] var7 = ids;
         int var6 = ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String user_id = var7[var5];
            if(user_id != null && !user_id.equals("")) {
               sql = "insert into tb_user_role (user_id,role_id) values (" + Integer.parseInt(user_id) + "," + role_id + ")";
               this.roleInfoDao.executeBySql(sql);
            }
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveRoleaAuthorityDept(String[] ids, Integer role_id) throws Exception {
      if(ids != null && ids.length > 0) {
         String sql = "delete from tb_department_role where role_id = " + role_id;
         this.roleInfoDao.executeBySql(sql);
         String[] var7 = ids;
         int var6 = ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String dept_id = var7[var5];
            if(dept_id != null && !dept_id.equals("")) {
               sql = "insert into tb_department_role (dept_id,role_id) values (" + Integer.parseInt(dept_id) + "," + role_id + ")";
               this.roleInfoDao.executeBySql(sql);
            }
         }
      }

   }

   public List findByCondition(RoleInfo roleInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(roleInfo != null) {
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
            orderby = "  order by t.id ";
         }

         StringBuffer sql1 = new StringBuffer("select * from (select t.id,t.role_code,t.role_name,t.parent_id,\t\t(select tt.role_code from tb_role_info tt where tt.id=t.parent_id) parent_code, \t\t(select tt.role_name from tb_role_info tt where tt.id=t.parent_id) parent_name, \t\tt.description,t.create_date,t.update_date,state, \t\tROW_NUMBER() OVER (" + orderby + ") AS RowNumber " + "  from tb_role_info t " + " where 1=1 ");
         if(roleInfo.getRole_code() != null && !roleInfo.getRole_code().equals("")) {
            sql1.append(" and t.role_code = \'" + roleInfo.getRole_code() + "\' ");
         }

         if(roleInfo.getRole_name() != null && !roleInfo.getRole_name().equals("")) {
            sql1.append(" and t.role_name like \'%" + roleInfo.getRole_name() + "%\' ");
         }

         if(roleInfo.getState() != null) {
            sql1.append(" and t.state =" + roleInfo.getState() + " ");
         }

         if(roleInfo.getParent_id() != null) {
            sql1.append(" and t.parent_id =" + roleInfo.getParent_id() + " ");
         }

         sql1.append(") t where 1=1 " + rownumber);
         if(roleInfo.getParent_name() != null && !roleInfo.getParent_name().equals("")) {
            sql1.append(" and t.parent_name like \'%" + roleInfo.getParent_name() + "%\' ");
         }

         result = this.roleInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public RoleInfo findByRoleCode(String roleCode) throws Exception {
      return this.roleInfoDao.findByRoleCode(roleCode);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteByRoleCode(String roleCode) throws Exception {
      String[] rcs = roleCode.split(",");
      String roleCodes = "";
      String[] var7 = rcs;
      int var6 = rcs.length;

      String sql;
      for(int var5 = 0; var5 < var6; ++var5) {
         sql = var7[var5];
         roleCodes = roleCodes + "\'" + sql + "\',";
      }

      if(roleCodes.toString().endsWith(",")) {
         roleCodes = roleCodes.substring(0, roleCodes.length() - 1);
      }

      sql = "delete from tb_role_info where parent_id in(select t.id  from (select temp.* from tb_role_info temp) t where t.role_code in(" + roleCodes + "))";
      this.roleInfoDao.executeBySql(sql);
      sql = "delete from tb_role_info where role_code in(" + roleCodes + ")";
      this.roleInfoDao.executeBySql(sql);
   }

   public List findRoleByUserId(Integer userId) throws Exception {
      StringBuffer sql = new StringBuffer("");
      sql.append("select t.id,t.role_code,t.role_name,t.parent_id,(select tt.role_code from tb_role_info tt where tt.id=t.parent_id) parent_code,(select tt.role_name from tb_role_info tt where tt.id=t.parent_id) parent_name,t.description,t.create_date,update_date,state  from tb_role_info t  where t.state = 1 and t.id in(select t.role_id from tb_user_role t where t.user_id in(" + userId + "))");
      return this.roleInfoDao.findBySql(sql.toString());
   }

   public List findRoleByActionId(Integer actionId) throws Exception {
      StringBuffer sql = new StringBuffer("");
      sql.append("select t.id,t.role_code,t.role_name,t.parent_id,(select tt.role_code from tb_role_info tt where tt.id=t.parent_id) parent_code,(select tt.role_name from tb_role_info tt where tt.id=t.parent_id) parent_name,t.description,t.create_date,update_date,state  from tb_role_info t  where t.state = 1 and t.id in(select t.role_id from tb_action_role t where t.action_id in(" + actionId + "))");
      return this.roleInfoDao.findBySql(sql.toString());
   }

   public List findRoleByMenuId(Integer menuId) throws Exception {
      StringBuffer sql = new StringBuffer("");
      sql.append("select t.id,t.role_code,t.role_name,t.parent_id,(select tt.role_code from tb_role_info tt where tt.id=t.parent_id) parent_code,(select tt.role_name from tb_role_info tt where tt.id=t.parent_id) parent_name,t.description,t.create_date,update_date,state  from tb_role_info t  where t.state = 1 and t.id in(select t.role_id from tb_menu_role t where t.menu_id in(" + menuId + "))");
      return this.roleInfoDao.findBySql(sql.toString());
   }

   public boolean isHaveRole(List listRole, String roleCode) {
      for(int i = 0; i < listRole.size(); ++i) {
         RoleInfo roleInfo = (RoleInfo)listRole.get(i);
         if(roleInfo.getRole_code().equals(roleCode)) {
            return true;
         }
      }

      return false;
   }
}
