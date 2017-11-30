package com.yq.common.pojo;

import java.util.Date;

public class OperationRecord {

   private Integer id;
   private Integer user_id;
   private String user_name;
   private String menu_name;
   private String url;
   private Integer object_id;
   private String operation_type;
   private String operation_object;
   private String operation_content;
   private String remark;
   private Date create_date;


   public Integer getObject_id() {
      return this.object_id;
   }

   public void setObject_id(Integer object_id) {
      this.object_id = object_id;
   }

   public String getMenu_name() {
      return this.menu_name;
   }

   public void setMenu_name(String menu_name) {
      this.menu_name = menu_name;
   }

   public String getUrl() {
      return this.url;
   }

   public void setUrl(String url) {
      this.url = url;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getUser_id() {
      return this.user_id;
   }

   public void setUser_id(Integer user_id) {
      this.user_id = user_id;
   }

   public String getUser_name() {
      return this.user_name;
   }

   public void setUser_name(String user_name) {
      this.user_name = user_name;
   }

   public String getOperation_type() {
      return this.operation_type;
   }

   public void setOperation_type(String operation_type) {
      this.operation_type = operation_type;
   }

   public String getOperation_object() {
      return this.operation_object;
   }

   public void setOperation_object(String operation_object) {
      this.operation_object = operation_object;
   }

   public String getOperation_content() {
      return this.operation_content;
   }

   public void setOperation_content(String operation_content) {
      this.operation_content = operation_content;
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
}
