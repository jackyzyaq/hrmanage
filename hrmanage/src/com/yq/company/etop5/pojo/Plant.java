package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class Plant extends VO {

   private Integer id;
   private Date begin_year;
   private String plant;
   private String upload_uuid;
   private Integer state;
   private String operater;
   private String type;
   private Date create_date;
   private Date update_date;
   private String level1;
   private String handler;
   private Date datepoint;
   private String ext_1;


   public Date getDatepoint() {
      return this.datepoint;
   }

   public void setDatepoint(Date datepoint) {
      this.datepoint = datepoint;
   }

   public String getExt_1() {
      return this.ext_1;
   }

   public void setExt_1(String ext_1) {
      this.ext_1 = ext_1;
   }

   public String getLevel1() {
      return this.level1;
   }

   public void setLevel1(String level1) {
      this.level1 = level1;
   }

   public String getHandler() {
      return this.handler;
   }

   public void setHandler(String handler) {
      this.handler = handler;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getUpload_uuid() {
      return this.upload_uuid;
   }

   public void setUpload_uuid(String upload_uuid) {
      this.upload_uuid = upload_uuid;
   }

   public Date getBegin_year() {
      return this.begin_year;
   }

   public void setBegin_year(Date begin_year) {
      this.begin_year = begin_year;
   }

   public String getPlant() {
      return this.plant;
   }

   public void setPlant(String plant) {
      this.plant = plant;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public String getOperater() {
      return this.operater;
   }

   public void setOperater(String operater) {
      this.operater = operater;
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

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }
}
