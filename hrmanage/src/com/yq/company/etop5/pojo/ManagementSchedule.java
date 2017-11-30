package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class ManagementSchedule extends VO {

   private Integer id;
   private String tb_name;
   private Date tb_schedule_date;
   private String tb_status_am;
   private String tb_status_pm;
   private String tb_backup;
   private Date create_date;
   private Date update_date;
   private String tb_create_user;
   private String tb_update_user;
   private Integer state;


   public ManagementSchedule() {}

   public ManagementSchedule(int state, String tb_name, Date tb_schedule_date) {
      this.state = Integer.valueOf(state);
      this.tb_name = tb_name;
      this.tb_schedule_date = tb_schedule_date;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getTb_name() {
      return this.tb_name;
   }

   public void setTb_name(String tb_name) {
      this.tb_name = tb_name;
   }

   public Date getTb_schedule_date() {
      return this.tb_schedule_date;
   }

   public void setTb_schedule_date(Date tb_schedule_date) {
      this.tb_schedule_date = tb_schedule_date;
   }

   public String getTb_status_am() {
      return this.tb_status_am;
   }

   public void setTb_status_am(String tb_status_am) {
      this.tb_status_am = tb_status_am;
   }

   public String getTb_status_pm() {
      return this.tb_status_pm;
   }

   public void setTb_status_pm(String tb_status_pm) {
      this.tb_status_pm = tb_status_pm;
   }

   public String getTb_backup() {
      return this.tb_backup;
   }

   public void setTb_backup(String tb_backup) {
      this.tb_backup = tb_backup;
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

   public String getTb_create_user() {
      return this.tb_create_user;
   }

   public void setTb_create_user(String tb_create_user) {
      this.tb_create_user = tb_create_user;
   }

   public String getTb_update_user() {
      return this.tb_update_user;
   }

   public void setTb_update_user(String tb_update_user) {
      this.tb_update_user = tb_update_user;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }
}
