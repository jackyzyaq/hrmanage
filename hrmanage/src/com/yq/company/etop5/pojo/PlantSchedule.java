package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class PlantSchedule extends VO {

   private Integer id;
   private Date begin_date;
   private Date end_date;
   private String title;
   private Integer state;
   private String operater;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Date getBegin_date() {
      return this.begin_date;
   }

   public void setBegin_date(Date begin_date) {
      this.begin_date = begin_date;
   }

   public Date getEnd_date() {
      return this.end_date;
   }

   public void setEnd_date(Date end_date) {
      this.end_date = end_date;
   }

   public String getTitle() {
      return this.title;
   }

   public void setTitle(String title) {
      this.title = title;
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
}
