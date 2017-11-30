package com.yq.faurecia.service;

import com.util.Page;
import com.yq.faurecia.dao.CommonSqlMapDao;
import com.yq.faurecia.pojo.Skill;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SkillService {

   private String columns = " id,emp_id,type_name,skill,state,create_usr,update_usr,create_date,update_date ";
   private Skill tmpSkill = new Skill();
   @Resource
   private CommonSqlMapDao commonSqlMapDao;


   public Skill queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public Skill queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from tb_employee_skill t " + " where id = " + id + state_s;
      return (Skill)this.commonSqlMapDao.queryObjectBySql(this.tmpSkill, sql);
   }

   public List queryByEmpId(int emp_id) throws Exception {
      String sql = " select " + this.columns + " from tb_employee_skill t " + " where state=1 and emp_id = " + emp_id;
      return this.commonSqlMapDao.findBySql(this.tmpSkill, sql.toString());
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(Skill skill) throws Exception {
      boolean id = false;
      int id1;
      if(skill.getId() != null && skill.getId().intValue() >= 1) {
         id1 = this.commonSqlMapDao.save(skill);
      } else {
         id1 = skill.getId().intValue();
         this.update(skill);
      }

      return id1;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(Skill skill) throws Exception {
      this.commonSqlMapDao.update(skill);
   }

   public List findByCondition(Skill skill, Page page) throws Exception {
      List result = null;
      if(skill != null) {
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
         sql1.append(" from tb_employee_skill t   ");
         sql1.append(" where 1=1 ");
         if(skill.getEmp_id() != null) {
            sql1.append(" and t.emp_id =" + skill.getEmp_id() + " ");
         }

         if(skill.getState() != null) {
            sql1.append(" and t.state =" + skill.getState() + " ");
         }

         if(StringUtils.isEmpty(skill.getType_name())) {
            sql1.append(" and t.type_name =\'" + skill.getType_name() + "\' ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.commonSqlMapDao.findBySql(skill, sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }
}
