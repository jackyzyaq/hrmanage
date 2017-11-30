package com.yq.authority.pojo;

import java.io.Serializable;
import java.util.Date;

public class ActionInfo implements Serializable {

   private static final long serialVersionUID = 7637854086958919533L;
   private Integer id;
   private String action_code;
   private String action_name;
   private Integer action_menu_id;
   private Integer viewmode;
   private Date create_date;
   private Date update_date;
   private String action_menu_name;
   private String action_menu_code;
   private String ids;
   private Integer role_id;


   public Integer getRole_id() {
      return this.role_id;
   }

   public void setRole_id(Integer role_id) {
      this.role_id = role_id;
   }

   public String getIds() {
      return this.ids;
   }

   public void setIds(String ids) {
      this.ids = ids;
   }

   public static long getSerialVersionUID() {
      return 7637854086958919533L;
   }

   public String getAction_code() {
      return this.action_code;
   }

   public void setAction_code(String action_code) {
      this.action_code = action_code;
   }

   public Integer getAction_menu_id() {
      return this.action_menu_id;
   }

   public void setAction_menu_id(Integer action_menu_id) {
      this.action_menu_id = action_menu_id;
   }

   public String getAction_name() {
      return this.action_name;
   }

   public void setAction_name(String action_name) {
      this.action_name = action_name;
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

   public Date getUpdate_date() {
      return this.update_date;
   }

   public void setUpdate_date(Date update_date) {
      this.update_date = update_date;
   }

   public Integer getViewmode() {
      return this.viewmode;
   }

   public void setViewmode(Integer viewmode) {
      this.viewmode = viewmode;
   }

   public String getAction_menu_code() {
      return this.action_menu_code;
   }

   public void setAction_menu_code(String action_menu_code) {
      this.action_menu_code = action_menu_code;
   }

   public String getAction_menu_name() {
      return this.action_menu_name;
   }

   public void setAction_menu_name(String action_menu_name) {
      this.action_menu_name = action_menu_name;
   }
}
