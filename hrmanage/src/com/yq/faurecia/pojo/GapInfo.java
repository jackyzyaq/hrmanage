package com.yq.faurecia.pojo;

import java.util.Date;

public class GapInfo {

   private Integer id;
   private String gap_code;
   private String gap_name;
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

   public String getGap_code() {
      return this.gap_code;
   }

   public void setGap_code(String gap_code) {
      this.gap_code = gap_code;
   }

   public String getGap_name() {
      return this.gap_name;
   }

   public void setGap_name(String gap_name) {
      this.gap_name = gap_name;
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
