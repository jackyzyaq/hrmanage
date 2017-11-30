package com.yq.faurecia.service;

import com.yq.common.service.CommonService;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ConfigInfoService {

   private String columns = " name,value ";
   private String table_default = "tb_config_info";
   @Resource
   private CommonService commonService;


   public String queryValueByName(String name) throws Exception {
      List tmpList = this.queryByName(name);
      return tmpList != null && !tmpList.isEmpty()?(String)((Map)tmpList.get(0)).get("value"):null;
   }

   public List queryByName(String name) throws Exception {
      String sql = " select " + this.columns + " from " + this.table_default + " where name = \'" + name + "\'";
      return this.commonService.findBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void save(String name, String value) throws Exception {
      String sql = null;
      if(this.queryByName(name) != null) {
         this.update(name, value);
      } else {
         sql = "INSERT INTO tb_config_info (name,value) values (?,?);";
         this.commonService.insert(sql, new Object[]{name, value});
      }

   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(String name, String value) throws Exception {
      String sql = "update tb_config_info set value=\'" + value + "\' where name=\'" + name + "\'";
      this.commonService.operate(sql, (Object[])null);
   }
}
