package com.yq.company.etop5.service;

import com.util.Page;
import com.util.ReflectPOJO;
import com.yq.company.etop5.dao.GapKPIDao;
import com.yq.company.etop5.pojo.GapKPI;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GapKPIService {

   private String columns = " id,kpi_date,kpi_type,title,subtitle,target,actual,cum,remark,operater,health_png,dept_name, ext_1,ext_2,ext_3,ext_4,ext_5,ext_6,ext_7,ext_8,ext_9,ext_10,target_flag,is_auto_cum,create_date,update_date ";
   private String defTable = "etop5.dbo.tb_gap_kpi";
   private String defOrderBy = " order by  CHARINDEX(dept_name,\'gap\') ";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private GapKPIDao gapKPIDao;


   public GapKPI queryById(int id) throws Exception {
      String sql = " select " + this.columns + " from " + this.defTable + " t " + " where id = " + id;
      return this.gapKPIDao.queryObjectBySql(sql);
   }

   public GapKPI queryByType(Date kpi_date, String kpi_type, String dept_name) throws Exception {
      return this.queryByType(kpi_date, kpi_type, dept_name, (String)null);
   }

   public GapKPI queryByType(Date kpi_date, String kpi_type, String dept_name, String inputOrOutput) throws Exception {
      return this.queryByType(kpi_date, kpi_type, dept_name, inputOrOutput, (String)null);
   }

   public GapKPI queryByType(Date kpi_date, String kpi_type, String dept_name, String inputOrOutput, String ext_2) throws Exception {
      if(kpi_date != null && !StringUtils.isEmpty(kpi_type) && !StringUtils.isEmpty(dept_name)) {
         String sql = " select " + this.columns + " from " + this.defTable + " t " + " where kpi_date = \'" + this.sdf.format(kpi_date) + "\' and kpi_type = \'" + kpi_type.trim() + "\' and dept_name= \'" + dept_name + "\' ";
         if(!StringUtils.isEmpty(inputOrOutput)) {
            sql = sql + " and ext_1 = \'" + inputOrOutput + "\'";
         }

         if(!StringUtils.isEmpty(ext_2)) {
            sql = sql + " and ext_2 = \'" + ext_2 + "\'";
         }

         return this.gapKPIDao.queryObjectBySql(sql);
      } else {
         return null;
      }
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(GapKPI gapKPI) throws Exception {
      gapKPI.setKpi_type(gapKPI.getKpi_type().trim());
      boolean id = false;
      GapKPI pkpi = this.queryByType(gapKPI.getKpi_date(), gapKPI.getKpi_type(), gapKPI.getDept_name());
      int id1;
      if(pkpi == null) {
         id1 = this.gapKPIDao.save(gapKPI);
      } else {
         id1 = pkpi.getId().intValue();
         gapKPI.setId(Integer.valueOf(id1));
         ReflectPOJO.copyObject(pkpi, gapKPI);
         this.gapKPIDao.update(pkpi);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(GapKPI gapKPI) throws Exception {
      gapKPI.setKpi_type(gapKPI.getKpi_type().trim());
      this.gapKPIDao.update(gapKPI);
   }

   public GapKPIDao getGapKPIDao() {
      return this.gapKPIDao;
   }

   public void setGapKPIDao(GapKPIDao gapKPIDao) {
      this.gapKPIDao = gapKPIDao;
   }

   public List findByCondition(GapKPI gapKPI, Page page) throws Exception {
      Object result = new ArrayList();
      if(gapKPI != null) {
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
            orderby = "  order by t.kpi_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + ",day(kpi_date) day ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defTable + " t   ");
         sql1.append(" where 1=1 ");
         if(gapKPI.getId() != null) {
            sql1.append(" and t.id =" + gapKPI.getId() + " ");
         }

         if(gapKPI.getKpi_date() != null) {
            sql1.append(" and t.kpi_date =\'" + this.sdf.format(gapKPI.getKpi_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getKpi_type())) {
            sql1.append(" and t.kpi_type = \'" + gapKPI.getKpi_type().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getDept_name())) {
            sql1.append(" and t.dept_name =\'" + gapKPI.getDept_name() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getExt_1())) {
            sql1.append(" and t.ext_1 =\'" + gapKPI.getExt_1().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getExt_2())) {
            sql1.append(" and t.ext_2 =\'" + gapKPI.getExt_2().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getStart_date())) {
            sql1.append(" and t.kpi_date >=\'" + gapKPI.getStart_date().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getOver_date())) {
            sql1.append(" and t.kpi_date <=\'" + gapKPI.getOver_date().trim() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.gapKPIDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findMonthByCondition(GapKPI gapKPI) throws Exception {
      List result = null;
      if(gapKPI != null) {
         String orderby = "  order by month asc ";
         StringBuffer sql = new StringBuffer("");
         sql.append(" select MONTH(kpi_date) month,AVG(target) target,AVG(actual) actual,AVG(cum) cum  ");
         sql.append(" from " + this.defTable + " t   ");
         sql.append(" where 1=1 ");
         if(gapKPI.getId() != null) {
            sql.append(" and t.id =" + gapKPI.getId() + " ");
         }

         if(gapKPI.getKpi_date() != null) {
            sql.append(" and t.kpi_date =\'" + this.sdf.format(gapKPI.getKpi_date()) + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getKpi_type())) {
            sql.append(" and t.kpi_type =\'" + gapKPI.getKpi_type().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getDept_name())) {
            sql.append(" and t.dept_name =\'" + gapKPI.getDept_name() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getExt_1())) {
            sql.append(" and t.ext_1 =\'" + gapKPI.getExt_1().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getExt_2())) {
            sql.append(" and t.ext_2 =\'" + gapKPI.getExt_2().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getStart_date())) {
            sql.append(" and t.kpi_date >=\'" + gapKPI.getStart_date().trim() + "\' ");
         }

         if(!StringUtils.isEmpty(gapKPI.getOver_date())) {
            sql.append(" and t.kpi_date <=\'" + gapKPI.getOver_date().trim() + "\' ");
         }

         sql.append(" group by MONTH(kpi_date) " + orderby);
         result = this.gapKPIDao.findBySql(sql.toString());
      }

      return result;
   }

   public List autoComplete(Map params) throws Exception {
      String param = "";
      String paramVal = "";
      if(params != null && !StringUtils.isEmpty((CharSequence)params.get("kpi_type"))) {
         param = "kpi_type";
         paramVal = (String)params.get("kpi_type");
      } else if(params != null && !StringUtils.isEmpty((CharSequence)params.get("dept_name"))) {
         param = "dept_name";
         paramVal = (String)params.get("dept_name");
      }

      StringBuffer sql = new StringBuffer("");
      sql.append("select * from (");
      sql.append(this.getKPISql(param, paramVal));
      sql.append(") t where RowNumber > 0 and RowNumber <=10 ");
      return this.gapKPIDao.findBySql(sql.toString());
   }

   public List queryKPIType() throws Exception {
      return this.gapKPIDao.findBySql(this.getKPISql("kpi_type", "") + "  ");
   }

   public List queryKPIDept() throws Exception {
      return this.queryKPIDeptByQCDPAndInOrOut((String)null, (String)null);
   }

   public List queryKPIDeptByInOrOut(String inputOrOutput) throws Exception {
      return this.queryKPIDeptByQCDPAndInOrOut((String)null, inputOrOutput);
   }

   public List queryKPIDeptByQCDPAndInOrOut(String qcdp, String inputOrOutput) throws Exception {
      if(!StringUtils.isEmpty(qcdp)) {
         qcdp = " and t.ext_2=\'" + qcdp + "\' ";
      }

      if(!StringUtils.isEmpty(inputOrOutput)) {
         inputOrOutput = " and t.ext_1 = \'" + inputOrOutput + "\' ";
      }

      return this.gapKPIDao.findBySql(this.getKPISql("dept_name", "").replace("1=1", "1=1" + StringUtils.defaultString(qcdp, "") + StringUtils.defaultString(inputOrOutput, "")) + this.defOrderBy);
   }

   public List queryKPITypeByDept(String dept_name) throws Exception {
      return this.queryKPITypeByDept((String)null, dept_name, (String)null);
   }

   public List queryKPITypeByDept(String dept_name, String inputOrOutput) throws Exception {
      return this.queryKPITypeByDept((String)null, dept_name, inputOrOutput);
   }

   public List queryKPITypeByDept(String qcdp, String dept_name, String inputOrOutput) throws Exception {
      if(!StringUtils.isEmpty(qcdp)) {
         qcdp = " and t.ext_2=\'" + qcdp + "\' ";
      }

      if(!StringUtils.isEmpty(dept_name)) {
         dept_name = " and t.dept_name = \'" + dept_name + "\' ";
      }

      if(!StringUtils.isEmpty(inputOrOutput)) {
         inputOrOutput = " and t.ext_1 = \'" + inputOrOutput + "\' ";
      }

      return this.gapKPIDao.findBySql(this.getKPISql("kpi_type", "").replace("1=1", "1=1" + StringUtils.defaultString(qcdp, "") + StringUtils.defaultString(dept_name, "") + StringUtils.defaultString(inputOrOutput, "")) + " ");
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

   public List getKPITypeAndDeptSql(String ext_2, String inputOrOutput) throws Exception {
      if(!StringUtils.isEmpty(ext_2) && !StringUtils.isEmpty(inputOrOutput)) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select t.kpi_type,t.dept_name ");
         sql.append(" from " + this.defTable + " t   ");
         sql.append(" where 1=1 ");
         sql.append(" and t.ext_1=\'" + StringUtils.defaultString(inputOrOutput, "") + "\' ");
         sql.append(" and t.ext_2=\'" + StringUtils.defaultString(ext_2, "") + "\' ");
         sql.append(" group by t.dept_name,t.kpi_type " + this.defOrderBy);
         return this.gapKPIDao.findBySql(sql.toString());
      } else {
         return null;
      }
   }

   public GapKPI findMaxDayofMonth(String kpi_type, String start_date, String end_date, String dept_name, String inputOrOutput, String ext_2) throws Exception {
      if(!StringUtils.isEmpty(inputOrOutput)) {
         inputOrOutput = " and ext_1=\'" + inputOrOutput + "\'";
      }

      if(!StringUtils.isEmpty(ext_2)) {
         ext_2 = " and ext_2=\'" + ext_2 + "\'";
      }

      StringBuffer sql = new StringBuffer("");
      sql.append(" select " + this.columns + "  ");
      sql.append(" from " + this.defTable + " t   ");
      sql.append(" where kpi_type=\'" + kpi_type.trim() + "\' and dept_name=\'" + dept_name + "\' " + inputOrOutput + ext_2 + " AND kpi_date in( ");
      sql.append(" \tselect max(kpi_date) from " + this.defTable + " where kpi_type=\'" + kpi_type.trim() + "\' and kpi_date >=\'" + start_date.trim() + "\' and kpi_date <=\'" + end_date.trim() + "\'  and dept_name=\'" + dept_name + "\' " + inputOrOutput + ext_2 + " ");
      sql.append(" ) ");
      return this.gapKPIDao.queryObjectBySql(sql.toString());
   }

   public double findSumCum(String kpi_type, String start_date, String end_date, String dept_name, String inputOrOutput, String ext_2) throws Exception {
      if(!StringUtils.isEmpty(inputOrOutput)) {
         inputOrOutput = " and ext_1=\'" + inputOrOutput + "\'";
      }

      if(!StringUtils.isEmpty(ext_2)) {
         ext_2 = " and ext_2=\'" + ext_2 + "\'";
      }

      StringBuffer sql = new StringBuffer("");
      sql.append(" select sum(actual) cum  ");
      sql.append(" from " + this.defTable + " t   ");
      sql.append(" where kpi_type=\'" + kpi_type.trim() + "\' and dept_name=\'" + dept_name + "\' " + inputOrOutput + ext_2 + " ");
      sql.append("   and kpi_date >=\'" + start_date.trim() + "\' and kpi_date <=\'" + end_date.trim() + "\' ");
      GapKPI p = this.gapKPIDao.queryObjectBySql(sql.toString());
      return p != null && p.getCum() != null?p.getCum().doubleValue():0.0D;
   }
}
