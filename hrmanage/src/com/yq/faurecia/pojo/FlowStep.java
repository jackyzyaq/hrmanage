package com.yq.faurecia.pojo;

import java.util.Date;

public class FlowStep {

   private Integer id;
   private Integer flow_id;
   private Integer handle_id;
   private Integer state;
   private Date state_date;
   private Integer emp_id;
   private String emp_name;
   private String remark;
   private Date create_date;


   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
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

   public Integer getHandle_id() {
      return this.handle_id;
   }

   public void setHandle_id(Integer handle_id) {
      this.handle_id = handle_id;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public Date getState_date() {
      return this.state_date;
   }

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
   }

   public String getEmp_name() {
      return this.emp_name;
   }

   public void setEmp_name(String emp_name) {
      this.emp_name = emp_name;
   }

   public void setState_date(Date state_date) {
      this.state_date = state_date;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }
}
