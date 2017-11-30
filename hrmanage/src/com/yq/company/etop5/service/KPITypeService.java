package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.KPITypeDao;
import com.yq.company.etop5.pojo.KPIType;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class KPITypeService {

   private String defTable = "etop5.dbo.tb_kpi_type";
   private String columns;
   private SimpleDateFormat sdf;
   private SimpleDateFormat sdf1;
   @Resource
   private KPITypeDao kpiTypeDao;


   public KPITypeService() {
      this.columns = "id,          parent_id,(select count(id) from " + this.defTable + " where parent_id=t.id) node_count, " + "        (select name from " + this.defTable + " where id=t.parent_id) parent_name,   " + "        name,create_user,create_date,update_date,operater,state ";
      this.sdf = new SimpleDateFormat("yyyy-MM-dd");
      this.sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   }

   public KPIType queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void delete(int id) throws Exception {
      String ids = this.getSubIdsById(Integer.valueOf(id), (List)null);
      if(!StringUtils.isEmpty(ids)) {
         String sql = " delete from " + this.defTable + " " + " where id in(" + ids + ")";
         this.kpiTypeDao.executeBySql(sql);
      }

   }

   public KPIType queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state;
      }

      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id + state_s;
      return this.kpiTypeDao.queryObjectBySql(sql);
   }

   public List findByParentId(Integer parent_id) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where state=1 and parent_id = " + parent_id;
      return this.kpiTypeDao.findBySql(sql);
   }

   public KPIType queryByName(String name) throws Exception {
      if(StringUtils.isEmpty(name)) {
         return null;
      } else {
         String sql = " select " + this.columns + " from " + this.defTable + " t " + " where name = \'" + name.trim() + "\' ";
         return this.kpiTypeDao.queryObjectBySql(sql);
      }
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(KPIType kpiType) throws Exception {
      boolean id = false;
      KPIType pkpi = this.queryById(kpiType.getId().intValue());
      int id1;
      if(pkpi == null) {
         id1 = this.kpiTypeDao.save(kpiType);
      } else {
         id1 = pkpi.getId().intValue();
         kpiType.setId(Integer.valueOf(id1));
         ReflectPOJO.copyObject(pkpi, kpiType);
         this.kpiTypeDao.update(pkpi);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(KPIType kpiType) throws Exception {
      this.kpiTypeDao.update(kpiType);
   }

   public KPITypeDao getKPITypeDao() {
      return this.kpiTypeDao;
   }

   public void setKPITypeDao(KPITypeDao kpiTypeDao) {
      this.kpiTypeDao = kpiTypeDao;
   }

   public List findByCondition(KPIType kpiType, Page page) throws Exception {
      Object result = new ArrayList();
      if(kpiType != null) {
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
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(kpiType.getId() != null) {
            sql1.append(" and t.id =" + kpiType.getId() + " ");
         }

         if(!StringUtils.isEmpty(kpiType.getIds())) {
            sql1.append(" and t.id in(" + kpiType.getIds() + ") ");
         }

         if(!StringUtils.isEmpty(kpiType.getName())) {
            sql1.append(" and t.name like \'%" + kpiType.getName().trim() + "%\' ");
         }

         if(kpiType.getState() != null) {
            sql1.append(" and t.state =" + kpiType.getState() + " ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.kpiTypeDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List autoComplete(Map params) throws Exception {
      String param = "";
      String paramVal = "";
      if(params != null && !StringUtils.isEmpty((CharSequence)params.get("name"))) {
         param = "name";
         paramVal = (String)params.get("name");
      }

      StringBuffer sql = new StringBuffer("");
      sql.append("select * from (");
      sql.append(this.getKPISql(param, paramVal));
      sql.append(") t where RowNumber > 0 and RowNumber <=10 ");
      return this.kpiTypeDao.findBySql(sql.toString());
   }

   private String getKPISql(String param, String paramVal) {
      if(StringUtils.isEmpty(param)) {
         return "";
      } else {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + param + ",ROW_NUMBER() OVER (order by t." + param + ") AS RowNumber ");
         sql.append(" from " + this.defTable + " t   ");
         sql.append(" where 1=1 ");
         sql.append(" and t." + param + " like \'%" + StringUtils.defaultString(paramVal, "") + "%\' ");
         sql.append(" group by t." + param + " ");
         return sql.toString();
      }
   }

   public String getKPITypeAllNameById(Integer id) throws Exception {
      KPIType am = this.queryById(id.intValue());

      String allName;
      for(allName = am.getName() == null?"":am.getName(); am != null; allName = am.getName() + " >> " + allName) {
         am = this.queryById(am.getParent_id().intValue());
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
            KPIType di = (KPIType)var5.next();
            this.getSubIdsById(di.getId(), (List)ids);
         }
      }

      return ((List)ids).isEmpty()?null:StringUtils.substringBetween(ids.toString(), "[", "]");
   }
}
