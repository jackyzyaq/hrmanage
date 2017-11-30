package com.yq.faurecia.pojo;

import java.util.Date;

public class NationalHoliday {

   private Integer id;
   private String holiday_name;
   private Integer state;
   private Date holiday;
   private String remark;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getHoliday_name() {
      return this.holiday_name;
   }

   public void setHoliday_name(String holiday_name) {
      this.holiday_name = holiday_name;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public Date getHoliday() {
      return this.holiday;
   }

   public void setHoliday(Date holiday) {
      this.holiday = holiday;
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
