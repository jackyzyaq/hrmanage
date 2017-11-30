package com.yq.authority.service;

import com.util.Global;
import com.util.Page;
import com.yq.authority.dao.MenuInfoDao;
import com.yq.authority.pojo.MenuInfo;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MenuInfoService {

   @Resource
   private MenuInfoDao menuInfoDao;


   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteById(Integer id) throws Exception {
      this.menuInfoDao.deleteById(id);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void deleteByIds(String ids) throws Exception {
      this.menuInfoDao.deleteByIds(ids);
   }

   public MenuInfo findById(Integer id) throws Exception {
      return this.menuInfoDao.findById(id);
   }

   public MenuInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public MenuInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      String sql = " select id,          parent_id,         (select menu_code from tb_menu_info where id=t.parent_id) parent_menu_code,           (select menu_name from tb_menu_info where id=t.parent_id) parent_menu_name,         menu_code,menu_name,url,url_param,create_date,update_date,description,state,is_menu  from tb_menu_info t  where id = " + id + state_s;
      return this.menuInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(MenuInfo menuInfo) throws Exception {
      int id = this.menuInfoDao.save(menuInfo);
      menuInfo.setId(Integer.valueOf(id));
      Global.loadData(menuInfo);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(MenuInfo menuInfo) throws Exception {
      this.menuInfoDao.update(menuInfo);
      Global.loadData(menuInfo);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(List menuInfos) throws Exception {
      if(menuInfos != null && menuInfos.size() > 0) {
         String sql = null;
         Iterator var4 = menuInfos.iterator();

         while(var4.hasNext()) {
            MenuInfo mi = (MenuInfo)var4.next();
            if(mi.getId() != null) {
               sql = " update tb_menu_info  \t\t\t\t\t   set \tupdate_date=getdate() \t\t";
               if(mi.getParent_id() != null) {
                  sql = sql + " ,parent_id=" + mi.getParent_id();
               }

               if(!StringUtils.isEmpty(mi.getMenu_code())) {
                  sql = sql + " ,menu_code=" + mi.getMenu_code();
               }

               if(!StringUtils.isEmpty(mi.getMenu_name())) {
                  sql = sql + " ,menu_name=" + mi.getMenu_name();
               }

               if(!StringUtils.isEmpty(mi.getUrl())) {
                  sql = sql + " ,url=" + mi.getUrl();
               }

               if(!StringUtils.isEmpty(mi.getUrl_param())) {
                  sql = sql + " ,url_param=" + mi.getUrl_param();
               }

               if(!StringUtils.isEmpty(mi.getDescription())) {
                  sql = sql + " ,description=" + mi.getDescription();
               }

               if(mi.getState() != null) {
                  sql = sql + " ,state=" + mi.getState();
               }

               if(mi.getOrderNum() != null) {
                  sql = sql + " ,orderNum=" + mi.getOrderNum();
               }

               sql = sql + " where id = " + mi.getId() + " \t\t\t\t\t\t";
               this.menuInfoDao.executeBySql(sql);
            }
         }
      }

   }

   public MenuInfoDao getMenuInfoDao() {
      return this.menuInfoDao;
   }

   public void setMenuInfoDao(MenuInfoDao menuInfoDao) {
      this.menuInfoDao = menuInfoDao;
   }

   public List findByCondition(MenuInfo menuInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(menuInfo != null) {
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
            orderby = "  order by t.orderNum ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select id,t.orderNum, ");
         sql1.append("        parent_id,(select count(id) from tb_menu_info where parent_id=t.id) node_count, ");
         sql1.append("        (select menu_code from tb_menu_info where id=t.parent_id) parent_menu_code, ");
         sql1.append("        (select menu_name from tb_menu_info where id=t.parent_id) parent_menu_name, ");
         sql1.append("        menu_code,menu_name,url,url_param,create_date,update_date,description,state,is_menu,   ");
         sql1.append("        ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from tb_menu_info t   ");
         sql1.append(" where 1=1 ");
         if(menuInfo.getMenu_code() != null && !menuInfo.getMenu_code().equals("")) {
            sql1.append(" and t.menu_code = \'" + menuInfo.getMenu_code() + "\' ");
         }

         if(menuInfo.getMenu_name() != null && !menuInfo.getMenu_name().equals("")) {
            sql1.append(" and t.menu_name like \'%" + menuInfo.getMenu_name() + "%\' ");
         }

         if(menuInfo.getParent_id() != null) {
            sql1.append(" and t.parent_id =" + menuInfo.getParent_id() + " ");
         }

         if(menuInfo.getState() != null) {
            sql1.append(" and t.state =" + menuInfo.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         if(menuInfo.getParent_menu_name() != null && !menuInfo.getParent_menu_name().equals("")) {
            sql1.append(" and t.parent_menu_name like \'%" + menuInfo.getParent_menu_name() + "%\' ");
         }

         sql1.append(" " + orderby);
         result = this.menuInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findByParentId(Integer parent_id) throws Exception {
      return this.menuInfoDao.findByParentId(parent_id);
   }

   public MenuInfo findByMenuCode(String menu_code) throws Exception {
      return this.menuInfoDao.findByMenuCode(menu_code);
   }

   public boolean checkMenuCode(String menu_code) throws Exception {
      boolean isTrue = false;
      MenuInfo menuInfo = new MenuInfo();
      menuInfo.setMenu_code(menu_code);
      List mis = this.findByCondition(menuInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public List findByMenuRole(Integer role_id) throws Exception {
      Object result = new ArrayList();
      if(role_id != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from ( ");
         sql.append(" select t.id, ");
         sql.append("        t.parent_id,(select count(id) from tb_menu_info where parent_id=t.id) node_count, ");
         sql.append("        (select menu_code from tb_menu_info where id=t.parent_id) parent_menu_code, ");
         sql.append("        (select menu_name from tb_menu_info where id=t.parent_id) parent_menu_name, ");
         sql.append("        t.menu_code,t.menu_name,t.url,t.url_param,t.create_date,t.update_date,t.description,state,is_menu   ");
         sql.append(" from tb_menu_info t,tb_menu_role t1     ");
         sql.append(" where t.id=t1.menu_id and t.state = 1 and t1.role_id=" + role_id);
         sql.append(" ) t");
         result = this.menuInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findByMenuRole(String role_ids) throws Exception {
      Object result = new ArrayList();
      if(role_ids != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append("\t  select         ");
         sql.append("\t\t t.id,         ");
         sql.append("\t\t t.parent_id,(select count(id) from tb_menu_info where parent_id=t.id) node_count,         ");
         sql.append("\t\t (select menu_code from tb_menu_info where id=t.parent_id) parent_menu_code,          ");
         sql.append("\t\t (select menu_name from tb_menu_info where id=t.parent_id) parent_menu_name,          ");
         sql.append("\t\t t.menu_code,t.menu_name,t.url,t.url_param,t.create_date,t.update_date,t.description,state,is_menu          ");
         sql.append("        from tb_menu_info t                  ");
         sql.append("       where t.state = 1 and t.id in(         ");
         sql.append("\t\t\t                 select t.id           ");
         sql.append("                               from tb_menu_info t,tb_menu_role t1           ");
         sql.append("\t                          where t.id=t1.menu_id and t.state = 1 and t1.role_id in(" + role_ids + ")         ");
         sql.append("        ) order by t.orderNum asc         ");
         result = this.menuInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void saveMenuRole(String[] ids, Integer role_id) throws Exception {
      if(ids != null && ids.length > 0) {
         String sql = "delete from tb_menu_role where role_id = " + role_id;
         this.menuInfoDao.executeBySql(sql);
         String[] var7 = ids;
         int var6 = ids.length;

         for(int var5 = 0; var5 < var6; ++var5) {
            String menu_id = var7[var5];
            if(menu_id != null && !menu_id.equals("")) {
               this.menuInfoDao.saveMenuRole(Integer.valueOf(Integer.parseInt(menu_id)), role_id);
            }
         }
      }

   }

   public String getMenuAllNameById(Integer id) throws Exception {
      MenuInfo am = this.findById(id);

      String allName;
      for(allName = am.getMenu_name() == null?"":am.getMenu_name(); am != null; allName = am.getMenu_name() + " >> " + allName) {
         am = this.findById(am.getParent_id());
         if(am == null) {
            break;
         }
      }

      return allName;
   }
}
