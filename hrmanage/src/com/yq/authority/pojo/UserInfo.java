package com.yq.authority.pojo;

import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class UserInfo {

   @Id
   @GeneratedValue(
      strategy = GenerationType.AUTO
   )
   private Integer id;
   private String name;
   private String pwd;
   private String zh_name;
   private String email;
   private Integer state;
   private String upload_uuid;
   private Date create_date;
   private Date update_date;
   private Date last_date;
   private String repwd;
   private String role_ids;


   public Date getLast_date() {
      return this.last_date;
   }

   public void setLast_date(Date last_date) {
      this.last_date = last_date;
   }

   public String getRole_ids() {
      return this.role_ids;
   }

   public void setRole_ids(String role_ids) {
      this.role_ids = role_ids;
   }

   public String getRepwd() {
      return this.repwd;
   }

   public void setRepwd(String repwd) {
      this.repwd = repwd;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }

   public String getEmail() {
      return this.email;
   }

   public void setEmail(String email) {
      this.email = email;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getPwd() {
      return this.pwd;
   }

   public void setPwd(String pwd) {
      this.pwd = pwd;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public String getUpload_uuid() {
      return this.upload_uuid;
   }

   public void setUpload_uuid(String upload_uuid) {
      this.upload_uuid = upload_uuid;
   }

   public String getZh_name() {
      return this.zh_name;
   }

   public void setZh_name(String zh_name) {
      this.zh_name = zh_name;
   }
}
