package com.yq.company.etop5.pojo;

import com.yq.faurecia.pojo.VO;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;

public class SupplierRanking extends VO {

   private Integer id;
   private String type;
   private String supplier;
   private Date begin_month;
   private Double kpi_1;
   private String operater;
   private Date create_date;
   private Date update_date;


   public String getType() {
      return this.type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getSupplier() {
      return this.supplier;
   }

   public void setSupplier(String supplier) {
      if(StringUtils.isEmpty(supplier)) {
         this.supplier = "";
      } else {
         this.supplier = supplier.trim();
      }

   }

   public Date getBegin_month() {
      return this.begin_month;
   }

   public void setBegin_month(Date begin_month) {
      this.begin_month = begin_month;
   }

   public Double getKpi_1() {
      return this.kpi_1;
   }

   public void setKpi_1(Double kpi_1) {
      this.kpi_1 = kpi_1;
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
