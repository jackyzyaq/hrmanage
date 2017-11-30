package com.yq.authority.service;

import com.util.Page;
import com.yq.authority.dao.ActionInfoDao;
import com.yq.authority.pojo.ActionInfo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ActionInfoService {

   @Resource
   private ActionInfoDao actionInfoDao;


   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteById(Integer id) throws Exception {
      this.actionInfoDao.deleteById(id);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteByIds(String ids) throws Exception {
      this.actionInfoDao.deleteByIds(ids);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public ActionInfo findById(Integer id) throws Exception {
      return this.actionInfoDao.findById(id);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(ActionInfo actionInfo, String[] roles) throws Exception {
      this.actionInfoDao.save(actionInfo);
      if(roles != null && roles.length > 0) {
         String[] var6 = roles;
         int var5 = roles.length;

         for(int var4 = 0; var4 < var5; ++var4) {
            String role_id = var6[var4];
            this.actionInfoDao.saveActionRole(actionInfo.getId(), role_id);
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateActionRole(String[] action_ids, Integer role_id) throws Exception {
      if(action_ids != null && action_ids.length > 0) {
         String sql = "delete from tb_action_role where role_id = " + role_id;
         this.actionInfoDao.executeBySql(sql);
         String[] var7 = action_ids;
         int var6 = action_ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String action_id = var7[var5];
            if(action_id != null && !action_id.equals("")) {
               this.actionInfoDao.saveActionRole(Integer.valueOf(Integer.parseInt(action_id)), "" + role_id);
            }
         }
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ActionInfo actionInfo) throws Exception {
      this.actionInfoDao.update(actionInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(ActionInfo actionInfo, String[] roles) throws Exception {
      this.actionInfoDao.update(actionInfo);
      String sql = "delete from tb_action_role where action_id = " + actionInfo.getId();
      this.actionInfoDao.executeBySql(sql);
      if(roles != null && roles.length > 0) {
         String[] var7 = roles;
         int var6 = roles.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String role_id = var7[var5];
            this.actionInfoDao.saveActionRole(actionInfo.getId(), role_id);
         }
      }

   }

   public boolean checkActionCode(String action_code) throws Exception {
      boolean isTrue = false;
      ActionInfo action = new ActionInfo();
      action.setAction_code(action_code);
      List actions = this.findByCondition(action, (Page)null);
      if(actions != null && actions.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public ActionInfoDao getActionInfoDao() {
      return this.actionInfoDao;
   }

   public void setActionInfoDao(ActionInfoDao actionInfoDao) {
      this.actionInfoDao = actionInfoDao;
   }

   public List findByCondition(ActionInfo actionInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(actionInfo != null) {
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
         sql1.append(" select id,action_name,action_code, ");
         sql1.append("    \t   action_menu_id,        ");
         sql1.append("    \t   (select menu_name from tb_menu_info where id=t.action_menu_id) action_menu_name, ");
         sql1.append("        (select menu_code from tb_menu_info where id=t.action_menu_id) action_menu_code, ");
         sql1.append("       viewmode,create_date,update_date, ");
         sql1.append("        ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append("   from tb_action_info t ");
         sql1.append("  where 1=1 ");
         if(actionInfo.getAction_code() != null && !actionInfo.getAction_code().equals("")) {
            sql1.append(" and t.action_code like \'%" + actionInfo.getAction_code() + "%\' ");
         }

         if(actionInfo.getAction_name() != null && !actionInfo.getAction_name().equals("")) {
            sql1.append(" and t.action_name like \'%" + actionInfo.getAction_name() + "%\' ");
         }

         if(actionInfo.getAction_menu_id() != null) {
            sql1.append(" and t.action_menu_id =" + actionInfo.getAction_menu_id() + " ");
         }

         if(actionInfo.getViewmode() != null) {
            sql1.append(" and t.viewmode =" + actionInfo.getViewmode() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.actionInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findByMenuIds(String menuIds) throws Exception {
      List result = null;
      if(!StringUtils.isEmpty(menuIds)) {
         result = this.actionInfoDao.findByMenuIds(menuIds);
      }

      return (List)(result == null?new ArrayList():result);
   }

   public ActionInfo findByActionCode(String action_code) throws Exception {
      return this.actionInfoDao.findByActionCode(action_code);
   }

   public List findByActionRole(String role_ids) throws Exception {
      Object result = new ArrayList();
      if(role_ids != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("        select id,action_name,action_code,       ");
         sql.append("\t\t       action_menu_id,              ");
         sql.append("\t\t       (select menu_name from tb_menu_info where id=t.action_menu_id) action_menu_name,        ");
         sql.append("\t\t       (select menu_code from tb_menu_info where id=t.action_menu_id) action_menu_code,       ");
         sql.append("\t\t       viewmode,create_date,update_date            ");
         sql.append("        from tb_action_info t                ");
         sql.append("        where t.viewmode = 1 and t.id in(       ");
         sql.append("                   select id from (        ");
         sql.append("\t\t\t                 select t.id         ");
         sql.append("                               from tb_action_info t,tb_action_role t1        ");
         sql.append("\t                          where t.id=t1.action_id and t.viewmode = 1 and t1.role_id in(" + role_ids + ")       ");
         sql.append("                   ) t group by id       ");
         sql.append("        )       ");
         result = this.actionInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
