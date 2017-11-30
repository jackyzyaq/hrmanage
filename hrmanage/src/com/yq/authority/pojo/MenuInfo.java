package com.yq.authority.pojo;

import java.io.Serializable;
import java.util.Date;

public class MenuInfo implements Serializable {

   private static final long serialVersionUID = 7637854086958919533L;
   private Integer id;
   private Integer parent_id;
   private String menu_code;
   private String menu_name;
   private String url;
   private String url_param;
   private Date create_date;
   private Date update_date;
   private String parent_menu_code;
   private String parent_menu_name;
   private String description;
   private String ids;
   private Integer node_count;
   private Integer state;
   private Integer is_menu;
   private Integer orderNum;


   public Integer getIs_menu() {
      return this.is_menu;
   }

   public void setIs_menu(Integer is_menu) {
      this.is_menu = is_menu;
   }

   public Integer getOrderNum() {
      return this.orderNum;
   }

   public void setOrderNum(Integer orderNum) {
      this.orderNum = orderNum;
   }

   public Integer getState() {
      return this.state;
   }

   public void setState(Integer state) {
      this.state = state;
   }

   public Integer getNode_count() {
      return this.node_count;
   }

   public void setNode_count(Integer node_count) {
      this.node_count = node_count;
   }

   public static long getSerialVersionUID() {
      return 7637854086958919533L;
   }

   public Date getCreate_date() {
      return this.create_date;
   }

   public void setCreate_date(Date create_date) {
      this.create_date = create_date;
   }

   public Integer getId() {
      return this.id;
   }

   public void setId(Integer id) {
      this.id = id;
   }

   public String getIds() {
      return this.ids;
   }

   public void setIds(String ids) {
      this.ids = ids;
   }

   public String getMenu_code() {
      return this.menu_code;
   }

   public void setMenu_code(String menu_code) {
      this.menu_code = menu_code;
   }

   public String getMenu_name() {
      return this.menu_name;
   }

   public void setMenu_name(String menu_name) {
      this.menu_name = menu_name;
   }

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public String getUrl() {
      return this.url;
   }

   public void setUrl(String url) {
      this.url = url;
   }

   public Integer getParent_id() {
      return this.parent_id;
   }

   public void setParent_id(Integer parent_id) {
      this.parent_id = parent_id;
   }

   public String getParent_menu_code() {
      return this.parent_menu_code;
   }

   public void setParent_menu_code(String parent_menu_code) {
      this.parent_menu_code = parent_menu_code;
   }

   public String getParent_menu_name() {
      return this.parent_menu_name;
   }

   public void setParent_menu_name(String parent_menu_name) {
      this.parent_menu_name = parent_menu_name;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public String getUrl_param() {
      return this.url_param;
   }

   public void setUrl_param(String url_param) {
      this.url_param = url_param;
   }
}
