package com.yq.common.service;

import com.util.Global;
import com.util.Util;
import com.yq.common.dao.CommonDao;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CommonRemoteService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private CommonDao commonDao;


   public CommonDao getCommonDao() {
      return this.commonDao;
   }

   public void setCommonDao(CommonDao commonDao) {
      this.commonDao = commonDao;
   }

   public List syncTimeSheet(String icCard, String car, Date class_date) {
      ArrayList list = new ArrayList();
      if(!StringUtils.isEmpty(icCard) && icCard.indexOf(".") == -1 && !Util.containsLetter(icCard)) {
         try {
            List e = null;
            long card = Long.parseLong(icCard);
            String date = this.sdf.format(class_date);
            Calendar c = Calendar.getInstance();
            c.setTime(class_date);
            c.add(5, 2);
            String date_new = this.sdf.format(c.getTime());
            String sql = "\tselect convert(datetime,DataTime-2,120) inner_date,(case when PortNum=1 then \'I\' when PortNum=2 then \'O\' else \'\' end) type,\'" + Global.timesheet_source[1] + "\' source from OneCard.dbo.CardRecord where CardData = " + card + " and convert(datetime,DataTime,120)>=\'" + date_new + " 00:00:00\' and convert(datetime,DataTime,120) <=\'" + date_new + " 23:59:59\' ";
            e = this.commonDao.findRemoteBySQL(sql);
            if(e != null) {
               list.addAll(e);
            }

            e = null;
            sql = "\tselect t1.insj inner_date,\'I\' type,\'" + Global.timesheet_source[0] + "\' source from car_cp.dbo.iord t1,car_cp.dbo.carinfo t2 where t1.incp=t2.carcp and t2.cardnm = \'" + card + "\' and t1.insj>=\'" + date + " 00:00:00\' and t1.insj <=\'" + date + " 23:59:59\' ";
            e = this.commonDao.findRemoteBySQL(sql);
            if(e != null) {
               list.addAll(e);
            }

            e = null;
            sql = "\tselect t1.outsj inner_date,\'O\' type,\'" + Global.timesheet_source[0] + "\' source from car_cp.dbo.iord t1,car_cp.dbo.carinfo t2 where t1.outcp=t2.carcp and t2.cardnm = \'" + card + "\' and t1.outsj>=\'" + date + " 00:00:00\' and t1.outsj <=\'" + date + " 23:59:59\' ";
            e = this.commonDao.findRemoteBySQL(sql);
            if(e != null) {
               list.addAll(e);
            }
         } catch (Exception var12) {
            var12.printStackTrace();
         }
      }

      return list;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public boolean addICCard(int empId, String zh_name, String deptName, String card, String car) {
      boolean isTrue = true;

      try {
         if(empId != 0 && !StringUtils.isEmpty(zh_name) && !StringUtils.isEmpty(deptName) && !StringUtils.isEmpty(card)) {
            boolean e = false;
            int e1;
            if(this.isExistsByDept(deptName)) {
               e1 = this.queryDeptId(deptName);
            } else {
               e1 = this.addDept(deptName);
            }

            if(e1 > 0) {
               if(this.isExistsByCard(card)) {
                  isTrue = false;
               } else if(this.isExistsByEmp(empId)) {
                  isTrue = false;
               } else {
                  this.addCard(empId, this.addEmp(empId, zh_name, e1, card), card);
               }
            }

            if(isTrue && !StringUtils.isEmpty(car)) {
               if(!this.isExistsByCarCard(card) && !this.isExistsByCar(car)) {
                  this.addCar(car, zh_name, card);
               } else {
                  isTrue = false;
               }
            }
         } else {
            isTrue = false;
         }
      } catch (Exception var8) {
         isTrue = false;
         var8.printStackTrace();
      }

      return isTrue;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public boolean overICard(int state, String card, Date overDate) {
      boolean isTrue = true;

      try {
         if(StringUtils.isEmpty(card)) {
            isTrue = false;
         } else if(state > 0) {
            if(state == 1) {
               Calendar e = Calendar.getInstance();
               if(overDate != null) {
                  e.setTime(overDate);
               }

               e.add(1, 50);
               this.overCard(card, 1);
               this.overCarCard(card, e.getTime(), 1);
            } else {
               this.overCard(card, 3);
               this.overCarCard(card, overDate, 3);
            }
         }
      } catch (Exception var6) {
         isTrue = false;
         var6.printStackTrace();
      }

      return isTrue;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public boolean updateICard(int empId, String newCard, String car) {
      boolean isTrue = true;

      try {
         if(empId != 0 && !StringUtils.isEmpty(newCard)) {
            String e = this.queryPersonnelICCard(empId);
            if(!this.isExistsByCard(newCard) && this.isExistsByEmp(empId)) {
               if(!StringUtils.isEmpty(e)) {
                  this.overCard(e, 3);
               }

               int personnelid = this.queryPersonnelId(empId);
               this.addCard(empId, personnelid, newCard);
               this.updateEmp(personnelid, newCard);
            } else {
               isTrue = false;
            }

            if(isTrue && !StringUtils.isEmpty(car)) {
               if(this.isExistsByCarCard(e)) {
                  this.updateCarEmp(e, newCard);
               } else {
                  isTrue = false;
               }
            }
         } else {
            isTrue = false;
         }
      } catch (Exception var7) {
         isTrue = false;
         var7.printStackTrace();
      }

      return isTrue;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public boolean updateCar(String zh_name, String card, String oldCar, String newCar) {
      boolean isTrue = true;

      try {
         if(StringUtils.isEmpty(card)) {
            isTrue = false;
         } else if(!StringUtils.isEmpty(newCar)) {
            if(this.isExistsByCarCard(card)) {
               this.updateCarinfo(oldCar, newCar);
            } else {
               this.addCar(newCar, zh_name, card);
            }
         }
      } catch (Exception var7) {
         isTrue = false;
         var7.printStackTrace();
      }

      return isTrue;
   }

   public boolean isExistsByCard(String card) {
      List tmpList = null;
      String sql = "select carddata from OneCard.dbo.cardlist where carddata=" + card;
      tmpList = this.commonDao.findRemoteBySQL(sql);
      return tmpList != null && !tmpList.isEmpty();
   }

   public boolean isExistsByEmp(int empId) {
      return this.queryPersonnelId(empId) > 0;
   }

   public boolean isExistsByDept(String deptName) {
      return this.queryDeptId(deptName) > 0;
   }

   public int queryDeptId(String deptName) {
      String sql = "\tselect deptid from OneCard.dbo.Department where deptname = \'" + deptName + "\' ";
      List tmpList = this.commonDao.findRemoteBySQL(sql);
      return tmpList != null && !tmpList.isEmpty()?((Integer)((Map)tmpList.get(0)).get("deptid")).intValue():0;
   }

   public boolean isExistsByCarCard(String card) {
      List tmpList = null;
      String sql = "select cardnm from car_cp.dbo.carinfo where cardnm=\'" + card + "\'";
      tmpList = this.commonDao.findRemoteBySQL(sql);
      return tmpList != null && !tmpList.isEmpty();
   }

   public boolean isExistsByCar(String car) {
      List tmpList = null;
      String sql = "select carcp from car_cp.dbo.carinfo where carcp=\'" + car + "\'";
      tmpList = this.commonDao.findRemoteBySQL(sql);
      return tmpList != null && !tmpList.isEmpty();
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int addDept(String deptName) {
      String sql = "insert into OneCard.dbo.Department (parentid,deptnum,deptname,deptdesc,userid) values (0,\'" + deptName + "\',\'" + deptName + "\',\'\',1)";
      this.commonDao.executeRemoteBySQL(sql);
      return this.queryDeptId(deptName);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int addEmp(int empId, String zh_name, int deptId, String card) {
      String sql = "insert into OneCard.dbo.personnel \t\t(PName,PCode,CardData,CardCode,\t\t\tCardData_Backup,CardCode_Backup,PPassword,Sex,DepartmentID,Job,Nation,Country,NativePlace,Birthday,IdentityCard,IdentityCardType,Study,Degree,GraduateSchool,GraduateTime,Technical,MobilePhone,Addr,EMail,PDesc,PImage,InputSystemTime,InputUser) \tvalues \t\t(\'" + zh_name + "\',\'" + empId + "\'," + card + ",\'" + empId + "\'," + "\t\t\t0,\'\',\'\',0," + deptId + ",\'职员\',\'汉族\',\'\',\'\',\'42615\',\'\',\'\',\'\',\'\',\'\',\'0\',\'\',\'\',\'\',\'\',\'\',0,\'0\',\'\') ";
      this.commonDao.executeRemoteBySQL(sql);
      return this.queryPersonnelId(empId);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateEmp(int personnelid, String newCard) {
      String sql = "update OneCard.dbo.personnel set CardData=\'" + newCard + "\' where personnelid=" + personnelid;
      this.commonDao.executeRemoteBySQL(sql);
   }

   public int queryPersonnelId(int empId) {
      List tmpList = this.queryPersonnelMap(empId);
      return tmpList != null && !tmpList.isEmpty()?((Integer)((Map)tmpList.get(0)).get("personnelid")).intValue():0;
   }

   public String queryPersonnelICCard(int empId) {
      List tmpList = this.queryPersonnelMap(empId);
      return tmpList != null && !tmpList.isEmpty()?((Long)((Map)tmpList.get(0)).get("carddata")).toString():null;
   }

   public List queryPersonnelMap(int empId) {
      String sql = "select personnelid,carddata from OneCard.dbo.personnel where ltrim(rtrim(pcode))=\'" + empId + "\'";
      return this.commonDao.findRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void addCard(int empId, int personnelid, String card) {
      String sql = " insert into OneCard.dbo.cardlist \t\t(cardcode,carddata,cardstatus,hstrytime,personnelid,icwritecard) \tvalues \t\t(\'" + empId + "\'," + card + ",1,convert(float,convert(datetime,\'" + this.sdf1.format(new Date()) + "\') )," + personnelid + ",0) ";
      this.commonDao.executeRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void overCard(String card, int status) {
      String sql = " update OneCard.dbo.cardlist set cardstatus=" + status + " where carddata=\'" + card + "\' ";
      this.commonDao.executeRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void addCar(String car, String zh_name, String card) {
      Calendar c = Calendar.getInstance();
      String lid = Util.getNumber();
      Date now = c.getTime();
      c.add(1, 50);
      Date last = c.getTime();
      String sql = " insert into car_cp.dbo.carinfo \t\t(carname,carcp,carcw,cartel,caraddr,carlx,carcolor,carbz,carbh,carqx1,carqx2,carqx3,carqx4,carqx5,carqx6,carqx7,carqx8,carqx9,carqx10,carqx11,carqx12,carqx13,carqx14,carqx15,carqx16,carqx17,carqx18,carqx19,carqx20,carqx21,carqx22,carqx23,carqx24,carqx25,carqx26,carqx27,carqx28,carqx29,carqx30,carqx31,carqx32,carqx33,carqx34,carqx35,carqx36,carqx37,carqx38,carqx39,carqx40,carlrsj,caryk,caryksj,inwz,incp,inpic,inczy,insj,carzc,carqr,yklssf,tjinpic,cardnm) \tvalues \t\t(\'" + zh_name + "\',\'" + car + "\',\'\',\'\',\'\',\'\',\'\',\'\',\'" + lid + "\',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,convert(datetime,\'" + this.sdf1.format(now) + "\'),1,convert(datetime,\'" + this.sdf1.format(last) + "\'),1,\'" + car + "\',null,\'101\',convert(datetime,\'" + this.sdf1.format(now) + "\'),1,0,0,null,\'" + card + "\') ";
      this.commonDao.executeRemoteBySQL(sql);
      sql = " insert into car_cp.dbo.monthjf \t\t(carname,carcp,carbh,sflxname,jfsj,ys,ss,czybh,jb,jbsj) \tvalues \t\t(\'" + zh_name + "\',\'" + car + "\',\'" + lid + "\',\'小车包月收费\',convert(datetime,\'" + this.sdf1.format(now) + "\'),\'.0000\',\'.0000\',\'101\',\'0\',null) ";
      this.commonDao.executeRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateCarEmp(String oldCard, String newCard) {
      String sql = "update car_cp.dbo.carinfo set cardnm=\'" + newCard + "\' where cardnm=\'" + oldCard + "\' ";
      this.commonDao.executeRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void overCarCard(String card, Date overDate, int status) {
      String sql = " update car_cp.dbo.carinfo set caryk=\'" + status + "\',caryksj=convert(datetime,\'" + this.sdf1.format(overDate) + "\') where cardnm=\'" + card + "\' ";
      this.commonDao.executeRemoteBySQL(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void updateCarinfo(String oldCar, String newCar) {
      String sql = " update car_cp.dbo.carinfo set carcp=\'" + newCar + "\',incp=\'" + newCar + "\' where carcp=\'" + oldCar + "\' ";
      this.commonDao.executeRemoteBySQL(sql);
      sql = " update car_cp.dbo.monthjf set carcp=\'" + newCar + "\' where carcp=\'" + oldCar + "\' ";
      this.commonDao.executeRemoteBySQL(sql);
   }
}
