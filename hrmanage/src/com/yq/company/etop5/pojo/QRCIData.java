package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class QRCIData extends VO {

   private Integer id;
   private String qrci_type;
   private String open_date;
   private String problem_descripion;
   private String yesterday_task_to_be_checked;
   private String task_for_next_day_future;
   private String respensible;
   private String d3_24_hour;
   private String d6_10_day;
   private String d8_60_day;
   private String pfmea;
   private String cp;
   private String lls;
   private String plant_manager;
   private String lls1;
   private String lls_transversalization;
   private String lls_daily_tracking_30_days;
   private String lls1_pic;
   private String lls_transversalization_pic;
   private String lls_daily_tracking_30_days_pic;
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

   public String getQrci_type() {
      return this.qrci_type;
   }

   public void setQrci_type(String qrci_type) {
      this.qrci_type = qrci_type;
   }

   public String getOpen_date() {
      return this.open_date;
   }

   public void setOpen_date(String open_date) {
      this.open_date = open_date;
   }

   public String getProblem_descripion() {
      return this.problem_descripion;
   }

   public void setProblem_descripion(String problem_descripion) {
      this.problem_descripion = problem_descripion;
   }

   public String getYesterday_task_to_be_checked() {
      return this.yesterday_task_to_be_checked;
   }

   public void setYesterday_task_to_be_checked(String yesterday_task_to_be_checked) {
      this.yesterday_task_to_be_checked = yesterday_task_to_be_checked;
   }

   public String getTask_for_next_day_future() {
      return this.task_for_next_day_future;
   }

   public void setTask_for_next_day_future(String task_for_next_day_future) {
      this.task_for_next_day_future = task_for_next_day_future;
   }

   public String getRespensible() {
      return this.respensible;
   }

   public void setRespensible(String respensible) {
      this.respensible = respensible;
   }

   public String getD3_24_hour() {
      return this.d3_24_hour;
   }

   public void setD3_24_hour(String d3_24_hour) {
      this.d3_24_hour = d3_24_hour;
   }

   public String getD6_10_day() {
      return this.d6_10_day;
   }

   public void setD6_10_day(String d6_10_day) {
      this.d6_10_day = d6_10_day;
   }

   public String getD8_60_day() {
      return this.d8_60_day;
   }

   public void setD8_60_day(String d8_60_day) {
      this.d8_60_day = d8_60_day;
   }

   public String getPfmea() {
      return this.pfmea;
   }

   public void setPfmea(String pfmea) {
      this.pfmea = pfmea;
   }

   public String getCp() {
      return this.cp;
   }

   public void setCp(String cp) {
      this.cp = cp;
   }

   public String getLls() {
      return this.lls;
   }

   public void setLls(String lls) {
      this.lls = lls;
   }

   public String getPlant_manager() {
      return this.plant_manager;
   }

   public void setPlant_manager(String plant_manager) {
      this.plant_manager = plant_manager;
   }

   public String getLls1() {
      return this.lls1;
   }

   public void setLls1(String lls1) {
      this.lls1 = lls1;
   }

   public String getLls_transversalization() {
      return this.lls_transversalization;
   }

   public void setLls_transversalization(String lls_transversalization) {
      this.lls_transversalization = lls_transversalization;
   }

   public String getLls_daily_tracking_30_days() {
      return this.lls_daily_tracking_30_days;
   }

   public void setLls_daily_tracking_30_days(String lls_daily_tracking_30_days) {
      this.lls_daily_tracking_30_days = lls_daily_tracking_30_days;
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

   public String getLls1_pic() {
      return this.lls1_pic;
   }

   public void setLls1_pic(String lls1_pic) {
      this.lls1_pic = lls1_pic;
   }

   public String getLls_transversalization_pic() {
      return this.lls_transversalization_pic;
   }

   public void setLls_transversalization_pic(String lls_transversalization_pic) {
      this.lls_transversalization_pic = lls_transversalization_pic;
   }

   public String getLls_daily_tracking_30_days_pic() {
      return this.lls_daily_tracking_30_days_pic;
   }

   public void setLls_daily_tracking_30_days_pic(String lls_daily_tracking_30_days_pic) {
      this.lls_daily_tracking_30_days_pic = lls_daily_tracking_30_days_pic;
   }
}
