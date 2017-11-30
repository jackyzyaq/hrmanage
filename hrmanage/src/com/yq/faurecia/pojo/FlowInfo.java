package com.yq.faurecia.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class FlowInfo extends VO {

   private Integer id;
   private String flow_code;
   private String flow_name;
   private String step_info;
   private Integer days_down;
   private Integer days_up;
   private Integer days;
   private Integer state;
   private String remark;
   private Date create_date;
   private Date update_date;


   public Integer getDays() {
      return this.days;
   }

   public void setDays(Integer days) {
      this.days = days;
   }

   public Integer getDays_down() {
      return this.days_down;
   }

   public void setDays_down(Integer days_down) {
      this.days_down = days_down;
   }

   public Integer getDays_up() {
      return this.days_up;
   }

   public void setDays_up(Integer days_up) {
      this.days_up = days_up;
   }

   public String getFlow_code() {
      return this.flow_code;
   }

   public void setFlow_code(String flow_code) {
      this.flow_code = flow_code;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getFlow_name() {
      return this.flow_name;
   }

   public void setFlow_name(String flow_name) {
      this.flow_name = flow_name;
   }

   public String getStep_info() {
      return this.step_info;
   }

   public void setStep_info(String step_info) {
      this.step_info = step_info;
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
