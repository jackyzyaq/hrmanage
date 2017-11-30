package com.yq.faurecia.pojo;

import java.util.Date;

public class HrStatus {

   private Integer id;
   private Integer state;
   private String status_code;
   private Date create_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public String getStatus_code() {
      return this.status_code;
   }

   public void setStatus_code(String status_code) {
      this.status_code = status_code;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }
}
