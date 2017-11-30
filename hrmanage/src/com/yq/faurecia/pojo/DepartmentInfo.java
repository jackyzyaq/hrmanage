package com.yq.faurecia.pojo;

import java.util.Date;

public class DepartmentInfo {

   private Integer id;
   private Integer parent_id;
   private String dept_code;
   private String dept_name;
   private Date create_date;
   private Date update_date;
   private String parent_dept_code;
   private String parent_dept_name;
   private String description;
   private String ids;
   private Integer node_count;
   private Integer state;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getParent_id() {
      return this.parent_id;
   }

   public void setParent_id(Integer parent_id) {
      this.parent_id = parent_id;
   }

   public String getDept_code() {
      return this.dept_code;
   }

   public void setDept_code(String dept_code) {
      this.dept_code = dept_code;
   }

   public String getDept_name() {
      return this.dept_name;
   }

   public void setDept_name(String dept_name) {
      this.dept_name = dept_name;
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

   public String getParent_dept_code() {
      return this.parent_dept_code;
   }

   public void setParent_dept_code(String parent_dept_code) {
      this.parent_dept_code = parent_dept_code;
   }

   public String getParent_dept_name() {
      return this.parent_dept_name;
   }

   public void setParent_dept_name(String parent_dept_name) {
      this.parent_dept_name = parent_dept_name;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public String getIds() {
      return this.ids;
   }

   public void setIds(String ids) {
      this.ids = ids;
   }

   public Integer getNode_count() {
      return this.node_count;
   }

   public void setNode_count(Integer node_count) {
      this.node_count = node_count;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }
}
