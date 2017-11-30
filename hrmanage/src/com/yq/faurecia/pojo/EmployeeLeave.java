package com.yq.faurecia.pojo;

import java.util.Date;

public class EmployeeLeave {

   private Integer id;
   private Integer emp_id;
   private Integer year;
   private Double annualDays;
   private Double companyDays;
   private Double totalDays;
   private Integer state;
   private Date create_date;
   private Date update_date;


   public EmployeeLeave() {}

   public EmployeeLeave(int empId, int year, double aDays, double cDays) {
      this.emp_id = Integer.valueOf(empId);
      this.year = Integer.valueOf(year);
      this.annualDays = Double.valueOf(aDays);
      this.companyDays = Double.valueOf(cDays);
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
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

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
   }

   public Integer getYear() {
      return this.year;
   }

   public void setYear(Integer year) {
      this.year = year;
   }

   public Double getAnnualDays() {
      return this.annualDays;
   }

   public void setAnnualDays(Double annualDays) {
      this.annualDays = annualDays;
   }

   public Double getCompanyDays() {
      return this.companyDays;
   }

   public void setCompanyDays(Double companyDays) {
      this.companyDays = companyDays;
   }

   public Double getTotalDays() {
      return this.totalDays;
   }

   public void setTotalDays(Double totalDays) {
      this.totalDays = totalDays;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }
}
