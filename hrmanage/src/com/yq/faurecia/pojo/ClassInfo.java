package com.yq.faurecia.pojo;

import java.util.Date;

public class ClassInfo {

   private Integer id;
   private String class_code;
   private String class_name;
   private String begin_time;
   private String end_time;
   private Double hours;
   private String meals;
   private Integer have_meals;
   private Double over_hour;
   private String remark;
   private Integer state;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Double getHours() {
      return this.hours;
   }

   public void setHours(Double hours) {
      this.hours = hours;
   }

   public String getClass_code() {
      return this.class_code;
   }

   public void setClass_code(String class_code) {
      this.class_code = class_code;
   }

   public String getClass_name() {
      return this.class_name;
   }

   public void setClass_name(String class_name) {
      this.class_name = class_name;
   }

   public String getBegin_time() {
      return this.begin_time;
   }

   public void setBegin_time(String begin_time) {
      this.begin_time = begin_time;
   }

   public String getEnd_time() {
      return this.end_time;
   }

   public void setEnd_time(String end_time) {
      this.end_time = end_time;
   }

   public String getMeals() {
      return this.meals;
   }

   public void setMeals(String meals) {
      this.meals = meals;
   }

   public Integer getHave_meals() {
      return this.have_meals;
   }

   public void setHave_meals(Integer have_meals) {
      this.have_meals = have_meals;
   }

   public Double getOver_hour() {
      return this.over_hour;
   }

   public void setOver_hour(Double over_hour) {
      this.over_hour = over_hour;
   }

   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
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
