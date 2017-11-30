package com.yq.faurecia.pojo;

import java.util.Date;

public class Skill {

   private Integer id;
   private Integer emp_id;
   private String type_name;
   private Integer state;
   private String create_usr;
   private String update_usr;
   private String skill;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
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

   public String getCreate_usr() {
      return this.create_usr;
   }

   public void setCreate_usr(String create_usr) {
      this.create_usr = create_usr;
   }

   public String getUpdate_usr() {
      return this.update_usr;
   }

   public void setUpdate_usr(String update_usr) {
      this.update_usr = update_usr;
   }

   public String getSkill() {
      return this.skill;
   }

   public void setSkill(String skill) {
      this.skill = skill;
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
