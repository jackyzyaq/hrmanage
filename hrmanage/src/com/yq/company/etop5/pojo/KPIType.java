package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class KPIType extends VO {

   private Integer id;
   private Integer parent_id;
   private String parent_name;
   private String name;
   private String create_user;
   private String operater;
   private Date create_date;
   private Date update_date;
   private Integer state;


   public String getParent_name() {
      return this.parent_name;
   }

   public void setParent_name(String parent_name) {
      this.parent_name = parent_name;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getParent_id() {
      return this.parent_id;
   }

   public void setParent_id(Integer parent_id) {
      this.parent_id = parent_id;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getCreate_user() {
      return this.create_user;
   }

   public void setCreate_user(String create_user) {
      this.create_user = create_user;
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
