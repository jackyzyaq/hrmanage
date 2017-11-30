package com.yq.authority.pojo;

import java.io.Serializable;
import java.util.Date;

public class RoleInfo implements Serializable {

   private static final long serialVersionUID = 7637854086958919533L;
   private Integer id;
   private String type_code;
   private String role_code;
   private String role_name;
   private String parent_code;
   private Integer parent_id;
   private String parent_name;
   private String description;
   private Integer state;
   private Date create_date;
   private Date update_date;
   private Integer role_id;
   private Integer menu_id;
   private Integer action_id;
   private Integer user_id;


   public Integer getAction_id() {
      return this.action_id;
   }

   public void setAction_id(Integer action_id) {
      this.action_id = action_id;
   }

   public Integer getUser_id() {
      return this.user_id;
   }

   public void setUser_id(Integer user_id) {
      this.user_id = user_id;
   }

   public Integer getRole_id() {
      return this.role_id;
   }

   public void setRole_id(Integer role_id) {
      this.role_id = role_id;
   }

   public Integer getMenu_id() {
      return this.menu_id;
   }

   public void setMenu_id(Integer menu_id) {
      this.menu_id = menu_id;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public static long getSerialVersionUID() {
      return 7637854086958919533L;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getParent_code() {
      return this.parent_code;
   }

   public void setParent_code(String parent_code) {
      this.parent_code = parent_code;
   }

   public Integer getParent_id() {
      return this.parent_id;
   }

   public void setParent_id(Integer parent_id) {
      this.parent_id = parent_id;
   }

   public String getParent_name() {
      return this.parent_name;
   }

   public void setParent_name(String parent_name) {
      this.parent_name = parent_name;
   }

   public String getRole_code() {
      return this.role_code;
   }

   public void setRole_code(String role_code) {
      this.role_code = role_code;
   }

   public String getRole_name() {
      return this.role_name;
   }

   public void setRole_name(String role_name) {
      this.role_name = role_name;
   }

   public String getType_code() {
      return this.type_code;
   }

   public void setType_code(String type_code) {
      this.type_code = type_code;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }
}
