package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class SupervisorRanking extends VO {

   private Integer id;
   private Integer dept_id;
   private String dept_name;
   private String supervisor;
   private Date begin_month;
   private Date end_month;
   private Double kpi_1;
   private Double kpi_2;
   private Double kpi_3;
   private Double kpi_4;
   private Double kpi_5;
   private Double kpi_6;
   private String type;
   private String header_1;
   private String header_2;
   private String header_3;
   private String header_4;
   private String header_5;
   private String header_6;
   private Double over_all;
   private String operater;
   private Date create_date;
   private Date update_date;


   public String getHeader_1() {
      return this.header_1;
   }

   public void setHeader_1(String header_1) {
      this.header_1 = header_1;
   }

   public String getHeader_2() {
      return this.header_2;
   }

   public void setHeader_2(String header_2) {
      this.header_2 = header_2;
   }

   public String getHeader_3() {
      return this.header_3;
   }

   public void setHeader_3(String header_3) {
      this.header_3 = header_3;
   }

   public String getHeader_4() {
      return this.header_4;
   }

   public void setHeader_4(String header_4) {
      this.header_4 = header_4;
   }

   public String getHeader_5() {
      return this.header_5;
   }

   public void setHeader_5(String header_5) {
      this.header_5 = header_5;
   }

   public String getHeader_6() {
      return this.header_6;
   }

   public void setHeader_6(String header_6) {
      this.header_6 = header_6;
   }

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public String getDept_name() {
      return this.dept_name;
   }

   public void setDept_name(String dept_name) {
      this.dept_name = dept_name;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Integer getDept_id() {
      return this.dept_id;
   }

   public void setDept_id(Integer dept_id) {
      this.dept_id = dept_id;
   }

   public String getSupervisor() {
      return this.supervisor;
   }

   public void setSupervisor(String supervisor) {
      this.supervisor = supervisor;
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

   public Double getKpi_1() {
      return this.kpi_1;
   }

   public void setKpi_1(Double kpi_1) {
      this.kpi_1 = kpi_1;
   }

   public Double getKpi_2() {
      return this.kpi_2;
   }

   public void setKpi_2(Double kpi_2) {
      this.kpi_2 = kpi_2;
   }

   public Double getKpi_3() {
      return this.kpi_3;
   }

   public void setKpi_3(Double kpi_3) {
      this.kpi_3 = kpi_3;
   }

   public Double getKpi_4() {
      return this.kpi_4;
   }

   public void setKpi_4(Double kpi_4) {
      this.kpi_4 = kpi_4;
   }

   public Double getKpi_5() {
      return this.kpi_5;
   }

   public void setKpi_5(Double kpi_5) {
      this.kpi_5 = kpi_5;
   }

   public Double getKpi_6() {
      return this.kpi_6;
   }

   public void setKpi_6(Double kpi_6) {
      this.kpi_6 = kpi_6;
   }

   public Double getOver_all() {
      return this.over_all;
   }

   public void setOver_all(Double over_all) {
      this.over_all = over_all;
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
