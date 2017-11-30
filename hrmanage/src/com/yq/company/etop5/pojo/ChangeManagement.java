package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;

public class ChangeManagement extends VO {

   private Integer id;
   private Date report_date;
   private Integer dept_id;
   private Integer emp_id;
   private String type;
   private String ext_1;
   private String ext_2;
   private String ext_3;
   private String ext_4;
   private String ext_5_1;
   private Date ext_5_1_date;
   private String ext_5_2;
   private Date ext_5_2_date;
   private String ext_5_3;
   private Date ext_5_3_date;
   private String ext_5_4;
   private Date ext_5_4_date;
   private String ext_5_5;
   private Date ext_5_5_date;
   private Integer state;
   private String operater;
   private Date create_date;
   private Date update_date;


   public ChangeManagement() {}

   public ChangeManagement(int state) {
      this.state = Integer.valueOf(state);
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public Date getReport_date() {
      return this.report_date;
   }

   public void setReport_date(Date report_date) {
      this.report_date = report_date;
   }

   public Integer getDept_id() {
      return this.dept_id;
   }

   public void setDept_id(Integer dept_id) {
      this.dept_id = dept_id;
   }

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
   }

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
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

   public String getExt_5_1() {
      return this.ext_5_1;
   }

   public void setExt_5_1(String ext_5_1) {
      this.ext_5_1 = ext_5_1;
   }

   public Date getExt_5_1_date() {
      return this.ext_5_1_date;
   }

   public void setExt_5_1_date(Date ext_5_1_date) {
      this.ext_5_1_date = ext_5_1_date;
   }

   public String getExt_5_2() {
      return this.ext_5_2;
   }

   public void setExt_5_2(String ext_5_2) {
      this.ext_5_2 = ext_5_2;
   }

   public Date getExt_5_2_date() {
      return this.ext_5_2_date;
   }

   public void setExt_5_2_date(Date ext_5_2_date) {
      this.ext_5_2_date = ext_5_2_date;
   }

   public String getExt_5_3() {
      return this.ext_5_3;
   }

   public void setExt_5_3(String ext_5_3) {
      this.ext_5_3 = ext_5_3;
   }

   public Date getExt_5_3_date() {
      return this.ext_5_3_date;
   }

   public void setExt_5_3_date(Date ext_5_3_date) {
      this.ext_5_3_date = ext_5_3_date;
   }

   public String getExt_5_4() {
      return this.ext_5_4;
   }

   public void setExt_5_4(String ext_5_4) {
      this.ext_5_4 = ext_5_4;
   }

   public Date getExt_5_4_date() {
      return this.ext_5_4_date;
   }

   public void setExt_5_4_date(Date ext_5_4_date) {
      this.ext_5_4_date = ext_5_4_date;
   }

   public String getExt_5_5() {
      return this.ext_5_5;
   }

   public void setExt_5_5(String ext_5_5) {
      this.ext_5_5 = ext_5_5;
   }

   public Date getExt_5_5_date() {
      return this.ext_5_5_date;
   }

   public void setExt_5_5_date(Date ext_5_5_date) {
      this.ext_5_5_date = ext_5_5_date;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
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
