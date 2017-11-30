package com.yq.company.etop5.pojo;

import com.util.Util;
import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class PlantKPI extends VO {

   private Integer id;
   private Date kpi_date;
   private String kpi_type;
   private String title;
   private String subtitle;
   private Double target;
   private Double actual;
   private Double cum;
   private String remark;
   private String operater;
   private Date create_date;
   private Date update_date;
   private String health_png;
   private Integer month;
   private Integer day;
   private String dept_name;
   private String ext_1;
   private String ext_2;
   private String ext_3;
   private String ext_4;
   private String ext_5;
   private String ext_6;
   private String ext_7;
   private String ext_8;
   private String ext_9;
   private String ext_10;
   private Integer target_flag;
   private Integer is_auto_cum;


   public Integer getIs_auto_cum() {
      return this.is_auto_cum;
   }

   public void setIs_auto_cum(Integer is_auto_cum) {
      this.is_auto_cum = is_auto_cum;
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

   public Integer getTarget_flag() {
      return this.target_flag;
   }

   public void setTarget_flag(Integer target_flag) {
      this.target_flag = target_flag;
   }

   public String getDept_name() {
      return this.dept_name;
   }

   public void setDept_name(String dept_name) {
      this.dept_name = dept_name;
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

   public String getHealth_png() {
      return this.health_png;
   }

   public void setHealth_png(String health_png) {
      this.health_png = health_png;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Date getKpi_date() {
      return this.kpi_date;
   }

   public void setKpi_date(Date kpi_date) {
      this.kpi_date = kpi_date;
   }

   public String getKpi_type() {
      return this.kpi_type;
   }

   public void setKpi_type(String kpi_type) {
      this.kpi_type = Util.convertToString(kpi_type).replace("&", "and");
   }

   public String getTitle() {
      return this.title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getSubtitle() {
      return this.subtitle;
   }

   public void setSubtitle(String subtitle) {
      this.subtitle = subtitle;
   }

   public Double getTarget() {
      return this.target;
   }

   public void setTarget(Double target) {
      this.target = target;
   }

   public Double getActual() {
      return this.actual;
   }

   public void setActual(Double actual) {
      this.actual = actual;
   }

   public Double getCum() {
      return this.cum;
   }

   public void setCum(Double cum) {
      this.cum = cum;
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

   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
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
}
