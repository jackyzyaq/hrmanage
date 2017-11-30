package com.yq.faurecia.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;

public class TimeSheet extends VO {

   private Integer id;
   private Integer emp_id;
   private String emp_name;
   private Integer card_id;
   private String card;
   private Integer dept_id;
   private String dept_ids;
   private String dept_name;
   private String ip;
   private String type;
   private Date inner_date;
   private String begin_date;
   private String end_date;
   private Date create_date;
   private String source;
   private String operater;


   public String getOperater() {
      return this.operater;
   }

   public void setOperater(String operater) {
      this.operater = operater;
   }

   public String getSource() {
      return this.source;
   }

   public void setSource(String source) {
      this.source = source;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }

   public String getBegin_date() {
      return this.begin_date;
   }

   public void setBegin_date(String begin_date) {
      this.begin_date = begin_date;
   }

   public String getEnd_date() {
      return this.end_date;
   }

   public void setEnd_date(String end_date) {
      this.end_date = end_date;
   }

   public Integer getDept_id() {
      return this.dept_id;
   }

   public void setDept_id(Integer dept_id) {
      this.dept_id = dept_id;
   }

   public String getDept_ids() {
      return this.dept_ids;
   }

   public void setDept_ids(String dept_ids) {
      this.dept_ids = dept_ids;
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

   public Integer getEmp_id() {
      return this.emp_id;
   }

   public void setEmp_id(Integer emp_id) {
      this.emp_id = emp_id;
   }

   public String getEmp_name() {
      return this.emp_name;
   }

   public void setEmp_name(String emp_name) {
      this.emp_name = emp_name;
   }

   public Integer getCard_id() {
      return this.card_id;
   }

   public void setCard_id(Integer card_id) {
      this.card_id = card_id;
   }

   public String getCard() {
      return this.card;
   }

   public void setCard(String card) {
      this.card = card;
   }

   public String getIp() {
      return StringUtils.defaultString(this.ip, "");
   }

   public void setIp(String ip) {
      this.ip = StringUtils.defaultString(ip, "");
   }

   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public Date getInner_date() {
      return this.inner_date;
   }

   public void setInner_date(Date inner_date) {
      this.inner_date = inner_date;
   }
}
