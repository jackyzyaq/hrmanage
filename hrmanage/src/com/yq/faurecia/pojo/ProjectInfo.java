package com.yq.faurecia.pojo;

import java.util.Date;

public class ProjectInfo {

   private Integer id;
   private String project_code;
   private String project_name;
   private Integer state;
   private String remark;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getProject_code() {
      return this.project_code;
   }

   public void setProject_code(String project_code) {
      this.project_code = project_code;
   }

   public String getProject_name() {
      return this.project_name;
   }

   public void setProject_name(String project_name) {
      this.project_name = project_name;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
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
}
