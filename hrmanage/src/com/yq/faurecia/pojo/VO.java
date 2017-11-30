package com.yq.faurecia.pojo;


public class VO {

   private Integer noId;
   private String ids;
   private Integer count;
   private String flow_type;
   private String start_date;
   private String over_date;
   private String specialStr;


   public String getSpecialStr() {
      return this.specialStr;
   }

   public void setSpecialStr(String specialStr) {
      this.specialStr = specialStr;
   }

   public Integer getNoId() {
      return this.noId;
   }

   public void setNoId(Integer noId) {
      this.noId = noId;
   }

   public String getStart_date() {
      return this.start_date;
   }

   public void setStart_date(String start_date) {
      this.start_date = start_date;
   }

   public String getOver_date() {
      return this.over_date;
   }

   public void setOver_date(String over_date) {
      this.over_date = over_date;
   }

   public String getFlow_type() {
      return this.flow_type;
   }

   public void setFlow_type(String flow_type) {
      this.flow_type = flow_type;
   }

   public int getCount() {
      return this.count == null?0:this.count.intValue();
   }

   public void setCount(Integer count) {
      this.count = Integer.valueOf(count == null?0:count.intValue());
   }

   public String getIds() {
      return this.ids;
   }

   public void setIds(String ids) {
      this.ids = ids;
   }
}
