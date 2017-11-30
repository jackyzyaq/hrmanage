package com.yq.faurecia.pojo;

import java.util.Date;

public class LeaveType {

   private Integer id;
   private String type_code;
   private String type_name;
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

   public String getType_code() {
      return this.type_code;
   }

   public void setType_code(String type_code) {
      this.type_code = type_code;
   }

   public String getType_name() {
      return this.type_name;
   }

   public void setType_name(String type_name) {
      this.type_name = type_name;
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
