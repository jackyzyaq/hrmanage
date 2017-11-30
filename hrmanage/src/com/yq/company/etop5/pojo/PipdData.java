package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;
import org.apache.commons.lang.StringUtils;

public class PipdData extends VO {

   private Integer id;
   private String type;
   private String sub_type;
   private Date report_date;
   private Double reality_pipd_data;
   private Double must_pipd_data;
   private String operater;
   private Integer state;
   private String upload_pic_uuid;
   private String upload_uuid;
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
      this.type = StringUtils.isEmpty(type)?"":type.replace("<br/>", "");
   }

   public String getSub_type() {
      return this.sub_type;
   }

   public void setSub_type(String sub_type) {
      this.sub_type = StringUtils.isEmpty(sub_type)?"":sub_type.replace("<br/>", "");
   }

   public Date getReport_date() {
      return this.report_date;
   }

   public void setReport_date(Date report_date) {
      this.report_date = report_date;
   }

   public Double getReality_pipd_data() {
      return this.reality_pipd_data;
   }

   public void setReality_pipd_data(Double reality_pipd_data) {
      this.reality_pipd_data = reality_pipd_data;
   }

   public Double getMust_pipd_data() {
      return this.must_pipd_data;
   }

   public void setMust_pipd_data(Double must_pipd_data) {
      this.must_pipd_data = must_pipd_data;
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

   public String getUpload_pic_uuid() {
      return this.upload_pic_uuid;
   }

   public void setUpload_pic_uuid(String upload_pic_uuid) {
      this.upload_pic_uuid = upload_pic_uuid;
   }

   public String getUpload_uuid() {
      return this.upload_uuid;
   }

   public void setUpload_uuid(String upload_uuid) {
      this.upload_uuid = upload_uuid;
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
