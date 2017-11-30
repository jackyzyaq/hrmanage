package com.yq.faurecia.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class OverTimeInfo extends VO {

   private Integer id;
   private String wo_number;
   private Integer flow_id;
   private Integer dept_id;
   private String dept_name;
   private String dept_ids;
   private Integer emp_id;
   private String emp_name;
   private String type;
   private Date begin_date;
   private Date end_date;
   private Double over_hour;
   private String day_or_hour;
   private Integer user_id;
   private String user_name;
   private String remark;
   private Integer available;
   private Integer check_emp_id;
   private String check_emp_name;
   private Integer check_state;
   private String check_states;
   private Date check_state_date;
   private String check_remark;
   private Integer next_check_emp_id;
   private Integer status;
   private Date create_date;
   private Date update_date;
   private Integer year;
   private String tmp_date;


   public String getWo_number() {
      return this.wo_number;
   }

   public void setWo_number(String wo_number) {
      this.wo_number = wo_number;
   }

   public String getDay_or_hour() {
      return this.day_or_hour;
   }

   public void setDay_or_hour(String day_or_hour) {
      this.day_or_hour = day_or_hour;
   }

   public Integer getYear() {
      return this.year;
   }

   public void setYear(Integer year) {
      this.year = year;
   }

   public Double getOver_hour() {
      return this.over_hour;
   }

   public void setOver_hour(Double over_hour) {
      this.over_hour = over_hour;
   }

   public String getTmp_date() {
      return this.tmp_date;
   }

   public void setTmp_date(String tmp_date) {
      this.tmp_date = tmp_date;
   }

   public Integer getAvailable() {
      return this.available;
   }

   public void setAvailable(Integer available) {
      this.available = available;
   }

   public String getCheck_states() {
      return this.check_states;
   }

   public void setCheck_states(String check_states) {
      this.check_states = check_states;
   }

   public String getCheck_remark() {
      return this.check_remark;
   }

   public void setCheck_remark(String check_remark) {
      this.check_remark = check_remark;
   }

   public Integer getNext_check_emp_id() {
      return this.next_check_emp_id;
   }

   public void setNext_check_emp_id(Integer next_check_emp_id) {
      this.next_check_emp_id = next_check_emp_id;
   }

   public String getUser_name() {
      return this.user_name;
   }

   public void setUser_name(String user_name) {
      this.user_name = user_name;
   }

   public String getDept_ids() {
      return this.dept_ids;
   }

   public void setDept_ids(String dept_ids) {
      this.dept_ids = dept_ids;
   }

   public Integer getDept_id() {
      return this.dept_id;
   }

   public void setDept_id(Integer dept_id) {
      this.dept_id = dept_id;
   }

   public Integer getStatus() {
      return this.status;
   }

   public void setStatus(Integer status) {
      this.status = status;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getFlow_id() {
      return this.flow_id;
   }

   public void setFlow_id(Integer flow_id) {
      this.flow_id = flow_id;
   }

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
   }

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public Date getBegin_date() {
      return this.begin_date;
   }

   public void setBegin_date(Date begin_date) {
      this.begin_date = begin_date;
   }

   public Date getEnd_date() {
      return this.end_date;
   }

   public void setEnd_date(Date end_date) {
      this.end_date = end_date;
   }

   public Integer getUser_id() {
      return this.user_id;
   }

   public void setUser_id(Integer user_id) {
      this.user_id = user_id;
   }

   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
   }

   public Integer getCheck_emp_id() {
      return this.check_emp_id;
   }

   public void setCheck_emp_id(Integer check_emp_id) {
      this.check_emp_id = check_emp_id;
   }

   public Integer getCheck_state() {
      return this.check_state;
   }

   public void setCheck_state(Integer check_state) {
      this.check_state = check_state;
   }

   public Date getCheck_state_date() {
      return this.check_state_date;
   }

   public void setCheck_state_date(Date check_state_date) {
      this.check_state_date = check_state_date;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public String getDept_name() {
      return this.dept_name;
   }

   public void setDept_name(String dept_name) {
      this.dept_name = dept_name;
   }

   public String getEmp_name() {
      return this.emp_name;
   }

   public void setEmp_name(String emp_name) {
      this.emp_name = emp_name;
   }

   public String getCheck_emp_name() {
      return this.check_emp_name;
   }

   public void setCheck_emp_name(String check_emp_name) {
      this.check_emp_name = check_emp_name;
   }
}
