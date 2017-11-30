package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class PipdReport extends VO {

   private Integer id;
   private String type;
   private String sub_type;
   private Date begin_month;
   private Date end_month;
   private String upload_uuid_pic;
   private String upload_uuid;
   private String operater;
   private Integer state;
   private Date create_date;
   private Date update_date;


   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public String getSub_type() {
      return this.sub_type;
   }

   public void setSub_type(String sub_type) {
      this.sub_type = sub_type;
   }

   public Date getBegin_month() {
      return this.begin_month;
   }

   public void setBegin_month(Date begin_month) {
      this.begin_month = begin_month;
   }

   public Date getEnd_month() {
      return this.end_month;
   }

   public void setEnd_month(Date end_month) {
      this.end_month = end_month;
   }

   public String getUpload_uuid_pic() {
      return this.upload_uuid_pic;
   }

   public void setUpload_uuid_pic(String upload_uuid_pic) {
      this.upload_uuid_pic = upload_uuid_pic;
   }

   public String getUpload_uuid() {
      return this.upload_uuid;
   }

   public void setUpload_uuid(String upload_uuid) {
      this.upload_uuid = upload_uuid;
   }

   public String getOperater() {
      return this.operater;
   }

   public void setOperater(String operater) {
      this.operater = operater;
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
