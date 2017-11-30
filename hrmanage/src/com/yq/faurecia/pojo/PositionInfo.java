package com.yq.faurecia.pojo;

import java.util.Date;

public class PositionInfo {

   private Integer id;
   private String pos_code;
   private String pos_name;
   private Integer state;
   private Date create_date;
   private Date update_date;
   private String pos01;
   private String pos02;
   private String pos03;
   private String pos04;
   private String pos05;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getPos_code() {
      return this.pos_code;
   }

   public void setPos_code(String pos_code) {
      this.pos_code = pos_code;
   }

   public String getPos_name() {
      return this.pos_name;
   }

   public void setPos_name(String pos_name) {
      this.pos_name = pos_name;
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

   public String getPos01() {
      return this.pos01;
   }

   public void setPos01(String pos01) {
      this.pos01 = pos01;
   }

   public String getPos02() {
      return this.pos02;
   }

   public void setPos02(String pos02) {
      this.pos02 = pos02;
   }

   public String getPos03() {
      return this.pos03;
   }

   public void setPos03(String pos03) {
      this.pos03 = pos03;
   }

   public String getPos04() {
      return this.pos04;
   }

   public void setPos04(String pos04) {
      this.pos04 = pos04;
   }

   public String getPos05() {
      return this.pos05;
   }

   public void setPos05(String pos05) {
      this.pos05 = pos05;
   }
}
