package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class Tour extends VO {

   private Integer id = null;
   private String time = null;
   private String zone = null;
   private String input_kpi = null;
   private String criteria_standard_situation = null;
   private String linked_output_kpi = null;
   private String visual_tools = null;
   private String check_current_situation = null;
   private String up_rule_y = null;
   private String up_rule_o = null;
   private String up_rule_r = null;
   private String reaction_rule_y = null;
   private String reaction_rule_o = null;
   private String reaction_rule_r = null;
   private Integer dept_id = null;
   private String ext_1 = null;
   private String ext_2 = null;
   private String ext_3 = null;
   private String ext_4 = null;
   private String ext_5 = null;
   private String ext_6 = null;
   private String ext_7 = null;
   private String ext_8 = null;
   private String ext_9 = null;
   private String ext_10 = null;
   private Integer dept_id_1 = null;
   private Integer emp_id_1 = null;
   private String expect_time_1 = null;
   private Integer dept_id_2 = null;
   private Integer emp_id_2 = null;
   private String expect_time_2 = null;
   private Integer dept_id_3 = null;
   private Integer emp_id_3 = null;
   private String expect_time_3 = null;
   private Integer state = null;
   private String operater = null;
   private Date update_date = null;
   private Date create_date = null;
   private String tmp_emp_ids = null;
   private String tmp_dept_ids = null;
   private String tmp_expect_times = null;
   private String map_upload = null;


   public Tour(Integer state, Integer dept_id) {
      this.state = state;
      this.dept_id = dept_id;
   }

   public Tour(int state) {
      this.state = Integer.valueOf(state);
   }

   public Tour() {}

   public String getMap_upload() {
      return this.map_upload;
   }

   public void setMap_upload(String map_upload) {
      this.map_upload = map_upload;
   }

   public String getUp_rule_y() {
      return this.up_rule_y;
   }

   public void setUp_rule_y(String up_rule_y) {
      this.up_rule_y = up_rule_y;
   }

   public String getUp_rule_o() {
      return this.up_rule_o;
   }

   public void setUp_rule_o(String up_rule_o) {
      this.up_rule_o = up_rule_o;
   }

   public String getUp_rule_r() {
      return this.up_rule_r;
   }

   public void setUp_rule_r(String up_rule_r) {
      this.up_rule_r = up_rule_r;
   }

   public Integer getDept_id() {
      return this.dept_id;
   }

   public void setDept_id(Integer dept_id) {
      this.dept_id = dept_id;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public String getTmp_emp_ids() {
      return this.tmp_emp_ids;
   }

   public void setTmp_emp_ids(String tmp_emp_ids) {
      this.tmp_emp_ids = tmp_emp_ids;
   }

   public String getTmp_dept_ids() {
      return this.tmp_dept_ids;
   }

   public void setTmp_dept_ids(String tmp_dept_ids) {
      this.tmp_dept_ids = tmp_dept_ids;
   }

   public String getTmp_expect_times() {
      return this.tmp_expect_times;
   }

   public void setTmp_expect_times(String tmp_expect_times) {
      this.tmp_expect_times = tmp_expect_times;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getTime() {
      return this.time;
   }

   public void setTime(String time) {
      this.time = time;
   }

   public String getZone() {
      return this.zone;
   }

   public void setZone(String zone) {
      this.zone = zone;
   }

   public String getInput_kpi() {
      return this.input_kpi;
   }

   public void setInput_kpi(String input_kpi) {
      this.input_kpi = input_kpi;
   }

   public String getCriteria_standard_situation() {
      return this.criteria_standard_situation;
   }

   public void setCriteria_standard_situation(String criteria_standard_situation) {
      this.criteria_standard_situation = criteria_standard_situation;
   }

   public String getLinked_output_kpi() {
      return this.linked_output_kpi;
   }

   public void setLinked_output_kpi(String linked_output_kpi) {
      this.linked_output_kpi = linked_output_kpi;
   }

   public String getVisual_tools() {
      return this.visual_tools;
   }

   public void setVisual_tools(String visual_tools) {
      this.visual_tools = visual_tools;
   }

   public String getCheck_current_situation() {
      return this.check_current_situation;
   }

   public void setCheck_current_situation(String check_current_situation) {
      this.check_current_situation = check_current_situation;
   }

   public String getReaction_rule_y() {
      return this.reaction_rule_y;
   }

   public void setReaction_rule_y(String reaction_rule_y) {
      this.reaction_rule_y = reaction_rule_y;
   }

   public String getReaction_rule_o() {
      return this.reaction_rule_o;
   }

   public void setReaction_rule_o(String reaction_rule_o) {
      this.reaction_rule_o = reaction_rule_o;
   }

   public String getReaction_rule_r() {
      return this.reaction_rule_r;
   }

   public void setReaction_rule_r(String reaction_rule_r) {
      this.reaction_rule_r = reaction_rule_r;
   }

   public Integer getDept_id_1() {
      return this.dept_id_1;
   }

   public void setDept_id_1(Integer dept_id_1) {
      this.dept_id_1 = dept_id_1;
   }

   public Integer getEmp_id_1() {
      return this.emp_id_1;
   }

   public void setEmp_id_1(Integer emp_id_1) {
      this.emp_id_1 = emp_id_1;
   }

   public String getExpect_time_1() {
      return this.expect_time_1;
   }

   public void setExpect_time_1(String expect_time_1) {
      this.expect_time_1 = expect_time_1;
   }

   public Integer getDept_id_2() {
      return this.dept_id_2;
   }

   public void setDept_id_2(Integer dept_id_2) {
      this.dept_id_2 = dept_id_2;
   }

   public Integer getEmp_id_2() {
      return this.emp_id_2;
   }

   public void setEmp_id_2(Integer emp_id_2) {
      this.emp_id_2 = emp_id_2;
   }

   public String getExpect_time_2() {
      return this.expect_time_2;
   }

   public void setExpect_time_2(String expect_time_2) {
      this.expect_time_2 = expect_time_2;
   }

   public Integer getDept_id_3() {
      return this.dept_id_3;
   }

   public void setDept_id_3(Integer dept_id_3) {
      this.dept_id_3 = dept_id_3;
   }

   public Integer getEmp_id_3() {
      return this.emp_id_3;
   }

   public void setEmp_id_3(Integer emp_id_3) {
      this.emp_id_3 = emp_id_3;
   }

   public String getExpect_time_3() {
      return this.expect_time_3;
   }

   public void setExpect_time_3(String expect_time_3) {
      this.expect_time_3 = expect_time_3;
   }

   public String getExt_1() {
      return this.ext_1;
   }

   public void setExt_1(String ext_1) {
      this.ext_1 = ext_1;
   }

   public String getExt_2() {
      return this.ext_2;
   }

   public void setExt_2(String ext_2) {
      this.ext_2 = ext_2;
   }

   public String getExt_3() {
      return this.ext_3;
   }

   public void setExt_3(String ext_3) {
      this.ext_3 = ext_3;
   }

   public String getExt_4() {
      return this.ext_4;
   }

   public void setExt_4(String ext_4) {
      this.ext_4 = ext_4;
   }

   public String getExt_5() {
      return this.ext_5;
   }

   public void setExt_5(String ext_5) {
      this.ext_5 = ext_5;
   }

   public String getExt_6() {
      return this.ext_6;
   }

   public void setExt_6(String ext_6) {
      this.ext_6 = ext_6;
   }

   public String getExt_7() {
      return this.ext_7;
   }

   public void setExt_7(String ext_7) {
      this.ext_7 = ext_7;
   }

   public String getExt_8() {
      return this.ext_8;
   }

   public void setExt_8(String ext_8) {
      this.ext_8 = ext_8;
   }

   public String getExt_9() {
      return this.ext_9;
   }

   public void setExt_9(String ext_9) {
      this.ext_9 = ext_9;
   }

   public String getExt_10() {
      return this.ext_10;
   }

   public void setExt_10(String ext_10) {
      this.ext_10 = ext_10;
   }

   public String getOperater() {
      return this.operater;
   }

   public void setOperater(String operater) {
      this.operater = operater;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }
}
