package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class TourRecord extends VO {

   private Integer id = null;
   private Integer tour_info_id = null;
   private Date report_date = null;
   private Integer number = null;
   private String dept_name = null;
   private String emp_name = null;
   private Integer status = null;
   private Date status_date = null;
   private String respones = null;
   private String ext_1 = null;
   private String ext_2 = null;
   private String ext_3 = null;
   private String ext_4 = null;
   private String ext_5 = null;
   private String ext_6 = null;
   private String ext_7 = null;
   private String ext_8 = null;
   private String ext_9 = null;
   private String ext_10 = null;
   private Integer month;
   private Integer day;
   private Date update_date = null;
   private Date create_date = null;
   private Integer hour = null;
   private String unit = null;
   private Double data24 = null;
   private String operater = null;


   public TourRecord(Integer number, Integer tour_info_id, Date report_date) {
      this.report_date = report_date;
      this.number = number;
      this.tour_info_id = tour_info_id;
   }

   public TourRecord() {}

   public Integer getHour() {
      return this.hour;
   }

   public void setHour(Integer hour) {
      this.hour = hour;
   }

   public String getUnit() {
      return this.unit;
   }

   public void setUnit(String unit) {
      this.unit = unit;
   }

   public Double getData24() {
      return this.data24;
   }

   public void setData24(Double data24) {
      this.data24 = data24;
   }

   public String getOperater() {
      return this.operater;
   }

   public void setOperater(String operater) {
      this.operater = operater;
   }

   public Integer getMonth() {
      return this.month;
   }

   public void setMonth(Integer month) {
      this.month = month;
   }

   public Integer getDay() {
      return this.day;
   }

   public void setDay(Integer day) {
      this.day = day;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getTour_info_id() {
      return this.tour_info_id;
   }

   public void setTour_info_id(Integer tour_info_id) {
      this.tour_info_id = tour_info_id;
   }

   public Date getReport_date() {
      return this.report_date;
   }

   public void setReport_date(Date report_date) {
      this.report_date = report_date;
   }

   public Integer getNumber() {
      return this.number;
   }

   public void setNumber(Integer number) {
      this.number = number;
   }

   public String getDept_name() {
      return this.dept_name;
   }

   public void setDept_name(String dept_name) {
      this.dept_name = dept_name;
   }

   public String getEmp_name() {
      return this.emp_name;
   }

   public void setEmp_name(String emp_name) {
      this.emp_name = emp_name;
   }

   public Integer getStatus() {
      return this.status;
   }

   public void setStatus(Integer status) {
      this.status = status;
   }

   public Date getStatus_date() {
      return this.status_date;
   }

   public void setStatus_date(Date status_date) {
      this.status_date = status_date;
   }

   public String getRespones() {
      return this.respones;
   }

   public void setRespones(String respones) {
      this.respones = respones;
   }

   public String getExt_1() {
      return this.ext_1;
   }

   public void setExt_1(String ext_1) {
      this.ext_1 = ext_1;
   }

   public String getExt_2() {
      return this.ext_2;
   }

   public void setExt_2(String ext_2) {
      this.ext_2 = ext_2;
   }

   public String getExt_3() {
      return this.ext_3;
   }

   public void setExt_3(String ext_3) {
      this.ext_3 = ext_3;
   }

   public String getExt_4() {
      return this.ext_4;
   }

   public void setExt_4(String ext_4) {
      this.ext_4 = ext_4;
   }

   public String getExt_5() {
      return this.ext_5;
   }

   public void setExt_5(String ext_5) {
      this.ext_5 = ext_5;
   }

   public String getExt_6() {
      return this.ext_6;
   }

   public void setExt_6(String ext_6) {
      this.ext_6 = ext_6;
   }

   public String getExt_7() {
      return this.ext_7;
   }

   public void setExt_7(String ext_7) {
      this.ext_7 = ext_7;
   }

   public String getExt_8() {
      return this.ext_8;
   }

   public void setExt_8(String ext_8) {
      this.ext_8 = ext_8;
   }

   public String getExt_9() {
      return this.ext_9;
   }

   public void setExt_9(String ext_9) {
      this.ext_9 = ext_9;
   }

   public String getExt_10() {
      return this.ext_10;
   }

   public void setExt_10(String ext_10) {
      this.ext_10 = ext_10;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }
}
