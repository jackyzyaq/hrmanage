package com.yq.authority.service;

import com.util.Page;
import com.yq.authority.dao.UserInfoDao;
import com.yq.authority.pojo.UserInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class UserInfoService {

   @Resource
   private UserInfoDao userInfoDao;
   private String columns = " id,name,pwd,zh_name,upload_uuid,email,state,create_date,update_date,last_date ";


   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(UserInfo user) throws Exception {
      this.userInfoDao.save(user);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(UserInfo user, String[] roles) throws Exception {
      this.userInfoDao.save(user);
      if(roles != null && roles.length > 0) {
         String[] var6 = roles;
         int var5 = roles.length;

         for(int var4 = 0; var4 < var5; ++var4) {
            String role_id = var6[var4];
            this.userInfoDao.saveUserRole(user.getId(), Integer.valueOf(Integer.parseInt(role_id)));
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateUserRole(String[] user_ids, Integer role_id) throws Exception {
      if(user_ids != null && user_ids.length > 0) {
         String sql = "delete from tb_user_role where role_id = " + role_id;
         this.userInfoDao.executeBySql(sql);
         String[] var7 = user_ids;
         int var6 = user_ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String user_id = var7[var5];
            if(user_id != null && !user_id.equals("")) {
               this.userInfoDao.saveUserRole(Integer.valueOf(Integer.parseInt(user_id)), role_id);
            }
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(UserInfo user) throws Exception {
      this.userInfoDao.update(user);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(UserInfo userInfo, String[] roles) throws Exception {
      this.userInfoDao.update(userInfo);
      String sql = "delete from tb_user_role where user_id = " + userInfo.getId();
      if(roles != null && roles.length > 0) {
         this.userInfoDao.executeBySql(sql);
         String[] var7 = roles;
         int var6 = roles.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String role_id = var7[var5];
            this.userInfoDao.saveUserRole(userInfo.getId(), Integer.valueOf(Integer.parseInt(role_id)));
         }
      }

   }

   public UserInfo query(UserInfo user) throws Exception {
      return this.userInfoDao.queryObjectBySql(this.queryUserSql(user));
   }

   public UserInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public UserInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      return this.userInfoDao.queryObjectBySql("select " + this.columns + " from tb_user_info where id = " + id + state_s);
   }

   public UserInfo queryByName(String name, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      return this.userInfoDao.queryObjectBySql("select " + this.columns + " from tb_user_info where name = \'" + name + "\' " + state_s);
   }

   private String queryUserSql(UserInfo user) {
      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + " from tb_user_info ");
      sql.append(" where state=1 ");
      if(user != null) {
         if(user.getId() != null) {
            sql.append(" and id in(" + user.getId() + ") ");
         }

         if(user.getName() != null && !user.getName().trim().equals("")) {
            sql.append(" and name = \'" + user.getName() + "\' ");
         }

         if(user.getPwd() != null && !user.getPwd().trim().equals("")) {
            sql.append(" and pwd = \'" + user.getPwd() + "\' ");
         }
      }

      return sql.toString();
   }

   public List findByCondition(UserInfo user, Page page) throws Exception {
      Object result = new ArrayList();
      if(user != null) {
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

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from (");
         sql1.append(" select " + this.columns + ", ");
         sql1.append("        ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append("   from tb_user_info t ");
         sql1.append("  where 1=1 ");
         if(user.getId() != null) {
            sql1.append(" and id in(" + user.getId() + ") ");
         }

         if(user.getName() != null && !user.getName().trim().equals("")) {
            sql1.append(" and name = \'" + user.getName() + "\' ");
         }

         if(user.getZh_name() != null && !user.getZh_name().trim().equals("")) {
            sql1.append(" and zh_name like \'%" + user.getZh_name() + "%\' ");
         }

         if(user.getPwd() != null && !user.getPwd().trim().equals("")) {
            sql1.append(" and pwd = \'" + user.getPwd() + "\' ");
         }

         if(user.getState() != null) {
            sql1.append(" and state in(" + user.getState() + ") ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.userInfoDao.queryListBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public boolean checkUserName(String name) throws Exception {
      boolean isTrue = false;
      UserInfo user = new UserInfo();
      user.setName(name);
      List users = this.findByCondition(user, (Page)null);
      if(users != null && users.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public List findByUserRole(Integer role_id) throws Exception {
      Object result = new ArrayList();
      if(role_id != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from ( ");
         sql.append(" select t." + this.columns.replace(",", ",t.") + "   ");
         sql.append(" from tb_user_info t,tb_user_role t1     ");
         sql.append(" where t.id=t1.user_id and t.state = 1 and t1.role_id=" + role_id);
         sql.append(" ) t");
         result = this.userInfoDao.queryListBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public UserInfoDao getUserDao() {
      return this.userInfoDao;
   }

   public void setUserDao(UserInfoDao userInfoDao) {
      this.userInfoDao = userInfoDao;
   }
}
